using System;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Drawing;
using System.Windows.Forms;

using SapSpcWinForms.Services;
using SapSpcWinForms.Utils;

namespace SapSpcWinForms
{
    public sealed class MerilneMetodeForm : Form
    {
        private readonly bool _isAdmin;
        private readonly int? _idPostFilter;
        private readonly string _merilnoMestoOpis;
        private OleDbConnection _connection;
        private OleDbDataAdapter _adapter;
        private DataTable _table;
        private DataGridView _grid;
        private Label _labelHeader;
        private Panel _bottomPanel;
        private Button _btnNovVnos;
        private const string DeleteColName = "__delete";

        public MerilneMetodeForm(bool isAdmin, int? idPostFilter = null, string merilnoMestoOpis = null)
        {
            _isAdmin = isAdmin;
            _idPostFilter = idPostFilter;
            _merilnoMestoOpis = merilnoMestoOpis;
            Text = TranslationService.Translate("MerilneMetodeForm.Text");
            StartPosition = FormStartPosition.CenterParent;
            Width = 900;
            Height = 600;
            BuildUi();
            UiTheme.ApplyFormTheme(this);
        }

        private void BuildUi()
        {
            _labelHeader = new Label
            {
                Dock = DockStyle.Top,
                Height = 32,
                Font = new Font("Segoe UI", 11F, FontStyle.Bold),
                ForeColor = Color.FromArgb(0, 64, 128),
                Text = string.Format(TranslationService.Translate("MerilneMetodeForm.Header"), _merilnoMestoOpis ?? ""),
                TextAlign = ContentAlignment.MiddleLeft,
                Padding = new Padding(12, 8, 8, 8)
            };

            _grid = new DataGridView
            {
                Dock = DockStyle.Fill,
                AllowUserToAddRows = false,
                ReadOnly = true,
                AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                Font = new Font("Segoe UI", 10F, FontStyle.Regular),
                ColumnHeadersDefaultCellStyle = new DataGridViewCellStyle { Font = new Font("Segoe UI", 10F, FontStyle.Bold) }
            };
            _grid.CellContentClick += Grid_CellContentClick;
            _grid.CellFormatting += Grid_CellFormatting;

            Controls.Clear();
            Controls.Add(_grid);
            Controls.Add(_labelHeader);

            // Add bottom bar for new entry if admin
            if (_bottomPanel == null)
            {
                _bottomPanel = new Panel
                {
                    Dock = DockStyle.Bottom,
                    Height = 56,
                    BackColor = Color.White,
                    Padding = new Padding(12, 8, 12, 8)
                };
                _btnNovVnos = new Button
                {
                    Dock = DockStyle.Fill,
                    Height = 40,
                    Text = TranslationService.Translate("MerilneMetodeForm.NewEntryButton"),
                    Enabled = _isAdmin,
                    BackColor = Color.FromArgb(46, 204, 113),
                    ForeColor = Color.White,
                    FlatStyle = FlatStyle.Flat,
                    TextAlign = ContentAlignment.MiddleCenter
                };
                _btnNovVnos.FlatAppearance.BorderSize = 0;
                _btnNovVnos.Margin = new Padding(0, 8, 0, 0);
                _btnNovVnos.Click += BtnNovVnos_Click;
                _bottomPanel.Controls.Add(_btnNovVnos);
                Controls.Add(_bottomPanel);
                _bottomPanel.BringToFront();
            }

            Load += Form_Load;
            FormClosing += Form_FormClosing;
        }

        private void Form_Load(object sender, EventArgs e)
        {
            LoadData();
        }

        private void LoadData()
        {
            var connString = ConfigurationManager.ConnectionStrings["StrojnaDb"]?.ConnectionString;
            if (string.IsNullOrWhiteSpace(connString))
            {
                MessageBox.Show(TranslationService.Translate("MerilneMetodeForm.MissingConn"), TranslationService.Translate("Common.ErrorTitle"), MessageBoxButtons.OK, MessageBoxIcon.Error);
                Close();
                return;
            }

            _connection = new OleDbConnection(connString);
            string selectSql;
            if (_idPostFilter.HasValue)
            {
                selectSql = "SELECT idmet, idpost, metoda, kanal, opis FROM metode WHERE idpost = ? ORDER BY metoda";
                _adapter = new OleDbDataAdapter(selectSql, _connection);
                _adapter.SelectCommand.Parameters.Add("idpost", OleDbType.Integer).Value = _idPostFilter.Value;
            }
            else
            {
                selectSql = "SELECT idmet, idpost, metoda, kanal, opis FROM metode ORDER BY metoda";
                _adapter = new OleDbDataAdapter(selectSql, _connection);
            }

            _adapter.InsertCommand = new OleDbCommand(@"INSERT INTO metode (idpost, metoda, kanal, opis) VALUES (?, ?, ?, ?)", _connection);
            _adapter.InsertCommand.Parameters.Add("idpost", OleDbType.Integer, 0, "idpost");
            _adapter.InsertCommand.Parameters.Add("metoda", OleDbType.VarWChar, 5, "metoda");
            _adapter.InsertCommand.Parameters.Add("kanal", OleDbType.Integer, 0, "kanal");
            _adapter.InsertCommand.Parameters.Add("opis", OleDbType.VarWChar, 40, "opis");

            _adapter.UpdateCommand = new OleDbCommand(@"UPDATE metode SET idpost = ?, metoda = ?, kanal = ?, opis = ? WHERE idmet = ?", _connection);
            _adapter.UpdateCommand.Parameters.Add("idpost", OleDbType.Integer, 0, "idpost");
            _adapter.UpdateCommand.Parameters.Add("metoda", OleDbType.VarWChar, 5, "metoda");
            _adapter.UpdateCommand.Parameters.Add("kanal", OleDbType.Integer, 0, "kanal");
            _adapter.UpdateCommand.Parameters.Add("opis", OleDbType.VarWChar, 40, "opis");
            _adapter.UpdateCommand.Parameters.Add("idmet", OleDbType.Integer, 0, "idmet").SourceVersion = DataRowVersion.Original;

            _adapter.DeleteCommand = new OleDbCommand(@"DELETE FROM metode WHERE idmet = ?", _connection);
            _adapter.DeleteCommand.Parameters.Add("idmet", OleDbType.Integer, 0, "idmet").SourceVersion = DataRowVersion.Original;

            _table = new DataTable();
            _adapter.Fill(_table);
            _grid.DataSource = _table.DefaultView;
            EnsureDeleteColumn();
        }

        private void EnsureDeleteColumn()
        {
            if (_grid.Columns[DeleteColName] == null)
            {
                var col = new DataGridViewButtonColumn
                {
                    Name = DeleteColName,
                    HeaderText = "",
                    Text = TranslationService.Translate("MerilneMetodeForm.DeleteButton"),
                    UseColumnTextForButtonValue = true,
                    Width = 60,
                    ReadOnly = true,
                    Resizable = DataGridViewTriState.False,
                    Frozen = false
                };
                _grid.Columns.Add(col);
            }
            _grid.Columns[DeleteColName].Visible = _isAdmin;
        }

        private void SaveChanges()
        {
            if (_adapter == null || _table == null) return;
            try
            {
                _grid.EndEdit();
                _adapter.Update(_table);
            }
            catch (Exception ex)
            {
                MessageBox.Show(TranslationService.Translate("MerilneMetodeForm.SaveError") + "\n" + ex.Message, TranslationService.Translate("Common.ErrorTitle"), MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void Form_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (_table == null) return;
            if (_table.GetChanges() != null)
            {
                var result = MessageBox.Show(TranslationService.Translate("MerilneMetodeForm.SavePrompt"), TranslationService.Translate("MerilneMetodeForm.SaveTitle"), MessageBoxButtons.YesNoCancel, MessageBoxIcon.Question);
                if (result == DialogResult.Cancel)
                {
                    e.Cancel = true;
                    return;
                }
                if (result == DialogResult.Yes)
                {
                    SaveChanges();
                }
            }
        }

        private void Grid_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0) return;
            var col = _grid.Columns[e.ColumnIndex];
            if (col == null || col.Name != DeleteColName) return;
            var cell = _grid.Rows[e.RowIndex].Cells[e.ColumnIndex];
            cell.Style.BackColor = Color.FromArgb(231, 76, 60);
            cell.Style.ForeColor = Color.White;
            cell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter;
        }

        private void Grid_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (!_isAdmin) return;
            if (e.RowIndex < 0 || e.ColumnIndex < 0) return;
            var col = _grid.Columns[e.ColumnIndex];
            if (col == null || col.Name != DeleteColName) return;
            var row = _grid.Rows[e.RowIndex];
            if (row == null || row.IsNewRow) return;
            var drv = row.DataBoundItem as DataRowView;
            if (drv == null) return;
            var res = MessageBox.Show(TranslationService.Translate("MerilneMetodeForm.DeletePrompt"), TranslationService.Translate("MerilneMetodeForm.ConfirmTitle"), MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (res != DialogResult.Yes) return;
            drv.Row.Delete();
            SaveChanges();
            LoadData();
        }

        private void BtnNovVnos_Click(object sender, EventArgs e)
        {
            if (!_isAdmin) { MessageBox.Show(TranslationService.Translate("MerilneMetodeForm.AdminOnly"), TranslationService.Translate("MerilneMetodeForm.NotAllowedTitle"), MessageBoxButtons.OK, MessageBoxIcon.Information); return; }
            if (_table == null) return;
            using (var dlg = new NovaMetodaDialog(_idPostFilter))
            {
                if (dlg.ShowDialog(this) != DialogResult.OK) return;
                var input = dlg.Value;
                var newRow = _table.NewRow();
                newRow["idpost"] = input.IdPost;
                newRow["metoda"] = input.Metoda ?? "";
                newRow["kanal"] = input.Kanal;
                newRow["opis"] = input.Opis ?? "";
                _table.Rows.Add(newRow);
                SaveChanges();
                LoadData();
            }
        }

        private sealed class NovaMetodaDialog : Form
        {
            public MetodaInput Value { get; private set; }
            private NumericUpDown _numIdPost;
            private TextBox _tbMetoda;
            private NumericUpDown _numKanal;
            private TextBox _tbOpis;
            private Button _btnOk;
            private Button _btnCancel;

            public NovaMetodaDialog(int? idPostPreset)
            {
                Text = TranslationService.Translate("MerilneMetodeForm.NewDialog.Text");
                FormBorderStyle = FormBorderStyle.FixedDialog;
                StartPosition = FormStartPosition.CenterParent;
                MaximizeBox = false;
                MinimizeBox = false;
                ShowInTaskbar = false;
                ClientSize = new Size(520, 220);
                BuildUi(idPostPreset);
            }

            private void BuildUi(int? idPostPreset)
            {
                var grid = new TableLayoutPanel { Dock = DockStyle.Fill, Padding = new Padding(12), ColumnCount = 2, RowCount = 4 };
                grid.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 140));
                grid.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
                int r = 0;
                grid.Controls.Add(new Label { Text = "idpost", AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _numIdPost = new NumericUpDown { Dock = DockStyle.Left, Minimum = 0, Maximum = 999999, Width = 160, Value = idPostPreset.HasValue ? idPostPreset.Value : 0 };
                grid.Controls.Add(_numIdPost, 1, r++);

                grid.Controls.Add(new Label { Text = TranslationService.Translate("MerilneMetodeForm.NewDialog.Metoda"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _tbMetoda = new TextBox { Dock = DockStyle.Fill, MaxLength = 5 };
                grid.Controls.Add(_tbMetoda, 1, r++);

                grid.Controls.Add(new Label { Text = TranslationService.Translate("MerilneMetodeForm.NewDialog.Channel"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _numKanal = new NumericUpDown { Dock = DockStyle.Left, Minimum = 0, Maximum = 65535, Width = 160 };
                grid.Controls.Add(_numKanal, 1, r++);

                grid.Controls.Add(new Label { Text = TranslationService.Translate("MerilneMetodeForm.NewDialog.Description"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _tbOpis = new TextBox { Dock = DockStyle.Fill, MaxLength = 40 };
                grid.Controls.Add(_tbOpis, 1, r++);

                var buttons = new FlowLayoutPanel { Dock = DockStyle.Bottom, FlowDirection = FlowDirection.RightToLeft, Padding = new Padding(12), Height = 52 };
                _btnOk = new Button { Text = TranslationService.Translate("Common.Ok"), DialogResult = DialogResult.OK, AutoSize = true };
                _btnCancel = new Button { Text = TranslationService.Translate("Common.Cancel"), DialogResult = DialogResult.Cancel, AutoSize = true };
                _btnOk.Click += Ok_Click;
                buttons.Controls.Add(_btnOk);
                buttons.Controls.Add(_btnCancel);

                Controls.Add(grid);
                Controls.Add(buttons);
                AcceptButton = _btnOk;
                CancelButton = _btnCancel;
            }

            private void Ok_Click(object sender, EventArgs e)
            {
                var metoda = (_tbMetoda.Text ?? "").Trim();
                if (string.IsNullOrWhiteSpace(metoda)) { MessageBox.Show(TranslationService.Translate("MerilneMetodeForm.NewDialog.Required"), TranslationService.Translate("Common.ErrorTitle"), MessageBoxButtons.OK, MessageBoxIcon.Warning); DialogResult = DialogResult.None; return; }
                Value = new MetodaInput
                {
                    IdPost = (int)_numIdPost.Value,
                    Metoda = metoda,
                    Kanal = (int)_numKanal.Value,
                    Opis = (_tbOpis.Text ?? "").Trim()
                };
            }

            internal sealed class MetodaInput
            {
                public int IdPost { get; set; }
                public string Metoda { get; set; }
                public int Kanal { get; set; }
                public string Opis { get; set; }
            }
        }
    }
}
