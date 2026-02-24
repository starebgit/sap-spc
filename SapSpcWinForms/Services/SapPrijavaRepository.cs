using System;
using System.Configuration;
using System.Data.OleDb;

namespace SapSpcWinForms
{
    public sealed class SapPrijava
    {
        public int Ident { get; set; }
        public string Uporab { get; set; }
        public string Sistem { get; set; }
        public string Client { get; set; }
        public string Streznik { get; set; }
        public int Sysnnum { get; set; }
        public string Pass { get; set; }
        public string Jezik { get; set; }
        public bool Glavni { get; set; }
    }

    public sealed class SapPrijavaRepository
    {
        private readonly string _connStr =
            ConfigurationManager.ConnectionStrings["SapPrijavaDb"].ConnectionString;

        public SapPrijava GetDefault()
            => GetOne("glavni = 'X'");

        public SapPrijava GetByIdent(int ident)
            => GetOne("ident = ?", cmd => cmd.Parameters.AddWithValue("@p1", ident));

        private SapPrijava GetOne(string whereSql, Action<OleDbCommand> addParams = null)
        {
            using (var conn = new OleDbConnection(_connStr))
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText =
                    "SELECT TOP 1 ident, uporab, sistem, client, streznik, sysnnum, pass, jezik, glavni " +
                    "FROM prijava " +
                    "WHERE " + whereSql + " " +
                    "ORDER BY ident";

                addParams?.Invoke(cmd);

                conn.Open();
                using (var r = cmd.ExecuteReader())
                {
                    if (r == null || !r.Read()) return null;

                    return new SapPrijava
                    {
                        Ident = r["ident"] == DBNull.Value ? 0 : Convert.ToInt32(r["ident"]),
                        Uporab = r["uporab"] == DBNull.Value ? "" : r["uporab"].ToString(),
                        Sistem = r["sistem"] == DBNull.Value ? "" : r["sistem"].ToString(),
                        Client = r["client"] == DBNull.Value ? "" : r["client"].ToString(),
                        Streznik = r["streznik"] == DBNull.Value ? "" : r["streznik"].ToString(),
                        Sysnnum = r["sysnnum"] == DBNull.Value ? 0 : Convert.ToInt32(r["sysnnum"]),
                        Pass = r["pass"] == DBNull.Value ? "" : r["pass"].ToString(),
                        Jezik = r["jezik"] == DBNull.Value ? "" : r["jezik"].ToString(),
                        Glavni = (r["glavni"] != DBNull.Value) && (r["glavni"].ToString().Trim().Equals("X", StringComparison.OrdinalIgnoreCase))
                    };
                }
            }
        }
    }
}
