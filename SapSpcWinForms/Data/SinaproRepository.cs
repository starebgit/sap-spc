using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.OleDb;

namespace SapSpcWinForms.Data
{
    public static class SinaproRepository
    {
        public static bool PreveriStroj(int idstroja)
        {
            try
            {
                string sinaproConnStr = ConfigurationManager.ConnectionStrings["SinaproDb"].ConnectionString;
                using (var conn = new OleDbConnection(sinaproConnStr))
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "SELECT TOP 1 cas_zacetek, cas_zast_zacetek FROM t_del_stanjestroj WHERE st_stroj_ID = ? AND st_podjetje_ID = '1060'";
                    cmd.Parameters.AddWithValue("@st_stroj_ID", idstroja);
                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            var cas_zacetek = reader["cas_zacetek"];
                            var cas_zast_zacetek = reader["cas_zast_zacetek"];
                            if (cas_zacetek != DBNull.Value && (cas_zast_zacetek == DBNull.Value))
                                return true;
                        }
                    }
                }
            }
            catch { }
            return false;
        }

        public static List<string> GetSinaproKodaListForMachine(int strojId)
        {
            var list = new List<string>();
            string sinaproConnStr = ConfigurationManager.ConnectionStrings["SinaproDb"].ConnectionString;

            using (var conn = new OleDbConnection(sinaproConnStr))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText =
                    "SELECT TOP 50 t.klasifikacija " +
                    "FROM ( " +
                    "   SELECT iz.klasifikacija AS klasifikacija, MAX(ss.cas_zacetek) AS last_time " +
                    "   FROM (((t_del_stanjestroj ss " +
                    "       INNER JOIN t_del_stanjeoperacija so ON so.t_delstanjestroj_ID = ss.t_delstanjestroj_ID) " +
                    "       INNER JOIN t_pod_caslistvsi cv ON cv.st_caslist_ID = so.st_caslist_ID) " +
                    "       INNER JOIN t_pod_delnalog dn ON dn.st_delnal_ID = cv.st_delnal_ID) " +
                    "       INNER JOIN t_pod_izdelek iz ON iz.st_izdelek_ID = dn.st_izdelek_ID " +
                    "   WHERE ss.st_stroj_ID = ? " +
                    "     AND ss.st_podjetje_ID = '1060' " +
                    "     AND ss.cas_zacetek >= ? " +
                    "   GROUP BY iz.klasifikacija " +
                    ") t " +
                    "WHERE t.klasifikacija IS NOT NULL AND LTRIM(RTRIM(t.klasifikacija)) <> '' " +
                    "ORDER BY t.last_time DESC";

                cmd.Parameters.AddWithValue("@p1", strojId);
                cmd.Parameters.AddWithValue("@p2", DateTime.Today.AddDays(-3));

                conn.Open();
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        var k = r["klasifikacija"] == DBNull.Value ? "" : r["klasifikacija"].ToString();
                        if (!string.IsNullOrWhiteSpace(k))
                            list.Add(k.Trim());
                    }
                }
            }

            return list;
        }

        public static string GetOperatorNameFromSinapro(int strojId)
        {
            string sinaproConnStr = ConfigurationManager.ConnectionStrings["SinaproDb"].ConnectionString;

            using (var conn = new OleDbConnection(sinaproConnStr))
            {
                conn.Open();

                string stanjId = null;
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText =
                        "SELECT TOP 1 t_delstanjestroj_ID " +
                        "FROM t_del_stanjestroj " +
                        "WHERE st_stroj_ID = ? AND cas_zacetek >= ? AND st_podjetje_ID = '1060' AND cas_zast_zacetek IS NULL " +
                        "ORDER BY cas_zacetek DESC";

                    cmd.Parameters.Add("p1", OleDbType.Integer).Value = strojId;
                    cmd.Parameters.Add("p2", OleDbType.Date).Value = DateTime.Today.AddDays(-3);

                    var v = cmd.ExecuteScalar();
                    if (v == null || v == DBNull.Value) return string.Empty;
                    stanjId = v.ToString();
                }

                string delavecId = null;
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText =
                        "SELECT TOP 1 st_delavec_ID " +
                        "FROM t_del_stanjedelavec " +
                        "WHERE t_delstanjestroj_ID = ? AND st_podjetje_ID = '1060'";

                    cmd.Parameters.Add("p1", OleDbType.VarWChar).Value = stanjId;

                    var v = cmd.ExecuteScalar();
                    if (v == null || v == DBNull.Value) return string.Empty;
                    delavecId = v.ToString();
                }

                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText =
                        "SELECT TOP 1 naz_ime, naz_priimek " +
                        "FROM t_pod_delavec " +
                        "WHERE st_delavec_ID = ?";

                    cmd.Parameters.Add("p1", OleDbType.VarWChar).Value = delavecId;

                    using (var r = cmd.ExecuteReader())
                    {
                        if (!r.Read()) return string.Empty;

                        var ime = r["naz_ime"] == DBNull.Value ? "" : r["naz_ime"].ToString();
                        var pri = r["naz_priimek"] == DBNull.Value ? "" : r["naz_priimek"].ToString();
                        return (ime + " " + pri).Trim();
                    }
                }
            }
        }
    }
}
