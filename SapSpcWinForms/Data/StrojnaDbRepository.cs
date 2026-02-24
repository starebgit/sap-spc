using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Linq;
using System.Windows.Forms;

namespace SapSpcWinForms.Data
{
    public static class StrojnaDbRepository
    {
        // DB part for LoadMerilnoMesto
        public static (int? stpost, string opis) LoadMerilnoMestoDb(string compName)
        {
            string opis = "(ni prijave)";
            int? stpost = null;
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;
                using (var conn = new OleDbConnection(connStr))
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "SELECT stpost, opis FROM postaje WHERE imerac = ?";
                    cmd.Parameters.AddWithValue("@imerac", compName);
                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            stpost = reader["stpost"] as int? ?? Convert.ToInt32(reader["stpost"]);
                            opis = reader["opis"].ToString();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                opis = "Napaka: " + ex.Message;
            }
            return (stpost, opis);
        }

        public static List<(int idstroja, string naziv)> GetMachinesForPost(int stpost)
        {
            var list = new List<(int idstroja, string naziv)>();
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;
                using (var conn = new OleDbConnection(connStr))
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "SELECT idstroja, naziv FROM stroji WHERE stPost = ? ORDER BY sifstroja";
                    cmd.Parameters.AddWithValue("@stPost", stpost);
                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            int idstroja = Convert.ToInt32(reader["idstroja"]);
                            string naziv = reader["naziv"].ToString();
                            list.Add((idstroja, naziv));
                        }
                    }
                }
            }
            catch
            {
                // caller handles errors
            }
            return list;
        }

        public static int? GetSelectedMachineId(int stpost, string machineName)
        {
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;
                using (var conn = new OleDbConnection(connStr))
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "SELECT idstroja FROM stroji WHERE stPost = ? AND naziv = ?";
                    cmd.Parameters.AddWithValue("@stPost", stpost);
                    cmd.Parameters.AddWithValue("@naziv", machineName);
                    conn.Open();
                    var result = cmd.ExecuteScalar();
                    if (result != null && int.TryParse(result.ToString(), out int id))
                        return id;
                }
            }
            catch { }
            return null;
        }

        public static int GetIzbiraFromPostajeOrDefault(int stpost)
        {
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;

                using (var conn = new OleDbConnection(connStr))
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "SELECT TOP 1 izbiraKd FROM postaje WHERE stpost = ?";
                    cmd.Parameters.AddWithValue("@p1", stpost);

                    conn.Open();

                    var v = cmd.ExecuteScalar();

                    if (v == null)
                        return 0;

                    if (v == DBNull.Value)
                        return 0;

                    var s = v.ToString();
                    bool ok = int.TryParse(s, out int kdp);

                    if (ok) return kdp;

                    return 0;
                }
            }
            catch
            {
                return 0;
            }
        }

        public static bool PreveriKodoDelphiLike(string kd, int idpost)
        {
            string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;

            using (var conn = new OleDbConnection(connStr))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText =
                    "SELECT COUNT(*) " +
                    "FROM konsar " +
                    "WHERE (koda = ?) AND (idpost = ?) AND (koncan <> 'Y') AND (koncan <> 'X')";

                cmd.Parameters.AddWithValue("@p1", kd);
                cmd.Parameters.AddWithValue("@p2", idpost);

                conn.Open();
                int n = Convert.ToInt32(cmd.ExecuteScalar() ?? 0);
                return n > 0;
            }
        }

        public static List<string> GetListaCodesForPostaja(int idpost)
        {
            var list = new List<string>();
            string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;

            using (var conn = new OleDbConnection(connStr))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText =
                    "SELECT koda " +
                    "FROM konsar " +
                    "WHERE idpost = ? AND (koncan <> 'Y') AND (koncan <> 'X') " +
                    "ORDER BY koda";

                cmd.Parameters.AddWithValue("@p1", idpost);

                conn.Open();
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        var k = r["koda"] == DBNull.Value ? "" : r["koda"].ToString();
                        if (!string.IsNullOrWhiteSpace(k))
                            list.Add(k);
                    }
                }
            }

            return list;
        }

        public static string GetSarzaForKoda(string kd, int idpost)
        {
            string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;
            using (var conn = new OleDbConnection(connStr))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText =
                    "SELECT TOP 1 [sarza] " +
                    "FROM [konsar] " +
                    "WHERE [koda] = ? AND [idpost] = ? AND ( [koncan] IS NULL OR [koncan] <> 'Y' ) " +
                    "ORDER BY [ident] DESC";

                cmd.Parameters.AddWithValue("@p1", kd);
                cmd.Parameters.AddWithValue("@p2", idpost);

                conn.Open();
                var val = cmd.ExecuteScalar();
                return val == null || val == DBNull.Value ? null : val.ToString();
            }
        }

        public static DataTable GetKonplanRowsForSarza(string srz, int idpost)
        {
            string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;
            using (var conn = new OleDbConnection(connStr))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText =
                    "SELECT kp.[idplan], kp.[idsar], kp.[tip], kp.[pozicija], kp.[naziv], kp.[predpis], kp.[spmeja], kp.[zgmeja], " +
                    "       kp.[kanal], kp.[stvz], kp.[stkanal], kp.[com], kp.[oznaka], kp.[operacija] " +
                    "FROM [konsar] ks INNER JOIN [konplan] kp ON kp.[idsar] = ks.[ident] " +
                    "WHERE ks.[sarza] = ? AND ks.[idpost] = ? " +
                    "ORDER BY kp.[tip], kp.[pozicija]";

                cmd.Parameters.AddWithValue("@p1", srz);
                cmd.Parameters.AddWithValue("@p2", idpost);

                var dt = new DataTable();
                using (var da = new OleDbDataAdapter(cmd))
                {
                    da.Fill(dt);
                }
                return dt;
            }
        }

        public static (int diff, int traj) GetIntervalFromKonsar(string kd, int idpost)
        {
            string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;
            using (var conn = new OleDbConnection(connStr))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText =
                    "SELECT TOP 1 merdiff, mertraj " +
                    "FROM konsar " +
                    "WHERE koda = ? AND idpost = ? AND (koncan IS NULL OR koncan <> 'Y') " +
                    "ORDER BY ident DESC";

                cmd.Parameters.AddWithValue("@p1", (kd ?? "").Replace("-", "").Trim());
                cmd.Parameters.AddWithValue("@p2", idpost);

                conn.Open();
                using (var r = cmd.ExecuteReader())
                {
                    if (!r.Read()) return (60, 0);
                    int diff = r["merdiff"] == DBNull.Value ? 60 : Convert.ToInt32(r["merdiff"]);
                    int traj = r["mertraj"] == DBNull.Value ? 0  : Convert.ToInt32(r["mertraj"]);
                    return (diff, traj);
                }
            }
        }

        public static TimeSpan TryGetLastMeasurementTimeOfDay(int stpost, int idstroja, Func<DateTime, (DateTime dat, int izm)> getIzmFunc)
        {
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;

                using (var conn = new OleDbConnection(connStr))
                using (var cmd = conn.CreateCommand())
                {
                    conn.Open();

                    var pair = getIzmFunc(DateTime.Now);
                    var dat = pair.dat;
                    var izm = pair.izm;

                    cmd.Parameters.Clear();
                    cmd.CommandText =
                        "SELECT TOP 1 ident FROM GenDnevi " +
                        "WHERE datum = ? AND izmena = ? AND stpost = ?";
                    cmd.Parameters.AddWithValue("@p1", dat.Date);
                    cmd.Parameters.AddWithValue("@p2", izm);
                    cmd.Parameters.AddWithValue("@p3", stpost);

                    var idsObj = cmd.ExecuteScalar();
                    if (idsObj == null || idsObj == DBNull.Value) return TimeSpan.Zero;
                    int ids = Convert.ToInt32(idsObj);

                    string sx = idstroja.ToString();
                    if (sx == "408203500") return TryGetTmlCas(145, conn);
                    if (sx == "408203600") return TryGetTmlCas(180, conn);

                    cmd.Parameters.Clear();
                    cmd.CommandText =
                        "SELECT cas FROM GenCasovni " +
                        "WHERE ident = ? AND stroj = ? AND stpost = ? " +
                        "ORDER BY cas";

                    cmd.Parameters.AddWithValue("@p1", ids);
                    cmd.Parameters.AddWithValue("@p2", sx);
                    cmd.Parameters.AddWithValue("@p3", stpost);

                    TimeSpan last = TimeSpan.Zero;

                    using (var r = cmd.ExecuteReader())
                    {
                        while (r.Read())
                        {
                            var v = r["cas"];
                            if (v == null || v == DBNull.Value) continue;

                            if (v is DateTime dt) last = dt.TimeOfDay;
                            else if (TimeSpan.TryParse(v.ToString(), out var ts)) last = ts;
                            else if (DateTime.TryParse(v.ToString(), out var dt2)) last = dt2.TimeOfDay;
                        }
                    }

                    return last;
                }
            }
            catch
            {
                return TimeSpan.Zero;
            }
        }

        public static TimeSpan TryGetTmlCas(int premer, OleDbConnection openConn)
        {
            using (var cmd = openConn.CreateCommand())
            {
                cmd.CommandText = "SELECT TOP 1 [èas] FROM tmlmeritve WHERE premer = ? ORDER BY [èas] DESC";
                cmd.Parameters.AddWithValue("@p1", premer);

                var v = cmd.ExecuteScalar();
                if (v == null || v == DBNull.Value) return TimeSpan.Zero;

                if (v is DateTime dt)
                    return (dt.Date < DateTime.Today) ? TimeSpan.Zero : dt.TimeOfDay;

                if (DateTime.TryParse(v.ToString(), out var dt2))
                    return (dt2.Date < DateTime.Today) ? TimeSpan.Zero : dt2.TimeOfDay;

                return TimeSpan.Zero;
            }
        }

        public static List<GrafiForm.GrafPoint> FetchGrafPoints(string koda, string karakt)
        {
            var list = new List<GrafiForm.GrafPoint>();

            string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;
            using (var conn = new OleDbConnection(connStr))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText =
                    "SELECT TOP 31 gm.idmer, gm.datum, AVG(km.vrednost) AS vrednost " +
                    "FROM Glavmer gm " +
                    "INNER JOIN Karmer km ON km.idmer = gm.idmer " +
                    "WHERE LTRIM(RTRIM(gm.koda)) = ? " +
                    "  AND LTRIM(RTRIM(km.karakt)) = ? " +
                    "  AND km.vrednost IS NOT NULL " +
                    "GROUP BY gm.idmer, gm.datum " +
                    "ORDER BY gm.datum DESC";

                cmd.Parameters.AddWithValue("@p1", (koda ?? "").Trim());
                cmd.Parameters.AddWithValue("@p2", (karakt ?? "").Trim());

                conn.Open();
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        var dt = Convert.ToDateTime(r["datum"]);
                        var v = Convert.ToDouble(r["vrednost"]);
                        list.Add(new GrafiForm.GrafPoint { When = dt, Value = v });
                    }
                }
            }

            list.Reverse();

            for (int i = 0; i < list.Count; i++)
                list[i].Vzorec = i + 1;

            return list;
        }

        public static string GetImeKTFromPostajeOrEmpty(int stpost)
        {
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;
                using (var conn = new OleDbConnection(connStr))
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "SELECT TOP 1 imekt FROM postaje WHERE stpost = ?";
                    cmd.Parameters.AddWithValue("@p1", stpost);
                    conn.Open();
                    var v = cmd.ExecuteScalar();
                    return (v == null || v == DBNull.Value) ? "" : v.ToString().Trim();
                }
            }
            catch { return ""; }
        }

        public static List<string> GetDodatKodNazivi(string kd)
        {
            var list = new List<string>();
            string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;

            using (var conn = new OleDbConnection(connStr))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText = "SELECT naziv FROM dodatkod WHERE koda = ? ORDER BY zaopored";
                cmd.Parameters.AddWithValue("@p1", (kd ?? "").Replace("-", "").Trim());

                conn.Open();
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        var naziv = r["naziv"] == DBNull.Value ? "" : r["naziv"].ToString().Trim();
                        if (!string.IsNullOrWhiteSpace(naziv))
                            list.Add(naziv);
                    }
                }
            }

            return list;
        }

        public static List<string> GetDodatneOpredelitveNazivi(string koda)
        {
            MessageBox.Show(koda);

            var list = new List<string>();
            var connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"]?.ConnectionString;
            using (var conn = new OleDbConnection(connStr))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText = "SELECT naziv FROM dodatkod WHERE koda = ? ORDER BY zaopored";
                cmd.Parameters.AddWithValue("@p1", koda);
                conn.Open();
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                        list.Add((r[0]?.ToString() ?? "").Trim());
                }
            }
            MessageBox.Show(list.Count.ToString());

            return list;
        }

        public static List<string> GetUkrepiForPost(int idpost)
        {
            var list = new List<string>();

            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;

                using (var conn = new OleDbConnection(connStr))
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "SELECT ukrep FROM ukrepi WHERE idpost = ? ORDER BY idukr";
                    cmd.Parameters.AddWithValue("@p1", idpost);

                    conn.Open();
                    using (var r = cmd.ExecuteReader())
                    {
                        while (r.Read())
                        {
                            var s = r["ukrep"] == DBNull.Value ? "" : r["ukrep"].ToString();
                            s = (s ?? "").Trim();
                            if (!string.IsNullOrWhiteSpace(s))
                                list.Add(s);
                        }
                    }
                }
            }
            catch
            {
            }

            return list;
        }
    }
}
