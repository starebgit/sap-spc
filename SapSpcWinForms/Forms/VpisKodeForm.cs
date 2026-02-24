using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;

namespace SapSpcWinForms
{
    public sealed class VpisKodeForm : Form
    {
        private readonly Func<string, bool, List<string>> _loadSarze;
        private readonly Func<string, string, int, int, int> _insertKonsar;
        private readonly Action<int, string> _ensureKonplan;
        private readonly Action<int> _onAdded;

        private readonly TextBox _txtKoda = new TextBox();
        private readonly ListBox _listSarze = new ListBox();
        private readonly TextBox _txtFrk = new TextBox();
        private readonly TextBox _txtTrj = new TextBox();
        private readonly CheckBox _chkPreveri = new CheckBox();

        private readonly Button _btnDodaj = new Button();
        private readonly Button _btnZapri = new Button();

        public VpisKodeForm(
            string presetKoda,
            Func<string, bool, List<string>> loadSarze,
            Func<string, string, int, int, int> insertKonsar,
            Action<int, string> ensureKonplan,
            Action<int> onAdded)
        {
            _loadSarze = loadSarze;
            _insertKonsar = insertKonsar;
            _ensureKonplan = ensureKonplan;
            _onAdded = onAdded;

            Text = "Vpis kode";
            StartPosition = FormStartPosition.CenterParent;
            FormBorderStyle = FormBorderStyle.FixedDialog;
            MaximizeBox = false;
            MinimizeBox = false;
            ShowInTaskbar = false;
            ClientSize = new Size(520, 360);

            BuildUi();

            _chkPreveri.Checked = true;           // Delphi: checkbox1.checked := true
            _txtFrk.Text = "120";                 // Delphi defaults
            _txtTrj.Text = "15";
            _txtKoda.Text = presetKoda ?? "";

            if (!string.IsNullOrWhiteSpace(_txtKoda.Text))
                RefreshSarze();
        }

        private void BuildUi()
        {
            var lblKoda = new Label { Left = 12, Top = 14, AutoSize = true, Text = "Koda:" };
            _txtKoda.SetBounds(90, 10, 170, 24);
            _txtKoda.Leave += (_, __) => RefreshSarze();

            _chkPreveri.SetBounds(280, 12, 220, 24);
            _chkPreveri.AutoSize = true;
            _chkPreveri.Text = "Preveri / filtriraj (SAP)";
            _chkPreveri.CheckedChanged += (_, __) => RefreshSarze();

            var lblSarze = new Label { Left = 12, Top = 52, AutoSize = true, Text = "Kontrolne šarže:" };
            _listSarze.SetBounds(12, 74, 488, 170);

            var lblFrk = new Label { Left = 12, Top = 260, AutoSize = true, Text = "Frekvenca:" };
            _txtFrk.SetBounds(90, 256, 80, 24);

            var lblTrj = new Label { Left = 190, Top = 260, AutoSize = true, Text = "Èas:" };
            _txtTrj.SetBounds(230, 256, 80, 24);

            _btnDodaj.Text = "Dodaj";
            _btnDodaj.SetBounds(320, 302, 80, 30);
            _btnDodaj.Click += (_, __) => Dodaj();

            _btnZapri.Text = "Zapri";
            _btnZapri.SetBounds(420, 302, 80, 30);
            _btnZapri.Click += (_, __) => Close();

            Controls.AddRange(new Control[]
            {
                lblKoda, _txtKoda, _chkPreveri,
                lblSarze, _listSarze,
                lblFrk, _txtFrk, lblTrj, _txtTrj,
                _btnDodaj, _btnZapri
            });
        }

        private void RefreshSarze()
        {
            _listSarze.Items.Clear();

            var kd = (_txtKoda.Text ?? "").Trim();
            if (string.IsNullOrWhiteSpace(kd)) return;

            List<string> sarze;
            try
            {
                sarze = _loadSarze(kd, _chkPreveri.Checked) ?? new List<string>();
            }
            catch (Exception ex)
            {
                MessageBox.Show(this, "Napaka pri branju šarž iz SAP:\n" + ex.Message, "SAP",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            foreach (var s in sarze)
                _listSarze.Items.Add(s);
        }

        private void Dodaj()
        {
            var kd = (_txtKoda.Text ?? "").Trim();
            if (string.IsNullOrWhiteSpace(kd)) return;

            if (_listSarze.SelectedIndex < 0)
            {
                MessageBox.Show(this, "Izberi šaržo.", "Vpis",
                    MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }

            var srz = _listSarze.SelectedItem.ToString();

            int frk = int.TryParse((_txtFrk.Text ?? "").Trim(), out var a) ? a : 120;
            int trj = int.TryParse((_txtTrj.Text ?? "").Trim(), out var b) ? b : 15;

            try
            {
                var newIdent = _insertKonsar(kd, srz, frk, trj);
                _ensureKonplan(newIdent, srz);
                _onAdded?.Invoke(newIdent);

                // Delphi behavior: clear edit1 + list
                _txtKoda.Text = "";
                _listSarze.Items.Clear();
                _txtKoda.Focus();
            }
            catch (Exception ex)
            {
                MessageBox.Show(this, "Napaka pri zapisu:\n" + ex.Message, "Vpis",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}
