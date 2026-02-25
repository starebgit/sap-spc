using System;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Drawing;
using System.Windows.Forms;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;

using SapSpcWinForms.Services;

namespace SapSpcWinForms
{
    public sealed class KontrolniPlaniForm : Form
    {
        private readonly bool _isAdmin;
        private readonly int? _stPost;
        private readonly string _mestoOpis;

        private readonly DataGridView _konsarGrid = new DataGridView();
        private readonly DataGridView _konplanGrid = new DataGridView();
        private readonly BindingSource _konsarBs = new BindingSource();
        private readonly BindingSource _konplanBs = new BindingSource();
        private readonly MenuStrip _menu = new MenuStrip();

        private SplitContainer _split;

        private readonly CheckBox _chkNekoncane = new CheckBox();
        private bool _showOnlyNekoncane = true;

        private readonly SapService _sap = new SapService();

        public KontrolniPlaniForm(bool isAdmin, int? stPost, string mestoOpis)
        {
            _isAdmin = isAdmin;
            _stPost = stPost;
            _mestoOpis = mestoOpis ?? "";

            Text = TranslationService.Translate("KontrolniPlaniForm.Text");
            StartPosition = FormStartPosition.CenterParent;
            var wa = Screen.FromPoint(Cursor.Position).WorkingArea;
            Width = Math.Min((int)(1500 * 1.3), wa.Width);   // +30%, capped to screen
            Height = 850;

            BuildUi();

            Shown += (_, __) =>
            {
                if (!_stPost.HasValue || _stPost.Value <= 0)
                {
                    MessageBox.Show(this, TranslationService.Translate("KontrolniPlaniForm.SelectStationFirst"), TranslationService.Translate("KontrolniPlaniForm.Text"),
                        MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    Close();
                    return;
                }

                BeginInvoke(new Action(() =>
                {
                    _split.Panel1MinSize = 250;
                    _split.Panel2MinSize = 300;

                    int desiredLeft = 650; // pick a sane hardcoded left width
                    int maxLeft = _split.Width - _split.SplitterWidth - _split.Panel2MinSize;
                    _split.SplitterDistance = Math.Max(_split.Panel1MinSize, Math.Min(desiredLeft, maxLeft));
                }));

                LoadKonsar();
                SelectFirstRow();
            };
        }

        private void BuildUi()
        {
            var header = new Panel { Dock = DockStyle.Top, Height = 48, Padding = new Padding(12, 10, 12, 10) };
            header.BackColor = Color.FromArgb(0xDE, 0xDA, 0xC0);

            var title = new Label
            {
                AutoSize = true,
                Font = new Font("Segoe UI", 11f, FontStyle.Bold),
                Text = string.Format(TranslationService.Translate("KontrolniPlaniForm.Header"), _mestoOpis)
            };
            header.Controls.Add(title);

            // Checkbox for nekončane šarže
            _chkNekoncane.AutoSize = true;
            _chkNekoncane.Checked = true; // default = show only (koncan <> 'Y')
            _chkNekoncane.Text = TranslationService.Translate("KontrolniPlaniForm.ShowIncomplete");
            _chkNekoncane.Top = 12;
            header.Controls.Add(_chkNekoncane);
            header.Resize += (_, __) =>
            {
                _chkNekoncane.Left = header.ClientSize.Width - _chkNekoncane.Width - 12;
            };
            _chkNekoncane.Left = header.ClientSize.Width - _chkNekoncane.Width - 12;
            _chkNekoncane.CheckedChanged += (_, __) =>
            {
                _showOnlyNekoncane = _chkNekoncane.Checked;
                ReloadKonsarPreserveSelection();
            };

            // --- Menu (Delphi MainMenu1) ---
            _menu.Dock = DockStyle.Top;
            _menu.GripStyle = ToolStripGripStyle.Hidden;
            MainMenuStrip = _menu;

            var urejanjeKode = new ToolStripMenuItem(TranslationService.Translate("KontrolniPlaniForm.Menu.EditCode"));
            // requested wiring
            urejanjeKode.DropDownItems.Clear();
            urejanjeKode.DropDownItems.Add(new ToolStripMenuItem(TranslationService.Translate("KontrolniPlaniForm.Menu.NewCode"), null, (_, __) => NovaKoda()));
            urejanjeKode.DropDownItems.Add(new ToolStripMenuItem(TranslationService.Translate("KontrolniPlaniForm.Menu.ChangeBatch"), null, (_, __) => SpremembaKontrolneSarze()));
            urejanjeKode.DropDownItems.Add(new ToolStripMenuItem(TranslationService.Translate("KontrolniPlaniForm.Menu.DeleteCode"), null, (_, __) => BrisiKodo()));
            urejanjeKode.DropDownItems.Add(new ToolStripMenuItem(TranslationService.Translate("KontrolniPlaniForm.Menu.MeasurementFrequency"), null, (_, __) => FrekvencaMeritev()));

            var urejanjePlana = new ToolStripMenuItem(TranslationService.Translate("KontrolniPlaniForm.Menu.EditPlan"));
            urejanjePlana.DropDownItems.Add(new ToolStripMenuItem(TranslationService.Translate("KontrolniPlaniForm.Menu.ImportPlan"), null, (_, __) => PrenosKontrolnegaPlana()));
            urejanjePlana.DropDownItems.Add(new ToolStripMenuItem(TranslationService.Translate("KontrolniPlaniForm.Menu.ChangeChannel"), null, (_, __) => SpremembaKanala()));
            // Replaced stub handlers
            urejanjePlana.DropDownItems.Add(new ToolStripMenuItem(TranslationService.Translate("KontrolniPlaniForm.Menu.DeleteCharacteristic"), null, (_, __) => BrisiKarakteristiko()));
            urejanjePlana.DropDownItems.Add(new ToolStripMenuItem(TranslationService.Translate("KontrolniPlaniForm.Menu.DeletePlan"), null, (_, __) => BrisiKontrolniPlan()));

            // Replace Vpogled menu with only Dodatki
            var vpogled = new ToolStripMenuItem(TranslationService.Translate("KontrolniPlaniForm.Menu.View"));
            vpogled.DropDownItems.Add(new ToolStripMenuItem(TranslationService.Translate("KontrolniPlaniForm.Menu.Addons"), null, (_, __) => OpenDodatki()));

            var operacije = new ToolStripMenuItem(TranslationService.Translate("KontrolniPlaniForm.Menu.Operations"));
            operacije.DropDownItems.Add(new ToolStripMenuItem(TranslationService.Translate("KontrolniPlaniForm.Menu.CheckBatch"), null, (_, __) => PreveriSarzoMenu()));

            _menu.Items.AddRange(new ToolStripItem[] { urejanjeKode, urejanjePlana, vpogled, operacije });

            _split = new SplitContainer
            {
                Dock = DockStyle.Fill,
                Orientation = Orientation.Vertical,
                SplitterWidth = 6,
                FixedPanel = FixedPanel.Panel1,
                IsSplitterFixed = false
            };

            ConfigureGrid(_konsarGrid);
            _konsarGrid.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.DisplayedCells;
            ConfigureGrid(_konplanGrid);

            _konsarGrid.DataSource = _konsarBs;
            _konplanGrid.DataSource = _konplanBs;

            _konsarGrid.SelectionChanged += (_, __) => OnKonsarSelectionChanged();

            _split.Panel1.Controls.Add(_konsarGrid);
            _split.Panel2.Controls.Add(_konplanGrid);

            Controls.Add(_split);
            Controls.Add(header);
            Controls.Add(_menu);
        }

        private void ConfigureGrid(DataGridView grid)
        {
            grid.Dock = DockStyle.Fill;
            grid.ReadOnly = true;                 // samo prikaz (zaenkrat)
            grid.AllowUserToAddRows = false;
            grid.AllowUserToDeleteRows = false;
            grid.MultiSelect = false;
            grid.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            grid.RowHeadersVisible = false;
            grid.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells;
        }

        private static void ApplyDelphiLayout(DataGridView grid, params string[] colsInOrder)
        {
            for (int i = 0; i < colsInOrder.Length; i++)
            {
                var colName = colsInOrder[i];
                if (grid.Columns[colName] == null) continue;

                grid.Columns[colName].HeaderText = colName; // same as Delphi field name
                grid.Columns[colName].DisplayIndex = i;     // same order as Delphi
            }
        }

        private void LoadKonsar()
        {
            var dt = new DataTable();

            string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;
            using (var conn = new OleDbConnection(connStr))
            using (var cmd = conn.CreateCommand())
            using (var da = new OleDbDataAdapter(cmd))
            {
                var whereKoncan = _showOnlyNekoncane ? " AND (koncan <> 'Y') " : "";

                cmd.CommandText =
                    "SELECT ident, koda, sarza, razmik, idpost, koncan, merdiff, mertraj " +
                    "FROM konsar " +
                    "WHERE idpost = ? " + whereKoncan +
                    "ORDER BY koda";

                cmd.Parameters.AddWithValue("@p1", _stPost.Value);

                conn.Open();
                da.Fill(dt);
            }

            _konsarBs.DataSource = dt;

            ApplyDelphiLayout(_konsarGrid,
                "ident", "koda", "sarza", "razmik", "idpost", "koncan", "merdiff", "mertraj");

            if (_konsarGrid.Columns["koncan"] != null) _konsarGrid.Columns["koncan"].HeaderText = TranslationService.Translate("KontrolniPlaniForm.Col.Activity");
            if (_konsarGrid.Columns["merdiff"] != null) _konsarGrid.Columns["merdiff"].HeaderText = TranslationService.Translate("KontrolniPlaniForm.Col.Frequency");
            if (_konsarGrid.Columns["mertraj"] != null) _konsarGrid.Columns["mertraj"].HeaderText = TranslationService.Translate("KontrolniPlaniForm.Col.TimeForMeasurement");
        }

        private void SelectFirstRow()
        {
            if (_konsarGrid.Rows.Count > 0)
            {
                _konsarGrid.ClearSelection();
                _konsarGrid.Rows[0].Selected = true;
                _konsarGrid.CurrentCell = _konsarGrid.Rows[0].Cells[0];
            }
        }

        private void OnKonsarSelectionChanged()
        {
            if (_konsarGrid.CurrentRow == null) return;

            var identObj = _konsarGrid.CurrentRow.Cells["ident"]?.Value;
            if (identObj == null || identObj == DBNull.Value) return;

            if (!int.TryParse(identObj.ToString(), out int idsar)) return;

            LoadKonplan(idsar);
        }

        private void LoadKonplan(int idsar)
        {
            var dt = new DataTable();

            string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;
            using (var conn = new OleDbConnection(connStr))
            using (var cmd = conn.CreateCommand())
            using (var da = new OleDbDataAdapter(cmd))
            {
                cmd.CommandText =
                    "SELECT idplan, idsar, tip, pozicija, naziv, predpis, spmeja, zgmeja, kanal, stvz, stkanal, com, oznaka, operacija " +
                    "FROM konplan " +
                    "WHERE idsar = ? " +
                    "ORDER BY idplan";

                cmd.Parameters.AddWithValue("@p1", idsar);

                conn.Open();
                da.Fill(dt);
            }

            _konplanBs.DataSource = dt;

            // --- Delphi-like layout (pic2) ---
            // hide columns you don't want
            foreach (var c in new[] { "idplan", "idsar", "com", "oznaka" })
            {
                if (_konplanGrid.Columns[c] != null)
                    _konplanGrid.Columns[c].Visible = false;
            }

            // rename headers
            if (_konplanGrid.Columns["stvz"] != null)    _konplanGrid.Columns["stvz"].HeaderText = TranslationService.Translate("KontrolniPlaniForm.Col.SampleSize");
            if (_konplanGrid.Columns["spmeja"] != null)  _konplanGrid.Columns["spmeja"].HeaderText = TranslationService.Translate("KontrolniPlaniForm.Col.LowerLimit");
            if (_konplanGrid.Columns["zgmeja"] != null)  _konplanGrid.Columns["zgmeja"].HeaderText = TranslationService.Translate("KontrolniPlaniForm.Col.UpperLimit");
            if (_konplanGrid.Columns["stkanal"] != null) _konplanGrid.Columns["stkanal"].HeaderText = TranslationService.Translate("KontrolniPlaniForm.Col.ChannelNumber");
            if (_konplanGrid.Columns["kanal"] != null)   _konplanGrid.Columns["kanal"].HeaderText = TranslationService.Translate("KontrolniPlaniForm.Col.Method");

            // order columns left->right like Delphi (pic2)
            void Idx(string name, int i)
            {
                var col = _konplanGrid.Columns[name];
                if (col != null && col.Visible) col.DisplayIndex = i;
            }

            Idx("pozicija", 0);
            Idx("operacija", 1);
            Idx("stvz", 2);
            Idx("naziv", 3);
            Idx("tip", 4);
            Idx("predpis", 5);
            Idx("spmeja", 6);
            Idx("zgmeja", 7);
            Idx("kanal", 8);
            Idx("stkanal", 9);
        }

        // --- Add Delphi Prenoskar equivalent ---
        private void PrenosKontrolnegaPlana()
        {
            if (!_isAdmin)
            {
                MessageBox.Show(this, TranslationService.Translate("KontrolniPlaniForm.AdminImportOnly"), TranslationService.Translate("KontrolniPlaniForm.Text"),
                    MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }

            if (_konsarGrid.CurrentRow == null) return;

            var idsarObj = _konsarGrid.CurrentRow.Cells["ident"]?.Value;
            var srzObj   = _konsarGrid.CurrentRow.Cells["sarza"]?.Value;

            if (idsarObj == null || idsarObj == DBNull.Value) return;
            if (!int.TryParse(idsarObj.ToString(), out var idsar)) return;

            var srz = (srzObj == null || srzObj == DBNull.Value) ? "" : srzObj.ToString();
            if (string.IsNullOrWhiteSpace(srz))
            {
                MessageBox.Show(this, TranslationService.Translate("KontrolniPlaniForm.NoBatchInRow"), TranslationService.Translate("KontrolniPlaniForm.Text"),
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            // DEBUG: always show that we entered + what we're using
            var already = KonplanExists(idsar);

            List<SapKaraktVar> variabilne = new List<SapKaraktVar>();
            List<SapAtribVar> atributivne = new List<SapAtribVar>();

            try
            {
                (variabilne, atributivne) = _sap.GetKarakt("", srz);
            }
            catch (Exception ex)
            {
                MessageBox.Show(this, "GetKarakt failed:\n" + ex.Message, "SAP GetKarakt",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            // Commented out intentionally: this always-on SAP GetKarakt preview popup is debug-only
            // and interrupts normal import flow for every run.
            // MessageBox.Show(this,
            //     $"idsar={idsar}\nsarza='{srz}'\nkonplanExists={already}\n\n" + BuildSapPreview(variabilne, atributivne),
            //     "SAP GetKarakt preview",
            //     MessageBoxButtons.OK, MessageBoxIcon.Information);

            // keep Delphi behavior: don't insert if already exists
            if (already)
                return;

            InsertKonplanRows(idsar, variabilne, atributivne);

            LoadKonplan(idsar);
        }

        private bool KonplanExists(int idsar)
        {
            string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;
            using (var conn = new OleDbConnection(connStr))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText = "SELECT COUNT(*) FROM konplan WHERE idsar = ?";
                cmd.Parameters.AddWithValue("@p1", idsar);
                conn.Open();
                var n = Convert.ToInt32(cmd.ExecuteScalar());
                return n > 0;
            }
        }

        private int GetStKanalForMetoda(string metoda)
        {
            if (string.IsNullOrWhiteSpace(metoda)) return 0;

            // Delphi: Fmetode.Getkanal(pp^.metoda) filtered by current postaja
            if (!_stPost.HasValue || _stPost.Value <= 0) return 0;

            string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;
            using (var conn = new OleDbConnection(connStr))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText = "SELECT kanal FROM metode WHERE idpost = ? AND metoda = ?";
                cmd.Parameters.AddWithValue("@p1", _stPost.Value);
                cmd.Parameters.AddWithValue("@p2", metoda);
                conn.Open();
                var v = cmd.ExecuteScalar();
                if (v == null || v == DBNull.Value) return 0;
                return Convert.ToInt32(v);
            }
        }

        private void InsertKonplanRows(int idsar, List<SapKaraktVar> variabilne, List<SapAtribVar> atributivne)
        {
            string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;

            using (var conn = new OleDbConnection(connStr))
            {
                conn.Open();
                using (var tx = conn.BeginTransaction())
                {
                    // variabilne (tip=1)
                    foreach (var pp in variabilne)
                    {
                        var metoda = (pp.metoda ?? "").ToString();
                        var stkanal = GetStKanalForMetoda(metoda);
                        using (var cmd = conn.CreateCommand())
                        {
                            cmd.Transaction = tx;
                            cmd.CommandText =
                                "INSERT INTO konplan " +
                                "(idsar, tip, pozicija, naziv, predpis, spmeja, zgmeja, kanal, stvz, stkanal, operacija) " +
                                "VALUES (?,?,?,?,?,?,?,?,?,?,?)";

                            cmd.Parameters.AddWithValue("@p1", idsar);
                            cmd.Parameters.AddWithValue("@p2", 1);
                            cmd.Parameters.AddWithValue("@p3", (pp.poz ?? "").ToString());
                            cmd.Parameters.AddWithValue("@p4", (pp.naziv ?? "").ToString());

                            // Delphi: if predpis = '' then 0 else predpis
                            var predpisStr = (pp.predpis ?? "").ToString().Trim();
                            cmd.Parameters.AddWithValue("@p5", string.IsNullOrEmpty(predpisStr) ? 0.0 : Convert.ToDouble(predpisStr, CultureInfo.InvariantCulture));

                            cmd.Parameters.AddWithValue("@p6", ToDbDoubleOrNull(pp.spmeja));
                            cmd.Parameters.AddWithValue("@p7", ToDbDoubleOrNull(pp.zgmeja));

                            cmd.Parameters.AddWithValue("@p8", metoda);
                            cmd.Parameters.AddWithValue("@p9", Convert.ToInt32(pp.stevVz));
                            cmd.Parameters.AddWithValue("@p10", stkanal == 0 ? (object)DBNull.Value : stkanal);
                            cmd.Parameters.AddWithValue("@p11", (pp.operac ?? "").ToString());

                            cmd.ExecuteNonQuery();
                        }
                    }

                    // atributivne (tip=2)
                    foreach (var pk in atributivne)
                    {
                        using (var cmd = conn.CreateCommand())
                        {
                            cmd.Transaction = tx;
                            cmd.CommandText =
                                "INSERT INTO konplan " +
                                "(idsar, tip, pozicija, naziv, stvz, operacija) " +
                                "VALUES (?,?,?,?,?,?)";

                            cmd.Parameters.AddWithValue("@p1", idsar);
                            cmd.Parameters.AddWithValue("@p2", 2);
                            cmd.Parameters.AddWithValue("@p3", (pk.poz ?? "").ToString());
                            cmd.Parameters.AddWithValue("@p4", (pk.naziv ?? "").ToString());
                            cmd.Parameters.AddWithValue("@p5", Convert.ToInt32(pk.stevVz));
                            cmd.Parameters.AddWithValue("@p6", (pk.operac ?? "").ToString());

                            cmd.ExecuteNonQuery();
                        }
                    }

                    tx.Commit();
                }
            }
        }

        private static object ToDbDoubleOrNull(object value)
        {
            if (value == null || value == DBNull.Value) return DBNull.Value;
            var s = value.ToString().Trim();
            if (string.IsNullOrEmpty(s)) return DBNull.Value;
            if (double.TryParse(s, NumberStyles.Any, CultureInfo.InvariantCulture, out var d)) return d;
            if (double.TryParse(s, NumberStyles.Any, CultureInfo.CurrentCulture, out d)) return d;
            return DBNull.Value;
        }

        private void ReloadKonsarPreserveSelection()
        {
            int? selectedIdent = GetSelectedIdent();

            LoadKonsar();

            if (selectedIdent.HasValue && SelectRowByIdent(selectedIdent.Value))
                return;

            if (_konsarGrid.Rows.Count > 0)
            {
                SelectFirstRow();
            }
            else
            {
                // nothing to show -> clear right grid
                _konplanBs.DataSource = new DataTable();
            }
        }

        private int? GetSelectedIdent()
        {
            if (_konsarGrid.CurrentRow == null) return null;

            var v = _konsarGrid.CurrentRow.Cells["ident"]?.Value;
            if (v == null || v == DBNull.Value) return null;

            return int.TryParse(v.ToString(), out var ident) ? ident : (int?)null;
        }

        private bool SelectRowByIdent(int ident)
        {
            foreach (DataGridViewRow row in _konsarGrid.Rows)
            {
                var v = row.Cells["ident"]?.Value;
                if (v == null || v == DBNull.Value) continue;

                if (int.TryParse(v.ToString(), out var rowIdent) && rowIdent == ident)
                {
                    _konsarGrid.ClearSelection();
                    row.Selected = true;
                    _konsarGrid.CurrentCell = row.Cells[0];
                    return true;
                }
            }
            return false;
        }

        private void OpenDodatki()
        {
            if (_konsarGrid.CurrentRow == null) return;

            var kdObj = _konsarGrid.CurrentRow.Cells["koda"]?.Value;
            var kd = (kdObj == null || kdObj == DBNull.Value) ? "" : kdObj.ToString();

            if (string.IsNullOrWhiteSpace(kd))
            {
                MessageBox.Show(this, TranslationService.Translate("KontrolniPlaniForm.Dodatki.NoCode"), TranslationService.Translate("KontrolniPlaniForm.Menu.Addons"),
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;
            using (var f = new DodatkiForm(connStr, kd))
                f.ShowDialog(this);
        }

        private void PreveriSarzoMenu()
        {
            if (_konsarGrid.CurrentRow == null) return;

            var srzObj = _konsarGrid.CurrentRow.Cells["sarza"]?.Value;
            var srz = (srzObj == null || srzObj == DBNull.Value) ? "" : srzObj.ToString();

            if (string.IsNullOrWhiteSpace(srz))
            {
                MessageBox.Show(this, TranslationService.Translate("KontrolniPlaniForm.CheckBatch.NoBatch"), TranslationService.Translate("KontrolniPlaniForm.Menu.CheckBatch"),
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            try
            {
                UseWaitCursor = true;

                var ok = _sap.PreveriSar(srz.Trim());

                MessageBox.Show(this,
                    ok ? TranslationService.Translate("KontrolniPlaniForm.CheckBatch.Active") : TranslationService.Translate("KontrolniPlaniForm.CheckBatch.Inactive"),
                    TranslationService.Translate("KontrolniPlaniForm.Menu.CheckBatch"),
                    MessageBoxButtons.OK,
                    ok ? MessageBoxIcon.Information : MessageBoxIcon.Exclamation);
            }
            catch (Exception ex)
            {
                MessageBox.Show(this, TranslationService.Translate("KontrolniPlaniForm.CheckBatch.Error") + "\n" + ex.Message, TranslationService.Translate("KontrolniPlaniForm.Menu.CheckBatch"),
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                UseWaitCursor = false;
            }
        }

        private static string BuildSapPreview(List<SapKaraktVar> v, List<SapAtribVar> a)
        {
            var sb = new StringBuilder();

            sb.AppendLine($"Sarza: (preview)");
            sb.AppendLine($"Variabilne: {v?.Count ?? 0}");
            foreach (var x in (v ?? new List<SapKaraktVar>()).Take(10))
                sb.AppendLine($"V op:{x.operac} poz:{x.poz} naziv:{x.naziv} pred:{x.predpis} [{x.spmeja}..{x.zgmeja}] metoda:{x.metoda} vz:{x.stevVz}");

            sb.AppendLine();
            sb.AppendLine($"Atributivne: {a?.Count ?? 0}");
            foreach (var x in (a ?? new List<SapAtribVar>()).Take(10))
                sb.AppendLine($"A op:{x.operac} poz:{x.poz} naziv:{x.naziv} vz:{x.stevVz}");

            return sb.ToString();
        }

        private void SpremembaKanala()
        {
            if (!_isAdmin) return;
            if (_konplanGrid.CurrentRow == null) return;

            var drv = _konplanGrid.CurrentRow.DataBoundItem as DataRowView;
            if (drv == null) return;

            int current = (drv["stkanal"] == DBNull.Value) ? 1 : Convert.ToInt32(drv["stkanal"]);
            int newVal = ShowStKanalDialog(current);     // Delphi: Vpiskan(vl)
            if (newVal <= 0) return;                    // Delphi: cancel -> 0

            int idplan = Convert.ToInt32(drv["idplan"]);

            // write to DB (Delphi: ADOQuery2.Post)
            string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;
            using (var conn = new OleDbConnection(connStr))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText = "UPDATE konplan SET stkanal = ? WHERE idplan = ?";
                cmd.Parameters.AddWithValue("@p1", newVal);
                cmd.Parameters.AddWithValue("@p2", idplan);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            // update UI row
            drv.BeginEdit();
            drv["stkanal"] = newVal;
            drv.EndEdit();
        }

        private int ShowStKanalDialog(int initial)
        {
            using (var f = new Form
            {
                Text = TranslationService.Translate("KontrolniPlaniForm.ChannelDialog.Text"),
                FormBorderStyle = FormBorderStyle.FixedDialog,
                StartPosition = FormStartPosition.CenterParent,
                MinimizeBox = false,
                MaximizeBox = false,
                ShowInTaskbar = false,
                ClientSize = new Size(260, 120)
            })
            {
                var lbl = new Label { Left = 12, Top = 14, AutoSize = true, Text = TranslationService.Translate("KontrolniPlaniForm.ChannelDialog.Prompt") };
                var nud = new NumericUpDown
                {
                    Left = 12, Top = 40, Width = 120,
                    Minimum = 1, Maximum = 999,
                    Value = Math.Max(1, Math.Min(999, initial))
                };

                var ok = new Button { Text = TranslationService.Translate("Common.Ok"), Left = 70, Width = 80, Top = 78, DialogResult = DialogResult.OK };
                var cancel = new Button { Text = TranslationService.Translate("Common.Cancel"), Left = 158, Width = 80, Top = 78, DialogResult = DialogResult.Cancel };

                f.Controls.AddRange(new Control[] { lbl, nud, ok, cancel });
                f.AcceptButton = ok;
                f.CancelButton = cancel;

                return (f.ShowDialog(this) == DialogResult.OK) ? (int)nud.Value : 0;
            }
        }

        // --- Added delete handlers ---
        private void BrisiKarakteristiko()
        {
            if (!_isAdmin) return;
            if (_konplanGrid.CurrentRow == null) return;

            var ok = MessageBox.Show(this,
                TranslationService.Translate("KontrolniPlaniForm.DeletePrompt"),
                TranslationService.Translate("KontrolniPlaniForm.DeleteCharacteristicTitle"),
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question);

            if (ok != DialogResult.Yes) return;

            var drv = _konplanGrid.CurrentRow.DataBoundItem as DataRowView;
            if (drv == null) return;
            if (drv["idplan"] == DBNull.Value) return;

            int idplan = Convert.ToInt32(drv["idplan"]);

            ExecuteNonQuery("DELETE FROM konplan WHERE idplan = ?", idplan);

            var idsar = GetSelectedIdent();
            if (idsar.HasValue) LoadKonplan(idsar.Value);
        }

        private void BrisiKontrolniPlan()
        {
            if (!_isAdmin) return;

            var idsar = GetSelectedIdent();
            if (!idsar.HasValue) return;

            var ok = MessageBox.Show(this,
                TranslationService.Translate("KontrolniPlaniForm.DeletePlanPrompt"),
                TranslationService.Translate("KontrolniPlaniForm.DeletePlanTitle"),
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Warning);

            if (ok != DialogResult.Yes) return;

            ExecuteNonQuery("DELETE FROM konplan WHERE idsar = ?", idsar.Value);

            LoadKonplan(idsar.Value);
        }

        private static int ExecuteNonQuery(string sql, params object[] args)
        {
            string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;
            using (var conn = new OleDbConnection(connStr))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText = sql;
                foreach (var a in args)
                    cmd.Parameters.AddWithValue("@p", a ?? (object)DBNull.Value);

                conn.Open();
                return cmd.ExecuteNonQuery();
            }
        }

        // --- New features: Frekvenca meritev ---
        private void FrekvencaMeritev()
        {
            if (!_isAdmin) return;

            if (_konsarGrid.CurrentRow == null)
                return;

            bool prepisVse = true; // default = Delphi behavior

            // Prefill from selected row (fixes “always 120” confusion)
            int mrFk = ReadIntCell(_konsarGrid.CurrentRow, "merdiff") ?? 120;
            int mrTr = ReadIntCell(_konsarGrid.CurrentRow, "mertraj") ?? 15;

            if (!ShowVpisFrekDialog(ref mrFk, ref mrTr, ref prepisVse))
                return;

            if (mrFk == 0) return; // Delphi cancel/exit behavior

            if (prepisVse)
            {
                // bulk update for currently shown set (same as you had)
                var whereKoncan = _showOnlyNekoncane ? " AND (koncan <> 'Y') " : "";

                ExecuteNonQuery(
                    "UPDATE konsar SET merdiff = ?, mertraj = ? WHERE idpost = ? " + whereKoncan,
                    mrFk, mrTr, _stPost.Value
                );
            }
            else
            {
                // update ONLY selected row
                var ident = GetSelectedIdent();
                if (!ident.HasValue) return;

                ExecuteNonQuery(
                    "UPDATE konsar SET merdiff = ?, mertraj = ? WHERE ident = ?",
                    mrFk, mrTr, ident.Value
                );
            }

            ReloadKonsarPreserveSelection();
        }

        private static int? ReadIntCell(DataGridViewRow row, string colName)
        {
            if (row == null) return null;
            var v = row.Cells[colName]?.Value;
            if (v == null || v == DBNull.Value) return null;

            if (v is int i) return i;
            if (int.TryParse(v.ToString(), out i)) return i;
            return null;
        }

        private bool ShowVpisFrekDialog(ref int frk, ref int trj, ref bool prepisVse)
        {
            using (var f = new Form
            {
                Text = TranslationService.Translate("KontrolniPlaniForm.FrequencyDialog.Text"),
                FormBorderStyle = FormBorderStyle.FixedDialog,
                StartPosition = FormStartPosition.CenterParent,
                MinimizeBox = false,
                MaximizeBox = false,
                ShowInTaskbar = false,
                ClientSize = new Size(360, 185)
            })
            {
                var lbl1 = new Label { Left = 12, Top = 18, AutoSize = true, Text = TranslationService.Translate("KontrolniPlaniForm.FrequencyDialog.Frequency") };
                var txt1 = new TextBox { Left = 170, Top = 14, Width = 165, Text = frk.ToString() };

                var lbl2 = new Label { Left = 12, Top = 54, AutoSize = true, Text = TranslationService.Translate("KontrolniPlaniForm.FrequencyDialog.Time") };
                var txt2 = new TextBox { Left = 170, Top = 50, Width = 165, Text = trj.ToString() };

                var chkAll = new CheckBox
                {
                    Left = 12,
                    Top = 84,
                    AutoSize = true,
                    Text = TranslationService.Translate("KontrolniPlaniForm.FrequencyDialog.ApplyAll"),
                    Checked = prepisVse
                };

                var ok = new Button { Text = TranslationService.Translate("Common.Ok"), Left = 180, Width = 75, Top = 125, DialogResult = DialogResult.OK };
                var cancel = new Button { Text = TranslationService.Translate("Common.Cancel"), Left = 260, Width = 75, Top = 125, DialogResult = DialogResult.Cancel };

                f.Controls.AddRange(new Control[] { lbl1, txt1, lbl2, txt2, chkAll, ok, cancel });
                f.AcceptButton = ok;
                f.CancelButton = cancel;

                if (f.ShowDialog(this) != DialogResult.OK)
                {
                    frk = 0;
                    trj = 0;
                    return false;
                }

                prepisVse = chkAll.Checked;

                frk = int.TryParse(txt1.Text.Trim(), out var a) ? a : 0;
                trj = int.TryParse(txt2.Text.Trim(), out var b) ? b : 0;
                return true;
            }
        }

        // --- New: delete selected code and its plan rows ---
        private void BrisiKodo()
        {
            if (!_isAdmin) return;

            var idsar = GetSelectedIdent();
            if (!idsar.HasValue) return;

            var ok = MessageBox.Show(this,
                TranslationService.Translate("KontrolniPlaniForm.DeletePrompt"),
                TranslationService.Translate("KontrolniPlaniForm.DeleteCodeTitle"),
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question);

            if (ok != DialogResult.Yes) return;

            string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;

            try
            {
                using (var conn = new OleDbConnection(connStr))
                {
                    conn.Open();
                    using (var tx = conn.BeginTransaction())
                    {
                        // 1) delete plan rows (konplan) for this code (idsar)
                        using (var cmd1 = conn.CreateCommand())
                        {
                            cmd1.Transaction = tx;
                            cmd1.CommandText = "DELETE FROM konplan WHERE idsar = ?";
                            cmd1.Parameters.AddWithValue("@p1", idsar.Value);
                            cmd1.ExecuteNonQuery();
                        }

                        // 2) delete the code row itself (konsar)
                        using (var cmd2 = conn.CreateCommand())
                        {
                            cmd2.Transaction = tx;
                            cmd2.CommandText = "DELETE FROM konsar WHERE ident = ?";
                            cmd2.Parameters.AddWithValue("@p1", idsar.Value);
                            cmd2.ExecuteNonQuery();
                        }

                        tx.Commit();
                    }
                }

                ReloadKonsarPreserveSelection();
            }
            catch (Exception ex)
            {
                MessageBox.Show(this,
                    "Napaka pri brisanju kode:\n" + ex.Message,
                    "Briši kodo",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
        }

        // --- New methods for VpisKode ---
        private void NovaKoda()
        {
            if (!_isAdmin) return;

            using (var f = new VpisKodeForm(
                presetKoda: "",
                loadSarze: (kd, preve) => _sap.GetKonsarza(kd, new DateTime(2019, 1, 1), preve),
                insertKonsar: InsertKonsarRow,
                ensureKonplan: EnsureKonplanFromSap,
                onAdded: newIdent => RefreshAfterInsert(newIdent)
            ))
            {
                f.ShowDialog(this);
            }
        }

        private void SpremembaKontrolneSarze()
        {
            if (!_isAdmin) return;
            if (_konsarGrid.CurrentRow == null) return;

            var kdObj = _konsarGrid.CurrentRow.Cells["koda"]?.Value;
            var kd = (kdObj == null || kdObj == DBNull.Value) ? "" : kdObj.ToString();

            using (var f = new VpisKodeForm(
                presetKoda: kd,
                loadSarze: (k, preve) => _sap.GetKonsarza(k, new DateTime(2019, 1, 1), preve),
                insertKonsar: InsertKonsarRow,
                ensureKonplan: EnsureKonplanFromSap,
                onAdded: newIdent => RefreshAfterInsert(newIdent)
            ))
            {
                f.ShowDialog(this);
            }
        }

        private void RefreshAfterInsert(int newIdent)
        {
            LoadKonsar();
            SelectRowByIdent(newIdent); // triggers right grid load via SelectionChanged
        }

        private int InsertKonsarRow(string kd, string srz, int frk, int trj)
        {
            string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;

            using (var conn = new OleDbConnection(connStr))
            {
                conn.Open();

                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText =
                        "INSERT INTO konsar (koda, sarza, idpost, merdiff, mertraj, koncan) " +
                        "VALUES (?,?,?,?,?,?)";

                    cmd.Parameters.AddWithValue("@p1", kd ?? "");
                    cmd.Parameters.AddWithValue("@p2", srz ?? "");
                    cmd.Parameters.AddWithValue("@p3", _stPost.Value);
                    cmd.Parameters.AddWithValue("@p4", frk);
                    cmd.Parameters.AddWithValue("@p5", trj);
                    cmd.Parameters.AddWithValue("@p6", ""); // Delphi: koncan := ''

                    cmd.ExecuteNonQuery();
                }

                using (var idCmd = conn.CreateCommand())
                {
                    idCmd.CommandText = "SELECT @@IDENTITY";
                    var v = idCmd.ExecuteScalar();            // Access often returns decimal
                    return Convert.ToInt32(v);
                }
            }
        }

        private void EnsureKonplanFromSap(int idsar, string srz)
        {
            if (KonplanExists(idsar)) return;

            var (variabilne, atributivne) = _sap.GetKarakt("", srz);
            InsertKonplanRows(idsar, variabilne, atributivne);
        }
    }
}
