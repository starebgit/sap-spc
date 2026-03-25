using System;
using System.Collections.Generic;
using System.Configuration;
using SapSpcWinForms.Data;
using System.Data.OleDb;
using System.Globalization;
using System.Text.RegularExpressions;
using SAP.Middleware.Connector;
using SapSpcWinForms.Services;

namespace SapSpcWinForms
{
    public sealed class SapService
    {
        // Helper: safe get string by field name from IRfcStructure (compatible with C# 7.3)
        private static string SafeGetField(IRfcStructure r, string name)
        {
            try { return r.GetString(name); }
            catch (Exception ex)
            {
                DiagnosticLog.Warn($"SapService.SafeGetField.{name}", ex);
                return "";
            }
        }

        // Helper: dump selected fields from a structure
        private static string DumpStructFields(IRfcStructure s, params string[] names)
        {
            if (s == null) return "<null>";
            var sb = new System.Text.StringBuilder();
            foreach (var n in names)
            {
                try
                {
                    var v = s.GetString(n);
                    sb.AppendLine($"{n} = '{v}'");
                }
                catch (Exception ex)
                {
                    sb.AppendLine($"{n} = <ERR: {ex.Message}>");
                }
            }
            return sb.ToString();
        }

        // Helper: dump RETURN and RETURNTABLE from a function
        private static string DumpReturn(IRfcFunction fn)
        {
            var sb = new System.Text.StringBuilder();

            try
            {
                var ret = fn.GetStructure("RETURN");
                sb.AppendLine($"RETURN.TYPE='{ret.GetString("TYPE")}', ID='{ret.GetString("ID")}', NO='{ret.GetString("NUMBER")}'");
                sb.AppendLine($"RETURN.MESSAGE='{ret.GetString("MESSAGE")}'");
            }
            catch (Exception ex)
            {
                DiagnosticLog.Warn("SapService.DumpReturn.RETURN", ex);
                sb.AppendLine("RETURN: <missing>");
            }

            try
            {
                var tab = fn.GetTable("RETURNTABLE");
                sb.AppendLine($"RETURNTABLE rows={tab.RowCount}");
                for (int i = 0; i < tab.RowCount; i++)
                {
                    var r = tab[i];
                    // field names differ by system; these 4 usually exist
                    sb.AppendLine($"{i + 1}: TYPE='{SafeGetField(r, "TYPE")}' ID='{SafeGetField(r, "ID")}' NO='{SafeGetField(r, "NUMBER")}' MSG='{SafeGetField(r, "MESSAGE")}'");
                }
            }
            catch (Exception ex)
            {
                DiagnosticLog.Warn("SapService.DumpReturn.RETURNTABLE", ex);
                sb.AppendLine("RETURNTABLE: <missing>");
            }

            return sb.ToString();
        }

        private static int? ExtractRejectedValueNumber(string message)
        {
            if (string.IsNullOrWhiteSpace(message)) return null;
            var m = Regex.Match(message, @"vrednost\s+0*(\d+)", RegexOptions.IgnoreCase);
            if (!m.Success) return null;
            return int.TryParse(m.Groups[1].Value, out var n) ? n : (int?)null;
        }

        private static void LogRejectedValueCandidates(IRfcTable singleResults, IRfcTable sampleResults, int rejectedNo)
        {
            try
            {
                var token = rejectedNo.ToString("D4");
                var lines = new List<string>();

                if (singleResults != null)
                {
                    for (int i = 0; i < singleResults.RowCount; i++)
                    {
                        var r = singleResults[i];
                        var resNo = SafeGetField(r, "RES_NO").Trim();
                        var inspSample = SafeGetField(r, "INSPSAMPLE").Trim();
                        if (string.Equals(resNo, token, StringComparison.OrdinalIgnoreCase) ||
                            string.Equals(inspSample, token, StringComparison.OrdinalIgnoreCase))
                        {
                            lines.Add($"SINGLE_RESULTS row={i + 1} INSPCHAR='{SafeGetField(r, "INSPCHAR").Trim()}' INSPSAMPLE='{inspSample}' RES_NO='{resNo}'");
                        }
                    }
                }

                if (sampleResults != null)
                {
                    for (int i = 0; i < sampleResults.RowCount; i++)
                    {
                        var r = sampleResults[i];
                        var inspSample = SafeGetField(r, "INSPSAMPLE").Trim();
                        if (string.Equals(inspSample, token, StringComparison.OrdinalIgnoreCase))
                        {
                            lines.Add($"SAMPLE_RESULTS row={i + 1} INSPCHAR='{SafeGetField(r, "INSPCHAR").Trim()}' INSPSAMPLE='{inspSample}'");
                        }
                    }
                }

                if (lines.Count > 0)
                    DiagnosticLog.Warn("SapService.Zapis.RejectedValueCandidates", string.Join(Environment.NewLine, lines));
                else
                    DiagnosticLog.Warn("SapService.Zapis.RejectedValueCandidates", $"No candidate rows found for token '{token}'.");
            }
            catch (Exception ex)
            {
                DiagnosticLog.Warn("SapService.Zapis.RejectedValueCandidates", ex);
            }
        }

        // Delphi: beriOperac(srz, ListOpr)
        public List<string> BeriOperac(string srz)
        {
            if (string.IsNullOrWhiteSpace(srz)) return new List<string>();

            var dest = SapSession.GetDestination();
            var f = dest.Repository.CreateFunction("BAPI_INSPLOT_GETOPERATIONS");
            f.SetValue("NUMBER", srz.Trim());
            f.Invoke(dest);

            var ops = new List<string>();
            var tab = SafeGetTable(f, "INSPOPER_LIST");
            if (tab == null) return ops;

            foreach (IRfcStructure row in tab)
            {
                // Delphi used column 2; typical field name is INSPOPER
                var op = GetString(row, "INSPOPER", fallbackIndex: 1);
                if (!string.IsNullOrWhiteSpace(op))
                    ops.Add(op.Trim());
            }

            return ops;
        }

        // Delphi: preveriSar(srz)
        public bool PreveriSar(string srz)
        {
            if (string.IsNullOrWhiteSpace(srz)) return false;

            var dest = SapSession.GetDestination();
            var f = dest.Repository.CreateFunction("BAPI_INSPLOT_GETDETAIL");
            f.SetValue("NUMBER", srz.Trim());
            // Delphi set LANGUAGE; with NCo your connection language is already set -> OK to omit.
            f.Invoke(dest);

            var statusTab = SafeGetTable(f, "SYSTEM_STATUS");
            if (statusTab == null) return false;

            return SarzaKontrol(statusTab);
        }

        // Delphi: GetKonsarza(kd, dat, preve, listsrz)
        public List<string> GetKonsarza(string kd, DateTime dat, bool preve, string ktex = null)
        {
            var result = new List<string>();
            if (string.IsNullOrWhiteSpace(kd)) return result;

            var dest = SapSession.GetDestination();
            var f = dest.Repository.CreateFunction("BAPI_INSPLOT_GETLIST");

            f.SetValue("MATERIAL", Koda18(kd.Trim()));
            f.SetValue("PLANT", SapSession.GetPlant());
            f.SetValue("CREAT_DAT", dat.ToString("yyyyMMdd"));   // DATS as YYYYMMDD string

            f.SetValue("STATUS_UD", "");
            f.SetValue("STATUS_RELEASED", "X");
            f.SetValue("STATUS_CREATED", "X");

            f.Invoke(dest);

            var tab = SafeGetTable(f, "INSPLOT_LIST");
            if (tab == null) return result;

            foreach (IRfcStructure row in tab)
            {
                // Delphi: srz := tabc.value[j,1]
                var srz = GetString(row, "INSPLOT", fallbackIndex: 0);
                if (string.IsNullOrWhiteSpace(srz)) continue;

                bool b1 = true;

                if (preve)
                {
                    // Delphi: saptex := tabc.value[j,12]; if copy(saptex,1,2)='MM' ...
                    // Field name might differ; SHORT_TEXT is common.
                    var saptex = GetString(row, "SHORT_TEXT", fallbackIndex: 11);
                    if (!string.IsNullOrEmpty(saptex) && saptex.StartsWith("MM", StringComparison.OrdinalIgnoreCase))
                        b1 = true;
                    else
                        b1 = string.IsNullOrEmpty(ktex); // approx of Delphi branch without Fpostaje.gettex
                }

                if (b1 && PreveriSar(srz))
                    result.Add(srz.Trim());
            }

            return result;
        }



        public bool TryFetchSarzaFromSapAndCache(string kd, int idpost, out string srz, out string error)
        {
            srz = null;
            error = null;

            try
            {
                var ktex = StrojnaDbRepository.GetImeKTFromPostajeOrEmpty(idpost);
                var sarze = GetKonsarza(kd, new DateTime(2018, 1, 1), true, ktex) ?? new List<string>();

                if (sarze.Count != 1)
                {
                    error = "Izbrana koda nima kontrolne are.\nProsim kontaktiraj administratorja programa.";
                    return false;
                }

                srz = (sarze[0] ?? "").Trim();
                if (string.IsNullOrWhiteSpace(srz))
                {
                    error = "SAP je vrnil neveljavno kontrolno aro.";
                    return false;
                }

                var idsar = InsertKonsarFromFallback(kd, srz, idpost);
                if (idsar <= 0)
                {
                    error = "Neuspeen zapis kontrolne are v lokalno bazo.";
                    return false;
                }

                ImportKonplanFromSap(idsar, srz, idpost);
                return true;
            }
            catch (Exception ex)
            {
                error = "Napaka pri prenosu kontrolne are iz SAP:\n" + ex.Message;
                return false;
            }
        }

        private int InsertKonsarFromFallback(string kd, string srz, int idpost)
        {
            const int defaultIntervalDiffMinutes = 120;
            const int defaultIntervalTrajMinutes = 15;

            string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;

            using (var conn = new OleDbConnection(connStr))
            {
                conn.Open();

                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText =
                        "INSERT INTO konsar (koda, sarza, idpost, merdiff, mertraj, koncan) VALUES (?,?,?,?,?,?)";

                    cmd.Parameters.AddWithValue("@p1", kd ?? "");
                    cmd.Parameters.AddWithValue("@p2", srz ?? "");
                    cmd.Parameters.AddWithValue("@p3", idpost);
                    cmd.Parameters.AddWithValue("@p4", defaultIntervalDiffMinutes);
                    cmd.Parameters.AddWithValue("@p5", defaultIntervalTrajMinutes);
                    cmd.Parameters.AddWithValue("@p6", "");

                    cmd.ExecuteNonQuery();
                }

                using (var idCmd = conn.CreateCommand())
                {
                    idCmd.CommandText = "SELECT @@IDENTITY";
                    return Convert.ToInt32(idCmd.ExecuteScalar());
                }
            }
        }

        private void ImportKonplanFromSap(int idsar, string srz, int idpost)
        {
            var (variabilne, atributivne) = GetKarakt("", srz);
            string connStr = ConfigurationManager.ConnectionStrings["StrojnaDb"].ConnectionString;

            using (var conn = new OleDbConnection(connStr))
            {
                conn.Open();

                foreach (var p in variabilne ?? new List<SapKaraktVar>())
                {
                    using (var cmd = conn.CreateCommand())
                    {
                        cmd.CommandText =
                            "INSERT INTO konplan (idsar, tip, pozicija, naziv, predpis, spmeja, zgmeja, kanal, stvz, stkanal, operacija) " +
                            "VALUES (?,?,?,?,?,?,?,?,?,?,?)";

                        cmd.Parameters.AddWithValue("@p1", idsar);
                        cmd.Parameters.AddWithValue("@p2", 1);
                        cmd.Parameters.AddWithValue("@p3", p?.poz ?? "");
                        cmd.Parameters.AddWithValue("@p4", p?.naziv ?? "");
                        cmd.Parameters.AddWithValue("@p5", ParseDoubleOrDefault(p?.predpis, 0));
                        cmd.Parameters.AddWithValue("@p6", ParseNullableDoubleOrDbNull(p?.spmeja));
                        cmd.Parameters.AddWithValue("@p7", ParseNullableDoubleOrDbNull(p?.zgmeja));
                        cmd.Parameters.AddWithValue("@p8", p?.metoda ?? "");
                        cmd.Parameters.AddWithValue("@p9", p?.stevVz ?? 1);
                        cmd.Parameters.AddWithValue("@p10", GetStKanalForMetoda(conn, idpost, p?.metoda));
                        cmd.Parameters.AddWithValue("@p11", p?.operac ?? "0010");

                        cmd.ExecuteNonQuery();
                    }
                }

                foreach (var p in atributivne ?? new List<SapAtribVar>())
                {
                    using (var cmd = conn.CreateCommand())
                    {
                        cmd.CommandText =
                            "INSERT INTO konplan (idsar, tip, pozicija, naziv, stvz, operacija) VALUES (?,?,?,?,?,?)";

                        cmd.Parameters.AddWithValue("@p1", idsar);
                        cmd.Parameters.AddWithValue("@p2", 2);
                        cmd.Parameters.AddWithValue("@p3", p?.poz ?? "");
                        cmd.Parameters.AddWithValue("@p4", p?.naziv ?? "");
                        cmd.Parameters.AddWithValue("@p5", p?.stevVz ?? 1);
                        cmd.Parameters.AddWithValue("@p6", p?.operac ?? "0010");

                        cmd.ExecuteNonQuery();
                    }
                }
            }
        }

        private int GetStKanalForMetoda(OleDbConnection conn, int idpost, string metoda)
        {
            if (conn == null || string.IsNullOrWhiteSpace(metoda)) return 0;

            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText = "SELECT TOP 1 kanal FROM metode WHERE idpost = ? AND metoda = ?";
                cmd.Parameters.AddWithValue("@p1", idpost);
                cmd.Parameters.AddWithValue("@p2", metoda);

                var v = cmd.ExecuteScalar();
                if (v == null || v == DBNull.Value) return 0;
                return int.TryParse(v.ToString(), out var kanal) ? kanal : 0;
            }
        }

        private static double ParseDoubleOrDefault(string value, double fallback)
        {
            if (string.IsNullOrWhiteSpace(value)) return fallback;
            return double.TryParse(value.Replace(',', '.'), NumberStyles.Any, CultureInfo.InvariantCulture, out var d)
                ? d
                : fallback;
        }

        private static object ParseNullableDoubleOrDbNull(string value)
        {
            if (string.IsNullOrWhiteSpace(value)) return DBNull.Value;
            return double.TryParse(value.Replace(',', '.'), NumberStyles.Any, CultureInfo.InvariantCulture, out var d)
                ? (object)d
                : DBNull.Value;
        }

        // Delphi: SarzaKontrol(tab)
        private static bool SarzaKontrol(IRfcTable tab)
        {
            int ix = 0;

            foreach (IRfcStructure row in tab)
            {
                // Delphi used column 2 for DOPS/LANS/KAKK/SERS; also column 1 had I0224 in other code.
                var token = GetStatusToken(row);

                if (Equals4(token, "DOPS")) ix++;
                if (Equals4(token, "LANS")) ix++;
                if (Equals4(token, "KAKK")) ix++;
                if (Equals4(token, "SERS")) ix--;
            }

            return ix == 3;
        }

        private static bool Equals4(string a, string b)
            => string.Equals(a?.Trim(), b, StringComparison.OrdinalIgnoreCase);

        private static string GetStatusToken(IRfcStructure row)
        {
            // Try common names first, then fallback to "2nd column" like Delphi
            var s =
                GetString(row, "STAT", null) ??
                GetString(row, "STATUS", null) ??
                GetString(row, "USER_STATUS", null) ??
                GetString(row, "USTAT", null);

            if (!string.IsNullOrWhiteSpace(s)) return s;

            // fallback: Delphi tab.value[ii,2] => index 1
            try
            {
                if (row.Metadata.FieldCount > 1)
                    return row.GetString(1);
            }
            catch { /* ignore */ }

            return "";
        }

        private static IRfcTable SafeGetTable(IRfcFunction f, string tableName)
        {
            try { return f.GetTable(tableName); }
            catch { return null; }
        }

        private static string GetString(IRfcStructure row, string fieldName, int? fallbackIndex)
        {
            if (row == null) return null;

            if (!string.IsNullOrWhiteSpace(fieldName))
            {
                var md = row.Metadata;
                for (int i = 0; i < md.FieldCount; i++)
                {
                    // Name match without throwing exceptions
                    if (string.Equals(md[i].Name, fieldName, StringComparison.OrdinalIgnoreCase))
                        return row.GetString(i);
                }
            }

            if (fallbackIndex.HasValue)
            {
                var idx = fallbackIndex.Value;
                if (idx >= 0 && idx < row.Metadata.FieldCount)
                    return row.GetString(idx);
            }

            return null;
        }

        // Delphi: Koda18(kd)
        private static string Koda18(string kd)
        {
            if (string.IsNullOrWhiteSpace(kd)) return "";

            kd = kd.Replace(".", "").Trim();
            while (kd.StartsWith("-", StringComparison.Ordinal)) kd = kd.Substring(1);

            int slash = kd.IndexOf('/');
            if (slash > 0)
            {
                var left = kd.Substring(0, slash);
                var right = kd.Substring(slash + 1);
                right = right.Length >= 2 ? right.Substring(0, 2) : right.PadRight(2, '0');
                kd = "0000" + left + "00" + right;
            }
            else
            {
                int dash = kd.IndexOf('-');
                if (dash > 0)
                {
                    kd = kd.Replace("-", "");
                    kd = "0000" + kd.Trim() + "00";
                }
                else
                {
                    kd = "0000" + kd + "0000";
                }
            }

            while (kd.Length < 18) kd = "0" + kd;
            if (kd.Length > 18) kd = kd.Substring(kd.Length - 18); // safety
            return kd;
        }

        // Delphi: getkarakt(kd,srz,listkar1,listkar2)
        public (List<SapKaraktVar> variabilne, List<SapAtribVar> atributivne) GetKarakt(string kd, string srz)
        {
            var variabilne = new List<SapKaraktVar>();
            var atributivne = new List<SapAtribVar>();

            if (string.IsNullOrWhiteSpace(srz))
                return (variabilne, atributivne);

            var ops = BeriOperac(srz.Trim());
            if (ops.Count == 0)
                return (variabilne, atributivne);

            var dest = SapSession.GetDestination();

            foreach (var opr in ops)
            {
                var f = dest.Repository.CreateFunction("BAPI_INSPOPER_GETDETAIL");
                f.SetValue("INSPLOT", srz.Trim());
                f.SetValue("INSPOPER", opr.Trim());

                // Delphi flags
                f.SetValue("READ_INSPPOINTS", "X");
                f.SetValue("READ_CHAR_REQUIREMENTS", "X");

                f.Invoke(dest);

                var tabl = SafeGetTable(f, "CHAR_REQUIREMENTS");
                if (tabl == null) continue;

                foreach (IRfcStructure row in tabl)
                {
                    // Delphi: tabl.value[j,6] = '01'
                    var tip = GetString(row, "CHAR_TYPE", fallbackIndex: 5) ?? "";

                    var poz   = GetString(row, "INSPCHAR", fallbackIndex: 2) ?? "";
                    var naziv = GetString(row, "CHAR_DESCR", fallbackIndex: 4) ?? "";

                    // Delphi indexes: 14,23,43,44,45 => 0-based: 13,22,42,43,44
                    var stevVz = GetInt(row, "SAMPLE_SIZE", fallbackIndex: 13);
                    var metoda = GetString(row, "METHOD", fallbackIndex: 22) ?? "";

                    if (string.Equals(tip.Trim(), "01", StringComparison.OrdinalIgnoreCase))
                    {
                        variabilne.Add(new SapKaraktVar
                        {
                            poz = poz.Trim(),
                            naziv = naziv.Trim(),
                            spmeja = (GetString(row, "LOWER_LIMIT", fallbackIndex: 44) ?? "").Trim(),
                            zgmeja = (GetString(row, "UPPER_LIMIT", fallbackIndex: 43) ?? "").Trim(),
                            predpis = (GetString(row, "TARGET_VALUE", fallbackIndex: 42) ?? "").Trim(),
                            metoda = metoda.Trim(),
                            operac = opr.Trim(),
                            stevVz = stevVz
                        });
                    }
                    else
                    {
                        atributivne.Add(new SapAtribVar
                        {
                            poz = poz.Trim(),
                            naziv = naziv.Trim(),
                            operac = opr.Trim(),
                            stevVz = stevVz
                        });
                    }
                }
            }

            return (variabilne, atributivne);
        }

        private static int GetInt(IRfcStructure row, string fieldName, int? fallbackIndex)
        {
            if (row == null) return 0;

            int idx = -1;

            if (!string.IsNullOrWhiteSpace(fieldName))
            {
                var md = row.Metadata;
                for (int i = 0; i < md.FieldCount; i++)
                {
                    if (string.Equals(md[i].Name, fieldName, StringComparison.OrdinalIgnoreCase))
                    {
                        idx = i;
                        break;
                    }
                }
            }

            if (idx < 0 && fallbackIndex.HasValue) idx = fallbackIndex.Value;
            if (idx < 0 || idx >= row.Metadata.FieldCount) return 0;

            // read as string first (SAP NUMC/CHAR), then parse
            var s = row.GetString(idx);
            return int.TryParse((s ?? "").Trim(), out var n) ? n : 0;
        }

        // ===== Delphi-style helpers (1-based safe field indexing) =====
        private static IRfcTable SafeGetTable(IRfcFunction f, string tableName, bool ignore)
        {
            // overload shim to avoid signature conflict if needed
            try { return f.GetTable(tableName); }
            catch { return null; }
        }

        private static IRfcStructure SafeGetStructure(IRfcFunction f, string name)
        {
            try { return f.GetStructure(name); }
            catch { return null; }
        }

        private static string GetString1(IRfcStructure row, int oneBasedFieldIndex)
        {
            if (row == null) return "";
            int idx = oneBasedFieldIndex - 1;
            if (idx < 0 || idx >= row.Metadata.FieldCount) return "";
            try { return row.GetString(idx) ?? ""; }
            catch { return ""; }
        }

        private static int GetInt1(IRfcStructure row, int oneBasedFieldIndex)
        {
            var s = GetString1(row, oneBasedFieldIndex);
            return int.TryParse((s ?? "").Trim(), out var v) ? v : 0;
        }

        private static void SetValue1(IRfcStructure row, int oneBasedFieldIndex, object value)
        {
            if (row == null) return;
            int idx = oneBasedFieldIndex - 1;
            if (idx < 0 || idx >= row.Metadata.FieldCount) return;
            try { row.SetValue(idx, value ?? ""); }
            catch { /* ignore */ }
        }

        private static string DumpPreviewRows(IRfcTable table, int maxRows = 12)
        {
            if (table == null) return "<null>";

            var md = table.Metadata?.LineType;
            if (md == null) return "<no metadata>";

            var sb = new System.Text.StringBuilder();
            sb.AppendLine($"rows={table.RowCount}, showing up to {maxRows}");

            int rows = Math.Min(table.RowCount, Math.Max(0, maxRows));
            for (int i = 0; i < rows; i++)
            {
                var r = table[i];
                sb.Append($"#{i + 1}: ");

                for (int c = 0; c < md.FieldCount; c++)
                {
                    var name = md[c].Name;
                    string v;
                    try { v = (r.GetString(c) ?? "").Trim(); }
                    catch { v = "<err>"; }

                    if (v.Length > 80) v = v.Substring(0, 80) + "...";
                    sb.Append(name).Append("='").Append(v).Append("' ");
                }

                sb.AppendLine();
            }

            return sb.ToString();
        }

        private static bool TryParseSapDate(string sapDats, out DateTime dt)
        {
            return DateTime.TryParseExact(
                (sapDats ?? "").Trim(),
                "yyyyMMdd",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None,
                out dt
            );
        }

        private static bool TryParseSapTime(string sapTims, out TimeSpan ts)
        {
            ts = default;

            var s = (sapTims ?? "").Trim();
            if (s.Length != 6) return false;

            if (!int.TryParse(s.Substring(0, 2), out var h)) return false;
            if (!int.TryParse(s.Substring(2, 2), out var m)) return false;
            if (!int.TryParse(s.Substring(4, 2), out var sec)) return false;

            ts = new TimeSpan(h, m, sec);
            return true;
        }

        // ===== Delphi: Zapis(...) =====
        // Returns (ok, message)
        public (bool ok, string message) Zapis(
            string srz, string opr, string nazivp, string merl, string odl, string orod,
            DateTime dd, IReadOnlyList<SapKarMer> karlist, IReadOnlyList<SapEvaluac> evalList)
        {
            if (string.IsNullOrWhiteSpace(srz)) return (false, "srz is empty");
            if (string.IsNullOrWhiteSpace(opr)) return (false, "opr is empty");

            var dest = SapSession.GetDestination();
            var plant = SapSession.GetPlant();

            string dt = dd.ToString("yyyyMMdd");
            string tm = dd.ToString("HHmmss");

            var fn = dest.Repository.CreateFunction("BAPI_INSPOPER_RECORDRESULTS");

            fn.SetValue("INSPLOT", srz.Trim());
            fn.SetValue("INSPOPER", opr.Trim());

            var inspPointData = SafeGetStructure(fn, "INSPPOINTDATA");

            // Commented out intentionally: debug metadata dump created a StringBuilder that was
            // never consumed (no logging/output), so it is disabled to avoid dead debug code.
            // {
            //     var md = inspPointData.Metadata;
            //     var sb = new System.Text.StringBuilder();
            //     sb.AppendLine("INSPPOINTDATA field order (NCo):");
            //     for (int i = 0; i < md.FieldCount; i++)
            //     {
            //         var f = md[i];
            //         sb.AppendLine($"{i + 1,3}: {f.Name}  ({f.DataType}) len={f.NucLength}");
            //     }
            // }

            if (inspPointData == null) return (false, "Missing INSPPOINTDATA structure in BAPI_INSPOPER_RECORDRESULTS");

            // Delphi index-based filling (same positions as your reference snippet)
            SetValue1(inspPointData, 1, srz.Trim());
            SetValue1(inspPointData, 2, opr.Trim());
            SetValue1(inspPointData, 12, nazivp ?? "");
            SetValue1(inspPointData, 28, merl ?? "");
            SetValue1(inspPointData, 16, dt);
            SetValue1(inspPointData, 17, tm);
            SetValue1(inspPointData, 18, "3");
            SetValue1(inspPointData, 19, plant);
            // Name-based fields replacing Delphi indices 20-23
            inspPointData.SetValue("SEL_SET",  "A/R");         // Delphi (20)
            inspPointData.SetValue("CODE_GRP", "A/R");         // Delphi (21)
            inspPointData.SetValue("CODE",     (odl  ?? "").Trim());  // Delphi (22) len=4
            inspPointData.SetValue("REMARK",   (orod ?? "").Trim());  // Delphi (23)

            var charResults   = SafeGetTable(fn, "CHAR_RESULTS");
            var singleResults = SafeGetTable(fn, "SINGLE_RESULTS");
            var sampleResults = SafeGetTable(fn, "SAMPLE_RESULTS");

            if (charResults == null || singleResults == null || sampleResults == null)
                return (false, "Missing CHAR_RESULTS/SINGLE_RESULTS/SAMPLE_RESULTS tables in BAPI_INSPOPER_RECORDRESULTS");

            // Delphi mm counter (kept for parity)
            int mm = 1;

            for (int kk = 1; kk <= (karlist?.Count ?? 0); kk++)
            {
                var pv = karlist[kk - 1];
                string stkr = (pv?.stkar ?? "").Trim();
                string dbred = (pv?.eval ?? "A").Trim();
                string opom = (pv?.opom ?? "").Trim();
                string merit = (pv?.merit ?? "").Trim();
                string stip = (pv?.tip ?? "").Trim();
                string skpp = (pv?.skupi ?? "").Trim();

                // CHAR_RESULTS append
                charResults.Append();
                var cr = charResults[charResults.RowCount - 1];

                SetValue1(cr, 1, srz.Trim());
                SetValue1(cr, 2, opr.Trim());
                SetValue1(cr, 3, stkr);
                SetValue1(cr, 23, merl ?? "");
                SetValue1(cr, 25, opom);

                if (skpp == "X")
                {
                    // SINGLE_RESULTS append
                    singleResults.Append();
                    var sr = singleResults[singleResults.RowCount - 1];

                    SetValue1(sr, 1, srz.Trim());
                    SetValue1(sr, 2, opr.Trim());
                    SetValue1(sr, 3, stkr);
                    SetValue1(sr, 4, pv.stMer);
                    SetValue1(sr, 5, kk);
                    SetValue1(sr, 7, "X");
                    SetValue1(sr, 16, merl ?? "");

                    if (stip == "02")
                        SetValue1(sr, 13, dbred);
                    else
                        SetValue1(sr, 10, merit);

                    SetValue1(cr, 4, "X");
                    SetValue1(cr, 5, "X");
                    SetValue1(cr, 8, dbred);
                    SetValue1(cr, 15, merit);
                    SetValue1(cr, 25, opom);

                    // Delphi: end-of-sample marker => SAMPLE_RESULTS row
                    if (pv.stevnp == 1)
                    {
                        sampleResults.Append();
                        var smp = sampleResults[sampleResults.RowCount - 1];

                        SetValue1(smp, 1, srz.Trim());
                        SetValue1(smp, 2, opr.Trim());
                        SetValue1(smp, 3, stkr);
                        SetValue1(smp, 4, kk);
                        SetValue1(smp, 6, "X");
                        SetValue1(smp, 7, "X");
                        SetValue1(smp, 25, merl ?? "");
                        SetValue1(smp, 27, opom);
                        mm++;
                    }
                }
                else
                {
                    // Attribute mode: find evaluation summary like Delphi
                    string slabi = "0";
                    for (int ll = 0; ll < (evalList?.Count ?? 0); ll++)
                    {
                        var px = evalList[ll];
                        if (px != null && string.Equals((px.stkar ?? "").Trim(), stkr, StringComparison.OrdinalIgnoreCase))
                        {
                            dbred = (px.ev ?? "A").Trim();
                            slabi = px.st.ToString(CultureInfo.InvariantCulture);
                            break;
                        }
                    }

                    sampleResults.Append();
                    var smp = sampleResults[sampleResults.RowCount - 1];

                    SetValue1(smp, 1, srz.Trim());
                    SetValue1(smp, 2, opr.Trim());
                    SetValue1(smp, 3, stkr);
                    SetValue1(smp, 4, kk);
                    SetValue1(smp, 6, "X");
                    SetValue1(smp, 7, "X");
                    SetValue1(smp, 13, slabi);
                    SetValue1(smp, 25, merl ?? "");
                    SetValue1(smp, 27, opom);

                    if (stip == "02")
                    {
                        SetValue1(smp, 10, dbred);
                        SetValue1(smp, 28, dbred);
                        SetValue1(smp, 29, "A/R");
                    }
                    else
                    {
                        SetValue1(smp, 17, merit);
                    }

                    SetValue1(cr, 4, "X");
                    SetValue1(cr, 5, "X");
                    SetValue1(cr, 8, dbred);
                    SetValue1(cr, 13, slabi);
                    SetValue1(cr, 15, merit);
                    SetValue1(cr, 25, opom);

                    mm++;
                }
            }

            // Wrap in NCo stateful context: record + commit
            SAP.Middleware.Connector.RfcSessionManager.BeginContext(dest);
            try
            {
                DiagnosticLog.Info("SapService.Zapis.CHAR_RESULTS", DumpPreviewRows(charResults));
                DiagnosticLog.Info("SapService.Zapis.SINGLE_RESULTS", DumpPreviewRows(singleResults));
                DiagnosticLog.Info("SapService.Zapis.SAMPLE_RESULTS", DumpPreviewRows(sampleResults));

                fn.Invoke(dest);

                // RETURN structure check (Delphi: RETURN.value[1] == 'E')
                var ret = SafeGetStructure(fn, "RETURN");
                string typ = GetString1(ret, 1);

                // Prefer explicit text message over old "TYPE/MSGV1" short format.
                string msg = BuildSapReturnMessage(fn);

                if (string.Equals(typ, "E", StringComparison.OrdinalIgnoreCase))
                {
                    var detailedMsg = SafeGetField(retTab != null && retTab.RowCount > 0 ? retTab[0] : null, "MESSAGE");
                    var rejectedNo = ExtractRejectedValueNumber(detailedMsg);
                    if (rejectedNo.HasValue)
                        LogRejectedValueCandidates(singleResults, sampleResults, rejectedNo.Value);
                    return (false, msg ?? "SAP returned error (RETURN.TYPE='E').");
                }

                var commit = dest.Repository.CreateFunction("BAPI_TRANSACTION_COMMIT");
                commit.SetValue("WAIT", "X");
                commit.Invoke(dest);

                return (true, msg);
            }
            finally
            {
                SAP.Middleware.Connector.RfcSessionManager.EndContext(dest);
            }
        }

        // ===== Delphi: Getresult(anl, listr) =====
        public List<SapRezultat> GetResult(SapAnaliza anl)
        {
            var outList = new List<SapRezultat>();
            if (anl == null) return outList;

            var dest = SapSession.GetDestination();

            var fn = dest.Repository.CreateFunction("BAPI_INSPPOINT_GETLIST");
            fn.SetValue("INSPLOT", (anl.sarza ?? "").Trim());
            fn.SetValue("INSPOPER", (anl.operac ?? "").Trim());
            fn.Invoke(dest);

            var tabb = SafeGetTable(fn, "INSPPOINT_LIST");
            if (tabb == null) return outList;

            for (int ii = 0; ii < tabb.RowCount; ii++)
            {
                var row = tabb[ii];

                // Delphi: dt := tabb.value[ii,26]
                var dtStr = GetString1(row, 26);
                if (!TryParseSapDate(dtStr, out var dt))
                    continue;

                if (dt < anl.zacDat || dt > anl.konDat)
                    continue;

                // Delphi: kk := tabb.value[ii,3] -> INSPSAMPLE
                string inspsample = GetString1(row, 3);

                var fn2 = dest.Repository.CreateFunction("BAPI_INSPCHAR_GETRESULT");
                fn2.SetValue("INSPLOT", (anl.sarza ?? "").Trim());
                fn2.SetValue("INSPOPER", (anl.operac ?? "").Trim());
                fn2.SetValue("INSPCHAR", (anl.pozic ?? "").Trim());
                fn2.SetValue("INSPSAMPLE", (inspsample ?? "").Trim());
                fn2.Invoke(dest);

                var tabn = SafeGetTable(fn2, "SINGLE_RESULTS");
                if (tabn == null) continue;

                for (int jj = 0; jj < tabn.RowCount; jj++)
                {
                    var r = tabn[jj];

                    // Delphi: date := [8], time := [9], value := [10]
                    var dStr = GetString1(r, 8);
                    if (!TryParseSapDate(dStr, out var d))
                        d = dt;

                    var tStr = GetString1(r, 9);
                    var vStr = GetString1(r, 10);

                    if (!float.TryParse((vStr ?? "").Trim(), NumberStyles.Any, CultureInfo.InvariantCulture, out var vv))
                        vv = 0;

                    outList.Add(new SapRezultat
                    {
                        datum = d,
                        cas = TryParseSapTime(tStr, out var ts) ? ts : TimeSpan.Zero,
                        vrednost = vv,
                        vzorec = 0
                    });
                }
            }

            return outList;
        }

        // ===== OPTIONAL: overload that also returns stcl/stvp like Delphi =====
        public void GetKarakt(string kd, string srz,
            List<SapKaraktVar> variabilne, List<SapAtribVar> atributivne,
            out int stcl, out int stvp)
        {
            stcl = 0;
            stvp = 0;

            variabilne?.Clear();
            atributivne?.Clear();

            var (v, a) = GetKarakt(kd, srz);

            if (variabilne != null) variabilne.AddRange(v);
            if (atributivne != null) atributivne.AddRange(a);

            foreach (var x in v) stcl = Math.Max(stcl, x.stevVz);
            foreach (var x in a) stvp = Math.Max(stvp, x.stevVz);

            if (stcl <= 0) stcl = 1;
            if (stvp <= 0) stvp = 1;
        }
    }
}
