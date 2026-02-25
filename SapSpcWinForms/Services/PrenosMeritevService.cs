using System;
using System.Diagnostics;
using System.IO.Ports;
using System.Text;
using System.Threading;
using System.Windows.Forms;
using SapSpcWinForms.Utils;

namespace SapSpcWinForms.Services
{
    public static class PrenosMeritevService
    {
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
            if (!TryGetCurrentVzorecCell(grid, out var cell))
                return;

            grid.EndEdit();
            grid.CommitEdit(DataGridViewDataErrorContexts.Commit);

            cell.Value = measurement;
            MoveToNextVzorecCell(grid, cell.RowIndex, cell.ColumnIndex);
        }

        public static void MoveToNextVzorecCell(DataGridView grid, int row, int curCol)
        {
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

            if (nextCol >= 0)
            {
                grid.CurrentCell = grid.Rows[nextRow].Cells[nextCol];
                grid.Focus();
                grid.BeginEdit(true);
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

        public static string ReadSingleMeasurementRaw(string comPort, int baud, TimeSpan timeout, int stKanal)
        {
            var sw = Stopwatch.StartNew();
            var sb = new StringBuilder();
            long lastDataMs = -1;

            using (var sp = CreateConfiguredSerialPort(comPort, baud))
            {
                sp.Open();
                sp.DiscardInBuffer();

                while (sw.Elapsed < timeout)
                {
                    string chunk = null;
                    try { chunk = sp.ReadExisting(); }
                    catch (TimeoutException) { }

                    if (!string.IsNullOrEmpty(chunk))
                    {
                        sb.Append(chunk);
                        lastDataMs = sw.ElapsedMilliseconds;

                        if (sb.Length > 2048)
                            sb.Remove(0, sb.Length - 2048);

                        if (stKanal <= 8 && AppUtils.TryParseLast04AFrame(sb.ToString(), out _, out _, out _))
                            break;
                    }

                    if (sb.Length > 0 && lastDataMs >= 0 && (sw.ElapsedMilliseconds - lastDataMs) > 220)
                        break;

                    Thread.Sleep(25);
                }
            }

            return sb.ToString();
        }

        public static bool TryParseMeasurementForKanal(string raw, int stKanal, Func<double, string> formatter, out string parsedText)
        {
            parsedText = "";
            if (string.IsNullOrWhiteSpace(raw))
                return false;

            if (stKanal <= 8)
            {
                if (!AppUtils.TryParseLast04AFrame(raw, out double value, out _, out _))
                    return false;

                parsedText = formatter(value);
                return true;
            }

            string mr = raw;
            if (stKanal == 9)
            {
                mr = mr.Trim();
                if (mr.Length < 3)
                    return false;

                int ii = mr.Length - 2;
                while (ii >= 0 && mr[ii] != ' ')
                    ii--;
                if (ii < 0)
                    return false;

                int start = ii + 1;
                int len = mr.Length - ii - 2;
                if (len <= 0 || (start + len) > mr.Length)
                    return false;

                parsedText = mr.Substring(start, len).Replace('.', ',').Trim();
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
                    return false;

                int ll = ii;
                while (ii >= 0 && mr[ii] != ' ')
                    ii--;

                int start = ii + 1;
                int len = ll - ii;
                if (len <= 0 || (start + len) > mr.Length)
                    return false;

                parsedText = mr.Substring(start, len).Replace('.', ',').Trim();
                return parsedText.Length > 0;
            }

            return false;
        }

        public static bool TryConsumeLast04AFrame(StringBuilder buffer, out double value)
        {
            value = 0;
            if (buffer == null || buffer.Length == 0)
                return false;

            var raw = buffer.ToString();
            if (!AppUtils.TryParseLast04AFrame(raw, out value, out int endIdx, out _))
                return false;

            if (endIdx > 0 && endIdx <= buffer.Length)
                buffer.Remove(0, endIdx);

            return true;
        }
    }
}
