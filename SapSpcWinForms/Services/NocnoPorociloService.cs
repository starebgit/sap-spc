using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.OleDb;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;

namespace SapSpcWinForms.Services
{
    /// <summary>
    /// Tihi način (SapSpcWinForms.exe /porocilo): pošlje e-poštno poročilo vseh meritev
    /// izven mej (rdeča cona) za pretekli dan. Sproži ga Windows Task Scheduler.
    /// Nastavitve so v App.config (appSettings, ključi "Porocilo.*").
    /// </summary>
    internal static class NocnoPorociloService
    {
        private const string Src = "NocnoPorocilo";

        private sealed class Vrstica
        {
            public DateTime Datum;
            public string MerilnoMesto;
            public string Stroj;
            public string Koda;
            public string Sarza;
            public string Merilec;
            public string Karakt;
            public string Naziv;
            public int Tip;
            public int Vzorec;
            public double? Vrednost;
            public int Slabi;
            public double? SpMeja;
            public double? ZgMeja;
        }

        /// <param name="dan">Dan, za katerega se pošlje poročilo (00:00–24:00).</param>
        /// <param name="samoTest">true = pošlji samo testnim prejemnikom (ročni preizkus).</param>
        /// <returns>0 = uspeh, 1 = napaka.</returns>
        public static int Run(DateTime dan, bool samoTest)
        {
            try
            {
                var od = dan.Date;
                var doo = od.AddDays(1);
                var vrstice = NaloziIzvenMej(od, doo);

                var prejemniki = DolociPrejemnike(samoTest);
                if (prejemniki.Count == 0)
                    throw new InvalidOperationException("Ni nastavljenih prejemnikov (prejemniki.txt).");

                int stVar = vrstice.Count(v => v.Tip == 1);
                int stAtr = vrstice.Count(v => v.Tip == 2);
                int skupaj = stVar + stAtr;

                string zadeva = $"SPC – meritve izven mej – {od:dd.MM.yyyy} ({skupaj})";
                string telo = SestaviHtml(od, vrstice, stVar, stAtr);

                Poslji(prejemniki, zadeva, telo);
                DiagnosticLog.Info(Src, $"Poslano za {od:yyyy-MM-dd}: {skupaj} izven mej -> {string.Join(", ", prejemniki)}");
                return 0;
            }
            catch (Exception ex)
            {
                DiagnosticLog.Warn(Src, ex);
                return 1;
            }
        }

        private static string Nastavitev(string kljuc, string privzeto = "")
        {
            var v = ConfigurationManager.AppSettings[kljuc];
            return string.IsNullOrWhiteSpace(v) ? privzeto : v.Trim();
        }

        private static List<string> Razdeli(string s)
        {
            return (s ?? "")
                .Split(new[] { ';', ',' }, StringSplitOptions.RemoveEmptyEntries)
                .Select(x => x.Trim())
                .Where(x => x.Length > 0)
                .ToList();
        }

        /// <summary>
        /// Redni prejemniki so v tekstovni datoteki poleg exe (privzeto prejemniki.txt,
        /// ključ Porocilo.PrejemnikiDatoteka): en e-naslov na vrstico, vrstice z # so komentar.
        /// Datoteko se ureja brez novega deploya. Če je ni, se uporabi Porocilo.Prejemniki.
        /// /test pošlje samo na Porocilo.TestniPrejemniki.
        /// </summary>
        private static List<string> DolociPrejemnike(bool samoTest)
        {
            if (samoTest)
                return Razdeli(Nastavitev("Porocilo.TestniPrejemniki"));

            string pot = Nastavitev("Porocilo.PrejemnikiDatoteka", "prejemniki.txt");
            if (!Path.IsPathRooted(pot))
                pot = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, pot);

            List<string> result;
            if (File.Exists(pot))
            {
                result = File.ReadAllLines(pot, Encoding.UTF8)
                    .Select(l => l.Trim())
                    .Where(l => l.Length > 0 && !l.StartsWith("#"))
                    .SelectMany(Razdeli)
                    .ToList();
            }
            else
            {
                DiagnosticLog.Info(Src, $"Datoteka s prejemniki ne obstaja ({pot}), uporabim Porocilo.Prejemniki.");
                result = Razdeli(Nastavitev("Porocilo.Prejemniki"));
            }

            return result.Distinct(StringComparer.OrdinalIgnoreCase).ToList();
        }

        private static List<Vrstica> NaloziIzvenMej(DateTime od, DateTime doo)
        {
            // Meje niso shranjene ob meritvi, zato jih vzamemo iz kontrolnega plana šarže
            // (najnovejši konsar, glej fix za podvojene šarže). Toleranca 0.0001 kot pri SAP zapisu.
            const string sql =
                "SELECT g.datum, " +
                " (SELECT TOP 1 RTRIM(po.opis) FROM postaje po WHERE po.stPost = g.idpost) AS mesto, " +
                " (SELECT TOP 1 RTRIM(st.naziv) FROM stroji st WHERE st.idstroja = g.idstroj) AS stroj, " +
                " RTRIM(g.idstroj) AS idstroj, RTRIM(g.koda) AS koda, RTRIM(g.sarza) AS sarza, RTRIM(g.merilec) AS merilec, " +
                " RTRIM(k.karakt) AS karakt, RTRIM(k.naziv) AS naziv, k.zapvz, k.vrednost, k.slabi, " +
                " p.tip, p.spmeja, p.zgmeja " +
                "FROM glavmer g " +
                "JOIN karmer k ON k.idmer = g.idmer " +
                "JOIN konsar s ON s.ident = (SELECT MAX(s2.ident) FROM konsar s2 " +
                "   WHERE s2.koda = g.koda AND s2.sarza = g.sarza AND s2.idpost = g.idpost) " +
                "JOIN konplan p ON p.idsar = s.ident AND p.pozicija = k.karakt " +
                "WHERE g.datum >= ? AND g.datum < ? " +
                " AND ((p.tip = 1 AND k.vrednost IS NOT NULL " +
                "       AND (k.vrednost < p.spmeja - 0.0001 OR k.vrednost > p.zgmeja + 0.0001)) " +
                "   OR (p.tip = 2 AND k.slabi > 0)) " +
                "ORDER BY g.datum, g.idmer, k.karakt, k.zapvz";

            var list = new List<Vrstica>();
            string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;
            using (var conn = new OleDbConnection(connStr))
            using (var cmd = conn.CreateCommand())
            {
                conn.Open();
                cmd.CommandText = sql;
                cmd.CommandTimeout = 120;
                cmd.Parameters.Add("@od", OleDbType.Date).Value = od;
                cmd.Parameters.Add("@do", OleDbType.Date).Value = doo;

                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        string stroj = Str(r["stroj"]);
                        list.Add(new Vrstica
                        {
                            Datum = Convert.ToDateTime(r["datum"]),
                            MerilnoMesto = Str(r["mesto"]),
                            Stroj = stroj.Length > 0 ? stroj : Str(r["idstroj"]),
                            Koda = Str(r["koda"]),
                            Sarza = Str(r["sarza"]),
                            Merilec = Str(r["merilec"]),
                            Karakt = Str(r["karakt"]),
                            Naziv = Str(r["naziv"]),
                            Tip = Convert.ToInt32(r["tip"]),
                            Vzorec = r["zapvz"] == DBNull.Value ? 0 : Convert.ToInt32(r["zapvz"]),
                            Vrednost = Dbl(r["vrednost"]),
                            Slabi = r["slabi"] == DBNull.Value ? 0 : Convert.ToInt32(r["slabi"]),
                            SpMeja = Dbl(r["spmeja"]),
                            ZgMeja = Dbl(r["zgmeja"])
                        });
                    }
                }
            }

            return list;
        }

        private static string Str(object o) => o == null || o == DBNull.Value ? "" : o.ToString().Trim();
        private static double? Dbl(object o) => o == null || o == DBNull.Value ? (double?)null : Convert.ToDouble(o);

        private static string Stevilo(double? d) =>
            d.HasValue ? d.Value.ToString("0.####", CultureInfo.GetCultureInfo("sl-SI")) : "";

        private static string H(string s) => WebUtility.HtmlEncode(s ?? "");

        private static string SestaviHtml(DateTime dan, List<Vrstica> vrstice, int stVar, int stAtr)
        {
            const string th = "style=\"border:1px solid #ccc;padding:4px 8px;background:#f2f2f2;text-align:left\"";
            const string td = "style=\"border:1px solid #ccc;padding:4px 8px\"";
            const string tdRed = "style=\"border:1px solid #ccc;padding:4px 8px;background:#ffd6d6;font-weight:bold\"";
            const string table = "style=\"border-collapse:collapse;font-family:Segoe UI,Arial,sans-serif;font-size:13px\"";

            var sb = new StringBuilder();
            sb.Append("<html><body style=\"font-family:Segoe UI,Arial,sans-serif;font-size:14px\">");
            sb.Append("<p>Pozdravljeni,</p>");

            int skupaj = stVar + stAtr;
            if (skupaj == 0)
            {
                sb.Append($"<p><b>0 meritev izven mej</b> na dan {dan:dd.MM.yyyy}.</p>");
            }
            else
            {
                sb.Append($"<p>na dan {dan:dd.MM.yyyy} je bilo vnešenih <b>{skupaj} meritev izven mej</b>.</p>");

                if (stVar > 0)
                {
                    sb.Append($"<h3 style=\"margin-bottom:4px\">Variabilne karakteristike izven tolerance ({stVar})</h3>");
                    sb.Append($"<table {table}><tr>");
                    foreach (var h in new[] { "Čas", "Merilno mesto", "Stroj", "Koda", "Šarža", "Karakteristika", "Vzorec", "Vrednost", "Meje", "Merilec" })
                        sb.Append($"<th {th}>{h}</th>");
                    sb.Append("</tr>");
                    foreach (var v in vrstice.Where(x => x.Tip == 1))
                    {
                        sb.Append("<tr>")
                          .Append($"<td {td}>{v.Datum:dd.MM. HH:mm}</td>")
                          .Append($"<td {td}>{H(v.MerilnoMesto)}</td>")
                          .Append($"<td {td}>{H(v.Stroj)}</td>")
                          .Append($"<td {td}>{H(v.Koda)}</td>")
                          .Append($"<td {td}>{H(v.Sarza)}</td>")
                          .Append($"<td {td}>{H(v.Karakt)} {H(v.Naziv)}</td>")
                          .Append($"<td {td}>{v.Vzorec}</td>")
                          .Append($"<td {tdRed}>{Stevilo(v.Vrednost)}</td>")
                          .Append($"<td {td}>{Stevilo(v.SpMeja)} – {Stevilo(v.ZgMeja)}</td>")
                          .Append($"<td {td}>{H(v.Merilec)}</td>")
                          .Append("</tr>");
                    }
                    sb.Append("</table>");
                }

                if (stAtr > 0)
                {
                    sb.Append($"<h3 style=\"margin-bottom:4px\">Atributivne karakteristike z neustreznimi kosi ({stAtr})</h3>");
                    sb.Append($"<table {table}><tr>");
                    foreach (var h in new[] { "Čas", "Merilno mesto", "Stroj", "Koda", "Šarža", "Karakteristika", "Neustreznih", "Merilec" })
                        sb.Append($"<th {th}>{h}</th>");
                    sb.Append("</tr>");
                    foreach (var v in vrstice.Where(x => x.Tip == 2))
                    {
                        sb.Append("<tr>")
                          .Append($"<td {td}>{v.Datum:dd.MM. HH:mm}</td>")
                          .Append($"<td {td}>{H(v.MerilnoMesto)}</td>")
                          .Append($"<td {td}>{H(v.Stroj)}</td>")
                          .Append($"<td {td}>{H(v.Koda)}</td>")
                          .Append($"<td {td}>{H(v.Sarza)}</td>")
                          .Append($"<td {td}>{H(v.Karakt)} {H(v.Naziv)}</td>")
                          .Append($"<td {tdRed}>{v.Slabi}</td>")
                          .Append($"<td {td}>{H(v.Merilec)}</td>")
                          .Append("</tr>");
                    }
                    sb.Append("</table>");
                }
            }

            sb.Append("<p style=\"color:#888;font-size:12px;margin-top:16px\">Samodejno sporočilo aplikacije SapSpc.</p>");
            sb.Append("</body></html>");
            return sb.ToString();
        }

        private static void Poslji(List<string> prejemniki, string zadeva, string htmlTelo)
        {
            string host = Nastavitev("Porocilo.SmtpStreznik", "mailrelay.bfits.com");
            int port = int.TryParse(Nastavitev("Porocilo.SmtpPort", "25"), out var p) ? p : 25;
            string od = Nastavitev("Porocilo.Posiljatelj", "it.slovenia@egoproducts.com");
            string odIme = Nastavitev("Porocilo.PosiljateljIme", "SapSpc poročilo");

            using (var msg = new MailMessage())
            using (var client = new SmtpClient(host, port))
            {
                msg.From = new MailAddress(od, odIme, Encoding.UTF8);
                foreach (var to in prejemniki)
                    msg.To.Add(to);
                msg.Subject = zadeva;
                msg.SubjectEncoding = Encoding.UTF8;
                msg.Body = htmlTelo;
                msg.BodyEncoding = Encoding.UTF8;
                msg.IsBodyHtml = true;

                client.DeliveryMethod = SmtpDeliveryMethod.Network;
                client.UseDefaultCredentials = false;
                client.Timeout = 60000;
                client.Send(msg);
            }
        }
    }
}
