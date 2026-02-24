using System;
using System.Drawing;
using System.Windows.Forms;

namespace SapSpcWinForms
{
    public sealed class VpisStevDialog : Form
    {
        private readonly Label _label;
        private readonly NumericUpDown _num;
        private readonly Button _ok;

        private VpisStevDialog(string title, string label, int value, int min, int max)
        {
            Text = title;
            FormBorderStyle = FormBorderStyle.FixedToolWindow;
            MaximizeBox = false;
            MinimizeBox = false;
            StartPosition = FormStartPosition.CenterParent;
            ClientSize = new Size(340, 130);

            _label = new Label
            {
                AutoSize = true,
                Text = label,
                Location = new Point(12, 14)
            };

            _num = new NumericUpDown
            {
                Location = new Point(12, 42),
                Width = 140,
                Minimum = min,
                Maximum = max,
                Value = Math.Max(min, Math.Min(max, value))
            };

            _ok = new Button
            {
                Text = "V redu",
                DialogResult = DialogResult.OK,
                Location = new Point(240, 78),
                Width = 80
            };

            Controls.Add(_label);
            Controls.Add(_num);
            Controls.Add(_ok);

            AcceptButton = _ok;
        }

        // Delphi-like: returns the number even if user closes the window (ignores DialogResult)
        public static int Vpis(IWin32Window owner, string nas, string lab, int vl, int min, int max)
        {
            using (var f = new VpisStevDialog(nas, lab, vl, min, max))
            {
                f.ShowDialog(owner);
                return (int)f._num.Value;
            }
        }
    }
}
