using System;
using System.Diagnostics;
using System.IO.Ports;
using System.Text;
using System.Threading;
using System.Windows.Forms;
using SapSpcWinForms.Utils;
using SapSpcWinForms.Services;

namespace SapSpcWinForms.Services
{
    public static class PrenosMeritevService
    {
        private static string SanitizeRawForLog(string input, int maxLen = 320)
        {
            if (string.IsNullOrEmpty(input))
                return "<empty>";

            var s = input.Replace("\r", "\\r").Replace("\n", "\\n");
            if (s.Length <= maxLen)
                return s;

            return s.Substring(0, maxLen) + "...";
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
            MoveToNextVzorecCell(grid, cell.RowIndex, cell.ColumnIndex);
        }

        public static void MoveToNextVzorecCell(DataGridView grid, int row, int curCol)
        {
            if (grid == null || row < 0 || row >= grid.Rows.Count || grid.ColumnCount <= 0)
                return;

            int firstVzCol = -1;
            for (int i = 0; i < grid.ColumnCount; i++)
            {
                if (grid.Columns[i].Name.StartsWith("Vzorec", StringComparison.OrdinalIgnoreCase))
                {
                    firstVzCol = i;
                    break;
                }
            }

            int nextCol = -1;
            for (int i = curCol + 1; i < grid.ColumnCount; i++)
            {
                if (grid.Columns[i].Name.StartsWith("Vzorec", StringComparison.OrdinalIgnoreCase))
                {
                    nextCol = i;
                    break;
                }
            }

            int nextRow = row;
            if (nextCol < 0 && firstVzCol >= 0 && (row + 1 < grid.Rows.Count))
            {
                nextRow = row + 1;
                nextCol = firstVzCol;
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

        public static string ReadSingleMeasurementRaw(string comPort, int baud, TimeSpan timeout, int stKanal, string transferId = null)
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
                sp.Open();
                sp.DiscardInBuffer();

                DiagnosticLog.Info("PrenosMeritevService.ReadSingleMeasurementRaw",
                    $"transferId={transferId ?? "n/a"}; serial opened and input buffer discarded");

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

                        DiagnosticLog.Info("PrenosMeritevService.ReadSingleMeasurementRaw",
                            $"transferId={transferId ?? "n/a"}; chunk#{chunkCount}; chunkLen={chunk.Length}; totalLen={sb.Length}; elapsedMs={sw.ElapsedMilliseconds}; chunk='{SanitizeRawForLog(chunk, 120)}'");

                        if (sb.Length > 2048)
                            sb.Remove(0, sb.Length - 2048);

                        if (stKanal <= 8 && sb.Length >= 12)
                        {
                            var hasFrameSignature = chunk.IndexOf("04A", StringComparison.OrdinalIgnoreCase) >= 0
                                || sb.ToString().IndexOf("04A", StringComparison.OrdinalIgnoreCase) >= 0;

                            if (hasFrameSignature && AppUtils.TryParseLast04AFrame(sb.ToString(), out _, out _, out _))
                            {
                                DiagnosticLog.Info("PrenosMeritevService.ReadSingleMeasurementRaw",
                                    $"transferId={transferId ?? "n/a"}; stopping read due to complete 04A frame; elapsedMs={sw.ElapsedMilliseconds}");
                                break;
                            }
                        }
                    }

                    if (sb.Length > 0 && lastDataMs >= 0 && (sw.ElapsedMilliseconds - lastDataMs) > 220)
                    {
                        DiagnosticLog.Info("PrenosMeritevService.ReadSingleMeasurementRaw",
                            $"transferId={transferId ?? "n/a"}; stopping read due to idle gap >220ms; elapsedMs={sw.ElapsedMilliseconds}; lastDataMs={lastDataMs}");
                        break;
                    }

                    Thread.Sleep(25);
                }
            }

            DiagnosticLog.Info("PrenosMeritevService.ReadSingleMeasurementRaw",
                $"transferId={transferId ?? "n/a"}; end elapsedMs={sw.ElapsedMilliseconds}; chunks={chunkCount}; bytesTotal={bytesTotal}; rawLen={sb.Length}; raw='{SanitizeRawForLog(sb.ToString())}'");

            return sb.ToString();
        }

        public static bool TryParseMeasurementForKanal(string raw, int stKanal, Func<double, string> formatter, out string parsedText, string transferId = null)
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
                    DiagnosticLog.Warn("PrenosMeritevService.TryParseMeasurementForKanal",
                        $"transferId={transferId ?? "n/a"}; failed 04A parse for stKanal={stKanal}; raw='{SanitizeRawForLog(raw)}'");
                    return false;
                }

                parsedText = formatter(value);
                DiagnosticLog.Info("PrenosMeritevService.TryParseMeasurementForKanal",
                    $"transferId={transferId ?? "n/a"}; parsed stKanal={stKanal}; value={value}; formatted='{parsedText}'");
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
                DiagnosticLog.Info("PrenosMeritevService.TryParseMeasurementForKanal",
                    $"transferId={transferId ?? "n/a"}; parsed stKanal=9; formatted='{parsedText}'");
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
                DiagnosticLog.Info("PrenosMeritevService.TryParseMeasurementForKanal",
                    $"transferId={transferId ?? "n/a"}; parsed stKanal=10; formatted='{parsedText}'");
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
                return false;

            if (endIdx > 0 && endIdx <= buffer.Length)
                buffer.Remove(0, endIdx);

            return true;
        }
    }
}
