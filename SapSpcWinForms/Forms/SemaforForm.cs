using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Windows.Forms;

namespace SapSpcWinForms
{
    public sealed partial class SemaforForm : Form
    {
        // You feed the form with current machine rows (like Delphi: lista := Fzacetna.ListStr)
        private readonly Func<List<SemaforRow>> _getRows;
        private readonly bool _isAdmin;

        private readonly Timer _timer = new Timer();

        private List<SemaforRow> _rows = new List<SemaforRow>();

        // paging (Delphi: ilos/dlos + dln)
        private int _pageIndex = 0;
        private int _pageSize = 1;     // visible rows count
        private int _rowOffset = 0;    // pageIndex * pageSize

        public SemaforForm(bool isAdmin, Func<List<SemaforRow>> getRows)
        {
            InitializeComponent(); // <-- MUST, otherwise your designer controls aren't initialized

            _isAdmin = isAdmin;
            _getRows = getRows ?? throw new ArgumentNullException(nameof(getRows));

            BuildUi(); // now configures MachinesGrid (designer), not a new grid
            ApplyAdminBorder(isAdmin);
            PositionOnMonitor();
            RecomputeLayoutAndRowCount();
            RefreshRowsAndRebind();

            _timer.Interval = 1000;
            _timer.Tick += (s, e) => OnTick();
            _timer.Start();
        }

        private void BuildUi()
        {
            Text = "Semafor";
            StartPosition = FormStartPosition.Manual;

            // Delphi semafor has no built-in legend panel; keep only grid + close button
            MachinesGrid.Dock = DockStyle.None;
            CloseButton.Dock = DockStyle.Bottom;
            CloseButton.Height = 40;

            MachinesGrid.Left = 0;
            MachinesGrid.Top = 0;
            MachinesGrid.Width = ClientSize.Width;
            MachinesGrid.Height = Math.Max(0, ClientSize.Height - CloseButton.Height);

            // Keep layout responsive to resize
            this.Resize += (s, e) =>
            {
                MachinesGrid.Left = 0;
                MachinesGrid.Top = 0;
                MachinesGrid.Width = ClientSize.Width;
                MachinesGrid.Height = Math.Max(0, ClientSize.Height - CloseButton.Height);
            };

            MachinesGrid.ReadOnly = true;
            MachinesGrid.AllowUserToAddRows = false;
            MachinesGrid.AllowUserToDeleteRows = false;
            MachinesGrid.AllowUserToResizeRows = false;
            MachinesGrid.AllowUserToResizeColumns = false;
            MachinesGrid.RowHeadersVisible = false;
            MachinesGrid.ColumnHeadersVisible = false;
            MachinesGrid.MultiSelect = false;
            MachinesGrid.SelectionMode = DataGridViewSelectionMode.CellSelect;
            MachinesGrid.BackgroundColor = Color.Black;
            MachinesGrid.GridColor = Color.Black;
            MachinesGrid.ScrollBars = ScrollBars.None;
            MachinesGrid.EnableHeadersVisualStyles = false;
            MachinesGrid.DefaultCellStyle.BackColor = Color.Black;
            MachinesGrid.DefaultCellStyle.ForeColor = Color.White;
            MachinesGrid.DefaultCellStyle.SelectionBackColor = Color.Black;
            MachinesGrid.DefaultCellStyle.SelectionForeColor = Color.White;

            // Ensure columns exist (designer grid starts empty)
            MachinesGrid.Columns.Clear();
            MachinesGrid.Columns.Add(new DataGridViewTextBoxColumn { Name = "Machine", Width = 400 });
            MachinesGrid.Columns.Add(new DataGridViewTextBoxColumn { Name = "State", Width = 200 });
            MachinesGrid.Columns.Add(new DataGridViewTextBoxColumn { Name = "Info", AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill });

            MachinesGrid.CellPainting -= Grid_CellPainting;
            MachinesGrid.CellPainting += Grid_CellPainting;

            // Close button behavior
            CloseButton.Visible = _isAdmin;
            CloseButton.Click += (s, e) => Close();

            FormClosing += (s, e) =>
            {
                if (!_isAdmin) e.Cancel = true;
            };
        }

        private void ApplyAdminBorder(bool isAdmin)
        {
            if (isAdmin)
            {
                FormBorderStyle = FormBorderStyle.Sizable;
                ControlBox = true;
                MinimizeBox = true;
                MaximizeBox = true;
            }
            else
            {
                FormBorderStyle = FormBorderStyle.None;
                ControlBox = false;
                MinimizeBox = false;
                MaximizeBox = false;
                TopMost = true;
            }
        }

        private void PositionOnMonitor()
        {
            // Delphi picks the monitor that is NOT the one with Left=0 if there are 2 monitors.
            var screens = Screen.AllScreens;
            Screen target = screens.Length >= 2
                ? (screens[0].Bounds.Left == 0 ? screens[1] : screens[0])
                : screens[0];

            Bounds = target.Bounds;
        }

        private void RecomputeLayoutAndRowCount()
        {
            // Delphi: DefaultColWidth = (monitorWidth-10)/3, but clamped with fixed 400/400 + middle
            int w = ClientSize.Width;
            int h = ClientSize.Height;

            int col0 = 400;
            int col2 = 400;
            int col1 = Math.Max(50, w - col0 - col2);

            MachinesGrid.Columns[0].Width = col0;
            MachinesGrid.Columns[1].Width = col1;
            MachinesGrid.Columns[2].Width = col2; // keep “Info” fixed-ish like Delphi (you can swap if you want)

            // Delphi: rowHeight = (monitorHeight-60)/dln, where dln = number of visible rows
            // Here: pick a reasonable row height first, then compute visible rows.
            int usable = Math.Max(1, h - 60);
            int desiredRowH = usable >= 700 ? 90 : 60;
            _pageSize = Math.Max(1, usable / desiredRowH);
            int rowH = Math.Max(30, usable / _pageSize);

            MachinesGrid.RowTemplate.Height = rowH;
            MachinesGrid.RowCount = _pageSize;
        }

        private void OnTick()
        {
            RefreshRowsAndRebind();

            // Delphi paging:
            // if dln < lista.Count then ilos := (ilos+1) mod 2 else ilos := 0;
            // dlos := ilos*dln;
            if (_rows.Count > _pageSize)
            {
                _pageIndex = (_pageIndex + 1) % 2; // keep Delphi behavior (2 pages)
            }
            else
            {
                _pageIndex = 0;
            }

            _rowOffset = _pageIndex * _pageSize;
            MachinesGrid.Invalidate(); // redraw
        }

        private void RefreshRowsAndRebind()
        {
            _rows = _getRows()?.ToList() ?? new List<SemaforRow>();

            // We keep grid rows fixed (_pageSize). Data is drawn by CellPainting using offset.
            // No binding needed; just force redraw.
            MachinesGrid.Invalidate();
        }

        private void Grid_CellPainting(object sender, DataGridViewCellPaintingEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0) return;

            int dataIndex = e.RowIndex + _rowOffset;
            if (dataIndex >= _rows.Count)
            {
                // empty row
                e.Graphics.FillRectangle(Brushes.Black, e.CellBounds);
                e.Handled = true;
                return;
            }

            var row = _rows[dataIndex];

            // Background
            e.Graphics.FillRectangle(Brushes.Black, e.CellBounds);

            int rowH = MachinesGrid.RowTemplate.Height;
            bool big = rowH > 70;
            using (var fontSmall = new Font("Segoe UI", big ? 14 : 10, FontStyle.Regular))
            using (var fontBig = new Font("Segoe UI", big ? 22 : 12, FontStyle.Bold))
            {
                if (e.ColumnIndex == 0)
                {
                    // Machine name split into 2 lines similar to Delphi logic
                    var split = SplitMachineName(row.Naziv);
                    var l1 = split.line1;
                    var l2 = split.line2;

                    var y1 = e.CellBounds.Top + rowH / 6;
                    var y2 = e.CellBounds.Top + (2 * rowH) / 4;

                    DrawCenteredText(e.Graphics, l1, fontSmall, Brushes.White, e.CellBounds, y1);
                    DrawCenteredText(e.Graphics, l2, fontSmall, Brushes.White, e.CellBounds, y2);

                    e.Handled = true;
                    return;
                }

                if (e.ColumnIndex == 1)
                {
                    Color c;
                    switch (row.Status)
                    {
                        case 1: c = Color.Lime; break;
                        case 2: c = Color.Yellow; break;
                        case 3: c = Color.Red; break;
                        case 9: c = Color.Silver; break;
                        default: c = Color.Silver; break;
                    }
                    using (var b = new SolidBrush(c))
                    {
                        e.Graphics.FillRectangle(b, e.CellBounds);
                    }
                    e.Handled = true;
                    return;
                }

                if (e.ColumnIndex == 2)
                {
                    // time info
                    if (row.Status < 5)
                    {
                        string label = (row.Status == 3) ? "Meritev zamuja za" : "Do naslednje meritve";
                        string timeTxt = FormatRemaining(row);

                        var y1 = e.CellBounds.Top + rowH / 6;
                        var y2 = e.CellBounds.Top + (2 * rowH) / 4;

                        DrawCenteredText(e.Graphics, label, fontSmall, Brushes.White, e.CellBounds, y1);
                        DrawCenteredText(e.Graphics, timeTxt, fontBig, Brushes.White, e.CellBounds, y2);
                    }
                    else
                    {
                        string stt = "Stroj ni aktiven";
                        var y = e.CellBounds.Top + rowH / 3;
                        DrawCenteredText(e.Graphics, stt, fontBig, Brushes.White, e.CellBounds, y);
                    }

                    e.Handled = true;
                    return;
                }
            }
        }

        private static string FormatRemaining(SemaforRow row)
        {
            // Delphi does:
            // tt := diff/24/60 - time + acas
            // then TimeToStr(tt) without seconds
            var now = DateTime.Now.TimeOfDay;

            // We assume: row.DiffMinutes is the measurement interval (diff)
            // and row.NextBaseTime is the base time (acas) as TimeOfDay.
            var tt = TimeSpan.FromMinutes(row.DiffMinutes) - now + row.NextBaseTime.TimeOfDay;

            if (tt < TimeSpan.Zero) tt = tt.Negate(); // show positive duration like “late by”
            // show hh:mm
            return $"{(int)tt.TotalHours:00}:{tt.Minutes:00}";
        }

        private static (string line1, string line2) SplitMachineName(string name)
        {
            name = (name ?? "").Trim();
            if (name.Length <= 18) return (name, "");

            // Delphi tries to split after ~14 chars on space/dot
            int splitStart = Math.Min(14, name.Length);
            string tail = name.Substring(splitStart);
            int idx = tail.IndexOf(' ');
            if (idx < 0) idx = tail.IndexOf('.');
            if (idx < 0) return (name, "");

            int splitAt = splitStart + idx + 1;
            string l1 = name.Substring(0, splitAt).TrimEnd();
            string l2 = name.Substring(splitAt).TrimStart();
            return (l1, l2);
        }

        private static void DrawCenteredText(Graphics g, string text, Font font, Brush brush, Rectangle bounds, int y)
        {
            text = text ?? "";
            var size = g.MeasureString(text, font);
            int x = bounds.Left + (int)((bounds.Width - size.Width) / 2);
            g.DrawString(text, font, brush, x, y);
        }

        public sealed class SemaforRow
        {
            public string Naziv { get; set; } = "";
            public int Status { get; set; } = 9;               // 1/2/3/9 like Delphi
            public int DiffMinutes { get; set; } = 0;          // pp^.diff
            public DateTime NextBaseTime { get; set; } = DateTime.Today; // Fzacetna.acas[...] equivalent
        }
    }
}
