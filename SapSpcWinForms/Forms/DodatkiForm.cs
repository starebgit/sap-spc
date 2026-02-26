using System;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using SapSpcWinForms.Services;

namespace SapSpcWinForms
{
    public sealed class DodatkiForm : Form
    {
        private readonly string _connStr;
        private readonly string _koda;

        private readonly Label _lbl = new Label();
        private readonly DataGridView _grid = new DataGridView();
        private readonly BindingSource _bs = new BindingSource();

        private readonly Button _btnAdd = new Button();
        private readonly Button _btnDelete = new Button();
        private readonly Button _btnClose = new Button();

        public DodatkiForm(string connStr, string koda)
        {
            _connStr = connStr ?? throw new ArgumentNullException(nameof(connStr));
            _koda = (koda ?? "").Trim();

            Text = TranslationService.Translate("DodatkiForm.Text");
            StartPosition = FormStartPosition.CenterParent;
            Width = 900;
            Height = 600;

            BuildUi();

            Shown += (_, __) =>
            {
                if (string.IsNullOrWhiteSpace(_koda))
                {
                    MessageBox.Show(this, TranslationService.Translate("DodatkiForm.NoCode"), TranslationService.Translate("DodatkiForm.Text"),
                        MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    Close();
                    return;
                }

                _lbl.Text = string.Format(TranslationService.Translate("DodatkiForm.CodeLabel"), _koda);
                LoadData();
            };
        }

        private void BuildUi()
        {
            var top = new Panel { Dock = DockStyle.Top, Height = 48, Padding = new Padding(12, 10, 12, 10) };
            top.BackColor = Color.FromArgb(0xDE, 0xDA, 0xC0);

            _lbl.AutoSize = true;
            _lbl.Font = new Font("Segoe UI", 10f, FontStyle.Bold);
            top.Controls.Add(_lbl);

            var buttons = new FlowLayoutPanel
            {
                Dock = DockStyle.Top,
                Height = 56,
                Padding = new Padding(12, 8, 12, 8),
                FlowDirection = FlowDirection.LeftToRight,
                WrapContents = false
            };

            _btnAdd.Text = TranslationService.Translate("DodatkiForm.Add");
            _btnAdd.Width = 120;
            _btnAdd.Click += (_, __) =>
            {
                var nz = InputBox.Show(TranslationService.Translate("DodatkiForm.InputTitle"), TranslationService.Translate("DodatkiForm.Name"));
                if (string.IsNullOrWhiteSpace(nz)) return;

                int newId = InsertRow(nz.Trim());
                LoadData(keepId: newId);
            };

            _btnDelete.Text = TranslationService.Translate("DodatkiForm.Delete");
            _btnDelete.Width = 120;
            _btnDelete.Click += (_, __) =>
            {
                var id = GetCurrentId();
                if (!id.HasValue) return;

                var r = MessageBox.Show(this, TranslationService.Translate("DodatkiForm.DeletePrompt"), TranslationService.Translate("DodatkiForm.Text"),
                    MessageBoxButtons.YesNo, MessageBoxIcon.Question);

                if (r != DialogResult.Yes) return;

                DeleteRow(id.Value);
                LoadData();
            };

            _btnClose.Text = TranslationService.Translate("DodatkiForm.Close");
            _btnClose.Width = 120;
            _btnClose.Click += (_, __) => Close();

            buttons.Controls.AddRange(new Control[] { _btnAdd, _btnDelete, _btnClose });

            _grid.Dock = DockStyle.Fill;
            _grid.DataSource = _bs;
            _grid.AllowUserToAddRows = false;
            _grid.AllowUserToDeleteRows = false;
            _grid.MultiSelect = false;
            _grid.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            _grid.RowHeadersVisible = false;
            _grid.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells;
            _grid.ReadOnly = false; // Delphi grid is editable
            _grid.CellEndEdit += GridOnCellEndEdit;

            Controls.Add(_grid);
            Controls.Add(buttons);
            Controls.Add(top);
        }

        private void LoadData(int? keepId = null)
        {
            var dt = new DataTable();

            using (var conn = new OleDbConnection(_connStr))
            using (var cmd = conn.CreateCommand())
            using (var da = new OleDbDataAdapter(cmd))
            {
                cmd.CommandText = "SELECT zaopored, koda, naziv FROM dodatkod WHERE koda = ? ORDER BY zaopored";
                cmd.Parameters.AddWithValue("@p1", _koda);

                conn.Open();
                da.Fill(dt);
            }

            _bs.DataSource = dt;

            // layout like Delphi (mostly "naziv")
            if (_grid.Columns["zaopored"] != null) _grid.Columns["zaopored"].Visible = false;
            if (_grid.Columns["koda"] != null) _grid.Columns["koda"].Visible = false;

            if (_grid.Columns["naziv"] != null)
            {
                _grid.Columns["naziv"].HeaderText = TranslationService.Translate("DodatkiForm.Name");
                _grid.Columns["naziv"].ReadOnly = false;
                _grid.Columns["naziv"].AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill;
            }

            if (keepId.HasValue)
                SelectRowById(keepId.Value);
            else if (_grid.Rows.Count > 0)
                SelectFirstRow();
        }

        private void SelectFirstRow()
        {
            if (_grid.Rows.Count <= 0) return;
            _grid.ClearSelection();
            _grid.Rows[0].Selected = true;
            _grid.CurrentCell = _grid.Rows[0].Cells[_grid.Columns["naziv"]?.Index ?? 0];
        }

        private void SelectRowById(int id)
        {
            foreach (DataGridViewRow row in _grid.Rows)
            {
                var v = row.Cells["zaopored"]?.Value;
                if (v == null || v == DBNull.Value) continue;

                if (int.TryParse(v.ToString(), out var rowId) && rowId == id)
                {
                    _grid.ClearSelection();
                    row.Selected = true;
                    _grid.CurrentCell = row.Cells[_grid.Columns["naziv"]?.Index ?? 0];
                    return;
                }
            }
        }

        private int? GetCurrentId()
        {
            if (_grid.CurrentRow == null) return null;
            var v = _grid.CurrentRow.Cells["zaopored"]?.Value;
            if (v == null || v == DBNull.Value) return null;
            return int.TryParse(v.ToString(), out var id) ? id : (int?)null;
        }

        private void GridOnCellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0) return;
            if (_grid.Columns[e.ColumnIndex]?.Name != "naziv") return;

            var row = _grid.Rows[e.RowIndex];
            var idObj = row.Cells["zaopored"]?.Value;
            var nzObj = row.Cells["naziv"]?.Value;

            if (idObj == null || idObj == DBNull.Value) return;
            if (!int.TryParse(idObj.ToString(), out var id)) return;

            var nz = (nzObj?.ToString() ?? "").Trim();
            UpdateNaziv(id, nz);
        }

        private int InsertRow(string naziv)
        {
            using (var conn = new OleDbConnection(_connStr))
            using (var cmd = conn.CreateCommand())
            {
                conn.Open();

                cmd.CommandText = "INSERT INTO dodatkod (koda, naziv) VALUES (?, ?)";
                cmd.Parameters.AddWithValue("@p1", _koda);
                cmd.Parameters.AddWithValue("@p2", naziv);
                cmd.ExecuteNonQuery();

                // get AutoInc (Access)
                cmd.Parameters.Clear();
                cmd.CommandText = "SELECT @@IDENTITY";
                var idObj = cmd.ExecuteScalar();
                return Convert.ToInt32(idObj);
            }
        }

        private void UpdateNaziv(int zaopored, string naziv)
        {
            using (var conn = new OleDbConnection(_connStr))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText = "UPDATE dodatkod SET naziv = ? WHERE zaopored = ?";
                cmd.Parameters.AddWithValue("@p1", naziv);
                cmd.Parameters.AddWithValue("@p2", zaopored);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private void DeleteRow(int zaopored)
        {
            using (var conn = new OleDbConnection(_connStr))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText = "DELETE FROM dodatkod WHERE zaopored = ?";
                cmd.Parameters.AddWithValue("@p1", zaopored);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private static object GetActiveExcelCellValue()
        {
            try
            {
                // requires running Excel instance
                var excel = Marshal.GetActiveObject("Excel.Application");
                if (excel == null) return null;

                dynamic app = excel;
                return app.ActiveCell?.Value;
            }
            catch
            {
                return null;
            }
        }

        private static class InputBox
        {
            public static string Show(string title, string label)
            {
                using (var f = new Form())
                using (var tb = new TextBox())
                using (var lb = new Label())
                using (var ok = new Button())
                using (var cancel = new Button())
                {
                    f.Text = title;
                    f.StartPosition = FormStartPosition.CenterParent;
                    f.Width = 520;
                    f.Height = 160;
                    f.FormBorderStyle = FormBorderStyle.FixedDialog;
                    f.MaximizeBox = false;
                    f.MinimizeBox = false;

                    lb.Text = label;
                    lb.AutoSize = true;
                    lb.Left = 12;
                    lb.Top = 14;

                    tb.Left = 12;
                    tb.Top = 38;
                    tb.Width = 480;

                    ok.Text = TranslationService.Translate("Common.Ok");
                    ok.Left = 12;
                    ok.Top = 74;
                    ok.Width = 120;
                    ok.DialogResult = DialogResult.OK;

                    cancel.Text = TranslationService.Translate("Common.Cancel");
                    cancel.Left = 140;
                    cancel.Top = 74;
                    cancel.Width = 120;
                    cancel.DialogResult = DialogResult.Cancel;

                    f.Controls.Add(lb);
                    f.Controls.Add(tb);
                    f.Controls.Add(ok);
                    f.Controls.Add(cancel);

                    f.AcceptButton = ok;
                    f.CancelButton = cancel;

                    return f.ShowDialog() == DialogResult.OK ? (tb.Text ?? "") : "";
                }
            }
        }
    }
}
