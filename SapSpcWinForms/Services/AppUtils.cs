// File: SapSpcWinForms/Utils/AppUtils.cs
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Windows.Forms;

namespace SapSpcWinForms.Utils
{
    /// <summary>
    /// Single "utils service": stateless helpers only.
    /// Keeps ZacetnaForm behavior identical by not owning any runtime state.
    /// </summary>
    public static class AppUtils
    {
        // =========================
        // KODA / DELPHI FORMAT UTILS
        // =========================

        // Delphi behavior: ONLY special-case 18-char codes (don’t TrimStart for others)
        public static string NormalizeKodaDelphiLike(string kd)
        {
            kd = (kd ?? "").Trim();

            if (kd.Length == 18)
            {
                // Delphi expects 18 chars (often already zero-padded)
                var raw18 = kd.PadLeft(18, '0');

                // Delphi: kd := KodaForm(kd,'/',false);
                kd = KodaForm(raw18, "/", false);

                // Delphi: while (kd[1] = '0') or (kd[1] = '.') do kd := copy(kd,2,18);
                kd = TrimLeadingZeroDot(kd);
            }

            return kd.Trim();
        }

        // minimal Delphi KodaForm(kd,'/',false) clone for your 18-digit raw Sinapro code
        public static string KodaForm(string kd, string dd, bool kratko)
        {
            // kd is expected length 18
            var kdd = kd.Substring(4, 10);   // copy(kd,5,10)
            var dod = kd.Substring(14, 4);   // copy(kd,15,4)

            int i0 = 0;
            while (i0 < kdd.Length && kdd[i0] == '0') i0++;
            int ii = i0 + 1; // Delphi is 1-based

            string koda;

            switch (ii)
            {
                case 1:
                    koda = kdd.Substring(0, 2) + "." + kdd.Substring(2, 5) + "." + kdd.Substring(7, 3);
                    break;

                case 2:
                    koda = kdd.Substring(0, 3) + "." + kdd.Substring(3, 4) + "." + kdd.Substring(7, 3);
                    break;

                case 4:
                    koda = kdd.Substring(0, 5) + "." + kdd.Substring(5, 3) + "." + kdd.Substring(8, 2);
                    break;

                case 3:
                case 5:
                default:
                    koda = kdd.Substring(0, 4) + "." + kdd.Substring(4, 3) + "." + kdd.Substring(7, 3);
                    break;
            }

            if (!kratko)
            {
                if (dod.Substring(0, 2) != "00") koda += "-" + dod.Substring(0, 2);
                if (dod.Substring(2, 2) != "00") koda += "/" + dod.Substring(2, 2);
                if (dod == "0000") koda += dd + "00";
            }

            return koda;
        }

        public static string TrimLeadingZeroDot(string s)
        {
            while (!string.IsNullOrEmpty(s) && (s[0] == '0' || s[0] == '.'))
                s = s.Substring(1);
            return s;
        }

        public static string CleanKoda(string kd) => (kd ?? "").Replace("-", "").Trim();

        // =========================
        // PARSING / NUMBERS
        // =========================

        public static int ToIntSafe(object x)
        {
            if (x == null || x == DBNull.Value) return 0;
            if (int.TryParse(x.ToString(), out int v)) return v;
            return 0;
        }

        public static double ParseDoubleLoose(object value)
        {
            if (value == null || value == DBNull.Value) return 0;
            var s = value.ToString().Trim();
            if (string.IsNullOrEmpty(s)) return 0;

            // try current culture first
            if (double.TryParse(s, NumberStyles.Any, CultureInfo.CurrentCulture, out var d))
                return d;

            // try invariant with dot
            if (double.TryParse(s.Replace(',', '.'), NumberStyles.Any, CultureInfo.InvariantCulture, out d))
                return d;

            // try slovene style with comma
            var sl = CultureInfo.GetCultureInfo("sl-SI");
            if (double.TryParse(s.Replace('.', ','), NumberStyles.Any, sl, out d))
                return d;

            return 0;
        }

        public static bool TryParseRequiredDouble(string s, out double d)
        {
            d = 0;
            if (string.IsNullOrWhiteSpace(s)) return false;

            if (double.TryParse(s, NumberStyles.Any, CultureInfo.CurrentCulture, out d)) return true;
            if (double.TryParse(s.Replace(',', '.'), NumberStyles.Any, CultureInfo.InvariantCulture, out d)) return true;

            var sl = CultureInfo.GetCultureInfo("sl-SI");
            if (double.TryParse(s.Replace('.', ','), NumberStyles.Any, sl, out d)) return true;

            return false;
        }

        // =========================
        // SHIFT / SEMAFOR TIME LOGIC
        // =========================

        public static (DateTime dat, int izm) GetIzmDatDelphiLike(DateTime now)
        {
            var t1 = new TimeSpan(6, 0, 0);
            var t2 = new TimeSpan(14, 0, 0);
            var t3 = new TimeSpan(22, 0, 0);

            var tt = now.TimeOfDay;
            var dat = now.Date;
            int izm;

            if (tt < t1)
            {
                dat = dat.AddDays(-1);
                izm = 3;
            }
            else if (tt < t2)
            {
                izm = 1;
            }
            else if (tt < t3)
            {
                izm = 2;
            }
            else
            {
                izm = 3;
            }

            return (dat, izm);
        }

        public static bool IsNearShiftStart(TimeSpan now, TimeSpan[] zacIzm, double thresholdMinutes = 1.5)
        {
            // Delphi: abs((ZacIzm[i]-tt)*24*60) < 1.5
            // Expect zacIzm indexed 0..3 where 1..3 are valid
            for (int i = 1; i <= 3 && i < zacIzm.Length; i++)
            {
                var minutes = Math.Abs((zacIzm[i] - now).TotalMinutes);
                if (minutes < thresholdMinutes) return true;
            }
            return false;
        }

        public static int DolociSt(TimeSpan acas, int diff, int traj, TimeSpan now)
        {
            var ddHours = (now - acas).TotalHours;
            if (ddHours < 0) ddHours += 24; // wrap over midnight (same as your code)

            int ist = 1;
            if (ddHours > (diff - traj) / 60.0) ist = 2;
            if (ddHours > diff / 60.0) ist = 3;
            return ist;
        }

        // =========================
        // STATS (GRAF)
        // =========================

        public static void ComputeStats(IReadOnlyList<double> values, out double avr, out double std)
        {
            avr = 0;
            std = 0;

            int n = values?.Count ?? 0;
            if (n <= 0) return;

            double sum = 0;
            for (int i = 0; i < n; i++) sum += values[i];
            avr = sum / n;

            if (n <= 1) { std = 0; return; }

            double s2 = 0;
            for (int i = 0; i < n; i++)
            {
                double d = values[i] - avr;
                s2 += d * d;
            }

            // Delphi: sqrt(sum/(n-1))
            std = Math.Sqrt(s2 / (n - 1));
        }

        // =========================
        // WINFORMS CONTROL SEARCH
        // =========================

        public static T FindControl<T>(Control root, string name) where T : Control
        {
            try { return root.Controls.Find(name, true).OfType<T>().FirstOrDefault(); }
            catch { return null; }
        }

        public static Button FindFirstButtonByTextContains(Control root, string needle)
        {
            if (root == null) return null;
            if (string.IsNullOrWhiteSpace(needle)) return null;

            foreach (Control c in GetAllControls(root))
            {
                if (c is Button b && !string.IsNullOrWhiteSpace(b.Text) &&
                    b.Text.IndexOf(needle, StringComparison.OrdinalIgnoreCase) >= 0)
                    return b;
            }
            return null;
        }

        public static IEnumerable<Control> GetAllControls(Control root)
        {
            if (root == null) yield break;

            foreach (Control c in root.Controls)
            {
                yield return c;
                foreach (var child in GetAllControls(c))
                    yield return child;
            }
        }

        // =========================
        // SERIAL / STOPALKA PARSING
        // =========================

        public static readonly Regex Rx04AFrame = new Regex(
            @"04A(?<sign>[+-])(?<int>\d{5})[.,](?<frac>\d{2})",
            RegexOptions.IgnoreCase | RegexOptions.Compiled
        );

        // returns last COMPLETE frame value, and where that frame ended in the buffer (so caller can consume it)
        public static bool TryParseLast04AFrame(string raw, out double value, out int frameEndIndex, out string tokenUsed)
        {
            value = 0;
            frameEndIndex = -1;
            tokenUsed = null;

            if (string.IsNullOrWhiteSpace(raw)) return false;

            var m = Rx04AFrame.Matches(raw);
            if (m.Count == 0) return false;

            var last = m[m.Count - 1];
            var sign = last.Groups["sign"].Value;
            var iPart = last.Groups["int"].Value;
            var fPart = last.Groups["frac"].Value;

            tokenUsed = $"{sign}{iPart}.{fPart}";
            frameEndIndex = last.Index + last.Length;

            return double.TryParse(tokenUsed, NumberStyles.Any, CultureInfo.InvariantCulture, out value);
        }

        public static string ReadOneFrameFromCom(string portName, int baud, TimeSpan timeout)
        {
            if (string.IsNullOrWhiteSpace(portName))
                throw new ArgumentException("portName is empty.");

            var sw = Stopwatch.StartNew();
            var sb = new StringBuilder();

            using (var sp = new SerialPort(portName, baud, Parity.None, 8, StopBits.One)
            {
                Handshake = Handshake.None,
                DtrEnable = true,
                RtsEnable = true,
                Encoding = Encoding.ASCII,
                ReadTimeout = 250
            })
            {
                sp.Open();
                sp.DiscardInBuffer();

                while (sw.Elapsed < timeout)
                {
                    string chunk = null;
                    try { chunk = sp.ReadExisting(); }
                    catch (TimeoutException) { /* ignore */ }

                    if (!string.IsNullOrEmpty(chunk))
                    {
                        sb.Append(chunk);

                        // keep buffer sane
                        if (sb.Length > 1024)
                            sb.Remove(0, sb.Length - 1024);

                        // stop as soon as we have a full frame
                        if (Rx04AFrame.IsMatch(sb.ToString()))
                            return sb.ToString();
                    }

                    System.Threading.Thread.Sleep(30);
                }
            }

            return null; // timeout
        }

        public static string PadOp(string op)
        {
            op = (op ?? "").Trim();
            if (op.Length >= 4) return op;
            return op.PadLeft(4, '0');
        }

    }
}
