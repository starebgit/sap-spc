using System;
using System.Drawing;
using System.Windows.Forms;

namespace SapSpcWinForms.Utils
{
    internal static class UiTheme
    {
        private static readonly Color AccentColor = Color.FromArgb(0, 96, 160);
        private static readonly Color DisabledBackColor = Color.FromArgb(188, 196, 204);
        private static readonly Color DisabledForeColor = Color.FromArgb(90, 98, 106);
        private static readonly Color FormBackColor = Color.FromArgb(236, 243, 248);
        private static readonly Color PanelBackColor = Color.FromArgb(241, 247, 252);

        public static void ApplyFormTheme(Form form)
        {
            if (form == null)
                return;

            form.BackColor = FormBackColor;
            ApplyToControls(form.Controls);
            form.ControlAdded -= Form_ControlAdded;
            form.ControlAdded += Form_ControlAdded;
        }

        private static void Form_ControlAdded(object sender, ControlEventArgs e)
        {
            if (e?.Control == null)
                return;

            ApplyToControl(e.Control);
            ApplyToControls(e.Control.Controls);
        }

        private static void ApplyToControls(Control.ControlCollection controls)
        {
            if (controls == null)
                return;

            foreach (Control control in controls)
            {
                ApplyToControl(control);
                ApplyToControls(control.Controls);
            }
        }

        private static void ApplyToControl(Control control)
        {
            if (control is Button button)
            {
                StyleButton(button);
                return;
            }

            if (control is Panel || control is TableLayoutPanel || control is FlowLayoutPanel)
            {
                if (control.BackColor == Color.Empty || control.BackColor == SystemColors.Control || control.BackColor == Color.White)
                    control.BackColor = PanelBackColor;
            }
        }

        public static void StyleButton(Button button)
        {
            if (button == null)
                return;

            button.FlatStyle = FlatStyle.Flat;
            button.FlatAppearance.BorderSize = 0;
            button.Font = new Font("Segoe UI", 9F, FontStyle.Bold);
            button.Padding = new Padding(6);
            button.Height = Math.Max(button.Height, 36);
            button.UseVisualStyleBackColor = false;

            button.EnabledChanged -= Button_EnabledChanged;
            button.EnabledChanged += Button_EnabledChanged;
            ApplyButtonState(button);
        }

        private static void Button_EnabledChanged(object sender, EventArgs e)
        {
            if (sender is Button button)
                ApplyButtonState(button);
        }

        private static void ApplyButtonState(Button button)
        {
            if (button.Enabled)
            {
                button.BackColor = AccentColor;
                button.ForeColor = Color.White;
                button.Cursor = Cursors.Hand;
            }
            else
            {
                button.BackColor = DisabledBackColor;
                button.ForeColor = DisabledForeColor;
                button.Cursor = Cursors.Default;
            }
        }
    }
}
