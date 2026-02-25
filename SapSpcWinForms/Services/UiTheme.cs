using System;
using System.Collections.Generic;
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
        private static readonly Dictionary<Button, ButtonThemeState> ButtonStates = new Dictionary<Button, ButtonThemeState>();

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

            CaptureButtonState(button);

            button.FlatStyle = FlatStyle.Flat;
            button.FlatAppearance.BorderSize = 0;
            button.Font = new Font("Segoe UI", 9F, FontStyle.Bold);
            button.Padding = new Padding(4, 2, 4, 2);
            var minimumTextHeight = TextRenderer.MeasureText((button.Text ?? string.Empty) + " ", button.Font).Height + button.Padding.Vertical + 6;
            button.Height = Math.Max(button.Height, Math.Max(30, minimumTextHeight));
            button.UseVisualStyleBackColor = false;
            button.TextAlign = ContentAlignment.MiddleCenter;
            button.TextImageRelation = TextImageRelation.ImageBeforeText;
            button.AutoEllipsis = true;

            button.EnabledChanged -= Button_EnabledChanged;
            button.EnabledChanged += Button_EnabledChanged;
            button.Disposed -= Button_Disposed;
            button.Disposed += Button_Disposed;

            ApplyButtonState(button);
        }

        private static void CaptureButtonState(Button button)
        {
            var hasCustomBackColor = button.BackColor != Color.Empty && button.BackColor != SystemColors.Control;
            var enabledBackColor = hasCustomBackColor ? button.BackColor : AccentColor;
            var enabledForeColor = button.ForeColor != Color.Empty && button.ForeColor != SystemColors.ControlText
                ? button.ForeColor
                : GetReadableTextColor(enabledBackColor);

            if (ButtonStates.ContainsKey(button))
            {
                ButtonStates[button] = new ButtonThemeState(enabledBackColor, enabledForeColor);
                return;
            }

            ButtonStates.Add(button, new ButtonThemeState(enabledBackColor, enabledForeColor));
        }

        private static void Button_Disposed(object sender, EventArgs e)
        {
            if (sender is Button button)
                ButtonStates.Remove(button);
        }

        private static void Button_EnabledChanged(object sender, EventArgs e)
        {
            if (sender is Button button)
                ApplyButtonState(button);
        }

        private static void ApplyButtonState(Button button)
        {
            if (button == null)
                return;

            if (!ButtonStates.TryGetValue(button, out var state))
            {
                state = new ButtonThemeState(AccentColor, GetReadableTextColor(AccentColor));
                ButtonStates[button] = state;
            }

            if (button.Enabled)
            {
                button.BackColor = state.EnabledBackColor;
                button.ForeColor = state.EnabledForeColor;
                button.Cursor = Cursors.Hand;
            }
            else
            {
                button.BackColor = DisabledBackColor;
                button.ForeColor = DisabledForeColor;
                button.Cursor = Cursors.Default;
            }
        }

        private static Color GetReadableTextColor(Color background)
        {
            var luminance = (0.299 * background.R) + (0.587 * background.G) + (0.114 * background.B);
            return luminance >= 150 ? Color.FromArgb(24, 36, 48) : Color.White;
        }

        private struct ButtonThemeState
        {
            public ButtonThemeState(Color enabledBackColor, Color enabledForeColor)
            {
                EnabledBackColor = enabledBackColor;
                EnabledForeColor = enabledForeColor;
            }

            public Color EnabledBackColor { get; }
            public Color EnabledForeColor { get; }
        }
    }
}
