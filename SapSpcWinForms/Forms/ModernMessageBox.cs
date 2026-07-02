using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Windows.Forms;

namespace SapSpcWinForms
{
    /// <summary>
    /// Lightweight, modern-styled message dialog. Borderless rounded card with a
    /// drop shadow, a red warning glyph, a bold title and a wrapped message.
    /// </summary>
    public sealed class ModernMessageBox : Form
    {
        private static readonly Color WarnRed = Color.FromArgb(214, 45, 45);
        private static readonly Color AccentBlue = Color.FromArgb(0, 96, 160);
        private static readonly Color TitleColor = Color.FromArgb(28, 40, 54);
        private static readonly Color BodyColor = Color.FromArgb(78, 92, 108);
        private static readonly Color BorderColor = Color.FromArgb(214, 224, 234);

        private const int CardRadius = 16;
        private const int Pad = 26;
        private const int IconSize = 46;
        private const int CardWidth = 500;

        private readonly string _title;
        private readonly string _message;
        private readonly Rectangle _iconRect;
        private readonly Rectangle _titleRect;
        private readonly Rectangle _messageRect;

        private ModernMessageBox(string title, string message)
        {
            _title = title ?? string.Empty;
            _message = message ?? string.Empty;

            FormBorderStyle = FormBorderStyle.None;
            StartPosition = FormStartPosition.CenterParent;
            ShowInTaskbar = false;
            MinimizeBox = false;
            MaximizeBox = false;
            AutoScaleMode = AutoScaleMode.None;
            BackColor = Color.White;
            DoubleBuffered = true;
            KeyPreview = true;

            int textLeft = Pad + IconSize + 18;
            int textWidth = CardWidth - textLeft - Pad;

            using (var g = CreateGraphics())
            using (var titleFont = new Font("Segoe UI", 15F, FontStyle.Bold))
            using (var bodyFont = new Font("Segoe UI", 10.5F, FontStyle.Regular))
            {
                var titleSize = TextRenderer.MeasureText(g, _title, titleFont,
                    new Size(textWidth, int.MaxValue), TextFormatFlags.WordBreak);
                var msgSize = TextRenderer.MeasureText(g, _message, bodyFont,
                    new Size(textWidth, int.MaxValue), TextFormatFlags.WordBreak);

                _iconRect = new Rectangle(Pad, Pad, IconSize, IconSize);
                _titleRect = new Rectangle(textLeft, Pad, textWidth, titleSize.Height);
                _messageRect = new Rectangle(textLeft, _titleRect.Bottom + 12, textWidth, msgSize.Height);
            }

            int contentBottom = Math.Max(_iconRect.Bottom, _messageRect.Bottom);

            var okButton = new Button
            {
                Text = "V redu",
                DialogResult = DialogResult.OK,
                FlatStyle = FlatStyle.Flat,
                BackColor = AccentBlue,
                ForeColor = Color.White,
                Font = new Font("Segoe UI", 10.5F, FontStyle.Bold),
                Size = new Size(120, 42),
                Cursor = Cursors.Hand,
                UseVisualStyleBackColor = false
            };
            okButton.FlatAppearance.BorderSize = 0;
            okButton.FlatAppearance.MouseOverBackColor = Color.FromArgb(0, 114, 188);
            okButton.FlatAppearance.MouseDownBackColor = Color.FromArgb(0, 78, 131);

            int cardHeight = contentBottom + 24 + okButton.Height + Pad;
            ClientSize = new Size(CardWidth, cardHeight);

            okButton.Location = new Point(CardWidth - Pad - okButton.Width, cardHeight - Pad - okButton.Height);
            Controls.Add(okButton);

            AcceptButton = okButton;
            CancelButton = okButton;

            // Drag the borderless window by clicking anywhere on the card.
            MouseDown += (s, e) => { if (e.Button == MouseButtons.Left) DragWindow(); };
        }

        protected override CreateParams CreateParams
        {
            get
            {
                var cp = base.CreateParams;
                cp.ClassStyle |= 0x00020000; // CS_DROPSHADOW
                return cp;
            }
        }

        protected override void OnResize(EventArgs e)
        {
            base.OnResize(e);
            using (var path = RoundedRect(new Rectangle(0, 0, Width, Height), CardRadius))
                Region = new Region(path);
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            base.OnPaint(e);
            var g = e.Graphics;
            g.SmoothingMode = SmoothingMode.AntiAlias;
            g.TextRenderingHint = System.Drawing.Text.TextRenderingHint.ClearTypeGridFit;

            // Card border
            var border = new Rectangle(0, 0, Width - 1, Height - 1);
            using (var path = RoundedRect(border, CardRadius))
            using (var pen = new Pen(BorderColor, 1f))
                g.DrawPath(pen, path);

            DrawWarningIcon(g, _iconRect);

            using (var titleFont = new Font("Segoe UI", 15F, FontStyle.Bold))
                TextRenderer.DrawText(g, _title, titleFont, _titleRect, TitleColor,
                    TextFormatFlags.WordBreak | TextFormatFlags.NoPadding);

            using (var bodyFont = new Font("Segoe UI", 10.5F, FontStyle.Regular))
                TextRenderer.DrawText(g, _message, bodyFont, _messageRect, BodyColor,
                    TextFormatFlags.WordBreak | TextFormatFlags.NoPadding);
        }

        private static void DrawWarningIcon(Graphics g, Rectangle r)
        {
            // Rounded red triangle with a white exclamation mark.
            float w = r.Width, h = r.Height;
            var top = new PointF(r.Left + w / 2f, r.Top + 1f);
            var left = new PointF(r.Left + 1f, r.Bottom - 2f);
            var right = new PointF(r.Right - 1f, r.Bottom - 2f);

            using (var tri = new GraphicsPath())
            {
                tri.AddPolygon(new[] { top, right, left });
                using (var brush = new SolidBrush(WarnRed))
                    g.FillPath(brush, tri);
                using (var pen = new Pen(WarnRed, 3f) { LineJoin = LineJoin.Round })
                    g.DrawPath(pen, tri);
            }

            // Exclamation mark
            float cx = r.Left + w / 2f;
            using (var white = new SolidBrush(Color.White))
            {
                float barW = Math.Max(3f, w * 0.09f);
                float barTop = r.Top + h * 0.40f;
                float barH = h * 0.28f;
                g.FillRectangle(white, cx - barW / 2f, barTop, barW, barH);
                float dot = barW * 1.15f;
                g.FillEllipse(white, cx - dot / 2f, barTop + barH + h * 0.06f, dot, dot);
            }
        }

        private static GraphicsPath RoundedRect(Rectangle r, int radius)
        {
            int d = radius * 2;
            var path = new GraphicsPath();
            if (d <= 0 || r.Width <= 0 || r.Height <= 0)
            {
                path.AddRectangle(r);
                return path;
            }
            path.AddArc(r.X, r.Y, d, d, 180, 90);
            path.AddArc(r.Right - d, r.Y, d, d, 270, 90);
            path.AddArc(r.Right - d, r.Bottom - d, d, d, 0, 90);
            path.AddArc(r.X, r.Bottom - d, d, d, 90, 90);
            path.CloseFigure();
            return path;
        }

        // Native drag for borderless form.
        private void DragWindow()
        {
            ReleaseCapture();
            SendMessage(Handle, 0xA1 /*WM_NCLBUTTONDOWN*/, 0x2 /*HTCAPTION*/, 0);
        }

        [System.Runtime.InteropServices.DllImport("user32.dll")]
        private static extern bool ReleaseCapture();

        [System.Runtime.InteropServices.DllImport("user32.dll")]
        private static extern IntPtr SendMessage(IntPtr hWnd, int msg, int wParam, int lParam);

        public static void ShowWarning(IWin32Window owner, string title, string message)
        {
            using (var dlg = new ModernMessageBox(title, message))
                dlg.ShowDialog(owner);
        }
    }
}
