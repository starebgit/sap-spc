using System;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Drawing;
using System.Linq;
using System.Windows.Forms;
using SapSpcWinForms.Services;
using SapSpcWinForms.Utils;

namespace SapSpcWinForms
{
    public partial class MerilnaMestaForm : Form
    {
        private readonly bool _isAdmin;
        private readonly string _merilnoMestoOpis;
        private OleDbConnection _connection;
        private OleDbDataAdapter _adapter;
        private DataTable _table;

        private const string DeleteColName = "__delete";
        private const string SelectColName = "__select";

        private DataGridView _grid;
        private Label _labelHeader;
        private Panel _bottomPanel;
        private Button _btnNovaPostaja;

        public MerilnaMestaForm(bool isAdmin, string merilnoMestoOpis = null)
        {
            _isAdmin = isAdmin;
            _merilnoMestoOpis = merilnoMestoOpis;
            InitializeComponent();
            Text = TranslationService.Translate("MerilnaMestaForm.Text");
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
                Text = string.Format(
                    TranslationService.Translate("MerilnaMestaForm.Header"),
                    string.IsNullOrWhiteSpace(_merilnoMestoOpis)
                        ? TranslationService.Translate("MerilnaMestaForm.NoSelection")
                        : _merilnoMestoOpis),
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
                    Height = 44,
                    BackColor = Color.White,
                    Padding = new Padding(12, 10, 12, 12)
                };
                _btnNovaPostaja = new Button
                {
                    Dock = DockStyle.Fill,
                    Height = 40,
                    Text = TranslationService.Translate("MerilnaMestaForm.NewStationButton"),
                    Enabled = _isAdmin,
                    BackColor = Color.FromArgb(46, 204, 113),
                    ForeColor = Color.White,
                    FlatStyle = FlatStyle.Flat,
                    TextAlign = ContentAlignment.MiddleCenter
                };
                _btnNovaPostaja.FlatAppearance.BorderSize = 0;
                _btnNovaPostaja.Margin = new Padding(0, 8, 0, 0);
                _btnNovaPostaja.Click += BtnNovaPostaja_Click;
                _bottomPanel.Controls.Add(_btnNovaPostaja);
                Controls.Add(_bottomPanel);
                _bottomPanel.BringToFront();
            }

            Load += MerilnaMestaForm_Load;
            FormClosing += MerilnaMestaForm_FormClosing;
        }

        private void MerilnaMestaForm_Load(object sender, EventArgs e)
        {
            LoadData();
        }

        private void LoadData()
        {
            var connString = ConfigurationManager.ConnectionStrings["StrojnaDb"]?.ConnectionString;
            if (string.IsNullOrWhiteSpace(connString))
            {
                MessageBox.Show(TranslationService.Translate("MerilnaMestaForm.MissingConn"), TranslationService.Translate("Common.ErrorTitle"), MessageBoxButtons.OK, MessageBoxIcon.Error);
                Close();
                return;
            }

            _connection = new OleDbConnection(connString);
            _adapter = new OleDbDataAdapter(
                "SELECT stPost, imerac, com, opis, lokal, imekon, postkoda, stevrsta, izbiraKd FROM postaje",
                _connection);

            // Setup commands as before (insert, update, delete)
            _adapter.InsertCommand = new OleDbCommand(@"INSERT INTO postaje (imerac, com, opis, lokal, imekon, postkoda, stevrsta, izbiraKd) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", _connection);
            _adapter.InsertCommand.Parameters.Add("imerac", OleDbType.VarWChar, 50, "imerac");
            _adapter.InsertCommand.Parameters.Add("com", OleDbType.Integer, 0, "com");
            _adapter.InsertCommand.Parameters.Add("opis", OleDbType.VarWChar, 255, "opis");
            _adapter.InsertCommand.Parameters.Add("lokal", OleDbType.Integer, 0, "lokal");
            _adapter.InsertCommand.Parameters.Add("imekon", OleDbType.VarWChar, 100, "imekon");
            _adapter.InsertCommand.Parameters.Add("postkoda", OleDbType.VarWChar, 50, "postkoda");
            _adapter.InsertCommand.Parameters.Add("stevrsta", OleDbType.Integer, 0, "stevrsta");
            _adapter.InsertCommand.Parameters.Add("izbiraKd", OleDbType.Integer, 0, "izbiraKd");

            _adapter.UpdateCommand = new OleDbCommand(@"UPDATE postaje SET imerac = ?, com = ?, opis = ?, lokal = ?, imekon = ?, postkoda = ?, stevrsta = ?, izbiraKd = ? WHERE stPost = ?", _connection);
            _adapter.UpdateCommand.Parameters.Add("imerac", OleDbType.VarWChar, 50, "imerac");
            _adapter.UpdateCommand.Parameters.Add("com", OleDbType.Integer, 0, "com");
            _adapter.UpdateCommand.Parameters.Add("opis", OleDbType.VarWChar, 255, "opis");
            _adapter.UpdateCommand.Parameters.Add("lokal", OleDbType.Integer, 0, "lokal");
            _adapter.UpdateCommand.Parameters.Add("imekon", OleDbType.VarWChar, 100, "imekon");
            _adapter.UpdateCommand.Parameters.Add("postkoda", OleDbType.VarWChar, 50, "postkoda");
            _adapter.UpdateCommand.Parameters.Add("stevrsta", OleDbType.Integer, 0, "stevrsta");
            _adapter.UpdateCommand.Parameters.Add("izbiraKd", OleDbType.Integer, 0, "izbiraKd");
            _adapter.UpdateCommand.Parameters.Add("stPost", OleDbType.Integer, 0, "stPost").SourceVersion = DataRowVersion.Original;

            _adapter.DeleteCommand = new OleDbCommand("DELETE FROM postaje WHERE stPost = ?", _connection);
            _adapter.DeleteCommand.Parameters.Add("stPost", OleDbType.Integer, 0, "stPost").SourceVersion = DataRowVersion.Original;

            _table = new DataTable();
            _adapter.Fill(_table);
            _grid.DataSource = _table.DefaultView;

            EnsureSelectColumn();
            EnsureDeleteColumn();
        }

        private void EnsureSelectColumn()
        {
            if (_grid.Columns[SelectColName] == null)
            {
                var col = new DataGridViewButtonColumn
                {
                    Name = SelectColName,
                    HeaderText = "",
                    Text = TranslationService.Translate("MerilnaMestaForm.SelectButton"),
                    UseColumnTextForButtonValue = true,
                    Width = 70,
                    ReadOnly = true,
                    Resizable = DataGridViewTriState.False,
                    Frozen = false
                };
                // Add to the right, before delete column if present
                int deleteIdx = _grid.Columns[DeleteColName] != null ? _grid.Columns[DeleteColName].Index : _grid.Columns.Count;
                _grid.Columns.Insert(deleteIdx, col);
            }
            _grid.Columns[SelectColName].Visible = true;
        }

        private void EnsureDeleteColumn()
        {
            if (_grid.Columns[DeleteColName] == null)
            {
                var col = new DataGridViewButtonColumn
                {
                    Name = DeleteColName,
                    HeaderText = "",
                    Text = TranslationService.Translate("MerilnaMestaForm.DeleteButton"),
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
            else if (col.Name == SelectColName)
            {
                var cell = _grid.Rows[e.RowIndex].Cells[e.ColumnIndex];
                cell.Style.BackColor = Color.FromArgb(41, 128, 185); // blue
                cell.Style.ForeColor = Color.White;
                cell.Style.Alignment = DataGridViewContentAlignment.MiddleCenter;
                cell.Style.Font = new Font(_grid.Font, FontStyle.Bold);
            }
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
                var drv = row.DataBoundItem as DataRowView;
                if (drv == null) return;
                var res = MessageBox.Show(TranslationService.Translate("MerilnaMestaForm.DeletePrompt"), TranslationService.Translate("MerilnaMestaForm.ConfirmTitle"), MessageBoxButtons.YesNo, MessageBoxIcon.Question);
                if (res != DialogResult.Yes) return;
                drv.Row.Delete();
                _adapter.Update(_table);
                LoadData();
            }
            else if (col.Name == SelectColName)
            {
                var row = _grid.Rows[e.RowIndex];
                if (row == null || row.IsNewRow) return;
                var drv = row.DataBoundItem as DataRowView;
                if (drv == null) return;
                int stPost = drv.Row.Table.Columns.Contains("stPost") ? Convert.ToInt32(drv.Row["stPost"]) : 0;
                string opis = drv.Row.Table.Columns.Contains("opis") ? Convert.ToString(drv.Row["opis"]) : "";
                string imerac = drv.Row.Table.Columns.Contains("imerac") ? Convert.ToString(drv.Row["imerac"]) : "";
                SelectedMerilnoMesto = new MerilnoMestoSelection { StPost = stPost, Opis = opis, Imerac = imerac };
                MerilnoMestoState.Set(stPost, opis); // update global state immediately
                DialogResult = DialogResult.OK;
                Close();
            }
        }

        private void EnsureBottomBar()
        {
            if (_bottomPanel != null) return;

            _bottomPanel = new Panel
            {
                Dock = DockStyle.Bottom,
                Height = 44,
                BackColor = Color.White,
                Padding = new Padding(12, 10, 12, 12) // outer padding
            };

            _btnNovaPostaja = new Button
            {
                Dock = DockStyle.Fill,                 // full width
                Height = 40,
                Text = TranslationService.Translate("MerilnaMestaForm.NewStationButton"),
                Enabled = _isAdmin,
                BackColor = Color.FromArgb(46, 204, 113), // green
                ForeColor = Color.White,
                FlatStyle = FlatStyle.Flat,
                TextAlign = ContentAlignment.MiddleCenter
            };
            _btnNovaPostaja.FlatAppearance.BorderSize = 0;
            _btnNovaPostaja.Margin = new Padding(0, 8, 0, 0); // space from the table (top margin)
            _btnNovaPostaja.Click += BtnNovaPostaja_Click;

            _bottomPanel.Controls.Add(_btnNovaPostaja);

            Controls.Add(_bottomPanel);
            _bottomPanel.BringToFront();
        }

        private void SaveChanges()
        {
            if (_adapter == null || _table == null) return;

            try
            {
                // commit any active edits in the grid first
                _grid.EndEdit();

                _adapter.Update(_table);
            }
            catch (Exception ex)
            {
                MessageBox.Show(TranslationService.Translate("MerilnaMestaForm.SaveError") + "\n" + ex.Message,
                    TranslationService.Translate("Common.ErrorTitle"), MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void ReloadAndReselect(Func<DataRowView, bool> predicate = null)
        {
            // optional: remember selection
            int? keepStPost = null;
            if (predicate == null && _grid.CurrentRow != null && !_grid.CurrentRow.IsNewRow)
            {
                var drv0 = _grid.CurrentRow.DataBoundItem as DataRowView;
                if (drv0 != null && drv0.Row.Table.Columns.Contains("stPost") && drv0.Row["stPost"] != DBNull.Value)
                    keepStPost = Convert.ToInt32(drv0.Row["stPost"]);
            }

            LoadData();

            var view = _grid.DataSource as DataView;
            if (view == null) return;

            int targetIndex = -1;

            if (predicate != null)
            {
                for (int i = 0; i < view.Count; i++)
                {
                    if (predicate(view[i]))
                    {
                        targetIndex = i;
                        break;
                    }
                }
            }
            else if (keepStPost.HasValue)
            {
                for (int i = 0; i < view.Count; i++)
                {
                    if (view[i].Row["stPost"] != DBNull.Value && Convert.ToInt32(view[i].Row["stPost"]) == keepStPost.Value)
                    {
                        targetIndex = i;
                        break;
                    }
                }
            }

            if (targetIndex >= 0 && _grid.Rows.Count > targetIndex)
            {
                _grid.CurrentCell = _grid.Rows[targetIndex].Cells[0];
            }
        }

        private void MerilnaMestaForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (_table == null) return;

            if (_table.GetChanges() != null)
            {
                var result = MessageBox.Show(
                    TranslationService.Translate("MerilnaMestaForm.SavePrompt"),
                    TranslationService.Translate("MerilnaMestaForm.SaveTitle"),
                    MessageBoxButtons.YesNoCancel,
                    MessageBoxIcon.Question);

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

        // ======= TRASH ICON CLICK (row delete) =======
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
            var res = MessageBox.Show(TranslationService.Translate("MerilnaMestaForm.DeletePrompt"), TranslationService.Translate("MerilnaMestaForm.ConfirmTitle"), MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (res != DialogResult.Yes) return;
            drv.Row.Delete();
            SaveChanges();
            ReloadAndReselect();
        }

        // ======= NEW POSTAJA BUTTON (popup -> insert -> save) =======
        private void BtnNovaPostaja_Click(object sender, EventArgs e)
        {
            if (!_isAdmin)
            {
                MessageBox.Show(TranslationService.Translate("MerilnaMestaForm.AdminOnly"),
                    TranslationService.Translate("MerilnaMestaForm.NotAllowedTitle"), MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }

            if (_table == null) return;

            using (var dlg = new NovaPostajaDialog())
            {
                if (dlg.ShowDialog(this) != DialogResult.OK)
                    return;

                var input = dlg.Value;

                // create + save immediately
                var newRow = _table.NewRow();
                newRow["imerac"] = input.Imerac ?? "";
                newRow["com"] = input.Com;
                newRow["opis"] = input.Opis ?? "";
                newRow["lokal"] = input.Lokal;
                newRow["imekon"] = (object)(input.Imekon ?? "") ?? DBNull.Value;
                newRow["postkoda"] = (object)(input.Postkoda ?? "") ?? DBNull.Value;
                newRow["stevrsta"] = input.Stevrsta;
                newRow["izbiraKd"] = input.IzbiraKd;

                _table.Rows.Add(newRow);
                SaveChanges();

                // reload + reselect by (imerac+opis+postkoda) best-effort
                ReloadAndReselect(drv =>
                    string.Equals(Convert.ToString(drv.Row["imerac"]), input.Imerac, StringComparison.OrdinalIgnoreCase) &&
                    string.Equals(Convert.ToString(drv.Row["opis"]), input.Opis, StringComparison.OrdinalIgnoreCase) &&
                    string.Equals(Convert.ToString(drv.Row["postkoda"]), input.Postkoda ?? "", StringComparison.OrdinalIgnoreCase)
                );
            }
        }

        // keep these, but they won’t be used (menu hidden) — no other functionality changed
        private void vpisMerilnegaMestaToolStripMenuItem_Click(object sender, EventArgs e) { }
        private void brisiMerilnoMestoToolStripMenuItem_Click(object sender, EventArgs e) { }

        // ==========================================================
        //  Popup dialog for creating a new row
        // ==========================================================
        private sealed class NovaPostajaDialog : Form
        {
            public PostajaInput Value { get; private set; }

            private TextBox _tbImerac;
            private NumericUpDown _numCom;
            private TextBox _tbOpis;
            private ComboBox _cbLokal;
            private TextBox _tbImekon;
            private TextBox _tbPostkoda;
            private NumericUpDown _numStevrsta;
            private NumericUpDown _numIzbiraKd;

            private Button _btnOk;
            private Button _btnCancel;

            public NovaPostajaDialog()
            {
                Text = TranslationService.Translate("MerilnaMestaForm.NewDialog.Text");
                FormBorderStyle = FormBorderStyle.FixedDialog;
                StartPosition = FormStartPosition.CenterParent;
                MaximizeBox = false;
                MinimizeBox = false;
                ShowInTaskbar = false;
                ClientSize = new Size(520, 320);

                BuildUi();
            }

            private void BuildUi()
            {
                var grid = new TableLayoutPanel
                {
                    Dock = DockStyle.Fill,
                    Padding = new Padding(12),
                    ColumnCount = 2,
                    RowCount = 9,
                    AutoSize = false
                };
                grid.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 140));
                grid.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));

                int r = 0;

                grid.Controls.Add(new Label { Text = TranslationService.Translate("MerilnaMestaForm.NewDialog.Imerac"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _tbImerac = new TextBox { Dock = DockStyle.Fill, Text = Environment.MachineName };
                grid.Controls.Add(_tbImerac, 1, r++);

                grid.Controls.Add(new Label { Text = TranslationService.Translate("MerilnaMestaForm.NewDialog.ComPort"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _numCom = new NumericUpDown { Dock = DockStyle.Left, Minimum = 0, Maximum = 999, Width = 120, Value = 0 };
                grid.Controls.Add(_numCom, 1, r++);

                grid.Controls.Add(new Label { Text = TranslationService.Translate("MerilnaMestaForm.NewDialog.Opis"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _tbOpis = new TextBox { Dock = DockStyle.Fill };
                grid.Controls.Add(_tbOpis, 1, r++);

                // info text for lokal (0/1) - goes ABOVE the Lokal dropdown
                var info = new Label
                {
                    AutoSize = true,
                    MaximumSize = new Size(340, 0),
                    Text = TranslationService.Translate("MerilnaMestaForm.NewDialog.LokalHelp"),
                    ForeColor = Color.DimGray
                };

                grid.Controls.Add(info, 0, r);
                grid.SetColumnSpan(info, 2);
                r++;

                grid.Controls.Add(new Label { Text = TranslationService.Translate("MerilnaMestaForm.NewDialog.Lokal"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _cbLokal = new ComboBox { Dock = DockStyle.Left, DropDownStyle = ComboBoxStyle.DropDownList, Width = 120 };
                _cbLokal.Items.AddRange(new object[] { "0", "1" });
                _cbLokal.SelectedIndex = 1; // default 1 (server)
                grid.Controls.Add(_cbLokal, 1, r++);

                grid.Controls.Add(new Label { Text = TranslationService.Translate("MerilnaMestaForm.NewDialog.Imekon"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _tbImekon = new TextBox { Dock = DockStyle.Fill };
                grid.Controls.Add(_tbImekon, 1, r++);

                grid.Controls.Add(new Label { Text = TranslationService.Translate("MerilnaMestaForm.NewDialog.Postkoda"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _tbPostkoda = new TextBox { Dock = DockStyle.Fill };
                grid.Controls.Add(_tbPostkoda, 1, r++);

                grid.Controls.Add(new Label { Text = TranslationService.Translate("MerilnaMestaForm.NewDialog.Stevrsta"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _numStevrsta = new NumericUpDown { Dock = DockStyle.Left, Minimum = 0, Maximum = 999, Width = 120, Value = 6 };
                grid.Controls.Add(_numStevrsta, 1, r++);

                grid.Controls.Add(new Label { Text = TranslationService.Translate("MerilnaMestaForm.NewDialog.IzbiraKd"), AutoSize = true, Anchor = AnchorStyles.Left }, 0, r);
                _numIzbiraKd = new NumericUpDown { Dock = DockStyle.Left, Minimum = 0, Maximum = 999, Width = 120, Value = 0 };
                grid.Controls.Add(_numIzbiraKd, 1, r++);

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
                var imerac = (_tbImerac.Text ?? "").Trim();
                var opis = (_tbOpis.Text ?? "").Trim();

                if (string.IsNullOrWhiteSpace(imerac))
                {
                    MessageBox.Show(TranslationService.Translate("MerilnaMestaForm.NewDialog.ImeracRequired"), TranslationService.Translate("Common.ErrorTitle"),
                        MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    DialogResult = DialogResult.None;
                    return;
                }

                if (string.IsNullOrWhiteSpace(opis))
                {
                    MessageBox.Show(TranslationService.Translate("MerilnaMestaForm.NewDialog.OpisRequired"), TranslationService.Translate("Common.ErrorTitle"),
                        MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    DialogResult = DialogResult.None;
                    return;
                }

                int lokal = int.Parse(_cbLokal.SelectedItem?.ToString() ?? "1");

                Value = new PostajaInput
                {
                    Imerac = imerac,
                    Com = (int)_numCom.Value,
                    Opis = opis,
                    Lokal = lokal,
                    Imekon = (_tbImekon.Text ?? "").Trim(),
                    Postkoda = (_tbPostkoda.Text ?? "").Trim(),
                    Stevrsta = (int)_numStevrsta.Value,
                    IzbiraKd = (int)_numIzbiraKd.Value
                };
            }

            internal sealed class PostajaInput
            {
                public string Imerac { get; set; }
                public int Com { get; set; }
                public string Opis { get; set; }
                public int Lokal { get; set; }
                public string Imekon { get; set; }
                public string Postkoda { get; set; }
                public int Stevrsta { get; set; }
                public int IzbiraKd { get; set; }
            }
        }

        public class MerilnoMestoSelection
        {
            public int StPost { get; set; }
            public string Opis { get; set; }
            public string Imerac { get; set; }
        }
        public MerilnoMestoSelection SelectedMerilnoMesto { get; private set; }
    }
}
