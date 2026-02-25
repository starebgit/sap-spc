using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;
using SapSpcWinForms.Data;
using SapSpcWinForms.Services;

namespace SapSpcWinForms
{
    public sealed partial class VpisUkrepDialog : Form
    {
        private readonly ListBox _list = new ListBox();
        private readonly TextBox _txtOther = new TextBox();
        private readonly Label _lblOther = new Label();
        private readonly Label _lblImeKar = new Label();
        private readonly Button _btnOk = new Button();
        private readonly Button _btnCancel = new Button();

        private static readonly string OtherItemText = TranslationService.Translate("VpisUkrepDialog.Other");

        private VpisUkrepDialog(string imekar, IEnumerable<string> ukrepi)
        {
            Text = TranslationService.Translate("VpisUkrepDialog.Text");
            StartPosition = FormStartPosition.CenterParent;
            Width = 520;
            Height = 420;

            _lblImeKar.Dock = DockStyle.Top;
            _lblImeKar.Height = 28;
            _lblImeKar.Padding = new Padding(10, 8, 10, 0);
            _lblImeKar.Text = imekar ?? "";

            _list.Dock = DockStyle.Fill;
            _list.IntegralHeight = false;
            _list.SelectionMode = SelectionMode.One;
            _list.SelectedIndexChanged += (_, __) => OnSelectionChanged();

            var items = (ukrepi ?? Enumerable.Empty<string>()).ToList();
            foreach (var it in items) _list.Items.Add(it);
            _list.Items.Add(OtherItemText);

            var bottom = new Panel { Dock = DockStyle.Bottom, Height = 86, Padding = new Padding(10) };

            _lblOther.Text = TranslationService.Translate("VpisUkrepDialog.OtherLabel");
            _lblOther.Left = 10;
            _lblOther.Top = 10;
            _lblOther.Width = 60;
            _lblOther.Visible = false;

            _txtOther.Left = 80;
            _txtOther.Top = 8;
            _txtOther.Width = 400;
            _txtOther.Visible = false;
            _txtOther.TextChanged += (_, __) => _btnOk.Enabled = true;

            _btnOk.Text = TranslationService.Translate("Common.Ok");
            _btnOk.Left = 290;
            _btnOk.Top = 40;
            _btnOk.Width = 90;
            _btnOk.Enabled = false;
            _btnOk.DialogResult = DialogResult.OK;

            _btnCancel.Text = TranslationService.Translate("Common.Cancel");
            _btnCancel.Left = 390;
            _btnCancel.Top = 40;
            _btnCancel.Width = 90;
            _btnCancel.DialogResult = DialogResult.Cancel;

            bottom.Controls.AddRange(new Control[] { _lblOther, _txtOther, _btnOk, _btnCancel });

            Controls.Add(_list);
            Controls.Add(bottom);
            Controls.Add(_lblImeKar);

            AcceptButton = _btnOk;
            CancelButton = _btnCancel;
        }

        private void OnSelectionChanged()
        {
            var isOther = string.Equals(_list.SelectedItem as string, OtherItemText, StringComparison.OrdinalIgnoreCase);

            _lblOther.Visible = isOther;
            _txtOther.Visible = isOther;

            if (isOther)
            {
                _txtOther.Text = "";
                _btnOk.Enabled = false; // Delphi: enable only after Edit1Change
                _txtOther.Focus();
            }
            else
            {
                _btnOk.Enabled = _list.SelectedIndex >= 0; // Delphi: button enabled after selection
            }
        }

        private string GetResult()
        {
            if (DialogResult != DialogResult.OK) return "";

            var sel = _list.SelectedItem as string;
            if (string.IsNullOrWhiteSpace(sel)) return "";

            if (string.Equals(sel, OtherItemText, StringComparison.OrdinalIgnoreCase))
                return _txtOther.Text ?? "";

            return sel;
        }

        // This matches your calls: VpisUkrepDialog.Izbor(this, "")
        public static string Izbor(IWin32Window owner, string imekar, int idpost)
        {
            var ukrepi = idpost > 0
                ? StrojnaDbRepository.GetUkrepiForPost(idpost)
                : new List<string>();

            using (var f = new VpisUkrepDialog(imekar, ukrepi))
                return f.ShowDialog(owner) == DialogResult.OK ? f.GetResult() : "";
        }
    }
}