using System;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Drawing;
using System.Windows.Forms;
using SapSpcWinForms.Services;

namespace SapSpcWinForms
{
    public sealed class StrojiForm : Form
    {
        private readonly bool _isAdmin;
        private readonly int? _stPostFilter;
        private readonly string _merilnoMestoOpis;
        private OleDbConnection _connection;
        private OleDbDataAdapter _adapter;
        private DataTable _table;
        private DataGridView _grid;
        private Label _labelHeader;
        private Panel _bottomPanel;
        private Button _btnNovStroj;
        private const string DeleteColName = "__delete";

        public StrojiForm(bool isAdmin, int? stPostFilter = null, string merilnoMestoOpis = null)
        {
            _isAdmin = isAdmin;
            _stPostFilter = stPostFilter;
            _merilnoMestoOpis = merilnoMestoOpis;
            Text = TranslationService.Translate("StrojiForm.Text");
            StartPosition = FormStartPosition.CenterParent;
            Width = 900;
            Height = 600;
            BuildUi();
        }

        private void BuildUi()
        {
            _labelHeader = new Label
            {
                Dock = DockStyle.Top,
                Height = 32,
                Font = new Font("Segoe UI", 11F, FontStyle.Bold),
                ForeColor = Color.FromArgb(0, 64, 128),
                Text = string.Format(TranslationService.Translate("StrojiForm.Header"), _merilnoMestoOpis ?? string.Empty),
                TextAlign = ContentAlignment.MiddleLeft,
                Padding = new Padding(12, 8, 8, 8)
            };

            _grid = new DataGridView
            {
                Dock = DockStyle.Fill,
                AllowUserToAddRows = false,
                ReadOnly = !_isAdmin,
                AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                Font = new Font("Segoe UI", 10F, FontStyle.Regular),
                ColumnHeadersDefaultCellStyle = new DataGridViewCellStyle { Font = new Font("Segoe UI", 10F, FontStyle.Bold) }
            };
            _grid.CellContentClick += DataGridView1_CellContentClick;
            _grid.CellFormatting += DataGridView1_CellFormatting;

            Controls.Clear();
            Controls.Add(_grid);
            Controls.Add(_labelHeader);

            EnsureBottomBar();

            Load += StrojiForm_Load;
            FormClosing += StrojiForm_FormClosing;
        }

        private void StrojiForm_Load(object sender, EventArgs e)
        {
            LoadData();
        }

        private void LoadData()
        {
            var connString = ConfigurationManager.ConnectionStrings["StrojnaDb"]?.ConnectionString;
            if (string.IsNullOrWhiteSpace(connString))
            {
                MessageBox.Show(TranslationService.Translate("StrojiForm.MissingConn"), TranslationService.Translate("Common.ErrorTitle"), MessageBoxButtons.OK, MessageBoxIcon.Error);
                Close();
                return;
            }

            _connection = new OleDbConnection(connString);
            string selectSql;
            if (_stPostFilter.HasValue)
            {
                selectSql = "SELECT zapored, stPost, idstroja, sifstroja, naziv, koda FROM stroji WHERE stPost = ? ORDER BY sifstroja";
                _adapter = new OleDbDataAdapter(selectSql, _connection);
                _adapter.SelectCommand.Parameters.Add("stPost", OleDbType.Integer).Value = _stPostFilter.Value;
            }
            else
            {
                selectSql = "SELECT zapored, stPost, idstroja, sifstroja, naziv, koda FROM stroji ORDER BY sifstroja";
                _adapter = new OleDbDataAdapter(selectSql, _connection);
            }

            _adapter.InsertCommand = new OleDbCommand(@"INSERT INTO stroji (stPost, idstroja, sifstroja, naziv, koda) VALUES (?, ?, ?, ?, ?)", _connection);
            _adapter.InsertCommand.Parameters.Add("stPost", OleDbType.Integer, 0, "stPost");
            _adapter.InsertCommand.Parameters.Add("idstroja", OleDbType.VarWChar, 50, "idstroja");
            _adapter.InsertCommand.Parameters.Add("sifstroja", OleDbType.VarWChar, 50, "sifstroja");
            _adapter.InsertCommand.Parameters.Add("naziv", OleDbType.VarWChar, 255, "naziv");
            _adapter.InsertCommand.Parameters.Add("koda", OleDbType.VarWChar, 100, "koda");

            _adapter.UpdateCommand = new OleDbCommand(@"UPDATE stroji SET stPost = ?, idstroja = ?, sifstroja = ?, naziv = ?, koda = ? WHERE zapored = ?", _connection);
            _adapter.UpdateCommand.Parameters.Add("stPost", OleDbType.Integer, 0, "stPost");
            _adapter.UpdateCommand.Parameters.Add("idstroja", OleDbType.VarWChar, 50, "idstroja");
            _adapter.UpdateCommand.Parameters.Add("sifstroja", OleDbType.VarWChar, 50, "sifstroja");
            _adapter.UpdateCommand.Parameters.Add("naziv", OleDbType.VarWChar, 255, "naziv");
            _adapter.UpdateCommand.Parameters.Add("koda", OleDbType.VarWChar, 100, "koda");
            _adapter.UpdateCommand.Parameters.Add("zapored", OleDbType.Integer, 0, "zapored").SourceVersion = DataRowVersion.Original;

            _adapter.DeleteCommand = new OleDbCommand(@"DELETE FROM stroji WHERE zapored = ?", _connection);
            _adapter.DeleteCommand.Parameters.Add("zapored", OleDbType.Integer, 0, "zapored").SourceVersion = DataRowVersion.Original;

            _table = new DataTable();
            _adapter.Fill(_table);
            _grid.DataSource = _table.DefaultView;
        }

        private void EnsureBottomBar()
        {
            if (_bottomPanel != null) return;

            _bottomPanel = new Panel
            {
                Dock = DockStyle.Bottom,
                Height = 44,
                BackColor = Color.White,
                Padding = new Padding(12, 10, 12, 12)
            };

            _btnNovStroj = new Button
            {
                Dock = DockStyle.Fill,
                Height = 40,
                Text = TranslationService.Translate("StrojiForm.NewMachineButton"),
                Enabled = _isAdmin,
                BackColor = Color.FromArgb(46, 204, 113),
                ForeColor = Color.White,
                FlatStyle = FlatStyle.Flat,
                TextAlign = ContentAlignment.MiddleCenter
            };
            _btnNovStroj.FlatAppearance.BorderSize = 0;
            _btnNovStroj.Margin = new Padding(0, 8, 0, 0);
            _btnNovStroj.Click += BtnNovStroj_Click;

            _bottomPanel.Controls.Add(_btnNovStroj);
            Controls.Add(_bottomPanel);
            _bottomPanel.BringToFront();
        }

        private void EnsureDeleteColumn()
        {
            if (_grid.Columns[DeleteColName] == null)
            {
                var col = new DataGridViewButtonColumn
                {
                    Name = DeleteColName,
                    HeaderText = "",
                    Text = TranslationService.Translate("StrojiForm.DeleteButton"),
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
                MessageBox.Show(TranslationService.Translate("StrojiForm.SaveError") + "\n" + ex.Message, TranslationService.Translate("Common.ErrorTitle"), MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void StrojiForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (_table == null) return;
            if (_table.GetChanges() != null)
            {
                var result = MessageBox.Show(TranslationService.Translate("StrojiForm.SavePrompt"), TranslationService.Translate("StrojiForm.SaveTitle"), MessageBoxButtons.YesNoCancel, MessageBoxIcon.Question);
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

        private void DataGridView1_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0) return;
            var col = _grid.Columns[e.ColumnIndex];
            if (col == null || col.Name != DeleteColName) return;
            var cell = _grid.Rows[e.RowIndex].Cells[e.ColumnIndex];
            cell.Style.BackColor = Color.FromArgb(231, 76, 60);
            cell.Style.ForeColor = Color.White;
            cell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter;
        }

        private void DataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (!_isAdmin) return;
            if (e.RowIndex < 0 || e.ColumnIndex < 0) return;
            var col = _grid.Columns[e.ColumnIndex];
            if (col == null || col.Name != DeleteColName) return;
            var row = _grid.Rows[e.RowIndex];
            if (row == null || row.IsNewRow) return;
            var drv = row.DataBoundItem as DataRowView;
            if (drv == null) return;
            var res = MessageBox.Show(TranslationService.Translate("StrojiForm.DeletePrompt"), TranslationService.Translate("StrojiForm.ConfirmTitle"), MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (res != DialogResult.Yes) return;
            drv.Row.Delete();
            SaveChanges();
            LoadData();
        }

        private void BtnNovStroj_Click(object sender, EventArgs e)
        {
            if (!_isAdmin) { MessageBox.Show(TranslationService.Translate("StrojiForm.AdminOnly"), TranslationService.Translate("StrojiForm.NotAllowedTitle"), MessageBoxButtons.OK, MessageBoxIcon.Information); return; }
            if (_table == null) return;
            using (var dlg = new NovStrojDialog(_stPostFilter))
            {
                if (dlg.ShowDialog(this) != DialogResult.OK) return;
                var input = dlg.Value;
                var newRow = _table.NewRow();
                newRow["stPost"] = input.StPost;
                newRow["idstroja"] = input.IdStroja ?? "";
                newRow["sifstroja"] = input.SifStroja ?? "";
                newRow["naziv"] = input.Naziv ?? "";
                newRow["koda"] = input.Koda ?? "";
                _table.Rows.Add(newRow);
                SaveChanges();
                LoadData();
            }
        }

        private sealed class NovStrojDialog : Form
        {
            public StrojInput Value { get; private set; }
            private NumericUpDown _numStPost;
            private TextBox _tbId;
            private TextBox _tbSif;
            private TextBox _tbNaziv;
            private TextBox _tbKoda;
            private Button _btnOk;
            private Button _btnCancel;

            public NovStrojDialog(int? stPostPreset)
            {
                Text = TranslationService.Translate("StrojiForm.NewDialog.Text");
                FormBorderStyle = FormBorderStyle.FixedDialog;
                StartPosition = FormStartPosition.CenterParent;
                MaximizeBox = false;
                MinimizeBox = false;
                ShowInTaskbar = false;
                ClientSize = new Size(520, 260);
                BuildUi(stPostPreset);
            }

            private void BuildUi(int? stPostPreset)
            {
                var grid = new TableLayoutPanel { Dock = DockStyle.Fill, Padding = new Padding(12), ColumnCount = 2, RowCount = 5 };
                grid.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 140));
                grid.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
                int r = 0;
                grid.Controls.Add(new Label { Text = TranslationService.Translate("StrojiForm.NewDialog.stPost"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _numStPost = new NumericUpDown { Dock = DockStyle.Left, Minimum = 0, Maximum = 999999, Width = 160, Value = stPostPreset.HasValue ? stPostPreset.Value : 0 };
                grid.Controls.Add(_numStPost, 1, r++);

                grid.Controls.Add(new Label { Text = TranslationService.Translate("StrojiForm.NewDialog.IdStroja"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _tbId = new TextBox { Dock = DockStyle.Fill };
                grid.Controls.Add(_tbId, 1, r++);

                grid.Controls.Add(new Label { Text = TranslationService.Translate("StrojiForm.NewDialog.SifraStroja"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _tbSif = new TextBox { Dock = DockStyle.Fill };
                grid.Controls.Add(_tbSif, 1, r++);

                grid.Controls.Add(new Label { Text = TranslationService.Translate("StrojiForm.NewDialog.Naziv"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _tbNaziv = new TextBox { Dock = DockStyle.Fill };
                grid.Controls.Add(_tbNaziv, 1, r++);

                grid.Controls.Add(new Label { Text = TranslationService.Translate("StrojiForm.NewDialog.Koda"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _tbKoda = new TextBox { Dock = DockStyle.Fill };
                grid.Controls.Add(_tbKoda, 1, r++);

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
                var id = (_tbId.Text ?? "").Trim();
                var naziv = (_tbNaziv.Text ?? "").Trim();
                if (string.IsNullOrWhiteSpace(id)) { MessageBox.Show(TranslationService.Translate("StrojiForm.NewDialog.IdRequired"), TranslationService.Translate("Common.ErrorTitle"), MessageBoxButtons.OK, MessageBoxIcon.Warning); DialogResult = DialogResult.None; return; }
                if (string.IsNullOrWhiteSpace(naziv)) { MessageBox.Show(TranslationService.Translate("StrojiForm.NewDialog.NazivRequired"), TranslationService.Translate("Common.ErrorTitle"), MessageBoxButtons.OK, MessageBoxIcon.Warning); DialogResult = DialogResult.None; return; }
                Value = new StrojInput
                {
                    StPost = (int)_numStPost.Value,
                    IdStroja = id,
                    SifStroja = (_tbSif.Text ?? "").Trim(),
                    Naziv = naziv,
                    Koda = (_tbKoda.Text ?? "").Trim()
                };
            }

            internal sealed class StrojInput
            {
                public int StPost { get; set; }
                public string IdStroja { get; set; }
                public string SifStroja { get; set; }
                public string Naziv { get; set; }
                public string Koda { get; set; }
            }
        }
    }
}
