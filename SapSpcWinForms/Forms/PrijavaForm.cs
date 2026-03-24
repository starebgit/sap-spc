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
    public sealed class PrijavaForm : Form
    {
        private OleDbConnection _connection;
        private OleDbDataAdapter _adapter;
        private DataTable _table;
        private DataGridView _grid;
        private Label _labelHeader;
        private Panel _bottomPanel;
        private Button _btnNovVpis;
        private Button _btnIzberiPrijavo;
        private int? _selectedId = null;

        public PrijavaForm()
        {
            Text = TranslationService.Translate("PrijavaForm.Text");
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
                Text = TranslationService.Translate("PrijavaForm.Header"),
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
            _grid.SelectionChanged += Grid_SelectionChanged;

            Controls.Clear();
            Controls.Add(_grid);
            Controls.Add(_labelHeader);

            if (_bottomPanel == null)
            {
                _bottomPanel = new Panel
                {
                    Dock = DockStyle.Bottom,
                    Height = 56,
                    BackColor = Color.White,
                    Padding = new Padding(12, 8, 12, 8)
                };
                _btnNovVpis = new Button
                {
                    Dock = DockStyle.Left,
                    Width = 160,
                    Text = TranslationService.Translate("PrijavaForm.NewEntryButton"),
                    BackColor = Color.FromArgb(46, 204, 113),
                    ForeColor = Color.White,
                    FlatStyle = FlatStyle.Flat,
                    TextAlign = ContentAlignment.MiddleCenter
                };
                _btnNovVpis.FlatAppearance.BorderSize = 0;
                _btnNovVpis.Click += BtnNovVpis_Click;

                _btnIzberiPrijavo = new Button
                {
                    Dock = DockStyle.Right,
                    Width = 160,
                    Text = TranslationService.Translate("PrijavaForm.SelectLoginButton"),
                    BackColor = Color.FromArgb(41, 128, 185),
                    ForeColor = Color.White,
                    FlatStyle = FlatStyle.Flat,
                    TextAlign = ContentAlignment.MiddleCenter
                };
                _btnIzberiPrijavo.FlatAppearance.BorderSize = 0;
                _btnIzberiPrijavo.Click += BtnIzberiPrijavo_Click;

                _bottomPanel.Controls.Add(_btnNovVpis);
                _bottomPanel.Controls.Add(_btnIzberiPrijavo);
                Controls.Add(_bottomPanel);
                _bottomPanel.BringToFront();
            }

            Load += PrijavaForm_Load;
        }

        private void PrijavaForm_Load(object sender, EventArgs e)
        {
            LoadData();
        }

        private string GetPrijavaConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["SapPrijavaDb"].ConnectionString;
        }

        private void LoadData()
        {
            var connString = GetPrijavaConnectionString();
            _connection = new OleDbConnection(connString);
            _adapter = new OleDbDataAdapter(
                "SELECT ident, uporab, sistem, client, streznik, sysnnum, pass, jezik, glavni FROM prijava ORDER BY ident",
                _connection);
            _table = new DataTable();
            _adapter.Fill(_table);
            _grid.DataSource = _table;
            // Set user-friendly column headers and hide technical columns
            if (_grid.Columns.Contains("ident"))
                _grid.Columns["ident"].Visible = false;
            if (_grid.Columns.Contains("uporab"))
                _grid.Columns["uporab"].HeaderText = TranslationService.Translate("PrijavaForm.Col.Uporabnik");
            if (_grid.Columns.Contains("sistem"))
                _grid.Columns["sistem"].HeaderText = TranslationService.Translate("PrijavaForm.Col.Sistem");
            if (_grid.Columns.Contains("client"))
                _grid.Columns["client"].HeaderText = TranslationService.Translate("PrijavaForm.Col.Client");
            if (_grid.Columns.Contains("streznik"))
                _grid.Columns["streznik"].HeaderText = TranslationService.Translate("PrijavaForm.Col.Streznik");
            if (_grid.Columns.Contains("sysnnum"))
                _grid.Columns["sysnnum"].HeaderText = TranslationService.Translate("PrijavaForm.Col.SysNum");
            if (_grid.Columns.Contains("pass"))
                _grid.Columns["pass"].HeaderText = TranslationService.Translate("PrijavaForm.Col.Geslo");
            if (_grid.Columns.Contains("jezik"))
                _grid.Columns["jezik"].HeaderText = TranslationService.Translate("PrijavaForm.Col.Jezik");
            if (_grid.Columns.Contains("glavni"))
                _grid.Columns["glavni"].HeaderText = TranslationService.Translate("PrijavaForm.Col.Privzeta");
        }

        private void Grid_SelectionChanged(object sender, EventArgs e)
        {
            if (_grid.SelectedRows.Count > 0)
            {
                var row = _grid.SelectedRows[0];
                if (row != null && row.Cells["ident"].Value != DBNull.Value)
                {
                    _selectedId = Convert.ToInt32(row.Cells["ident"].Value);
                }
            }
            else
            {
                _selectedId = null;
            }
        }

        private void BtnNovVpis_Click(object sender, EventArgs e)
        {
            using (var dlg = new NovaPrijavaDialog())
            {
                if (dlg.ShowDialog(this) != DialogResult.OK)
                    return;
                var input = dlg.Value;
                var newRow = _table.NewRow();
                newRow["uporab"] = input.Uporabnik;
                newRow["sistem"] = input.Sistem;
                newRow["client"] = input.Client;
                newRow["streznik"] = input.Streznik;
                newRow["sysnnum"] = input.Sysnnum;
                newRow["pass"] = input.Geslo;
                newRow["jezik"] = input.Jezik;
                newRow["glavni"] = input.Privzeta ? "X" : "";
                _table.Rows.Add(newRow);
                SaveChanges();
                LoadData();
            }
        }

        private void BtnIzberiPrijavo_Click(object sender, EventArgs e)
        {
            if (!_selectedId.HasValue)
            {
                MessageBox.Show(TranslationService.Translate("PrijavaForm.SelectFirstMessage"), TranslationService.Translate("PrijavaForm.SelectTitle"),
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            SapSession.SetSelectedPrijava(_selectedId.Value);

            DialogResult = DialogResult.OK;
            Close();
        }

        private void SaveChanges()
        {
            if (_adapter == null || _table == null) return;
            try
            {
                _grid.EndEdit();
                if (_adapter.InsertCommand == null)
                {
                    _adapter.InsertCommand = new OleDbCommand(
                        "INSERT INTO prijava (uporab, sistem, client, streznik, sysnnum, pass, jezik, glavni) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", _connection);
                    _adapter.InsertCommand.Parameters.Add("uporab", OleDbType.VarWChar, 50, "uporab");
                    _adapter.InsertCommand.Parameters.Add("sistem", OleDbType.VarWChar, 50, "sistem");
                    _adapter.InsertCommand.Parameters.Add("client", OleDbType.VarWChar, 10, "client");
                    _adapter.InsertCommand.Parameters.Add("streznik", OleDbType.VarWChar, 100, "streznik");
                    _adapter.InsertCommand.Parameters.Add("sysnnum", OleDbType.Integer, 0, "sysnnum");
                    _adapter.InsertCommand.Parameters.Add("pass", OleDbType.VarWChar, 50, "pass");
                    _adapter.InsertCommand.Parameters.Add("jezik", OleDbType.VarWChar, 10, "jezik");
                    _adapter.InsertCommand.Parameters.Add("glavni", OleDbType.VarWChar, 1, "glavni");
                }
                _adapter.Update(_table);
            }
            catch (Exception ex)
            {
                MessageBox.Show(TranslationService.Translate("PrijavaForm.SaveError") + "\n" + ex.Message, TranslationService.Translate("Common.ErrorTitle"), MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private sealed class NovaPrijavaDialog : Form
        {
            public PrijavaInput Value { get; private set; }
            private TextBox _tbSistem, _tbClient, _tbStreznik, _tbSysnnum, _tbUporabnik, _tbGeslo, _tbJezik;
            private CheckBox _cbPrivzeta;
            private Button _btnOk, _btnCancel;
            public NovaPrijavaDialog()
            {
                Text = TranslationService.Translate("PrijavaForm.NewDialog.Text");
                FormBorderStyle = FormBorderStyle.FixedDialog;
                StartPosition = FormStartPosition.CenterParent;
                MaximizeBox = false;
                MinimizeBox = false;
                ShowInTaskbar = false;
                ClientSize = new Size(400, 340);
                BuildUi();
            }
            private void BuildUi()
            {
                var grid = new TableLayoutPanel
                {
                    Dock = DockStyle.Fill,
                    Padding = new Padding(12),
                    ColumnCount = 2,
                    RowCount = 8,
                    AutoSize = false
                };
                grid.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 120));
                grid.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
                int r = 0;
                grid.Controls.Add(new Label { Text = TranslationService.Translate("PrijavaForm.Col.Sistem"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _tbSistem = new TextBox { Dock = DockStyle.Fill };
                grid.Controls.Add(_tbSistem, 1, r++);
                grid.Controls.Add(new Label { Text = TranslationService.Translate("PrijavaForm.Col.Client"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _tbClient = new TextBox { Dock = DockStyle.Fill };
                grid.Controls.Add(_tbClient, 1, r++);
                grid.Controls.Add(new Label { Text = TranslationService.Translate("PrijavaForm.Col.Streznik"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _tbStreznik = new TextBox { Dock = DockStyle.Fill };
                grid.Controls.Add(_tbStreznik, 1, r++);
                grid.Controls.Add(new Label { Text = TranslationService.Translate("PrijavaForm.Col.SysNum"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _tbSysnnum = new TextBox { Dock = DockStyle.Fill };
                grid.Controls.Add(_tbSysnnum, 1, r++);
                grid.Controls.Add(new Label { Text = TranslationService.Translate("PrijavaForm.Col.Uporabnik"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _tbUporabnik = new TextBox { Dock = DockStyle.Fill };
                grid.Controls.Add(_tbUporabnik, 1, r++);
                grid.Controls.Add(new Label { Text = TranslationService.Translate("PrijavaForm.Col.Geslo"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _tbGeslo = new TextBox { Dock = DockStyle.Fill, UseSystemPasswordChar = true };
                grid.Controls.Add(_tbGeslo, 1, r++);
                grid.Controls.Add(new Label { Text = TranslationService.Translate("PrijavaForm.Col.Jezik"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _tbJezik = new TextBox { Dock = DockStyle.Fill };
                grid.Controls.Add(_tbJezik, 1, r++);
                grid.Controls.Add(new Label { Text = TranslationService.Translate("PrijavaForm.Col.Privzeta"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _cbPrivzeta = new CheckBox { Dock = DockStyle.Left };
                grid.Controls.Add(_cbPrivzeta, 1, r++);
                var buttons = new FlowLayoutPanel
                {
                    Dock = DockStyle.Bottom,
                    FlowDirection = FlowDirection.RightToLeft,
                    Padding = new Padding(12),
                    Height = 52
                };
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
                Value = new PrijavaInput
                {
                    Sistem = (_tbSistem.Text ?? "").Trim(),
                    Client = (_tbClient.Text ?? "").Trim(),
                    Streznik = (_tbStreznik.Text ?? "").Trim(),
                    Sysnnum = int.TryParse(_tbSysnnum.Text, out int n) ? n : 0,
                    Uporabnik = (_tbUporabnik.Text ?? "").Trim(),
                    Geslo = (_tbGeslo.Text ?? "").Trim(),
                    Jezik = (_tbJezik.Text ?? "").Trim(),
                    Privzeta = _cbPrivzeta.Checked
                };
            }
            internal sealed class PrijavaInput
            {
                public string Sistem { get; set; }
                public string Client { get; set; }
                public string Streznik { get; set; }
                public int Sysnnum { get; set; }
                public string Uporabnik { get; set; }
                public string Geslo { get; set; }
                public string Jezik { get; set; }
                public bool Privzeta { get; set; }
            }
        }
    }
}
