using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;
using SapSpcWinForms.Services;

namespace SapSpcWinForms.Forms
{
    public sealed partial class VpisOpombeForm : Form
    {
        private readonly DataGridView _grid = new DataGridView();
        private readonly Button _btnIzberi = new Button();
        private readonly Button _btnIzberiVsem = new Button();
        private readonly Button _btnOk = new Button();
        private readonly Button _btnCancel = new Button();
        private readonly int _idpost;

        private List<SapEval> _rows; // only Ev == "R"

        public VpisOpombeForm(int idpost)
        {
            _idpost = idpost;

            Text = TranslationService.Translate("VpisOpombeForm.Text");
            StartPosition = FormStartPosition.CenterParent;
            Width = 900;
            Height = 500;

            _grid.Dock = DockStyle.Fill;
            _grid.AllowUserToAddRows = false;
            _grid.RowHeadersVisible = false;
            _grid.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            _grid.MultiSelect = false;
            _grid.AutoGenerateColumns = false;

            _grid.Columns.Add(new DataGridViewTextBoxColumn { Name = "StKar", HeaderText = TranslationService.Translate("VpisOpombeForm.Col.StKar"), DataPropertyName = "StKar", Width = 90, ReadOnly = true });
            _grid.Columns.Add(new DataGridViewTextBoxColumn { Name = "ImeKar", HeaderText = TranslationService.Translate("VpisOpombeForm.Col.ImeKar"), DataPropertyName = "ImeKar", Width = 420, ReadOnly = true });
            _grid.Columns.Add(new DataGridViewTextBoxColumn { Name = "Op", HeaderText = TranslationService.Translate("VpisOpombeForm.Col.Op"), DataPropertyName = "Op", Width = 320 });

            var bottom = new FlowLayoutPanel
            {
                Dock = DockStyle.Bottom,
                Height = 48,
                FlowDirection = FlowDirection.LeftToRight,
                Padding = new Padding(10),
                WrapContents = false
            };

            _btnIzberi.Text = TranslationService.Translate("VpisOpombeForm.PickRow");
            _btnIzberi.Click += (s, e) => PickForCurrentRow();

            _btnIzberiVsem.Text = TranslationService.Translate("VpisOpombeForm.PickAll");
            _btnIzberiVsem.Click += (s, e) => PickForAllRows();

            _btnOk.Text = TranslationService.Translate("Common.Ok");
            _btnOk.DialogResult = DialogResult.OK;

            _btnCancel.Text = TranslationService.Translate("Common.Cancel");
            _btnCancel.DialogResult = DialogResult.Cancel;

            bottom.Controls.AddRange(new Control[] { _btnIzberi, _btnIzberiVsem, _btnOk, _btnCancel });

            Controls.Add(_grid);
            Controls.Add(bottom);

            AcceptButton = _btnOk;
            CancelButton = _btnCancel;
        }

        public static bool Vpis(IWin32Window owner, List<SapEval> evalList, int idpost)
        {
            var failed = (evalList ?? new List<SapEval>())
                .Where(x => string.Equals(x.Ev, "R", StringComparison.OrdinalIgnoreCase))
                .ToList();

            if (failed.Count == 0)
                return true;

            using (var f = new VpisOpombeForm(idpost))
            {
                f._rows = failed;
                f._grid.DataSource = new BindingSource { DataSource = f._rows };
                return f.ShowDialog(owner) == DialogResult.OK;
            }
        }

        private void PickForCurrentRow()
        {
            if (_grid.CurrentRow == null) return;

            var row = _grid.CurrentRow.DataBoundItem as SapEval;
            if (row == null) return;

            var izb = VpisUkrepDialog.Izbor(this, "", _idpost);
            if (!string.IsNullOrWhiteSpace(izb))
            {
                row.Op = izb;
                _grid.Refresh();
            }
        }

        private void PickForAllRows()
        {
            var izb = VpisUkrepDialog.Izbor(this, "", _idpost);
            if (string.IsNullOrWhiteSpace(izb)) return;

            foreach (var r in _rows)
                r.Op = izb;

            _grid.Refresh();
        }
    }
}
