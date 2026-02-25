using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Linq;
using System.Windows.Forms;

namespace SapSpcWinForms
{
    public sealed class GrafiForm : Form
    {
        public sealed class GrafPoint
        {
            public double Value { get; set; }
            public DateTime When { get; set; }
            public int Vzorec { get; set; }
        }

        public sealed class GrafRequest
        {
            public string Title { get; set; }
            public int StVz { get; set; }     // Delphi stvz
            public double Sr { get; set; }    // predpis
            public double Sp { get; set; }    // spmeja
            public double Zg { get; set; }    // zgmeja
            public double Avr { get; set; }   // average
            public double Std { get; set; }   // std dev
            public List<GrafPoint> Points { get; set; } = new List<GrafPoint>();
        }

        private readonly PictureBox[] _plots = new PictureBox[4];
        private readonly PictureBox _legend = new PictureBox();

        public GrafiForm(List<GrafRequest> graphs)
        {
            Text = "Grafi";
            Width = 1400;
            Height = 900; // reduced height by about 10%
            StartPosition = FormStartPosition.CenterParent;

            var root = new TableLayoutPanel
            {
                Dock = DockStyle.Fill,
                RowCount = 3,
                ColumnCount = 2
            };
            root.RowStyles.Add(new RowStyle(SizeType.Percent, 45));
            root.RowStyles.Add(new RowStyle(SizeType.Percent, 45));
            root.RowStyles.Add(new RowStyle(SizeType.Percent, 10));
            root.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50));
            root.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50));
            Controls.Add(root);

            for (int i = 0; i < 4; i++)
            {
                var pb = new PictureBox
                {
                    Dock = DockStyle.Fill,
                    BackColor = Color.White,
                    BorderStyle = BorderStyle.FixedSingle,
                    SizeMode = PictureBoxSizeMode.Normal
                };
                _plots[i] = pb;
                root.Controls.Add(pb, i % 2, i / 2);
            }

            _legend.Dock = DockStyle.Fill;
            _legend.BackColor = Color.White;
            _legend.BorderStyle = BorderStyle.FixedSingle;
            root.Controls.Add(_legend, 0, 2);
            root.SetColumnSpan(_legend, 2);

            DrawLegend();

            // draw up to 4 graphs
            for (int i = 0; i < _plots.Length; i++)
            {
                if (graphs != null && i < graphs.Count)
                    DrawGraph(_plots[i], graphs[i]);
                else
                    ClearPlot(_plots[i]);
            }

            FormClosed += (_, __) =>
            {
                foreach (var pb in _plots) pb.Image?.Dispose();
                _legend.Image?.Dispose();
            };
        }

        private void ClearPlot(PictureBox pb)
        {
            pb.Image?.Dispose();
            var bmp = new Bitmap(pb.Width > 10 ? pb.Width : 10, pb.Height > 10 ? pb.Height : 10);
            using (var g = Graphics.FromImage(bmp))
            {
                g.Clear(Color.White);
            }
            pb.Image = bmp;
        }

        private void DrawLegend()
        {
            _legend.Image?.Dispose();
            var bmp = new Bitmap(Math.Max(_legend.Width, 10), Math.Max(_legend.Height, 10));
            using (var g = Graphics.FromImage(bmp))
            {
                g.SmoothingMode = SmoothingMode.AntiAlias;
                g.Clear(Color.White);

                int y = 18;

                using (var p = new Pen(Color.Green, 2))
                {
                    g.DrawLine(p, 20, 25, 90, 25);
                    g.DrawString("Predpisana vrednost", Font, Brushes.Black, 95, y);
                }

                using (var p = new Pen(Color.Blue, 2))
                {
                    g.DrawLine(p, 250, 25, 320, 25);
                    g.DrawString("Povpreèje", Font, Brushes.Black, 325, y);
                }

                using (var p = new Pen(Color.Red, 2))
                {
                    g.DrawLine(p, 470, 25, 540, 25);
                    g.DrawString("Toleranène meje", Font, Brushes.Black, 545, y);
                }

                // Delphi color $0200c0c0 ~ teal-ish; keep close
                using (var p = new Pen(Color.FromArgb(0x00, 0xC0, 0xC0), 2))
                {
                    g.DrawLine(p, 700, 25, 770, 25);
                    g.DrawString("Kontrolne meje", Font, Brushes.Black, 775, y);
                }
            }
            _legend.Image = bmp;
        }

        private void DrawGraph(PictureBox pb, GrafRequest req)
        {
            pb.Image?.Dispose();
            var bmp = new Bitmap(Math.Max(pb.Width, 10), Math.Max(pb.Height, 10));

            using (var g = Graphics.FromImage(bmp))
            {
                g.SmoothingMode = SmoothingMode.AntiAlias;
                g.Clear(Color.White);

                // Delphi dif:
                double dif1 = req.Zg - req.Sr;
                double dif2 = req.Sr - req.Sp;
                double dif = Math.Max(dif1, dif2);
                if (Math.Abs(dif) < 1e-9) dif = 1;

                // Add vertical headroom so tolerance/control lines are not glued to top/bottom edges.
                const double yScalePaddingFactor = 1.25;
                double scaledDif = dif * yScalePaddingFactor;

                int zx, zy, zz;
                DrawBase(g, pb.ClientRectangle, req.Sp, req.Zg, req.Sr, scaledDif, req.Avr, req.Std, out zx, out zy, out zz);

                // title
                using (var p = new Pen(Color.Black, 1))
                {
                    int rb = pb.Width / 2 - 50;
                    g.DrawString(req.Title ?? "", Font, Brushes.Black, rb, 0);
                }

                // Calculate korak so all points fit in the available width
                int availableWidth = pb.Width - zx - 10; // 10px right margin
                if (availableWidth < 1) availableWidth = 1;

                // Use double precision step so dense series can still fit in the graph width.
                double korak = req.Points.Count > 1 ? (double)availableWidth / (req.Points.Count - 1) : availableWidth;

                int stvz = req.StVz <= 0 ? 1 : req.StVz;
                int iy = 0;
                int z2 = zy / 2;

                // Use a smaller font for axis labels
                using (var smallFont = new Font(Font.FontFamily, 7f))
                {
                    // Show only every Nth label, but always first and last
                    int labelStep = 1;
                    if (req.Points.Count > 20)
                        labelStep = req.Points.Count / 8; // show about 8 labels max
                    if (labelStep < 1) labelStep = 1;

                    for (int ii = 0; ii < req.Points.Count; ii++)
                    {
                        double xx = req.Points[ii].Value;

                        int ix = (int)Math.Round((z2 - zz) * (xx - req.Sr + scaledDif) / scaledDif) + zz;
                        int x = zx + (int)Math.Round(ii * korak);
                        int y = zy - ix;

                        if (ii == 0)
                        {
                            // just start
                        }
                        else
                        {
                            int px = zx + (int)Math.Round((ii - 1) * korak);
                            int py = zy - iy;
                            g.DrawLine(Pens.Black, px, py, x, y);
                        }

                        // Always show first and last label, otherwise every labelStep
                        bool showLabel = (ii == 0) || (ii == req.Points.Count - 1) || (ii % labelStep == 0 && stvz > 0 && (ii % stvz == 0));
                        if (showLabel)
                        {
                            var dt = req.Points[ii].When;

                            string tx = dt.ToString("HH:mm");
                            int w = TextRenderer.MeasureText(tx, smallFont).Width;
                            g.DrawString(tx, smallFont, Brushes.Black, x - w / 2, zy + 5);

                            string dx = dt.ToString("dd.MM");
                            int w2 = TextRenderer.MeasureText(dx, smallFont).Width;
                            g.DrawString(dx, smallFont, Brushes.Black, x - w2 / 2, zy + 15);

                            if (ii > 0)
                            {
                                using (var p = new Pen(Color.Black, 1) { DashStyle = DashStyle.Dot })
                                {
                                    g.DrawLine(p, x, zy, x, zz);
                                }
                            }
                        }

                        iy = ix;
                    }
                }
            }

            pb.Image = bmp;
        }

        private void DrawBase(Graphics g, Rectangle rect, double sp, double zg, double sr, double dif, double avr, double std,
                              out int zx, out int zy, out int zz)
        {
            zx = 5; // left margin
            zy = rect.Height - 25; // increased bottom margin for visible x axis labels
            zz = 5; // top margin

            int z2 = zy / 2;
            int zf = rect.Width;

            // axes
            g.DrawLine(Pens.Black, zx, zy, rect.Width, zy);
            g.DrawLine(Pens.Black, zx, zy, zx, 0);

            // cp/cpk (Delphi cps)
            double cp = 0, cpk = 0;
            if (Math.Abs(std) > 1e-8)
            {
                cp = (zg - sp) / (6 * std);
                double x1 = zg - avr;
                double x2 = avr - sp;
                cpk = Math.Min(x1, x2) / (3 * std);
            }

            g.DrawString($"cp = {cp:0.00}", Font, Brushes.Black, zf - 120, 0);
            g.DrawString($"cpk = {cpk:0.00}", Font, Brushes.Black, zf - 60, 0);

            // capture for lambda
            int localZ2 = z2;
            int localZz = zz;
            int localZy = zy;

            // helper for y transform (Delphi formula)
            Func<double, int> yy = (val) =>
            {
                int y = (int)Math.Round((localZ2 - localZz) * (val - sr + dif) / dif) + localZz;
                return localZy - y;
            };

            // tolerance lines (red): sp, zg
            using (var p = new Pen(Color.Red, 2))
            {
                int y1 = yy(sp);
                g.DrawLine(p, zx, y1, rect.Width, y1);
                g.DrawString($"{sp:0.00}", Font, Brushes.Black, 0, y1 - 7);

                int y2 = yy(zg);
                g.DrawLine(p, zx, y2, rect.Width, y2);
                g.DrawString($"{zg:0.00}", Font, Brushes.Black, 0, y2 - 7);
            }

            // average line (blue): avr
            using (var p = new Pen(Color.Blue, 2))
            {
                int ya = yy(avr);
                g.DrawLine(p, zx, ya, rect.Width, ya);
            }

            // control limits (teal): avr +/- 3*std
            using (var p = new Pen(Color.FromArgb(0x00, 0xC0, 0xC0), 2))
            {
                int yhi = yy(avr + 3 * std);
                int ylo = yy(avr - 3 * std);
                g.DrawLine(p, zx, yhi, rect.Width, yhi);
                g.DrawLine(p, zx, ylo, rect.Width, ylo);
            }

            // center line (green) at sr (Delphi draws it at z2 and prints sr)
            using (var p = new Pen(Color.Green, 2))
            {
                g.DrawLine(p, zx, z2, rect.Width, z2);
                g.DrawString($"{sr:0.00}", Font, Brushes.Black, 0, z2 - 7);
            }
        }
    }
}
