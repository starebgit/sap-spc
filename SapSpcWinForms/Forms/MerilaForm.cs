using System;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Drawing;
using System.Windows.Forms;

namespace SapSpcWinForms
{
    public sealed class MerilaForm : Form
    {
        private readonly bool _isAdmin;
        private readonly int? _idPost;
        private readonly string _merilnoMestoOpis;
        private OleDbConnection _connection;
        private OleDbDataAdapter _adapter;
        private DataTable _table;
        private DataGridView _grid;
        private Label _labelHeader;
        private Panel _bottomPanel;
        private Button _btnNovVnos;
        private const string DeleteColName = "__delete";

        public MerilaForm(bool isAdmin, int? idPost = null, string merilnoMestoOpis = null)
        {
            _isAdmin = isAdmin;
            _idPost = idPost;
            _merilnoMestoOpis = merilnoMestoOpis;
            Text = "Merila";
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
                Text = $"Merilno mesto: {_merilnoMestoOpis ?? ""}",
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

            if (_bottomPanel == null)
            {
                _bottomPanel = new Panel
                {
                    Dock = DockStyle.Bottom,
                    Height = 44,
                    BackColor = Color.White,
                    Padding = new Padding(12, 10, 12, 12)
                };
                _btnNovVnos = new Button
                {
                    Dock = DockStyle.Fill,
                    Height = 40,
                    Text = "+ Novo merilo",
                    Enabled = _isAdmin,
                    BackColor = Color.FromArgb(46, 204, 113),
                    ForeColor = Color.White,
                    FlatStyle = FlatStyle.Flat,
                    TextAlign = ContentAlignment.MiddleCenter
                };
                _btnNovVnos.FlatAppearance.BorderSize = 0;
                _btnNovVnos.Click += BtnNovVnos_Click;
                _bottomPanel.Controls.Add(_btnNovVnos);
                Controls.Add(_bottomPanel);
                _bottomPanel.BringToFront();
            }

            Load += MerilaForm_Load;
        }

        private void MerilaForm_Load(object sender, EventArgs e)
        {
            LoadData();
        }

        private void LoadData()
        {
            if (!_idPost.HasValue)
            {
                MessageBox.Show("Merilno mesto ni izbrano.", "Napaka", MessageBoxButtons.OK, MessageBoxIcon.Error);
                Close();
                return;
            }
            var connString = ConfigurationManager.ConnectionStrings["StrojnaDb"]?.ConnectionString;
            if (string.IsNullOrWhiteSpace(connString))
            {
                MessageBox.Show("Manjka connection string 'StrojnaDb' v App.config.", "Napaka", MessageBoxButtons.OK, MessageBoxIcon.Error);
                Close();
                return;
            }
            _connection = new OleDbConnection(connString);
            _adapter = new OleDbDataAdapter(
                "SELECT idmerila, red, idpost, stevilka, naziv, opis FROM merila WHERE idpost = ? ORDER BY red",
                _connection);
            _adapter.SelectCommand.Parameters.AddWithValue("@idpost", _idPost.Value);
            _table = new DataTable();
            _adapter.Fill(_table);
            _grid.DataSource = _table;
            // Set user-friendly column headers and hide technical columns
            if (_grid.Columns.Contains("idmerila"))
                _grid.Columns["idmerila"].Visible = false;
            if (_grid.Columns.Contains("idpost"))
                _grid.Columns["idpost"].Visible = false;
            if (_grid.Columns.Contains("red"))
                _grid.Columns["red"].HeaderText = "Zap. št.";
            if (_grid.Columns.Contains("stevilka"))
                _grid.Columns["stevilka"].HeaderText = "ID merila";
            if (_grid.Columns.Contains("naziv"))
                _grid.Columns["naziv"].HeaderText = "Naziv merila";
            if (_grid.Columns.Contains("opis"))
                _grid.Columns["opis"].HeaderText = "Opis merila";
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
                    Text = "Izbriši",
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

        private void Grid_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0) return;
            var col = _grid.Columns[e.ColumnIndex];
            if (col == null) return;
            if (col.Name == DeleteColName)
            {
                var cell = _grid.Rows[e.RowIndex].Cells[e.ColumnIndex];
                cell.Style.BackColor = Color.FromArgb(231, 76, 60);
                cell.Style.ForeColor = Color.White;
                cell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter;
            }
        }

        private void BtnRefresh_Click(object sender, EventArgs e)
        {
            LoadData();
        }

        private void Grid_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0) return;
            var col = _grid.Columns[e.ColumnIndex];
            if (col == null) return;
            if (col.Name == DeleteColName)
            {
                if (!_isAdmin) return;
                var row = _grid.Rows[e.RowIndex];
                if (row == null || row.IsNewRow) return;
                var res = MessageBox.Show("Ali zares želiš izbrisati izbrano merilo?", "Potrditev", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
                if (res != DialogResult.Yes) return;
                _grid.Rows.RemoveAt(e.RowIndex);
                SaveChanges();
                LoadData();
            }
        }

        private void BtnNovVnos_Click(object sender, EventArgs e)
        {
            if (!_isAdmin)
            {
                MessageBox.Show("Vpis merila je dovoljen samo administratorju.", "Ni dovoljeno", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }
            using (var dlg = new NovaMeriloDialog())
            {
                if (dlg.ShowDialog(this) != DialogResult.OK)
                    return;
                var input = dlg.Value;
                var newRow = _table.NewRow();
                newRow["red"] = input.Red;
                newRow["idpost"] = _idPost.Value;
                newRow["stevilka"] = input.Stevilka;
                newRow["naziv"] = input.Naziv;
                newRow["opis"] = input.Opis;
                _table.Rows.Add(newRow);
                SaveChanges();
                LoadData();
            }
        }

        private void SaveChanges()
        {
            if (_adapter == null || _table == null) return;
            try
            {
                _grid.EndEdit();
                // Explicitly set InsertCommand with parameter types
                if (_adapter.InsertCommand == null)
                {
                    _adapter.InsertCommand = new OleDbCommand(
                        "INSERT INTO merila (red, idpost, stevilka, naziv, opis) VALUES (?, ?, ?, ?, ?)", _connection);
                    _adapter.InsertCommand.Parameters.Add("red", OleDbType.Integer, 0, "red");
                    _adapter.InsertCommand.Parameters.Add("idpost", OleDbType.Integer, 0, "idpost");
                    _adapter.InsertCommand.Parameters.Add("stevilka", OleDbType.VarWChar, 6, "stevilka");
                    _adapter.InsertCommand.Parameters.Add("naziv", OleDbType.VarWChar, 50, "naziv");
                    _adapter.InsertCommand.Parameters.Add("opis", OleDbType.VarWChar, 50, "opis");
                }
                // Explicitly set UpdateCommand with parameter types
                if (_adapter.UpdateCommand == null)
                {
                    _adapter.UpdateCommand = new OleDbCommand(
                        "UPDATE merila SET red=?, idpost=?, stevilka=?, naziv=?, opis=? WHERE idmerila=?", _connection);
                    _adapter.UpdateCommand.Parameters.Add("red", OleDbType.Integer, 0, "red");
                    _adapter.UpdateCommand.Parameters.Add("idpost", OleDbType.Integer, 0, "idpost");
                    _adapter.UpdateCommand.Parameters.Add("stevilka", OleDbType.VarWChar, 6, "stevilka");
                    _adapter.UpdateCommand.Parameters.Add("naziv", OleDbType.VarWChar, 50, "naziv");
                    _adapter.UpdateCommand.Parameters.Add("opis", OleDbType.VarWChar, 50, "opis");
                    var p = _adapter.UpdateCommand.Parameters.Add("idmerila", OleDbType.Integer, 0, "idmerila");
                    p.SourceVersion = DataRowVersion.Original;
                }
                // Explicitly set DeleteCommand with parameter types
                if (_adapter.DeleteCommand == null)
                {
                    _adapter.DeleteCommand = new OleDbCommand(
                        "DELETE FROM merila WHERE idmerila=?", _connection);
                    var p = _adapter.DeleteCommand.Parameters.Add("idmerila", OleDbType.Integer, 0, "idmerila");
                    p.SourceVersion = DataRowVersion.Original;
                }
                _adapter.Update(_table);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Napaka pri shranjevanju sprememb:\n" + ex.Message, "Napaka", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private sealed class NovaMeriloDialog : Form
        {
            public MeriloInput Value { get; private set; }
            private NumericUpDown _numRed;
            private TextBox _tbStevilka;
            private TextBox _tbNaziv;
            private TextBox _tbOpis;
            private Button _btnOk;
            private Button _btnCancel;
            public NovaMeriloDialog()
            {
                Text = "Novo merilo";
                FormBorderStyle = FormBorderStyle.FixedDialog;
                StartPosition = FormStartPosition.CenterParent;
                MaximizeBox = false;
                MinimizeBox = false;
                ShowInTaskbar = false;
                ClientSize = new Size(400, 240);
                BuildUi();
            }
            private void BuildUi()
            {
                var grid = new TableLayoutPanel
                {
                    Dock = DockStyle.Fill,
                    Padding = new Padding(12),
                    ColumnCount = 2,
                    RowCount = 4,
                    AutoSize = false
                };
                grid.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 120));
                grid.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
                int r = 0;
                grid.Controls.Add(new Label { Text = "Zap. št.", AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _numRed = new NumericUpDown { Dock = DockStyle.Left, Minimum = 1, Maximum = 999, Width = 80, Value = 1 };
                grid.Controls.Add(_numRed, 1, r++);
                grid.Controls.Add(new Label { Text = "ID merila", AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _tbStevilka = new TextBox { Dock = DockStyle.Fill };
                grid.Controls.Add(_tbStevilka, 1, r++);
                grid.Controls.Add(new Label { Text = "Naziv merila", AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _tbNaziv = new TextBox { Dock = DockStyle.Fill };
                grid.Controls.Add(_tbNaziv, 1, r++);
                grid.Controls.Add(new Label { Text = "Opis merila", AutoSize = true, Anchor = AnchorStyles.Left, TextAlign = ContentAlignment.MiddleLeft }, 0, r);
                _tbOpis = new TextBox { Dock = DockStyle.Fill, Multiline = false, Margin = new Padding(0, 4, 0, 4) };
                grid.Controls.Add(_tbOpis, 1, r++);
                var buttons = new FlowLayoutPanel
                {
                    Dock = DockStyle.Bottom,
                    FlowDirection = FlowDirection.RightToLeft,
                    Padding = new Padding(12),
                    Height = 52
                };
                _btnOk = new Button { Text = "V redu", DialogResult = DialogResult.OK, AutoSize = true };
                _btnCancel = new Button { Text = "Prekliči", DialogResult = DialogResult.Cancel, AutoSize = true };
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
                Value = new MeriloInput
                {
                    Red = (int)_numRed.Value,
                    Stevilka = (_tbStevilka.Text ?? "").Trim(),
                    Naziv = (_tbNaziv.Text ?? "").Trim(),
                    Opis = (_tbOpis.Text ?? "").Trim()
                };
            }
            internal sealed class MeriloInput
            {
                public int Red { get; set; }
                public string Stevilka { get; set; }
                public string Naziv { get; set; }
                public string Opis { get; set; }
            }
        }
    }
}
