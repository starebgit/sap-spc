using System;
using System.Data;
using System.Data.OleDb;
using System.Drawing;
using System.Windows.Forms;
using System.Configuration;

using SapSpcWinForms.Services;
using SapSpcWinForms.Utils;

namespace SapSpcWinForms
{
    public sealed class DodatneKodeForm : Form
    {
        private readonly string _koda;
        private OleDbConnection _connection;
        private OleDbDataAdapter _adapter;
        private DataTable _table;
        private DataGridView _grid;
        private Button _btnAdd;
        private Button _btnDelete;
        private Label _labelHeader;
        private Panel _bottomPanel;
        
        public DodatneKodeForm(string koda)
        {
            _koda = koda;
            Text = TranslationService.Translate("DodatneKodeForm.Text");
            StartPosition = FormStartPosition.CenterParent;
            Width = 500;
            Height = 400;
            BuildUi();
            UiTheme.ApplyFormTheme(this);
            Load += DodatneKodeForm_Load;
        }

        private void BuildUi()
        {
            _labelHeader = new Label
            {
                Dock = DockStyle.Top,
                Height = 32,
                Font = new Font("Segoe UI", 11F, FontStyle.Bold),
                ForeColor = Color.FromArgb(0, 64, 128),
                Text = string.Format(TranslationService.Translate("DodatneKodeForm.Header"), _koda),
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

            _bottomPanel = new Panel
            {
                Dock = DockStyle.Bottom,
                Height = 44,
                BackColor = Color.White,
                Padding = new Padding(12, 10, 12, 12)
            };
            _btnAdd = new Button
            {
                Text = TranslationService.Translate("DodatneKodeForm.AddButton"),
                Width = 100,
                Height = 30,
                BackColor = Color.FromArgb(46, 204, 113),
                ForeColor = Color.White,
                FlatStyle = FlatStyle.Flat,
                Left = 0
            };
            _btnAdd.FlatAppearance.BorderSize = 0;
            _btnAdd.Click += BtnAdd_Click;

            _btnDelete = new Button
            {
                Text = TranslationService.Translate("DodatneKodeForm.DeleteButton"),
                Width = 100,
                Height = 30,
                BackColor = Color.FromArgb(231, 76, 60),
                ForeColor = Color.White,
                FlatStyle = FlatStyle.Flat,
                Left = 110
            };
            _btnDelete.FlatAppearance.BorderSize = 0;
            _btnDelete.Click += BtnDelete_Click;

            _bottomPanel.Controls.Add(_btnAdd);
            _bottomPanel.Controls.Add(_btnDelete);

            Controls.Clear();
            Controls.Add(_grid);
            Controls.Add(_labelHeader);
            Controls.Add(_bottomPanel);
        }

        private void DodatneKodeForm_Load(object sender, EventArgs e)
        {
            LoadData();
        }

        private void LoadData()
        {
            var connString = ConfigurationManager.ConnectionStrings["StrojnaDb"]?.ConnectionString;
            if (string.IsNullOrWhiteSpace(connString))
            {
                MessageBox.Show(TranslationService.Translate("DodatneKodeForm.MissingConn"), TranslationService.Translate("Common.ErrorTitle"), MessageBoxButtons.OK, MessageBoxIcon.Error);
                Close();
                return;
            }
            _connection = new OleDbConnection(connString);
            _adapter = new OleDbDataAdapter(
                "SELECT zaopored, koda, naziv FROM dodatkod WHERE koda = ? ORDER BY zaopored",
                _connection);
            _adapter.SelectCommand.Parameters.AddWithValue("@koda", _koda);
            _table = new DataTable();
            _adapter.Fill(_table);
            _grid.DataSource = _table;
            if (_grid.Columns.Contains("zaopored"))
                _grid.Columns["zaopored"].HeaderText = TranslationService.Translate("Common.Ordinal");
            if (_grid.Columns.Contains("naziv"))
                _grid.Columns["naziv"].HeaderText = TranslationService.Translate("DodatneKodeForm.Col.Name");
            if (_grid.Columns.Contains("koda"))
                _grid.Columns["koda"].Visible = false;
        }

        private void BtnAdd_Click(object sender, EventArgs e)
        {
            using (var dlg = new InputBoxDialog(TranslationService.Translate("DodatneKodeForm.InputPrompt")))
            {
                if (dlg.ShowDialog(this) == DialogResult.OK)
                {
                    var naziv = dlg.Value;
                    if (!string.IsNullOrWhiteSpace(naziv))
                    {
                        var newRow = _table.NewRow();
                        newRow["koda"] = _koda; // Set koda on insert
                        newRow["naziv"] = naziv;
                        // zaopored is auto-increment in DB, leave null
                        _table.Rows.Add(newRow);
                        SaveChanges();
                        LoadData();
                    }
                }
            }
        }

        private void BtnDelete_Click(object sender, EventArgs e)
        {
            if (_grid.SelectedRows.Count > 0)
            {
                var res = MessageBox.Show(TranslationService.Translate("DodatneKodeForm.DeletePrompt"), TranslationService.Translate("DodatneKodeForm.ConfirmTitle"), MessageBoxButtons.YesNo, MessageBoxIcon.Question);
                if (res == DialogResult.Yes)
                {
                    foreach (DataGridViewRow row in _grid.SelectedRows)
                    {
                        if (!row.IsNewRow)
                        {
                            _grid.Rows.Remove(row);
                        }
                    }
                    SaveChanges();
                    LoadData();
                }
            }
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
                        "INSERT INTO dodatkod (koda, naziv) VALUES (?, ?)", _connection);
                    // koda: fixed value from form field
                    _adapter.InsertCommand.Parameters.Add("koda", OleDbType.VarWChar, 50, "koda");
                    // naziv: from DataTable column
                    _adapter.InsertCommand.Parameters.Add("naziv", OleDbType.VarWChar, 255, "naziv");
                }
                if (_adapter.DeleteCommand == null)
                {
                    _adapter.DeleteCommand = new OleDbCommand(
                        "DELETE FROM dodatkod WHERE zaopored = ?", _connection);
                    var p = _adapter.DeleteCommand.Parameters.Add("zaopored", OleDbType.Integer, 0, "zaopored");
                    p.SourceVersion = DataRowVersion.Original;
                }
                _adapter.Update(_table);
            }
            catch (Exception ex)
            {
                MessageBox.Show(TranslationService.Translate("DodatneKodeForm.SaveError") + "\n" + ex.Message, TranslationService.Translate("Common.ErrorTitle"), MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }

    // Simple input dialog for adding/editing naziv
    public sealed class InputBoxDialog : Form
    {
        public string Value { get; private set; }
        private TextBox _tbInput;
        private Button _btnOk;
        private Button _btnCancel;
        public InputBoxDialog(string prompt)
        {
            Text = TranslationService.Translate("DodatneKodeForm.InputTitle");
            FormBorderStyle = FormBorderStyle.FixedDialog;
            StartPosition = FormStartPosition.CenterParent;
            MaximizeBox = false;
            MinimizeBox = false;
            ShowInTaskbar = false;
            ClientSize = new Size(320, 120);
            BuildUi(prompt);
        }
        private void BuildUi(string prompt)
        {
            var label = new Label { Text = prompt, Dock = DockStyle.Top, Height = 32, TextAlign = ContentAlignment.MiddleLeft };
            _tbInput = new TextBox { Dock = DockStyle.Top, Margin = new Padding(8), Height = 28 };
            var buttons = new FlowLayoutPanel { Dock = DockStyle.Bottom, FlowDirection = FlowDirection.RightToLeft, Height = 40 };
            _btnOk = new Button { Text = TranslationService.Translate("Common.Ok"), DialogResult = DialogResult.OK, AutoSize = true };
            _btnCancel = new Button { Text = TranslationService.Translate("Common.Cancel"), DialogResult = DialogResult.Cancel, AutoSize = true };
            _btnOk.Click += Ok_Click;
            buttons.Controls.Add(_btnOk);
            buttons.Controls.Add(_btnCancel);
            Controls.Add(label);
            Controls.Add(_tbInput);
            Controls.Add(buttons);
            AcceptButton = _btnOk;
            CancelButton = _btnCancel;
        }
        private void Ok_Click(object sender, EventArgs e)
        {
            Value = (_tbInput.Text ?? "").Trim();
        }
    }
}
