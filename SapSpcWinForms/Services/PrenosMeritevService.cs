using System;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading;
using System.Windows.Forms;
using SapSpcWinForms.Utils;
using SapSpcWinForms.Services;

namespace SapSpcWinForms.Services
{
    public static class PrenosMeritevService
    {
        public struct CellWriteResult
        {
            public bool WroteValue { get; set; }
            public bool ReachedColumnBottomAfterWrite { get; set; }
            public int RowIndex { get; set; }
            public int ColumnIndex { get; set; }
        }

        private static string SanitizeRawForLog(string input, int maxLen = 320)
        {
            if (string.IsNullOrEmpty(input))
                return "<empty>";

            var s = input.Replace("\r", "\\r").Replace("\n", "\\n");
            if (s.Length <= maxLen)
                return s;

            return s.Substring(0, maxLen) + "...";
        }

        public static int ResolveStKanalFromMeriloDelphiLike(string meriloValue, int fallbackStKanal)
        {
            var tx = (meriloValue ?? "").Trim();
            if (tx.Length <= 2 && int.TryParse(tx, out int parsed) && parsed >= 1 && parsed <= 10)
                return parsed;

            return fallbackStKanal;
        }

        public static bool TryResolveStKanalFromMeriloDelphiLike(string meriloValue, out int stKanal)
        {
            stKanal = 0;
            var tx = (meriloValue ?? "").Trim();
            return tx.Length <= 2 && int.TryParse(tx, out stKanal) && stKanal >= 1 && stKanal <= 10;
        }

        private static bool TryParseDelimitedCommaMeasurement(string raw, out double value)
        {
            value = 0;
            if (string.IsNullOrWhiteSpace(raw))
                return false;

            int p1 = raw.IndexOf(',');
            if (p1 < 0 || p1 + 1 >= raw.Length)
                return false;

            string tail = raw.Substring(p1 + 1);
            int p2 = tail.IndexOf(',');
            if (p2 < 0)
                return false;

            string token = tail.Substring(0, p2).Replace(" ", "").Trim();
            if (token.Length == 0)
                return false;

            if (double.TryParse(token.Replace(',', '.'), NumberStyles.Any, CultureInfo.InvariantCulture, out value))
                return true;

            return double.TryParse(token.Replace('.', ','), NumberStyles.Any, new CultureInfo("sl-SI"), out value);
        }

        private static bool TryConsumeDelimitedCommaMeasurement(StringBuilder buffer, out double value)
        {
            value = 0;
            if (buffer == null || buffer.Length == 0)
                return false;

            string raw = buffer.ToString();
            int secondComma = raw.LastIndexOf(',');
            while (secondComma > 0)
            {
                int firstComma = raw.LastIndexOf(',', secondComma - 1);
                if (firstComma < 0)
                    return false;

                string token = raw.Substring(firstComma + 1, secondComma - firstComma - 1).Replace(" ", "").Trim();
                if (token.Length > 0 &&
                    (double.TryParse(token.Replace(',', '.'), NumberStyles.Any, CultureInfo.InvariantCulture, out value) ||
                     double.TryParse(token.Replace('.', ','), NumberStyles.Any, new CultureInfo("sl-SI"), out value)))
                {
                    int removeLen = Math.Min(secondComma + 1, buffer.Length);
                    if (removeLen > 0)
                        buffer.Remove(0, removeLen);
                    return true;
                }

                secondComma = firstComma;
            }

            return false;
        }

        public static bool IsVzorecCell(DataGridViewCell cell)
        {
            var colName = cell?.OwningColumn?.Name ?? "";
            return colName.StartsWith("Vzorec", StringComparison.OrdinalIgnoreCase);
        }

        public static bool TryGetCurrentVzorecCell(DataGridView grid, out DataGridViewCell cell)
        {
            cell = grid?.CurrentCell;
            return cell != null && IsVzorecCell(cell);
        }

        public static void ApplyMeasurementToCurrentCell(DataGridView grid, string measurement)
        {
            if (grid == null)
                return;

            if (!TryGetCurrentVzorecCell(grid, out var cell))
                return;

            grid.EndEdit();
            grid.CommitEdit(DataGridViewDataErrorContexts.Commit);

            cell.Value = measurement;
            grid.EndEdit();
            grid.CommitEdit(DataGridViewDataErrorContexts.Commit);
            MoveToNextVzorecCell(grid, cell.RowIndex, cell.ColumnIndex);
        }

        public static CellWriteResult WriteMeasurementAndMoveDownOnly(DataGridView grid, string measurement)
        {
            var result = new CellWriteResult
            {
                WroteValue = false,
                ReachedColumnBottomAfterWrite = false,
                RowIndex = -1,
                ColumnIndex = -1
            };

            if (grid == null)
                return result;

            if (!TryGetCurrentVzorecCell(grid, out var cell))
                return result;

            int row = cell.RowIndex;
            int col = cell.ColumnIndex;
            result.RowIndex = row;
            result.ColumnIndex = col;

            FlushPendingCellEdit(grid);
            cell.Value = measurement;
            FlushPendingCellEdit(grid);
            result.WroteValue = true;

            int nextRow = row + 1;
            if (nextRow >= grid.Rows.Count)
            {
                result.ReachedColumnBottomAfterWrite = true;
                return result;
            }

            var targetRow = grid.Rows[nextRow];
            if (targetRow != null && col >= 0 && col < targetRow.Cells.Count)
            {
                grid.CurrentCell = targetRow.Cells[col];
                grid.Focus();
                grid.BeginEdit(true);
            }

            return result;
        }

        public static void MoveToNextVzorecCell(DataGridView grid, int row, int curCol)
        {
            if (grid == null || row < 0 || row >= grid.Rows.Count || grid.ColumnCount <= 0)
                return;

            if (curCol < 0 || curCol >= grid.ColumnCount)
                return;

            if (!grid.Columns[curCol].Name.StartsWith("Vzorec", StringComparison.OrdinalIgnoreCase))
                return;

            int nextRow = row + 1;
            int nextCol = curCol;

            // Normal case: continue down in the same Vzorec column.
            if (nextRow >= grid.Rows.Count)
            {
                // Bottom reached in this column -> continue at top of next Vzorec column.
                nextCol = FindNextVzorecColumnIndex(grid, curCol + 1);
                if (nextCol < 0)
                    return;

                nextRow = 0;
            }

            if (nextCol >= 0 && nextRow >= 0 && nextRow < grid.Rows.Count)
            {
                var targetRow = grid.Rows[nextRow];
                if (targetRow != null && nextCol < targetRow.Cells.Count)
                {
                    grid.CurrentCell = targetRow.Cells[nextCol];
                    grid.Focus();
                    grid.BeginEdit(true);
                }
            }
        }

        private static int FindNextVzorecColumnIndex(DataGridView grid, int startIndex)
        {
            if (grid == null)
                return -1;

            for (int col = Math.Max(0, startIndex); col < grid.ColumnCount; col++)
            {
                if (grid.Columns[col].Name.StartsWith("Vzorec", StringComparison.OrdinalIgnoreCase))
                    return col;
            }

            return -1;
        }

        public static SerialPort CreateConfiguredSerialPort(string comPort, int baud)
        {
            return new SerialPort(comPort, baud, Parity.None, 8, StopBits.One)
            {
                Handshake = Handshake.None,
                DtrEnable = true,
                RtsEnable = true,
                Encoding = Encoding.ASCII,
                ReadTimeout = 250
            };
        }

        public static string ReadSingleMeasurementRaw(string comPort, int baud, TimeSpan timeout, int stKanal, string transferId = null, bool detailedLogging = false)
        {
            var sw = Stopwatch.StartNew();
            var sb = new StringBuilder();
            long lastDataMs = -1;
            int chunkCount = 0;
            int bytesTotal = 0;

            DiagnosticLog.Info("PrenosMeritevService.ReadSingleMeasurementRaw",
                $"transferId={transferId ?? "n/a"}; start comPort={comPort}; baud={baud}; stKanal={stKanal}; timeoutMs={(int)timeout.TotalMilliseconds}");

            using (var sp = CreateConfiguredSerialPort(comPort, baud))
            {
                try
                {
                    sp.Open();
                }
                catch (IOException ex)
                {
                    var available = SerialPort.GetPortNames();
                    throw new IOException(
                        $"Configured port '{comPort}' is not available. Available ports: {(available.Length == 0 ? "<none>" : string.Join(", ", available))}.",
                        ex);
                }
                sp.DiscardInBuffer();

                DiagnosticLog.Info("PrenosMeritevService.ReadSingleMeasurementRaw",
                    $"transferId={transferId ?? "n/a"}; serial opened and input buffer discarded");

                if (stKanal <= 8)
                {
                    string cmd = $"10{stKanal}1100001001\r";
                    sp.Write(cmd);
                    Thread.Sleep(500);
                    DiagnosticLog.Info("PrenosMeritevService.ReadSingleMeasurementRaw",
                        $"transferId={transferId ?? "n/a"}; active poll command sent for stKanal={stKanal}; cmd='{SanitizeRawForLog(cmd, 80)}'");
                }

                while (sw.Elapsed < timeout)
                {
                    string chunk = null;
                    try { chunk = sp.ReadExisting(); }
                    catch (TimeoutException ex)
                    {
                        DiagnosticLog.Warn("PrenosMeritevService.ReadSingleMeasurementRaw.ReadExisting", ex);
                    }

                    if (!string.IsNullOrEmpty(chunk))
                    {
                        chunkCount++;
                        bytesTotal += chunk.Length;
                        sb.Append(chunk);
                        lastDataMs = sw.ElapsedMilliseconds;

                        if (detailedLogging)
                        {
                            DiagnosticLog.Info("PrenosMeritevService.ReadSingleMeasurementRaw",
                                $"transferId={transferId ?? "n/a"}; chunk#{chunkCount}; chunkLen={chunk.Length}; totalLen={sb.Length}; elapsedMs={sw.ElapsedMilliseconds}; chunk='{SanitizeRawForLog(chunk, 120)}'");
                        }

                        if (sb.Length > 2048)
                            sb.Remove(0, sb.Length - 2048);

                        if (stKanal <= 8 && sb.Length >= 12)
                        {
                            var hasFrameSignature = chunk.IndexOf("04A", StringComparison.OrdinalIgnoreCase) >= 0
                                || sb.ToString().IndexOf("04A", StringComparison.OrdinalIgnoreCase) >= 0;

                            if (hasFrameSignature && AppUtils.TryParseLast04AFrame(sb.ToString(), out _, out _, out _))
                            {
                                if (detailedLogging)
                                {
                                    DiagnosticLog.Info("PrenosMeritevService.ReadSingleMeasurementRaw",
                                        $"transferId={transferId ?? "n/a"}; stopping read due to complete 04A frame; elapsedMs={sw.ElapsedMilliseconds}");
                                }
                                break;
                            }

                            if (TryParseDelimitedCommaMeasurement(sb.ToString(), out _))
                            {
                                if (detailedLogging)
                                {
                                    DiagnosticLog.Info("PrenosMeritevService.ReadSingleMeasurementRaw",
                                        $"transferId={transferId ?? "n/a"}; stopping read due to complete comma-delimited response; elapsedMs={sw.ElapsedMilliseconds}");
                                }
                                break;
                            }
                        }
                    }

                    if (sb.Length > 0 && lastDataMs >= 0 && (sw.ElapsedMilliseconds - lastDataMs) > 220)
                    {
                        if (detailedLogging)
                        {
                            DiagnosticLog.Info("PrenosMeritevService.ReadSingleMeasurementRaw",
                                $"transferId={transferId ?? "n/a"}; stopping read due to idle gap >220ms; elapsedMs={sw.ElapsedMilliseconds}; lastDataMs={lastDataMs}");
                        }
                        break;
                    }

                    Thread.Sleep(25);
                }
            }

            DiagnosticLog.Info("PrenosMeritevService.ReadSingleMeasurementRaw",
                $"transferId={transferId ?? "n/a"}; end elapsedMs={sw.ElapsedMilliseconds}; chunks={chunkCount}; bytesTotal={bytesTotal}; rawLen={sb.Length}; raw='{SanitizeRawForLog(sb.ToString())}'");

            return sb.ToString();
        }

        public static bool TryParseMeasurementForKanal(string raw, int stKanal, Func<double, string> formatter, out string parsedText, string transferId = null, bool detailedLogging = false)
        {
            parsedText = "";
            if (string.IsNullOrWhiteSpace(raw))
            {
                DiagnosticLog.Warn("PrenosMeritevService.TryParseMeasurementForKanal",
                    $"transferId={transferId ?? "n/a"}; parse skipped because raw is empty; stKanal={stKanal}");
                return false;
            }

            if (stKanal <= 8)
            {
                if (!AppUtils.TryParseLast04AFrame(raw, out double value, out _, out _))
                {
                    if (!TryParseDelimitedCommaMeasurement(raw, out value))
                    {
                        DiagnosticLog.Warn("PrenosMeritevService.TryParseMeasurementForKanal",
                            $"transferId={transferId ?? "n/a"}; failed 04A and comma-delimited parse for stKanal={stKanal}; raw='{SanitizeRawForLog(raw)}'");
                        return false;
                    }
                }

                parsedText = formatter(value);
                if (detailedLogging)
                {
                    DiagnosticLog.Info("PrenosMeritevService.TryParseMeasurementForKanal",
                        $"transferId={transferId ?? "n/a"}; parsed stKanal={stKanal}; value={value}; formatted='{parsedText}'");
                }
                return true;
            }

            string mr = raw;
            if (stKanal == 9)
            {
                mr = mr.Trim();
                if (mr.Length < 3)
                {
                    DiagnosticLog.Warn("PrenosMeritevService.TryParseMeasurementForKanal",
                        $"transferId={transferId ?? "n/a"}; stKanal=9 raw too short; raw='{SanitizeRawForLog(raw)}'");
                    return false;
                }

                int ii = mr.Length - 2;
                while (ii >= 0 && mr[ii] != ' ')
                    ii--;
                if (ii < 0)
                {
                    DiagnosticLog.Warn("PrenosMeritevService.TryParseMeasurementForKanal",
                        $"transferId={transferId ?? "n/a"}; stKanal=9 no separator found; raw='{SanitizeRawForLog(raw)}'");
                    return false;
                }

                int start = ii + 1;
                int len = mr.Length - ii - 2;
                if (len <= 0 || (start + len) > mr.Length)
                {
                    DiagnosticLog.Warn("PrenosMeritevService.TryParseMeasurementForKanal",
                        $"transferId={transferId ?? "n/a"}; stKanal=9 invalid bounds start={start} len={len} rawLen={mr.Length}");
                    return false;
                }

                parsedText = mr.Substring(start, len).Replace('.', ',').Trim();
                if (detailedLogging)
                {
                    DiagnosticLog.Info("PrenosMeritevService.TryParseMeasurementForKanal",
                        $"transferId={transferId ?? "n/a"}; parsed stKanal=9; formatted='{parsedText}'");
                }
                return parsedText.Length > 0;
            }

            if (stKanal == 10)
            {
                int ii = mr.IndexOf('\n');
                if (ii < 0) ii = mr.Length;

                if (mr.Length > 0 && mr[0] != 'S')
                {
                    mr = (ii + 1 < mr.Length) ? mr.Substring(ii + 1) : "";
                    ii = mr.IndexOf('\n');
                    if (ii < 0) ii = mr.Length;
                }

                if (ii < mr.Length)
                    mr = mr.Substring(0, ii);

                mr = mr.TrimEnd('\r');
                ii = mr.Length - 1;
                while (ii >= 0 && !char.IsDigit(mr[ii]))
                    ii--;
                if (ii < 0)
                {
                    DiagnosticLog.Warn("PrenosMeritevService.TryParseMeasurementForKanal",
                        $"transferId={transferId ?? "n/a"}; stKanal=10 no trailing digit found; raw='{SanitizeRawForLog(raw)}'");
                    return false;
                }

                int ll = ii;
                while (ii >= 0 && mr[ii] != ' ')
                    ii--;

                int start = ii + 1;
                int len = ll - ii;
                if (len <= 0 || (start + len) > mr.Length)
                {
                    DiagnosticLog.Warn("PrenosMeritevService.TryParseMeasurementForKanal",
                        $"transferId={transferId ?? "n/a"}; stKanal=10 invalid bounds start={start} len={len} rawLen={mr.Length}");
                    return false;
                }

                parsedText = mr.Substring(start, len).Replace('.', ',').Trim();
                if (detailedLogging)
                {
                    DiagnosticLog.Info("PrenosMeritevService.TryParseMeasurementForKanal",
                        $"transferId={transferId ?? "n/a"}; parsed stKanal=10; formatted='{parsedText}'");
                }
                return parsedText.Length > 0;
            }

            DiagnosticLog.Warn("PrenosMeritevService.TryParseMeasurementForKanal",
                $"transferId={transferId ?? "n/a"}; unsupported stKanal={stKanal}");
            return false;
        }

        public static bool TryConsumeLast04AFrame(StringBuilder buffer, out double value)
        {
            value = 0;
            if (buffer == null || buffer.Length == 0)
                return false;

            if (!AppUtils.TryParseLast04AFrame(buffer, out value, out int endIdx, out _))
            {
                return TryConsumeDelimitedCommaMeasurement(buffer, out value);
            }

            if (endIdx > 0 && endIdx <= buffer.Length)
                buffer.Remove(0, endIdx);

            return true;
        }
    }
}
