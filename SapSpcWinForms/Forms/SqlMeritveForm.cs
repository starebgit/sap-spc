using System;
using System.Data;
using System.Data.OleDb;
using System.Configuration;
using System.Drawing;
using System.Windows.Forms;

namespace SapSpcWinForms
{
    public partial class SqlMeritveForm : Form
    {
        private readonly bool _isAdmin;
        private readonly int _idpost;
        private readonly string _postajaNaziv;
        private readonly string _connStr;

        private readonly DataTable _dtGlav = new DataTable();
        private readonly DataTable _dtKar = new DataTable();

        private OleDbDataAdapter _daGlav;
        private OleDbDataAdapter _daKar;

        private readonly BindingSource _bsGlav = new BindingSource();
        private readonly BindingSource _bsKar = new BindingSource();

        private DataGridView _gridGlav;
        private DataGridView _gridKar;
        private Label _lblPostaja;
        private Button _btnDelete;
        // --- Modern filter state ---
        private DateTime? _filterFrom = DateTime.Today.AddDays(-1);
        private DateTime? _filterToInclusive = DateTime.Today; // inclusive UI date
        private string _filterKoda = "";
        private string _filterSarza = "";

        private TextBox _txtKodaFilter;
        private TextBox _txtSarzaFilter;
        private DateTimePicker _dtFrom;
        private DateTimePicker _dtTo;
        private Button _btnClear;

        public SqlMeritveForm(bool isAdmin, int idpost, string postajaNaziv)
        {
            _isAdmin = isAdmin;
            _idpost = idpost;
            _postajaNaziv = postajaNaziv ?? "";
            _connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;

            BuildUi();
            LoadGlavMeritve();
        }

        private void BuildUi()
        {
            Text = TranslationService.Translate("SqlMeritveForm.Text");
            StartPosition = FormStartPosition.CenterParent;
            Width = 1200;
            Height = 750;

            // Use TableLayoutPanel for proper layout
            var layout = new TableLayoutPanel
            {
                Dock = DockStyle.Fill,
                RowCount = 3,
                ColumnCount = 1,
            };
            layout.RowStyles.Add(new RowStyle(SizeType.Absolute, 42)); // header row
            layout.RowStyles.Add(new RowStyle(SizeType.Absolute, 44)); // filter row
            layout.RowStyles.Add(new RowStyle(SizeType.Percent, 100F)); // grids
            layout.RowCount = 3;
            Controls.Add(layout);

            var top = new Panel { Dock = DockStyle.Fill, Height = 42, BackColor = Color.FromArgb(0xDE, 0xDA, 0xC0) };
            layout.Controls.Add(top, 0, 0);

            _lblPostaja = new Label
            {
                AutoSize = true,
                Left = 12,
                Top = 12,
                Font = new Font("Segoe UI", 10, FontStyle.Bold),
                Text = string.Format(TranslationService.Translate("SqlMeritveForm.Header"), _postajaNaziv, _idpost)
            };
            top.Controls.Add(_lblPostaja);

            _btnDelete = new Button
            {
                Text = TranslationService.Translate("SqlMeritveForm.DeleteButton"),
                Width = 140,
                Height = 26,
                Left = 1000, // will be adjusted by Anchor
                Top = 8,
                Anchor = AnchorStyles.Top | AnchorStyles.Right,
                Enabled = _isAdmin
            };
            _btnDelete.Click += BtnDelete_Click;
            top.Controls.Add(_btnDelete);

            // --- NEW: Filter bar panel ---
            var filter = new Panel { Dock = DockStyle.Fill, Height = 44, BackColor = Color.FromArgb(0xF4, 0xF4, 0xF4) };
            layout.Controls.Add(filter, 0, 1);
            BuildFilterBar(filter);

            // --- grids stay same, but row index changes (now row=2) ---
            var split = new SplitContainer
            {
                Dock = DockStyle.Fill,
                Orientation = Orientation.Horizontal,
                SplitterDistance = 330
            };
            layout.Controls.Add(split, 0, 2);

            _gridGlav = new DataGridView
            {
                Dock = DockStyle.Fill,
                ReadOnly = !_isAdmin,
                AutoGenerateColumns = true,
                AllowUserToAddRows = false,
                AllowUserToDeleteRows = false,
                SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                MultiSelect = false
            };
            split.Panel1.Controls.Add(_gridGlav);

            _gridKar = new DataGridView
            {
                Dock = DockStyle.Fill,
                ReadOnly = !_isAdmin,
                AutoGenerateColumns = true,
                AllowUserToAddRows = false,
                AllowUserToDeleteRows = false,
                SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                MultiSelect = false
            };
            split.Panel2.Controls.Add(_gridKar);

            _gridGlav.SelectionChanged += (s, e) =>
            {
                if (_bsGlav.Current is DataRowView drv)
                {
                    var idmerObj = drv.Row["idmer"];
                    if (idmerObj != DBNull.Value)
                        LoadKarMeritve(Convert.ToInt32(idmerObj));
                }
            };

            _bsGlav.DataSource = _dtGlav;
            _bsKar.DataSource = _dtKar;
            _gridGlav.DataSource = _bsGlav;
            _gridKar.DataSource = _bsKar;

            // Hide unwanted columns and set headers after data binding
            _gridGlav.DataBindingComplete += (s, e) =>
            {
                HideColumns(_gridGlav, new[] { "idpost", "dodatno", "orodja" });
                SetHeader(_gridGlav, "idmer", TranslationService.Translate("SqlMeritveForm.Col.ZapSt"));
            };
            _gridKar.DataBindingComplete += (s, e) =>
            {
                HideColumns(_gridKar, new[] { "idkam", "idmer", "idkarm" });
                SetHeader(_gridKar, "karakt", TranslationService.Translate("SqlMeritveForm.Col.Pozicija"));
                SetHeader(_gridKar, "zapvz", TranslationService.Translate("SqlMeritveForm.Col.StVzorca"));
                SetHeader(_gridKar, "vrednost", TranslationService.Translate("SqlMeritveForm.Col.Meritve"));
            };
        }

        private void BuildFilterBar(Panel host)
        {
            // Use a small TableLayout for "modern" inline controls
            var bar = new TableLayoutPanel
            {
                Dock = DockStyle.Fill,
                ColumnCount = 10,
                RowCount = 1,
                Padding = new Padding(10, 8, 10, 8)
            };

            // columns: FromLbl, From, ToLbl, To, KodaLbl, Koda, SarzaLbl, Sarza, ClearBtn, (spacer)
            bar.ColumnStyles.Add(new ColumnStyle(SizeType.AutoSize));
            bar.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 120));
            bar.ColumnStyles.Add(new ColumnStyle(SizeType.AutoSize));
            bar.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 120));
            bar.ColumnStyles.Add(new ColumnStyle(SizeType.AutoSize));
            bar.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 140));
            bar.ColumnStyles.Add(new ColumnStyle(SizeType.AutoSize));
            bar.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 140));
            bar.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 80));
            bar.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100f));

            host.Controls.Add(bar);

            var lblFrom = new Label { Text = TranslationService.Translate("SqlMeritveForm.Filter.From"), AutoSize = true, Anchor = AnchorStyles.Left };
            var lblTo = new Label { Text = TranslationService.Translate("SqlMeritveForm.Filter.To"), AutoSize = true, Anchor = AnchorStyles.Left };
            var lblKoda = new Label { Text = TranslationService.Translate("SqlMeritveForm.Filter.Koda"), AutoSize = true, Anchor = AnchorStyles.Left };
            var lblSarza = new Label { Text = TranslationService.Translate("SqlMeritveForm.Filter.Sarza"), AutoSize = true, Anchor = AnchorStyles.Left };

            _dtFrom = new DateTimePicker { Format = DateTimePickerFormat.Short, Width = 120 };
            _dtTo = new DateTimePicker { Format = DateTimePickerFormat.Short, Width = 120 };

            _txtKodaFilter = new TextBox { Width = 140 };
            _txtSarzaFilter = new TextBox { Width = 140 };

            _btnClear = new Button { Text = TranslationService.Translate("SqlMeritveForm.Filter.Clear"), Width = 70, Height = 26 };

            // Defaults (Delphi-ish but modern)
            _dtFrom.Value = _filterFrom ?? DateTime.Today.AddDays(-1);
            _dtTo.Value = _filterToInclusive ?? DateTime.Today;
            _txtKodaFilter.Text = _filterKoda ?? "";
            _txtSarzaFilter.Text = _filterSarza ?? "";

            bar.Controls.Add(lblFrom, 0, 0);
            bar.Controls.Add(_dtFrom, 1, 0);
            bar.Controls.Add(lblTo, 2, 0);
            bar.Controls.Add(_dtTo, 3, 0);
            bar.Controls.Add(lblKoda, 4, 0);
            bar.Controls.Add(_txtKodaFilter, 5, 0);
            bar.Controls.Add(lblSarza, 6, 0);
            bar.Controls.Add(_txtSarzaFilter, 7, 0);
            bar.Controls.Add(_btnClear, 8, 0);

            // Events: change => reload (lightweight, immediate)
            _dtFrom.ValueChanged += (s, e) => { _filterFrom = _dtFrom.Value.Date; ReloadWithFilters(); };
            _dtTo.ValueChanged += (s, e) => { _filterToInclusive = _dtTo.Value.Date; ReloadWithFilters(); };

            _txtKodaFilter.TextChanged += (s, e) =>
            {
                _filterKoda = (_txtKodaFilter.Text ?? "").Trim();
                ReloadWithFilters();
            };

            _txtSarzaFilter.TextChanged += (s, e) =>
            {
                _filterSarza = (_txtSarzaFilter.Text ?? "").Trim();
                ReloadWithFilters();
            };

            _btnClear.Click += (s, e) =>
            {
                _filterFrom = DateTime.Today.AddDays(-1);
                _filterToInclusive = DateTime.Today;
                _filterKoda = "";
                _filterSarza = "";

                _dtFrom.Value = _filterFrom.Value;
                _dtTo.Value = _filterToInclusive.Value;
                _txtKodaFilter.Text = "";
                _txtSarzaFilter.Text = "";

                ReloadWithFilters();
            };
        }

        private void HideColumns(DataGridView grid, string[] columns)
        {
            foreach (var colName in columns)
            {
                if (grid.Columns.Contains(colName))
                    grid.Columns[colName].Visible = false;
            }
        }

        private void SetHeader(DataGridView grid, string colName, string header)
        {
            if (grid.Columns.Contains(colName))
                grid.Columns[colName].HeaderText = header;
        }

        private void LoadGlavMeritve()
        {
            _dtGlav.Clear();
            _dtKar.Clear();

            using (var conn = new OleDbConnection(_connStr))
            using (var cmd = conn.CreateCommand())
            {
                // Build WHERE dynamically (still parameterized)
                var sql = "SELECT * FROM glavmer WHERE idpost = ?";
                cmd.Parameters.AddWithValue("@p_idpost", _idpost);

                if (_filterFrom.HasValue)
                {
                    sql += " AND datum >= ?";
                    cmd.Parameters.AddWithValue("@p_from", _filterFrom.Value.Date);
                }

                if (_filterToInclusive.HasValue)
                {
                    // inclusive UI date => exclusive end
                    sql += " AND datum < ?";
                    cmd.Parameters.AddWithValue("@p_to", _filterToInclusive.Value.Date.AddDays(1));
                }

                if (!string.IsNullOrWhiteSpace(_filterKoda))
                {
                    // If your column is not named "koda", rename it here.
                    sql += " AND koda LIKE ?";
                    cmd.Parameters.AddWithValue("@p_koda", "%" + _filterKoda + "%");
                }

                if (!string.IsNullOrWhiteSpace(_filterSarza))
                {
                    // If your column is not named "sarza", rename it here.
                    sql += " AND sarza LIKE ?";
                    cmd.Parameters.AddWithValue("@p_sarza", "%" + _filterSarza + "%");
                }

                sql += " ORDER BY datum";

                cmd.CommandText = sql;

                _daGlav = new OleDbDataAdapter(cmd);
                var cb = new OleDbCommandBuilder(_daGlav);

                conn.Open();
                _daGlav.Fill(_dtGlav);
            }

            if (_dtGlav.Rows.Count > 0)
            {
                _bsGlav.Position = _dtGlav.Rows.Count - 1;
                var idmer = Convert.ToInt32(_dtGlav.Rows[_dtGlav.Rows.Count - 1]["idmer"]);
                LoadKarMeritve(idmer);
            }
        }

        private void ReloadWithFilters()
        {
            // keep it simple: just reload glavmer and let SelectionChanged handle karmer
            LoadGlavMeritve();
        }

        private void LoadKarMeritve(int idmer)
        {
            _dtKar.Clear();

            using (var conn = new OleDbConnection(_connStr))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText = "SELECT * FROM karmer WHERE idmer = ?";
                cmd.Parameters.AddWithValue("@p1", idmer);

                _daKar = new OleDbDataAdapter(cmd);

                // Optional: enables editing back to DB if you later want it.
                var cb = new OleDbCommandBuilder(_daKar);

                conn.Open();
                _daKar.Fill(_dtKar);
            }
        }

        private void BtnDelete_Click(object sender, EventArgs e)
        {
            if (!_isAdmin) return;
            if (!(_bsGlav.Current is DataRowView drv)) return;

            var idmerObj = drv.Row["idmer"];
            if (idmerObj == DBNull.Value) return;
            int idmer = Convert.ToInt32(idmerObj);

            var confirm = MessageBox.Show(this, TranslationService.Translate("SqlMeritveForm.DeletePrompt"), TranslationService.Translate("SqlMeritveForm.ConfirmTitle"),
                MessageBoxButtons.YesNo, MessageBoxIcon.Warning);

            if (confirm != DialogResult.Yes) return;

            using (var conn = new OleDbConnection(_connStr))
            {
                conn.Open();
                using (var tx = conn.BeginTransaction())
                {
                    try
                    {
                        // Delphi: delete all karmer rows then delete glavmer
                        using (var cmd = conn.CreateCommand())
                        {
                            cmd.Transaction = tx;

                            cmd.CommandText = "DELETE FROM karmer WHERE idmer = ?";
                            cmd.Parameters.AddWithValue("@p1", idmer);
                            cmd.ExecuteNonQuery();

                            cmd.Parameters.Clear();
                            cmd.CommandText = "DELETE FROM glavmer WHERE idmer = ?";
                            cmd.Parameters.AddWithValue("@p1", idmer);
                            cmd.ExecuteNonQuery();
                        }

                        tx.Commit();
                    }
                    catch
                    {
                        tx.Rollback();
                        throw;
                    }
                }
            }

            LoadGlavMeritve();
        }
    }
}
