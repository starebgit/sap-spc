using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Windows.Forms;
using System.IO.Ports;
using System.Text;
using System.Threading.Tasks;
using SapSpcWinForms.Data;
using SapSpcWinForms.Utils;
using SapSpcWinForms.Forms;

namespace SapSpcWinForms
{
    public partial class ZacetnaForm : Form
    {
        private int _berMer = 1; // 0 = read measurements
        private bool _isAdmin = false;
        private int? _currentStPost = null;
        private string _currentMestoOpis = null;
        private int? _selectedMachineId = null;
        private string _selectedMachineName = null;
        private SemaforForm _semaforForm;
        private string _currentSarza;
        private string _currentKodaClean;
        private readonly Dictionary<int, int> _astanjeByIndex = new Dictionary<int, int>();          // key: 1..N (machine order)
        private readonly Dictionary<int, TimeSpan> _acasByIndex = new Dictionary<int, TimeSpan>();   // key: 1..N (machine order) time-of-day, TimeSpan.Zero = no value
        private readonly Dictionary<int, int> _diffByIndex = new Dictionary<int, int>();             // pp^.diff minutes
        private readonly Dictionary<int, int> _trajByIndex = new Dictionary<int, int>();             // pp^.traj minutes
        private readonly Dictionary<int, int> _machineIdByIndex = new Dictionary<int, int>();        // pp^.ident (idstroja)
        private readonly Dictionary<int, bool> _machineActiveByIndex = new Dictionary<int, bool>();  // Delphi strvkl[i]
        private const int DefaultIntervalDiffMinutes = StrojnaDbRepository.DefaultIntervalDiffMinutes;
        private const int DefaultIntervalTrajMinutes = StrojnaDbRepository.DefaultIntervalTrajMinutes;

        private readonly TimeSpan[] _zacIzm = new[]
        {
            TimeSpan.Zero,
            new TimeSpan(6,0,0),
            new TimeSpan(14,0,0),
            new TimeSpan(22,0,0)
        };

        private void BeriMeritveSettingsMenuItem_CheckedChanged(object sender, EventArgs e)
        {
            _berMer = beriMeritveSettingsToolStripMenuItem.Checked ? 0 : 1;
        }

        private void WireUpEvents()
        {
            machinesList.SelectedIndexChanged += MachinesList_SelectedIndexChanged;
            codesList.SelectedIndexChanged += CodesList_SelectedIndexChanged;

            WireUpKanalDecimalke();
        }

        private bool _testInputRunning = false;
        private Button _testInputButton;
        private const string TEST_INPUT_PORT = "COM8";
        private const int TEST_INPUT_BAUD = 9600;
        private const string PRENOS_PORT = "COM8";
        private const int PRENOS_BAUD = 9600;

        // Prenos s stopalko runtime state
        private System.Threading.CancellationTokenSource _prenosStopalkaCts;
        private SerialPort _prenosStopalkaPort;
        private volatile bool _prenosStopalkaRunning;

        private readonly object _prenosLock = new object();
        private readonly StringBuilder _prenosBuf = new StringBuilder();
        private int _prenosBusy;

        // Buttons
        private Button _prenosStopalkaButton;
        private Button _prekiniButton;

        private Panel _leftContent;
        private Panel _variablePanel;
        private Panel _attributePanel;

        private ListBox _dodIzborListBox;
        private Label _dodIzborLabel;
        private string _selectedOrodje = "";  // Stores the selected tool/equipment

        public ZacetnaForm()
        {
            _isAdmin = true; // Always start as admin, like Delphi
            InitializeComponent();   // must be first
            InitializeDodIzborControls(); // Add DodIzbor controls
            ConfigureResponsiveLayout(); // programmatic docking layout
            this.ClientSize = new Size(this.ClientSize.Width, this.ClientSize.Height + 120);
            WireUpEvents();
            beriMeritveSettingsToolStripMenuItem.Checked = (_berMer == 0);

            // Subscribe to global state changes
            MerilnoMestoState.StateChanged += OnMerilnoMestoStateChanged;

            // load logo image
            var logoPath = Path.Combine(
                AppDomain.CurrentDomain.BaseDirectory,
                "Resources",
                "ego.png"
            );

            if (File.Exists(logoPath))
            {
                logoPicture.Image = System.Drawing.Image.FromFile(logoPath);
            }

            // hook form closing to prevent non-admin exit
            this.FormClosing += ZacetnaForm_FormClosing;

            // Load merilno mesto info
            LoadMerilnoMesto();
            UpdateAdminUi();
            InitializeCharacteristicGrids();
            WireGrafColumnBehavior();

            // Wire GrafButton click
            if (GrafButton != null)
                GrafButton.Click += GrafButton_Click;

            WirePrenosStopalkaPrekiniButtons();
            this.FormClosing += (s, e) => StopPrenosStopalka();
        }

        private void OnMerilnoMestoStateChanged()
        {
            _currentStPost = MerilnoMestoState.CurrentStPost;
            _currentMestoOpis = MerilnoMestoState.CurrentMestoOpis;
            EnsureMerilnoMestoLabel();
            PopulateMachinesList();
        }

        private void PopulateMachinesList()
        {
            machinesList.Items.Clear();
            _machineIdByIndex.Clear();
            _diffByIndex.Clear();
            _trajByIndex.Clear();
            _machineActiveByIndex.Clear();
            _acasByIndex.Clear();
            _astanjeByIndex.Clear();

            if (!_currentStPost.HasValue)
                return;

            try
            {
                var machines = StrojnaDbRepository.GetMachinesForPost(_currentStPost.Value);

                foreach (var (idstroja, naziv) in machines)
                {
                    int index = machinesList.Items.Count + 1; // 1-based like Delphi
                    machinesList.Items.Add(naziv);

                    _machineIdByIndex[index] = idstroja;
                    _machineActiveByIndex[index] = SinaproRepository.PreveriStroj(idstroja);

                    var (diff, traj) = ResolveIntervalForMachine(idstroja);
                    _diffByIndex[index] = diff;
                    _trajByIndex[index] = traj;
                    _acasByIndex[index] = TimeSpan.Zero;
                    _astanjeByIndex[index] = 9;
                }
            }
            catch (Exception ex)
            {
                machinesList.Items.Add("Napaka: " + ex.Message);
            }
        }

        private (int diff, int traj) ResolveIntervalForMachine(int machineId)
        {
            if (!_currentStPost.HasValue)
                return (DefaultIntervalDiffMinutes, DefaultIntervalTrajMinutes);

            try
            {
                var codes = SinaproRepository.GetSinaproKodaListForMachine(machineId);
                var firstCode = codes?.FirstOrDefault(c => !string.IsNullOrWhiteSpace(c));
                var cleanKoda = AppUtils.CleanKoda(firstCode);
                if (string.IsNullOrWhiteSpace(cleanKoda))
                    return (DefaultIntervalDiffMinutes, DefaultIntervalTrajMinutes);

                return StrojnaDbRepository.GetIntervalFromKonsar(cleanKoda, _currentStPost.Value);
            }
            catch
            {
                return (DefaultIntervalDiffMinutes, DefaultIntervalTrajMinutes);
            }
        }
        private void LoadMerilnoMesto()
        {
            string compName = Environment.MachineName;

            var (stpost, opis) = StrojnaDbRepository.LoadMerilnoMestoDb(compName);

            _currentStPost = stpost;
            _currentMestoOpis = opis;

            MerilnoMestoState.Set(stpost, opis);
            EnsureMerilnoMestoLabel();
            PopulateMachinesList();
        }


        private Label _merilnoMestoLabel;
        private Label _merilnoMestoOpisLabel;
        private Label _strojiLabel;
        private Label _kodaLabel;
        private Label _operatorLabel;
        private Label _operatorValueLabel;
        private void EnsureMerilnoMestoLabel()
        {
            // --- LEFT SEGMENT: Merilno mesto ---
            if (_merilnoMestoLabel == null)
            {
                _merilnoMestoLabel = new Label
                {
                    Name = "merilnoMestoLabel",
                    AutoSize = true,
                    Location = new Point(12, 10),
                    Font = new Font("Segoe UI", 9F, FontStyle.Regular),
                    ForeColor = Color.Black,
                    BackColor = Color.Transparent,
                    Text = "Merilno mesto:"
                };
                topPanel.Controls.Add(_merilnoMestoLabel);
            }
            if (_merilnoMestoOpisLabel == null)
            {
                _merilnoMestoOpisLabel = new Label
                {
                    Name = "merilnoMestoOpisLabel",
                    AutoSize = true,
                    Location = new Point(12, 32),
                    Font = new Font("Segoe UI", 10F, FontStyle.Bold),
                    ForeColor = Color.FromArgb(0, 64, 128),
                    BackColor = Color.Transparent
                };
                topPanel.Controls.Add(_merilnoMestoOpisLabel);
            }
            _merilnoMestoOpisLabel.Text = _currentMestoOpis ?? string.Empty;

            // --- OPERATOR under Merilno mesto ---
            if (_operatorLabel == null)
            {
                _operatorLabel = new Label
                {
                    Name = "operatorLabel",
                    AutoSize = true,
                    Text = "Operater:",
                    Font = new Font("Segoe UI", 9F, FontStyle.Regular),
                    Location = new Point(12, 60),
                    ForeColor = Color.Black,
                    BackColor = Color.Transparent
                };
                topPanel.Controls.Add(_operatorLabel);
            }
            if (_operatorValueLabel == null)
            {
                _operatorValueLabel = new Label
                {
                    Name = "operatorValueLabel",
                    AutoSize = true,
                    Text = "(ni prijave)",
                    Font = new Font("Segoe UI", 10F, FontStyle.Bold),
                    Location = new Point(12, 80),
                    ForeColor = Color.FromArgb(0, 64, 128),
                    BackColor = Color.Transparent
                };
                topPanel.Controls.Add(_operatorValueLabel);
            }

            // --- MIDDLE SEGMENT: Stroji ---
            int middleX = _merilnoMestoLabel.Left + 180; // space from left
            if (_strojiLabel == null)
            {
                _strojiLabel = new Label
                {
                    Name = "strojiLabel",
                    AutoSize = true,
                    Text = "Stroji",
                    Font = new Font("Segoe UI", 9F, FontStyle.Bold),
                    Location = new Point(middleX, 10),
                    ForeColor = Color.Black,
                    BackColor = Color.Transparent
                };
                topPanel.Controls.Add(_strojiLabel);
            }
            machinesList.Location = new Point(middleX, 32);
            machinesList.Size = new Size(200, 120);

            // --- RIGHT SEGMENT: Koda ---
            int rightX = middleX + machinesList.Width + 40;
            if (_kodaLabel == null)
            {
                _kodaLabel = new Label
                {
                    Name = "kodaLabel",
                    AutoSize = true,
                    Text = "Koda",
                    Font = new Font("Segoe UI", 9F, FontStyle.Bold),
                    Location = new Point(rightX, 10),
                    ForeColor = Color.Black,
                    BackColor = Color.Transparent
                };
                topPanel.Controls.Add(_kodaLabel);
            }
            codesList.Location = new Point(rightX, 32);
            codesList.Size = new Size(200, 120);

            // --- DodIzbor to the RIGHT of codesList ---
            if (_dodIzborLabel != null && _dodIzborListBox != null)
            {
                const int gap = 16;

                int x = codesList.Right + gap;
                int y = codesList.Top;          // align top with codes list
                int w = 220;                    // pick your width (or keep codesList.Width)
                int h = codesList.Height;       // same height as codes list

                _dodIzborLabel.Location = new Point(x, y);
                _dodIzborListBox.Location = new Point(x, _dodIzborLabel.Bottom + 4);
                _dodIzborListBox.Size = new Size(w, h - (_dodIzborLabel.Height + 4));

                _dodIzborLabel.BringToFront();
                _dodIzborListBox.BringToFront();

                topPanel.Height = Math.Max(topPanel.Height, _dodIzborListBox.Bottom + 12);
            }
        }

        private void AdminToggleButton_Click(object sender, EventArgs e)
        {
            if (_isAdmin)
            {
                // logout
                _isAdmin = false;
                UpdateAdminUi();
                return;
            }

            using (var dlg = new AdminPasswordForm())
            {
                if (dlg.ShowDialog(this) == DialogResult.OK)
                {
                    var pwd = dlg.Password?.Trim();
                    if (!string.IsNullOrEmpty(pwd) && string.Equals(pwd, "STROJNAX", StringComparison.OrdinalIgnoreCase))
                    {
                        _isAdmin = true;
                        UpdateAdminUi();
                    }
                    else
                    {
                        MessageBox.Show(this, "Geslo ni pravilno", "Prijava", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                }
            }
        }

        private void ZacetnaForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (!_isAdmin)
            {
                e.Cancel = true;
                MessageBox.Show(this, "Zapiranje ni dovoljeno brez administratorske prijave.", "Obvestilo", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }

        private void UpdateAdminUi()
        {
            // Toggle admin menu button: text "Admin prijava" when not admin, "Odjava" when admin
            if (adminToggleButton != null)
            {
                var color = _isAdmin ? Color.Red : Color.Green;
                adminToggleButton.Text = _isAdmin ? "Admin odjava" : "Admin prijava";
                adminToggleButton.ForeColor = color;
                adminToggleButton.ToolTipText = _isAdmin ? "Odjava" : "Prijava";
                adminToggleButton.Image = CreateAdminIcon(color);
            }

            // Gate menus exactly like Delphi menupravice
            if (menuStrip != null)
            {
                // Baza na serverju  keep top-level enabled, gate subitems
                bazaNaServerjuToolStripMenuItem.Enabled = true;
                merilnaMestaServerToolStripMenuItem.Enabled = _isAdmin; // Postaja
                strojiServerToolStripMenuItem.Enabled = _isAdmin;       // Stroji
                merilneMetodeServerToolStripMenuItem.Enabled = _isAdmin; // Merilne metode
                ukrepiServerToolStripMenuItem.Enabled = _isAdmin;        // Ukrepi
                kontrolniPlaniServerToolStripMenuItem.Enabled = _isAdmin; // Kontrolni plani
                meritveServerToolStripMenuItem.Enabled = _isAdmin;        // Meritve

                // Nastavitve, Operacije, Informacije  not gated here
                nastavitveToolStripMenuItem.Enabled = true;
                operacijeToolStripMenuItem.Enabled = true;
                informacijeToolStripMenuItem.Enabled = true;
            }

            // Gate right panel: only Konec (close) button, as in Delphi (button3)
            if (KonecSideButton != null) KonecSideButton.Enabled = _isAdmin;

            // Keep original disabled state for Graf button
            if (GrafButton != null) GrafButton.Enabled = false;
        }

        private Image CreateAdminIcon(Color fill)
        {
            // Simple colored circle icon
            int size = 16;
            var bmp = new Bitmap(size, size);
            using (var g = Graphics.FromImage(bmp))
            using (var brush = new SolidBrush(fill))
            {
                g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;
                g.Clear(Color.Transparent);
                g.FillEllipse(brush, 0, 0, size - 1, size - 1);
            }
            return bmp;
        }

        private void LegendaButton_Click(object sender, EventArgs e)
        {
            using (var dlg = new LegendaForm())
            {
                dlg.ShowDialog(this);
            }
        }

        private void KonecButton_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void SemaforButton_Click(object sender, EventArgs e)
        {
            if (_semaforForm == null || _semaforForm.IsDisposed)
            {
                _semaforForm = new SemaforForm(_isAdmin, GetSemaforRows);
                _semaforForm.Show(this); // non-modal like Delphi
            }
            else
            {
                _semaforForm.BringToFront();
                _semaforForm.Activate();
            }
        }

        // --------- BAZA NA SERVERJU ------------------------------
        private void MerilnaMestaServerMenuItem_Click(object sender, EventArgs e)
        {
            using (var win = new MerilnaMestaForm(_isAdmin, _currentMestoOpis))
            {
                if (win.ShowDialog(this) == DialogResult.OK && win.SelectedMerilnoMesto != null)
                {
                    // Update global state (triggers UI update via event)
                    MerilnoMestoState.Set(win.SelectedMerilnoMesto.StPost, win.SelectedMerilnoMesto.Opis);
                }
            }
        }

        private void StrojiServerMenuItem_Click(object sender, EventArgs e)
        {
            using (var win = new StrojiForm(_isAdmin, _currentStPost, _currentMestoOpis))
            {
                win.ShowDialog(this);
            }
        }

        private void UkrepiServerMenuItem_Click(object sender, EventArgs e)
        {
            using (var win = new UkrepiForm(_isAdmin, _currentStPost, _currentMestoOpis))
            {
                win.ShowDialog(this);
            }
        }

        private void KontrolniPlaniServerMenuItem_Click(object sender, EventArgs e)
        {
            using (var win = new KontrolniPlaniForm(_isAdmin, _currentStPost, _currentMestoOpis))
                win.ShowDialog(this);
        }

        private void MeritveServerMenuItem_Click(object sender, EventArgs e)
        {
            if (!_currentStPost.HasValue)
            {
                MessageBox.Show("Najprej izberite merilno mesto.", "Napaka", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            using (var win = new SqlMeritveForm(_isAdmin, _currentStPost.Value, _currentMestoOpis))
            {
                win.ShowDialog(this);
            }
        }

        // --------- NASTAVITVE ------------------------------------
        private void VpisStevKanalaMenuItem_Click(object sender, EventArgs e)
        {
            _stKanal = VpisStevDialog.Vpis(this, "Vpis tev. kanala", "tevilka merila", _stKanal, 1, 10);
        }

        private void DecimalkeMenuItem_Click(object sender, EventArgs e)
        {
            _stDec = VpisStevDialog.Vpis(this, "Decimalke", "tevilo decimalk", _stDec, 0, 6);
        }

        private void BeriMeritveSettingsMenuItem_Click(object sender, EventArgs e)
        {
            beriMeritveSettingsToolStripMenuItem.Checked = !beriMeritveSettingsToolStripMenuItem.Checked;
            _berMer = beriMeritveSettingsToolStripMenuItem.Checked ? 0 : 1;
        }

        // --------- OPERACIJE -------------------------------------
        private void DodatneKodeMenuItem_Click(object sender, EventArgs e)
        {
            // TODO: Dodatne kode (Dodatnekode1Click)
            string selectedKoda = null;
            if (codesList.SelectedItem != null)
                selectedKoda = codesList.SelectedItem.ToString();
            if (string.IsNullOrWhiteSpace(selectedKoda))
            {
                MessageBox.Show("Najprej izberite kodo.", "Napaka", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            using (var win = new DodatneKodeForm(selectedKoda))
            {
                win.ShowDialog(this);
            }
        }

        // --------- INFORMACIJE -----------------------------------
        private void MerilaInfoMenuItem_Click(object sender, EventArgs e)
        {
            if (!_currentStPost.HasValue)
            {
                MessageBox.Show("Najprej izberite merilno mesto.", "Napaka", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            using (var form = new MerilaForm(_isAdmin, _currentStPost, _currentMestoOpis))
            {
                form.ShowDialog(this);
            }
        }

        private void PrijavaInfoMenuItem_Click(object sender, EventArgs e)
        {
            using (var form = new PrijavaForm())
            {
                form.ShowDialog(this);
            }
        }

        private void MerilneMetodeServerMenuItem_Click(object sender, EventArgs e)
        {
            using (var win = new MerilneMetodeForm(_isAdmin, _currentStPost, _currentMestoOpis))
            {
                win.ShowDialog(this);
            }
        }

        private void MachinesList_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (machinesList.SelectedIndex >= 0)
            {
                // Get machine id and name
                var machineName = machinesList.SelectedItem.ToString();
                _selectedMachineName = machineName;
                _selectedMachineId = GetSelectedMachineId(machineName);
                // Hide DodIzbor when machine changes (Delphi: izborLinije resets it)
                _dodIzborListBox.Items.Clear();
                _dodIzborListBox.Visible = false;
                _dodIzborLabel.Visible = false;
                _selectedOrodje = "";
                if (_operatorValueLabel != null && _selectedMachineId.HasValue)
                {
                    string op;
                    try { op = SinaproRepository.GetOperatorNameFromSinapro(_selectedMachineId.Value); }
                    catch { op = ""; }

                    _operatorValueLabel.Text = string.IsNullOrWhiteSpace(op) ? "(ni prijave)" : op;
                }
                PopulateCodesList();
            }
            else
            {
                _selectedMachineId = null;
                _selectedMachineName = null;
                codesList.Items.Clear();
            }
        }

        private int? GetSelectedMachineId(string machineName)
        {
            if (!_currentStPost.HasValue) return null;
            return StrojnaDbRepository.GetSelectedMachineId(_currentStPost.Value, machineName);
        }
        private void PopulateCodesList()
        {
            codesList.Items.Clear();

            if (!_selectedMachineId.HasValue || !_currentStPost.HasValue)
            {
                return;
            }

            int ident = _selectedMachineId.Value;
            int idpost = _currentStPost.Value;

            int kdp = 0;
            try
            {
                kdp = StrojnaDbRepository.GetIzbiraFromPostajeOrDefault(idpost);
            }
            catch { /* keep 0 */ }

            List<string> listak = new List<string>();
            string source = "UNKNOWN";

            try
            {
                switch (kdp)
                {
                    case 0:
                        source = "Sinapro.GetSinaproKodaListForMachine";
                        listak = SinaproRepository.GetSinaproKodaListForMachine(ident);
                        break;
                    case 1:
                        source = "StrojnaDb.GetListaCodesForPostaja";
                        listak = StrojnaDbRepository.GetListaCodesForPostaja(idpost);
                        break;
                    case 2:
                        source = "Stroji.Getkode (NOT USED)";
                        listak = new List<string>();
                        break;
                    default:
                        source = "Sinapro.GetSinaproKodaListForMachine (default)";
                        listak = SinaproRepository.GetSinaproKodaListForMachine(ident);
                        break;
                }
            }
            catch (Exception ex)
            {
                return;
            }

            int added = 0, duplicates = 0;
            int skippedEmpty = 0, skippedKddEmpty = 0;
            int noSlash = 0, shortSuffix = 0;
            int prevediFail = 0, toggledOk = 0, toggledFail = 0;

            foreach (var it in listak ?? Enumerable.Empty<string>())
            {
                string kd = (it ?? "").Trim();
                if (kd == "") { skippedEmpty++; continue; }

                string kdNorm = AppUtils.NormalizeKodaDelphiLike(kd);
                string kdd = (kdNorm ?? "").Replace("-", "").Trim();
                if (kdd == "") { skippedKddEmpty++; continue; }

                bool naselKd = false;
                try { naselKd = StrojnaDbRepository.PreveriKodoDelphiLike(kdd, idpost); }
                catch { naselKd = false; }

                string finalKd = "";
                string action = "";

                if (naselKd)
                {
                    finalKd = kdd;
                    action = "OK";
                }
                else
                {
                    int ipx = kdd.IndexOf('/');
                    if (ipx <= 0)
                    {
                        noSlash++;
                        action = "NO_SLASH -> drop";
                    }
                    else if (ipx + 2 >= kdd.Length)
                    {
                        shortSuffix++;
                        action = "SHORT_SUFFIX -> drop";
                    }
                    else
                    {
                        string xpx = kdd.Substring(ipx + 1, 2);
                        string toggled = kdd.Substring(0, ipx + 1) + (xpx == "01" ? "00" : "01");

                        bool ok2 = false;
                        try { ok2 = PreveriKodoDelphiLike(toggled, idpost); }
                        catch { ok2 = false; }

                        if (ok2)
                        {
                            finalKd = toggled;
                            toggledOk++;
                            action = $"TOGGLE {xpx}->{(xpx == "01" ? "00" : "01")} OK";
                        }
                        else
                        {
                            toggledFail++;
                            action = $"TOGGLE {xpx} FAIL -> drop";
                        }
                    }
                }

                if (finalKd != "")
                {
                    if (codesList.Items.IndexOf(finalKd) < 0)
                    {
                        codesList.Items.Add(finalKd);
                        added++;
                    }
                    else
                    {
                        duplicates++;
                    }
                }
                else
                {
                    prevediFail++;
                }

            }
        }

        // Delphi: SELECT * from konsar where (koda=:KD) and (idpost=:IDP) and (koncan <> 'Y') and (koncan <> 'X')
        private bool PreveriKodoDelphiLike(string kd, int idpost)
        {
            string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;

            using (var conn = new OleDbConnection(connStr))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText =
                    "SELECT COUNT(*) " +
                    "FROM konsar " +
                    "WHERE (koda = ?) AND (idpost = ?) AND (koncan <> 'Y') AND (koncan <> 'X')";

                cmd.Parameters.AddWithValue("@p1", kd);
                cmd.Parameters.AddWithValue("@p2", idpost);

                conn.Open();
                int n = Convert.ToInt32(cmd.ExecuteScalar() ?? 0);
                return n > 0;
            }
        }

        private void CodesList_SelectedIndexChanged(object sender, EventArgs e)
        {
            var selected = codesList.SelectedItem?.ToString();
            if (string.IsNullOrWhiteSpace(selected)) return;

            if (_currentStPost.HasValue && machinesList.SelectedIndex >= 0)
            {
                int idx = machinesList.SelectedIndex + 1; // 1-based like Delphi
                var (diff, traj) = StrojnaDbRepository.GetIntervalFromKonsar(selected, _currentStPost.Value);
                _diffByIndex[idx] = diff;
                _trajByIndex[idx] = traj;
            }

            LoadKonplanAndPopulateGrids(selected);
        }
        
        private void LoadKonplanAndPopulateGrids(string kdRaw)
        {
            if (!_currentStPost.HasValue)
                return;

            var kd = AppUtils.CleanKoda(kdRaw);
            UpdateDodIzborVisibility((kdRaw ?? "").Trim());

            //UpdateDodIzborVisibility(kd); // Show/hide DodIzbor like Delphi
            var srz = StrojnaDbRepository.GetSarzaForKoda(kd, _currentStPost.Value);

            _currentKodaClean = kd;
            _currentSarza = srz;

            if (string.IsNullOrWhiteSpace(srz))
            {
                MessageBox.Show("Koda nima kontrolne are v bazi (konsar).");
                ClearCharacteristicGrids();
                if (GrafButton != null) GrafButton.Enabled = false;
                // clear context
                _currentKodaClean = null;
                _currentSarza = null;
                return;
            }

            var dt = StrojnaDbRepository.GetKonplanRowsForSarza(srz, _currentStPost.Value);

            if (dt.Rows.Count == 0)
            {
                MessageBox.Show("Za izbrano aro ni kontrolnega plana v konplan.");
                ClearCharacteristicGrids();
                if (GrafButton != null) GrafButton.Enabled = false;
                // clear context
                _currentKodaClean = null;
                _currentSarza = null;
                return;
            }

            int stcl = dt.AsEnumerable()
                .Where(r => ToInt(r["tip"]) == 1)
                .Select(r => ToInt(r["stvz"]))
                .DefaultIfEmpty(0)
                .Max();

            int stvp = dt.AsEnumerable()
                .Where(r => ToInt(r["tip"]) == 2)
                .Select(r => ToInt(r["stvz"]))
                .DefaultIfEmpty(0)
                .Max();

            ConfigureKaraktiGrid(stcl);
            ConfigureAttriGrid();

            // Fill variable characteristics (tip=1)
            foreach (DataRow r in dt.Rows)
            {
                int tip = ToInt(r["tip"]);
                if (tip != 1) continue;

                object[] row = new object[DODK + stcl];
                row[0] = r["pozicija"]?.ToString();
                row[1] = r["naziv"]?.ToString();
                row[2] = r["predpis"] == DBNull.Value ? "0" : r["predpis"]?.ToString();
                row[3] = r["spmeja"] == DBNull.Value ? "" : r["spmeja"]?.ToString();
                row[4] = r["zgmeja"] == DBNull.Value ? "" : r["zgmeja"]?.ToString();

                var stkanal = (r.Table.Columns.Contains("stkanal") && r["stkanal"] != DBNull.Value) ? ToInt(r["stkanal"]) : 0;
                var metoda = r.Table.Columns.Contains("kanal") ? (r["kanal"]?.ToString() ?? "") : "";
                row[5] = stkanal == 0 ? metoda : stkanal.ToString();

                row[6] = (r.Table.Columns.Contains("com") && r["com"] != DBNull.Value) ? r["com"].ToString() : "";
                // GRAF as bool:
                row[7] = (r.Table.Columns.Contains("oznaka")
                          && r["oznaka"] != DBNull.Value
                          && string.Equals(r["oznaka"].ToString().Trim(), "X", StringComparison.OrdinalIgnoreCase));
                row[8] = (r.Table.Columns.Contains("idplan") && r["idplan"] != DBNull.Value) ? r["idplan"].ToString() : "";
                row[9] = ""; // Avr (unused for now)
                row[10] = ToInt(r["stvz"]); // IMPORTANT: stash stvz here for Graf (we'll read it later)
                row[11] = (r.Table.Columns.Contains("operacija") && r["operacija"] != DBNull.Value) ? r["operacija"].ToString() : "";

                KaraktiGrid.Rows.Add(row);
            }

            // Fill attribute characteristics (tip=2)
            foreach (DataRow r in dt.Rows)
            {
                int tip = ToInt(r["tip"]);
                if (tip != 2) continue;

                attriGrid.Rows.Add(
                    r["pozicija"]?.ToString(),
                    r["naziv"]?.ToString(),
                    r.Table.Columns.Contains("operacija") && r["operacija"] != DBNull.Value ? r["operacija"].ToString() : "",
                    ToInt(r["stvz"]).ToString(),
                    false,
                    ""
                );
            }
            UpdateGrafButtonEnabled();
            ApplyDefaultKanalFromFirstRow();
        }

        private void ClearCharacteristicGrids()
        {
            KaraktiGrid.Columns.Clear();
            KaraktiGrid.Rows.Clear();
            attriGrid.Columns.Clear();
            attriGrid.Rows.Clear();
            if (GrafButton != null) GrafButton.Enabled = false;
        }

        private void ConfigureKaraktiGrid(int stcl)
        {
            KaraktiGrid.Columns.Clear();
            KaraktiGrid.AutoGenerateColumns = false;
            KaraktiGrid.AllowUserToAddRows = false;
            KaraktiGrid.RowHeadersVisible = false;
            KaraktiGrid.ColumnHeadersVisible = true; // Ensure headers are visible

            KaraktiGrid.Columns.Add(new DataGridViewTextBoxColumn { Name = "Pozicija", HeaderText = "Pozicija", Width = 100 });
            KaraktiGrid.Columns.Add(new DataGridViewTextBoxColumn { Name = "Naziv", HeaderText = "Naziv", Width = 250 });
            KaraktiGrid.Columns.Add(new DataGridViewTextBoxColumn { Name = "Predpis", HeaderText = "Predpis", Width = 110 });
            KaraktiGrid.Columns.Add(new DataGridViewTextBoxColumn { Name = "SpMeja", HeaderText = "Sp. meja", Width = 110 });
            KaraktiGrid.Columns.Add(new DataGridViewTextBoxColumn { Name = "ZgMeja", HeaderText = "Zg. meja", Width = 110 });
            KaraktiGrid.Columns.Add(new DataGridViewTextBoxColumn { Name = "Merilo", HeaderText = "Merilo", Width = 100 });
            KaraktiGrid.Columns.Add(new DataGridViewTextBoxColumn { Name = "COM", HeaderText = "COM", Width = 80, Visible = false });
            var grafCol = new DataGridViewCheckBoxColumn
            {
                Name = "Graf",
                HeaderText = "Graf",
                Width = 60,
                ThreeState = false
            };
            KaraktiGrid.Columns.Add(grafCol);
            KaraktiGrid.Columns.Add(new DataGridViewTextBoxColumn { Name = "Preracun", HeaderText = "Preraèun", Width = 80, Visible = false });
            KaraktiGrid.Columns.Add(new DataGridViewTextBoxColumn { Name = "Avr", HeaderText = "Avr", Width = 80, Visible = false });
            KaraktiGrid.Columns.Add(new DataGridViewTextBoxColumn { Name = "StVz", HeaderText = "StVz", Width = 80, Visible = false });
            KaraktiGrid.Columns.Add(new DataGridViewTextBoxColumn { Name = "Operacija", HeaderText = "Operacija", Width = 80, Visible = false });

            for (int i = 1; i <= stcl; i++)
            {
                KaraktiGrid.Columns.Add(new DataGridViewTextBoxColumn
                {
                    Name = $"Vzorec{i}",
                    HeaderText = $"Vzorec {i}",
                    Width = 90
                });
            }
        }

        private void ConfigureAttriGrid()
        {
            attriGrid.Columns.Clear();
            attriGrid.AutoGenerateColumns = false;
            attriGrid.AllowUserToAddRows = false;
            attriGrid.RowHeadersVisible = false;
            attriGrid.ColumnHeadersVisible = true; // Ensure headers are visible

            attriGrid.Columns.Add(new DataGridViewTextBoxColumn { Name = "Pozicija", HeaderText = "Pozicija", Width = 100 });
            attriGrid.Columns.Add(new DataGridViewTextBoxColumn { Name = "Naziv", HeaderText = "Naziv", Width = 250 });
            attriGrid.Columns.Add(new DataGridViewTextBoxColumn { Name = "Operacija", HeaderText = "Operacija", Width = 80, Visible = false }); // ADD
            attriGrid.Columns.Add(new DataGridViewTextBoxColumn { Name = "StVzor", HeaderText = "t. vzor.", Width = 100 });
            var vsiDobriCol = new DataGridViewCheckBoxColumn { Name = "VsiDobri", HeaderText = "Vsi dobri", Width = 100 };
            attriGrid.Columns.Add(vsiDobriCol);
            attriGrid.Columns.Add(new DataGridViewTextBoxColumn { Name = "StSlabih", HeaderText = "t. slabih", Width = 100 });
        }

        private const int DODK = 11; // fixed columns 0..10 before Vzorec columns
        private int ToInt(object x)
        {
            if (x == null || x == DBNull.Value) return 0;
            return Convert.ToInt32(x);
        }

        private void InitializeCharacteristicGrids()
        {
            // --- KaraktiGrid behavior only (NO columns here) ---
            KaraktiGrid.AutoGenerateColumns = false;
            KaraktiGrid.AllowUserToAddRows = false;
            KaraktiGrid.RowHeadersVisible = false;
            KaraktiGrid.SelectionMode = DataGridViewSelectionMode.CellSelect;
            KaraktiGrid.MultiSelect = false;
            KaraktiGrid.ColumnHeadersVisible = true;

            // optional, but helps keep UI stable
            KaraktiGrid.EditMode = DataGridViewEditMode.EditOnEnter;

            // --- attriGrid behavior only (NO columns here) ---
            attriGrid.AutoGenerateColumns = false;
            attriGrid.AllowUserToAddRows = false;
            attriGrid.RowHeadersVisible = false;
            attriGrid.SelectionMode = DataGridViewSelectionMode.CellSelect;
            attriGrid.MultiSelect = false;
            attriGrid.ColumnHeadersVisible = true;
            attriGrid.EditMode = DataGridViewEditMode.EditOnEnter;

            // IMPORTANT: avoid double-subscribing if InitializeCharacteristicGrids is ever called again
            attriGrid.CellValueChanged -= AttriGrid_CellValueChanged;
            attriGrid.CurrentCellDirtyStateChanged -= AttriGrid_CurrentCellDirtyStateChanged;

            attriGrid.CellValueChanged += AttriGrid_CellValueChanged;
            attriGrid.CurrentCellDirtyStateChanged += AttriGrid_CurrentCellDirtyStateChanged;
        }

        private void AttriGrid_CurrentCellDirtyStateChanged(object sender, EventArgs e)
        {
            if (attriGrid.IsCurrentCellDirty)
                attriGrid.CommitEdit(DataGridViewDataErrorContexts.Commit);
        }

        private void AttriGrid_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0) return;
            if (attriGrid.Columns[e.ColumnIndex].Name != "VsiDobri") return;

            var row = attriGrid.Rows[e.RowIndex];
            var cell = row.Cells["VsiDobri"] as DataGridViewCheckBoxCell;

            if (cell?.Value is bool b && b)
                row.Cells["StSlabih"].Value = 0;
        }

        private void MeritveButton_Click(object sender, EventArgs e)
        {
            // Open SqlMeritveForm with the same logic as the menu item
            if (!_currentStPost.HasValue)
            {
                MessageBox.Show("Najprej izberite merilno mesto.", "Napaka", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            using (var win = new SqlMeritveForm(_isAdmin, _currentStPost.Value, _currentMestoOpis))
            {
                win.ShowDialog(this);
            }
        }

        private void ObnoviSemafor()
        {
            if (!_currentStPost.HasValue) return;
            var now = DateTime.Now;
            var tt = now.TimeOfDay;

            var (datTmp, izm) = AppUtils.GetIzmDatDelphiLike(DateTime.Now);
            bool novaiz = AppUtils.IsNearShiftStart(tt, _zacIzm);
            int machineCount = machinesList.Items.Count;
            for (int i = 1; i <= machineCount; i++)
            {
                bool strojAktiven = _machineActiveByIndex.TryGetValue(i, out var aktiven) && aktiven;
                if (!strojAktiven)
                {
                    _astanjeByIndex[i] = 9;
                    continue;
                }
                int diff = _diffByIndex.TryGetValue(i, out var d) ? d : DefaultIntervalDiffMinutes;
                int traj = _trajByIndex.TryGetValue(i, out var t) ? t : DefaultIntervalTrajMinutes;
                if (novaiz)
                {
                    _astanjeByIndex[i] = 2;
                    _acasByIndex[i] = tt - TimeSpan.FromMinutes(diff);
                    continue;
                }
                TimeSpan lastMeas = StrojnaDbRepository.TryGetLastMeasurementTimeOfDay(
                    _currentStPost.Value,
                    _machineIdByIndex[i],
                    AppUtils.GetIzmDatDelphiLike
                );

                if (lastMeas == TimeSpan.Zero)
                {
                    // if acas[i] == 0 then set
                    if (!_acasByIndex.TryGetValue(i, out var acas) || acas == TimeSpan.Zero)
                        _acasByIndex[i] = _zacIzm[izm] - TimeSpan.FromMinutes(diff);
                    _astanjeByIndex[i] = AppUtils.DolociSt(_acasByIndex[i], diff, traj, tt);
                }
                else
                {
                    _acasByIndex[i] = lastMeas;
                    _astanjeByIndex[i] = AppUtils.DolociSt(lastMeas, diff, traj, tt);
                }
            }
        }

        private List<SemaforForm.SemaforRow> GetSemaforRows()
        {
            ObnoviSemafor();
            var list = new List<SemaforForm.SemaforRow>();
            int n = machinesList.Items.Count;
            for (int i = 1; i <= n; i++)
            {
                string naziv = machinesList.Items[i - 1]?.ToString() ?? "";
                int status = _astanjeByIndex.TryGetValue(i, out var st) ? st : 9;
                int diff = _diffByIndex.TryGetValue(i, out var d) ? d : DefaultIntervalDiffMinutes;
                var acas = _acasByIndex.TryGetValue(i, out var t) ? t : TimeSpan.Zero;
                var baseDt = DateTime.Today.Add(acas);
                list.Add(new SemaforForm.SemaforRow
                {
                    Naziv = naziv,
                    Status = status,
                    DiffMinutes = diff,
                    NextBaseTime = baseDt
                });
            }
            return list;
        }

        // === GRAF COLUMN BEHAVIOR ===
        private void WireGrafColumnBehavior()
        {
            KaraktiGrid.CurrentCellDirtyStateChanged += KaraktiGrid_CurrentCellDirtyStateChanged;
            KaraktiGrid.CellValueChanged += KaraktiGrid_CellValueChanged;
            KaraktiGrid.CellDoubleClick += KaraktiGrid_CellDoubleClick;
        }
        private void KaraktiGrid_CurrentCellDirtyStateChanged(object sender, EventArgs e)
        {
            if (KaraktiGrid.IsCurrentCellDirty && KaraktiGrid.CurrentCell is DataGridViewCheckBoxCell)
                KaraktiGrid.CommitEdit(DataGridViewDataErrorContexts.Commit);
        }
        private void KaraktiGrid_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0) return;
            if (KaraktiGrid.Columns[e.ColumnIndex].Name == "Graf")
                UpdateGrafButtonEnabled();
        }
        private void KaraktiGrid_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0) return;
            var cell = KaraktiGrid.Rows[e.RowIndex].Cells["Graf"] as DataGridViewCheckBoxCell;
            if (cell == null) return;
            bool current = cell.Value is bool b && b;
            cell.Value = !current;
            KaraktiGrid.CommitEdit(DataGridViewDataErrorContexts.Commit);
            UpdateGrafButtonEnabled();
        }
        private void UpdateGrafButtonEnabled()
        {
            if (GrafButton == null) return;
            bool anyChecked = KaraktiGrid.Rows
                .Cast<DataGridViewRow>()
                .Any(r => r.Cells["Graf"].Value is bool b && b);
            GrafButton.Enabled = anyChecked;
        }

        private void GrafButton_Click(object sender, EventArgs e)
        {
            var kd = codesList.SelectedItem?.ToString();
            if (string.IsNullOrWhiteSpace(kd))
            {
                MessageBox.Show("Najprej izberite kodo.", "Graf", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            kd = AppUtils.CleanKoda(kd);

            // pick checked rows (max 4 like Delphi has 4 images)
            var checkedRows = KaraktiGrid.Rows
                .Cast<DataGridViewRow>()
                .Where(r => r.Cells["Graf"].Value is bool b && b)
                .Take(4)
                .ToList();

            if (checkedRows.Count == 0)
            {
                MessageBox.Show("Najprej oznaèite vsaj eno karakteristiko (Graf).", "Graf", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }

            var requests = new List<GrafiForm.GrafRequest>();

            foreach (var r in checkedRows)
            {
                var karakt = (r.Cells["Pozicija"].Value?.ToString() ?? "").Trim();
                var naziv = (r.Cells["Naziv"].Value?.ToString() ?? "").Trim();

                double sr = AppUtils.ParseDoubleLoose(r.Cells["Predpis"].Value);
                double sp = AppUtils.ParseDoubleLoose(r.Cells["SpMeja"].Value);
                double zg = AppUtils.ParseDoubleLoose(r.Cells["ZgMeja"].Value);

                int stvz = ToInt(r.Cells["StVz"].Value);
                if (stvz <= 0) stvz = 1;

                var points = StrojnaDbRepository.FetchGrafPoints(kd, karakt);
                if (points.Count == 0)
                    continue;

                AppUtils.ComputeStats(points.Select(p => p.Value).ToList(), out double avr, out double std);

                requests.Add(new GrafiForm.GrafRequest
                {
                    Title = $"{karakt} - {naziv}",
                    StVz = stvz,
                    Sr = sr,
                    Sp = sp,
                    Zg = zg,
                    Avr = avr,
                    Std = std,
                    Points = points
                });
            }

            if (requests.Count == 0)
            {
                MessageBox.Show("Za izbrane karakteristike ni zgodovine meritev (Glavmer/Karmer).", "Graf", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }

            using (var win = new GrafiForm(requests))
            {
                win.ShowDialog(this);
            }
        }

        private async void TestInputButton_Click(object sender, EventArgs e)
        {
            if (_testInputRunning) return;

            var btn = _testInputButton ?? (sender as Button);
            string oldText = btn?.Text ?? "Test Input";

            _testInputRunning = true;
            try
            {
                // Must click a Vzorec cell first
                var cell = KaraktiGrid?.CurrentCell;
                var colName = cell?.OwningColumn?.Name ?? "";
                if (cell == null || !colName.StartsWith("Vzorec", StringComparison.OrdinalIgnoreCase))
                {
                    MessageBox.Show(this,
                        "Najprej klikni celico v stolpcu Vzorec (Vzorec1, Vzorec2, ...).",
                        "Test Input",
                        MessageBoxButtons.OK,
                        MessageBoxIcon.Information);
                    return;
                }

                if (btn != null)
                {
                    btn.Enabled = false;
                    btn.Text = "Test Input (èakam...)";
                }

                // Read one fresh frame after click (caliper sends when you press it)
                string raw = await Task.Run(() => AppUtils.ReadOneFrameFromCom(TEST_INPUT_PORT, TEST_INPUT_BAUD, TimeSpan.FromSeconds(30)));

                if (string.IsNullOrWhiteSpace(raw))
                {
                    MessageBox.Show(this,
                        "Timeout (30s)  ni podatkov.\n\nNamig: klikni Test Input, nato pritisni gumb na ublerju.",
                        "Test Input",
                        MessageBoxButtons.OK,
                        MessageBoxIcon.Warning);
                    return;
                }

                if (!TryParseValueFromRaw(raw, out double value, out string tokenUsed))
                {
                    MessageBox.Show(this,
                        "Ne znam parsirati meritve iz prejetega okvirja.\n\nRAW:\n" + raw,
                        "Test Input",
                        MessageBoxButtons.OK,
                        MessageBoxIcon.Warning);
                    return;
                }

                ApplyPrenosValueToCurrentCell(value);
            }
            catch (Exception ex)
            {
                MessageBox.Show(this,
                    "Napaka pri branju COM porta:\n" + ex.Message,
                    "Test Input",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
            finally
            {
                if (btn != null)
                {
                    btn.Enabled = true;
                    btn.Text = oldText;
                }
                _testInputRunning = false;
            }
        }

        private static bool TryParseValueFromRaw(string raw, out double value, out string tokenUsed)
        {
            return AppUtils.TryParseLast04AFrame(raw, out value, out _, out tokenUsed);
        }

        private void ApplyPrenosValueToCurrentCell(double value)
        {
            var grid = KaraktiGrid;
            var cell = grid?.CurrentCell;
            var colName = cell?.OwningColumn?.Name ?? "";

            if (cell == null || !colName.StartsWith("Vzorec", StringComparison.OrdinalIgnoreCase))
            {
                MessageBox.Show(this,
                    "Najprej klikni celico v stolpcu Vzorec (Vzorec1, Vzorec2, ...).",
                    "Prenos s stopalko",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Information);
                StopPrenosStopalka();
                return;
            }

            // make sure were not stuck in edit mode
            grid.EndEdit();
            grid.CommitEdit(DataGridViewDataErrorContexts.Commit);

            // write value
            cell.Value = FormatMeasurement(value);

            int row = cell.RowIndex;
            int curCol = cell.ColumnIndex;

            // find first Vzorec col (for row wrap)
            int firstVzCol = -1;
            for (int i = 0; i < grid.ColumnCount; i++)
            {
                if (grid.Columns[i].Name.StartsWith("Vzorec", StringComparison.OrdinalIgnoreCase))
                {
                    firstVzCol = i;
                    break;
                }
            }

            // 1) next Vzorec cell to the right in same row
            int nextCol = -1;
            for (int i = curCol + 1; i < grid.ColumnCount; i++)
            {
                if (grid.Columns[i].Name.StartsWith("Vzorec", StringComparison.OrdinalIgnoreCase))
                {
                    nextCol = i;
                    break;
                }
            }

            int nextRow = row;

            // 2) if no next column, go to next row + first Vzorec column
            if (nextCol < 0 && firstVzCol >= 0)
            {
                if (row + 1 < grid.Rows.Count)
                {
                    nextRow = row + 1;
                    nextCol = firstVzCol;
                }
            }

            // move if we found a destination
            if (nextCol >= 0)
            {
                grid.CurrentCell = grid.Rows[nextRow].Cells[nextCol];
                grid.Focus();
                grid.BeginEdit(true);
            }
        }

        private void WirePrenosStopalkaPrekiniButtons()
        {
            _prenosStopalkaButton =
                AppUtils.FindControl<Button>(this, "PrenosStopalkaButton") ??
                AppUtils.FindFirstButtonByTextContains(this, "stopalk");

            _prekiniButton =
                AppUtils.FindControl<Button>(this, "PrekiniButton") ??
                AppUtils.FindFirstButtonByTextContains(this, "Prekini");

            if (_prenosStopalkaButton != null)
            {
                _prenosStopalkaButton.Click -= PrenosStopalkaButton_Click;
                _prenosStopalkaButton.Click += PrenosStopalkaButton_Click;
            }

            if (_prekiniButton != null)
            {
                _prekiniButton.Click -= PrekiniButton_Click;
                _prekiniButton.Click += PrekiniButton_Click;
                _prekiniButton.Enabled = false;
            }
        }

        private void PrenosStopalkaButton_Click(object sender, EventArgs e) => StartPrenosStopalka();
        private void PrekiniButton_Click(object sender, EventArgs e) => StopPrenosStopalka();

        private void StartPrenosStopalka()
        {
            if (_prenosStopalkaRunning) return;

            var cell = KaraktiGrid?.CurrentCell;
            var colName = cell?.OwningColumn?.Name ?? "";
            if (cell == null || !colName.StartsWith("Vzorec", StringComparison.OrdinalIgnoreCase))
            {
                MessageBox.Show(this,
                    "Najprej klikni celico v stolpcu Vzorec (Vzorec1, Vzorec2, ...).",
                    "Prenos s stopalko",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Information);
                return;
            }

            _prenosStopalkaRunning = true;
            if (_prenosStopalkaButton != null) _prenosStopalkaButton.Enabled = false;
            if (_prekiniButton != null) _prekiniButton.Enabled = true;

            _prenosStopalkaCts?.Dispose();
            _prenosStopalkaCts = new System.Threading.CancellationTokenSource();

            try
            {
                _prenosStopalkaPort = new SerialPort(PRENOS_PORT, PRENOS_BAUD, Parity.None, 8, StopBits.One)
                {
                    Handshake = Handshake.None,
                    DtrEnable = true,
                    RtsEnable = true,
                    Encoding = Encoding.ASCII,
                    ReadTimeout = 250
                };

                _prenosStopalkaPort.DataReceived += PrenosStopalkaPort_DataReceived;
                _prenosStopalkaPort.Open();
                _prenosStopalkaPort.DiscardInBuffer();
            }
            catch (Exception ex)
            {
                StopPrenosStopalka();
                MessageBox.Show(this,
                    "Napaka pri odpiranju COM porta:\n" + ex.Message,
                    "Prenos s stopalko",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
            }
        }

        private void StopPrenosStopalka()
        {
            _prenosStopalkaRunning = false;

            try { _prenosStopalkaCts?.Cancel(); } catch { }
            try { _prenosStopalkaCts?.Dispose(); } catch { }
            _prenosStopalkaCts = null;

            try
            {
                if (_prenosStopalkaPort != null)
                {
                    _prenosStopalkaPort.DataReceived -= PrenosStopalkaPort_DataReceived;
                    if (_prenosStopalkaPort.IsOpen) _prenosStopalkaPort.Close();
                    _prenosStopalkaPort.Dispose();
                }
            }
            catch { }
            _prenosStopalkaPort = null;

            lock (_prenosLock) _prenosBuf.Clear();

            if (IsHandleCreated)
            {
                BeginInvoke((Action)(() =>
                {
                    if (_prenosStopalkaButton != null) _prenosStopalkaButton.Enabled = true;
                    if (_prekiniButton != null) _prekiniButton.Enabled = false;
                }));
            }
        }

        private void PrenosStopalkaPort_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            if (!_prenosStopalkaRunning || _prenosStopalkaPort == null) return;

            string chunk;
            try { chunk = _prenosStopalkaPort.ReadExisting(); }
            catch { return; }

            if (string.IsNullOrEmpty(chunk)) return;

            lock (_prenosLock)
            {
                _prenosBuf.Append(chunk);
                if (_prenosBuf.Length > 512)
                    _prenosBuf.Remove(0, _prenosBuf.Length - 512);
            }

            if (System.Threading.Interlocked.Exchange(ref _prenosBusy, 1) == 1) return;

            try
            {
                string raw;
                lock (_prenosLock) raw = _prenosBuf.ToString();

                if (!AppUtils.TryParseLast04AFrame(raw, out double value, out int endIdx, out _))
                    return;

                // consume everything up to the end of the frame we used; keep any trailing bytes for next read
                lock (_prenosLock)
                {
                    if (endIdx > 0 && endIdx <= _prenosBuf.Length)
                        _prenosBuf.Remove(0, endIdx);
                }

                if (IsHandleCreated)
                    BeginInvoke((Action)(() => ApplyPrenosValueToCurrentCell(value)));
            }
            finally
            {
                System.Threading.Interlocked.Exchange(ref _prenosBusy, 0);
            }
        }

        // Programmatic docking layout for responsive UI
        private void ConfigureResponsiveLayout()
        {
            if (_leftContent != null) return;

            SuspendLayout();

            // Remove designer-added controls from the FORM so we can re-add them cleanly
            Controls.Remove(topPanel);
            Controls.Remove(variabilneTitleLabel);
            Controls.Remove(KaraktiGrid);
            Controls.Remove(atributivneTitleLabel);
            Controls.Remove(attriGrid);
            Controls.Remove(rightPanel);
            Controls.Remove(menuStrip);

            // Form regions
            menuStrip.Dock = DockStyle.Top;

            rightPanel.Dock = DockStyle.Right;
            rightPanel.Width = 260;

            _leftContent = new Panel
            {
                Dock = DockStyle.Fill,
                Padding = new Padding(27, 8, 8, 8),
                BackColor = this.BackColor
            };

            // Left-side regions: top header, middle (variable), bottom (attribute)
            _variablePanel = new Panel { Dock = DockStyle.Fill };
            _attributePanel = new Panel { Dock = DockStyle.Bottom, Height = 32 + 180 + 8 };

            // Dock order inside leftContent (add fill first, then bottom, then top)
            _leftContent.Controls.Add(_variablePanel);
            _leftContent.Controls.Add(_attributePanel);
            _leftContent.Controls.Add(topPanel);

            topPanel.Dock = DockStyle.Top;
            topPanel.Height = 220;

            // Variable section: title (top) + grid (fill)
            _variablePanel.Controls.Add(KaraktiGrid);
            _variablePanel.Controls.Add(variabilneTitleLabel);

            variabilneTitleLabel.AutoSize = false;
            variabilneTitleLabel.Dock = DockStyle.Top;
            variabilneTitleLabel.Height = 32;

            KaraktiGrid.Dock = DockStyle.Fill;

            // Attribute section: title (top) + grid (fill)
            _attributePanel.Controls.Add(attriGrid);
            _attributePanel.Controls.Add(atributivneTitleLabel);

            atributivneTitleLabel.AutoSize = false;
            atributivneTitleLabel.Dock = DockStyle.Top;
            atributivneTitleLabel.Height = 32;

            attriGrid.Dock = DockStyle.Fill;

            // Add to form in correct order (fill, right, top-last so it docks first)
            Controls.Add(_leftContent);
            Controls.Add(rightPanel);
            Controls.Add(menuStrip);

            ConfigureRightPanelCenteredLayout();

            ResumeLayout(true);
        }

        // Center the rightPanel content vertically (logo + text + buttons)
        private void ConfigureRightPanelCenteredLayout()
        {
            // Keep your existing controls, just re-parent them into a top header + centered button stack.
            var buttons = new Control[]
            {
                TransferButton,
                TransferWithPedalButton,
                PrekinButton,
                SAPButton,
                MeritveButton,
                LegendaSideButton,
                SemaforSideButton,
                GrafButton,
                KonecSideButton
            };

            rightPanel.SuspendLayout();

            // Clear panel (controls are not disposed; theyll be re-added)
            rightPanel.Controls.Clear();

            // ---------- TOP HEADER (logo + text) ----------
            var header = new TableLayoutPanel
            {
                Dock = DockStyle.Top,
                AutoSize = true,
                ColumnCount = 1,
                Padding = new Padding(0, 16, 0, 8),
                BackColor = rightPanel.BackColor
            };
            header.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100f));

            if (logoPicture != null)
            {
                logoPicture.Anchor = AnchorStyles.None;
                logoPicture.Margin = new Padding(0, 0, 0, 6);
                header.RowStyles.Add(new RowStyle(SizeType.AutoSize));
                header.Controls.Add(logoPicture, 0, header.RowCount++);
            }

            if (companyLabel != null)
            {
                companyLabel.Anchor = AnchorStyles.None;
                companyLabel.Margin = new Padding(0, 0, 0, 0);
                header.RowStyles.Add(new RowStyle(SizeType.AutoSize));
                header.Controls.Add(companyLabel, 0, header.RowCount++);
            }

            // ---------- BODY (buttons centered in remaining space) ----------
            var body = new TableLayoutPanel
            {
                Dock = DockStyle.Fill,
                ColumnCount = 1,
                BackColor = rightPanel.BackColor,
                Padding = new Padding(0, 8, 0, 16)
            };
            body.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100f));
            body.RowCount = 3;
            body.RowStyles.Add(new RowStyle(SizeType.Percent, 50f));  // spacer
            body.RowStyles.Add(new RowStyle(SizeType.AutoSize));      // buttons
            body.RowStyles.Add(new RowStyle(SizeType.Percent, 50f));  // spacer

            var flow = new FlowLayoutPanel
            {
                AutoSize = true,
                FlowDirection = FlowDirection.TopDown,
                WrapContents = false,
                Anchor = AnchorStyles.None,
                BackColor = rightPanel.BackColor,
                Margin = new Padding(0)
            };

            foreach (var c in buttons)
            {
                if (c == null) continue;
                c.Anchor = AnchorStyles.None;
                c.Margin = new Padding(0, 6, 0, 6);
                flow.Controls.Add(c);
            }

            body.Controls.Add(flow, 0, 1);

            // IMPORTANT: add Fill first, then Top (docking order)
            rightPanel.Controls.Add(body);
            rightPanel.Controls.Add(header);

            rightPanel.ResumeLayout(true);
        }

        private void SAPButton_Click(object sender, EventArgs e)
        {
            // CONFIRM SAP SYSTEM (E4P vs E4Q) BEFORE WRITING
            try
            {
                var dest = SapSession.GetDestination();
                var a = dest.SystemAttributes;

                // Example text: "E4P (client 101, sysnr 10) @ sape4p.blanc-fischer.com"
                var sysText = $"{a.SystemID} (client {a.Client}, sysnr {a.SystemNumber})";

                var dr = MessageBox.Show(
                    this,
                    $"Prepis v SAP?\n\nAre you sure you're signed into system:\n\n{sysText}",
                    "SAP zapis - potrditev sistema",
                    MessageBoxButtons.YesNo,
                    MessageBoxIcon.Warning,
                    MessageBoxDefaultButton.Button2
                );

                if (dr != DialogResult.Yes)
                    return;
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    this,
                    "Ne morem prebrati SAP sistema iz trenutne prijave.\n\n" + ex.Message,
                    "SAP zapis",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning
                );
                return;
            }

            if (!ValidateAllCharacteristicsEntered(out var validationError))
            {
                MessageBox.Show(validationError, "SAP zapis",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            if (!TryBuildSapPayload(out var p, out var err))
            {
                MessageBox.Show(err, "SAP zapis", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            // Delphi: FvpisOpom.Vpis(evalList);
            if (!VpisOpombeForm.Vpis(this, p.EvalList, _currentStPost ?? 0))
                return; // user canceled

            // Delphi: copy px.op into pv.opom for matching stkar
            foreach (var ev in p.EvalList)
            {
                if (string.IsNullOrWhiteSpace(ev.Op)) continue;

                foreach (var m in p.MerList)
                {
                    if (!string.Equals(m.StKar, ev.StKar, StringComparison.OrdinalIgnoreCase))
                        continue;

                    // Delphi rules:
                    // - tip 01: only failed rows (Eval == 'R')
                    // - tip 02: all rows
                    if ((m.Tip == "01" && string.Equals(m.Eval, "R", StringComparison.OrdinalIgnoreCase)) ||
                        (m.Tip == "02"))
                    {
                        m.Opom = ev.Op;
                    }
                }
            }
            Cursor.Current = Cursors.WaitCursor;
            try
            {
                // Map ZacetnaForm payload -> DTOs used by SapService.Zapis
                var karList = p.MerList.Select(m => new global::SapSpcWinForms.SapKarMer
                {
                    stkar = m.StKar,
                    imeKar = m.ImeKar,
                    stMer = m.StMer,
                    skupi = m.Skupi,
                    tip = m.Tip,
                    merit = m.Merit,
                    eval = m.Eval,
                    opom = m.Opom,
                    stevnp = m.StevNp,
                    stevilVz = m.StevilVz
                }).ToList();

                var evalList = p.EvalList.Select(x => new global::SapSpcWinForms.SapEvaluac
                {
                    stkar = x.StKar,
                    imeKar = x.ImeKar,
                    ev = x.Ev,
                    st = x.St,
                    op = x.Op
                }).ToList();

                var sap = new global::SapSpcWinForms.SapService();

                // odl/orod: keep empty for now (same as your current payload)
                var (ok, msg) = sap.Zapis(
                    srz: p.Sarza,
                    opr: p.Operacija,
                    nazivp: p.NazivKT,
                    merl: p.Merilec,
                    odl: "A",
                    orod: p.Orodje ?? "",
                    dd: p.Cas,
                    karlist: karList,
                    evalList: evalList
                );

                var sapCheckText =
                    $"SAP {(ok ? "OK" : "NAPAKA")}\n\n" +
                    $"Kontrolna ara (INSPLOT) za preverjanje v SAP:\n{p.Sarza}\n\n" +
                    $"Operacija: {p.Operacija}\n" +
                    $"Merilno mesto: {_currentMestoOpis}\n" +
                    $"Merilec: {p.Merilec}\n\n" +
                    $"{(string.IsNullOrWhiteSpace(msg) ? "" : ("SAP sporoèilo: " + msg + "\n\n"))}" +
                    $"Preveri v SAP: QA03 (ali QA02) -> odpri kontrolno aro -> pojdi na 'Rezultati / Zapis meritev'.";

                try { Clipboard.SetText(p.Sarza ?? ""); } catch { /* ignore */ }

                MessageBox.Show(
                    sapCheckText,
                    "SAP zapis",
                    MessageBoxButtons.OK,
                    ok ? MessageBoxIcon.Information : MessageBoxIcon.Error
                );
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "SAP zapis - exception", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                Cursor.Current = Cursors.Default;
            }
        }

        // ===== SAP DTOs + builder =====
        private bool TryBuildSapPayload(out SapWritePayload payload, out string error)
        {
            payload = null;
            error = null;

            if (!_currentStPost.HasValue) { error = "Ni merilnega mesta."; return false; }
            if (string.IsNullOrWhiteSpace(_currentKodaClean)) { error = "Ni izbrane kode."; return false; }
            if (string.IsNullOrWhiteSpace(_currentSarza)) { error = "Ni sare (konsar)."; return false; }

            // --- Delphi: opr from plan; default 0010 ---
            string opr = "0010";
            // you already carry operacija in grids; prefer it
            var opAny = KaraktiGrid.Rows.Cast<DataGridViewRow>()
                .Select(r => (r.Cells["Operacija"].Value?.ToString() ?? "").Trim())
                .FirstOrDefault(s => !string.IsNullOrWhiteSpace(s));
            if (!string.IsNullOrWhiteSpace(opAny)) opr = AppUtils.PadOp(opAny);

            // --- Delphi: ime kontrolne tocke; fallback machine name ---
            string imekt = StrojnaDbRepository.GetImeKTFromPostajeOrEmpty(_currentStPost.Value);
            string nazivp = !string.IsNullOrWhiteSpace(imekt) ? imekt : (_selectedMachineName ?? "");

            // --- Delphi: merilec from label12.Caption ---
            string merl = (_operatorValueLabel?.Text ?? "").Trim();
            if (string.IsNullOrWhiteSpace(merl)) merl = "(ni prijave)";

            var merList = new List<SapMer>();
            var evalList = new List<SapEval>();

            int stMerCounter = 0;

            // count Vzorec columns (stcl)
            var vzCols = KaraktiGrid.Columns.Cast<DataGridViewColumn>()
                .Where(c => c.Name.StartsWith("Vzorec", StringComparison.OrdinalIgnoreCase))
                .OrderBy(c => c.DisplayIndex)
                .ToList();
            int stcl = vzCols.Count;

            // -------- tip=01 (variabilne) --------
            foreach (DataGridViewRow row in KaraktiGrid.Rows)
            {
                if (row.IsNewRow) continue;

                string stkar = (row.Cells["Pozicija"].Value?.ToString() ?? "").Trim();
                string imekar = (row.Cells["Naziv"].Value?.ToString() ?? "").Trim();
                if (string.IsNullOrWhiteSpace(stkar)) continue; // defensive

                var px = new SapEval { StKar = stkar, ImeKar = imekar, Ev = "A", St = 0, Op = "" };

                // tolerance limits from row
                double sp = AppUtils.ParseDoubleLoose(row.Cells["SpMeja"].Value);
                double zg = AppUtils.ParseDoubleLoose(row.Cells["ZgMeja"].Value);

                SapMer lastForChar = null;

                for (int kk = 1; kk <= stcl; kk++)
                {
                    var col = vzCols[kk - 1];
                    string ss = (row.Cells[col.Name].Value?.ToString() ?? "").Trim();

                    if (!AppUtils.TryParseRequiredDouble(ss, out double xx))
                    {
                        // Delphi: focus offending cell + message
                        KaraktiGrid.CurrentCell = row.Cells[col.Name];
                        KaraktiGrid.Focus();
                        error = "Podatki o meritvah niso vredu (variabilne).";
                        return false;
                    }

                    bool okTol = (xx - sp > -0.0001) && (zg - xx > -0.0001);
                    string ev = okTol ? "A" : "R";
                    if (ev == "R") { px.Ev = "R"; px.St++; }

                    stMerCounter++;

                    var pv = new SapMer
                    {
                        StevNp = 0,
                        StKar = stkar,
                        ImeKar = imekar,
                        StMer = stMerCounter,
                        Skupi = "X",
                        Tip = "01",
                        StevilVz = kk,
                        Eval = ev,
                        Merit = ss,   // keep raw like Delphi karakti.Cells[]
                        Opom = ""
                    };

                    merList.Add(pv);
                    lastForChar = pv;
                }

                // Delphi: pv^.stevnp := 1  (mark end-of-sample / end-of-char)
                if (lastForChar != null) lastForChar.StevNp = 1;

                evalList.Add(px);
            }

            // -------- tip=02 (atributivne) --------
            // Delphi loops kk:=1..stvp (max stvz for tip=2). We can derive same from attriGrid "StVzor".
            int stvp = attriGrid.Rows.Cast<DataGridViewRow>()
                .Where(r => !r.IsNewRow)
                .Select(r => AppUtils.ToIntSafe(r.Cells["StVzor"].Value))
                .DefaultIfEmpty(0)
                .Max();
            if (stvp <= 0) stvp = 1;

            foreach (DataGridViewRow row in attriGrid.Rows)
            {
                if (row.IsNewRow) continue;

                string stkar = (row.Cells["Pozicija"].Value?.ToString() ?? "").Trim();
                string imekar = (row.Cells["Naziv"].Value?.ToString() ?? "").Trim();
                if (string.IsNullOrWhiteSpace(stkar)) continue;

                string slbTxt = (row.Cells["StSlabih"].Value?.ToString() ?? "").Trim();
                if (string.IsNullOrWhiteSpace(slbTxt))
                {
                    attriGrid.CurrentCell = row.Cells["StSlabih"];
                    attriGrid.Focus();
                    error = "Podatki o atrib. karakteristikah niso vpisani.";
                    return false;
                }
                if (!int.TryParse(slbTxt, out int slb)) slb = 0;

                var px = new SapEval
                {
                    StKar = stkar,
                    ImeKar = imekar,
                    Ev = (slb == 0) ? "A" : "R",
                    St = slb,
                    Op = ""
                };

                for (int kk = 1; kk <= stvp; kk++)
                {
                    stMerCounter++;

                    merList.Add(new SapMer
                    {
                        StKar = stkar,
                        ImeKar = imekar,
                        StevilVz = kk,
                        StMer = stMerCounter,
                        Skupi = "",
                        Tip = "02",
                        StevNp = slb,                 // Delphi: stevnp = st. slabih
                        Eval = (slb > 0) ? "R" : "A", // Delphi logic
                        Merit = "",                   // attribute has no numeric merit
                        Opom = ""
                    });
                }

                evalList.Add(px);
            }

            payload = new SapWritePayload
            {
                Koda = _currentKodaClean,
                Sarza = _currentSarza,
                Operacija = opr,
                NazivKT = nazivp,
                Merilec = merl,
                Orodje = _selectedOrodje ?? "", // Use DodIzbor selection
                Cas = DateTime.Now,
                MerList = merList,
                EvalList = evalList
            };

            return true;
        }

        private void InitializeDodIzborControls()
        {
            // Label for DodIzbor (Label14 equivalent)
            _dodIzborLabel = new Label
            {
                Name = "dodIzborLabel",
                Text = "Dodatna opredelitev:",
                AutoSize = true,
                Visible = false,  // Hidden by default like Delphi
                Font = new Font("Segoe UI", 9F, FontStyle.Bold),
                ForeColor = Color.FromArgb(0, 64, 128)
            };

            // ListBox for DodIzbor
            _dodIzborListBox = new ListBox
            {
                Name = "dodIzborListBox",
                Visible = false,  // Hidden by default
                Height = 80,
                Width = 200,
                IntegralHeight = false,  // Allow partial items like Delphi
                SelectionMode = SelectionMode.One
            };

            _dodIzborListBox.SelectedIndexChanged += DodIzborListBox_SelectedIndexChanged;

            // Add to your layout - place them near codesList or in the right panel
            // Option A: Add to topPanel near codesList
            topPanel.Controls.Add(_dodIzborLabel);
            topPanel.Controls.Add(_dodIzborListBox);
        }

        private void DodIzborListBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Placeholder for event handler logic
            if (_dodIzborListBox.SelectedItem != null)
                _selectedOrodje = _dodIzborListBox.SelectedItem.ToString();
            else
                _selectedOrodje = "";
        }

        private void UpdateDodIzborVisibility(string kd)
        {
            _dodIzborListBox.Items.Clear();
            _selectedOrodje = "";
            _dodIzborListBox.ClearSelected();

            var items = StrojnaDbRepository.GetDodatneOpredelitveNazivi(kd);

            if (items.Count > 0)
            {
                _dodIzborLabel.Visible = true;
                _dodIzborListBox.Visible = true;

                foreach (var x in items)
                    if (!string.IsNullOrWhiteSpace(x))
                        _dodIzborListBox.Items.Add(x);
            }
            else
            {
                _dodIzborLabel.Visible = false;
                _dodIzborListBox.Visible = false;
            }
        }

        private bool ValidateAllCharacteristicsEntered(out string error)
        {
            error = null;

            // ---- Variable characteristics (Vzorec columns) ----
            var vzCols = KaraktiGrid.Columns
                .Cast<DataGridViewColumn>()
                .Where(c => c.Name.StartsWith("Vzorec", StringComparison.OrdinalIgnoreCase))
                .ToList();

            foreach (DataGridViewRow row in KaraktiGrid.Rows)
            {
                if (row.IsNewRow) continue;

                foreach (var col in vzCols)
                {
                    var txt = (row.Cells[col.Name].Value?.ToString() ?? "").Trim();

                    if (!double.TryParse(txt.Replace('.', ','), out _))
                    {
                        KaraktiGrid.CurrentCell = row.Cells[col.Name];
                        KaraktiGrid.Focus();
                        error = "Podatki o meritvah niso vredu (vse meritve morajo biti vpisane).";
                        return false;
                    }
                }
            }

            // ---- Attribute characteristics ----
            foreach (DataGridViewRow row in attriGrid.Rows)
            {
                if (row.IsNewRow) continue;

                var txt = (row.Cells["StSlabih"].Value?.ToString() ?? "").Trim();

                if (string.IsNullOrWhiteSpace(txt))
                {
                    attriGrid.CurrentCell = row.Cells["StSlabih"];
                    attriGrid.Focus();
                    error = "Podatki o atrib. karakteristikah niso vpisani.";
                    return false;
                }
            }

            return true;
        }
    }
}