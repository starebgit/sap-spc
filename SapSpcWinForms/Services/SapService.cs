using System;
using System.Collections.Generic;
using System.Globalization;
using SAP.Middleware.Connector;

namespace SapSpcWinForms
{
    public sealed class SapKaraktVar
    {
        public string poz { get; set; }
        public string naziv { get; set; }
        public string spmeja { get; set; }
        public string zgmeja { get; set; }
        public string predpis { get; set; }
        public string metoda { get; set; }
        public string operac { get; set; }
        public int stevVz { get; set; }
    }

    public sealed class SapAtribVar
    {
        public string poz { get; set; }
        public string naziv { get; set; }
        public string operac { get; set; }
        public int stevVz { get; set; }
    }

    // ===== Added DTOs next to existing ones =====
    public sealed class SapKarMer
    {
        public string stkar { get; set; }     // characteristic number
        public string imeKar { get; set; }
        public int stMer { get; set; }        // measurement counter (Delphi StMer)
        public string skupi { get; set; }     // "X" => single entry
        public string tip { get; set; }       // "01" variable, "02" attribute
        public string merit { get; set; }     // value text
        public string eval { get; set; } = "A"; // "A" or "R"
        public string opom { get; set; }      // remark
        public int stevnp { get; set; }       // 1 marks end-of-sample (Delphi trick)
        public int stevilVz { get; set; }     // sample number
    }

    public sealed class SapEvaluac
    {
        public string stkar { get; set; }
        public string imeKar { get; set; }
        public string ev { get; set; } = "A";
        public int st { get; set; }           // number of bad parts
        public string op { get; set; }
    }

    public sealed class SapRezultat
    {
        public float vrednost { get; set; }
        public System.DateTime datum { get; set; }
        public System.TimeSpan cas { get; set; }
        public int vzorec { get; set; }
    }

    public sealed class SapAnaliza
    {
        public string koda { get; set; }
        public string sarza { get; set; }
        public string operac { get; set; }
        public string pozic { get; set; }     // INSPCHAR
        public string naziv { get; set; }
        public System.DateTime zacDat { get; set; }
        public System.DateTime konDat { get; set; }
        public float predpis { get; set; }
        public float spMeja { get; set; }
        public float zgMeja { get; set; }
        public float dodatTol { get; set; }
    }

    public sealed class SapService
    {
        // Helper: safe get string by field name from IRfcStructure (compatible with C# 7.3)
        private static string SafeGetField(IRfcStructure r, string name)
        {
            try { return r.GetString(name); } catch { return ""; }
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
            catch { sb.AppendLine("RETURN: <missing>"); }

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
            catch { sb.AppendLine("RETURNTABLE: <missing>"); }

            return sb.ToString();
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

            // DEBUG: show actual NCo field order for INSPPOINTDATA
            {
                var md = inspPointData.Metadata;
                var sb = new System.Text.StringBuilder();
                sb.AppendLine("INSPPOINTDATA field order (NCo):");
                for (int i = 0; i < md.FieldCount; i++)
                {
                    var f = md[i];
                    sb.AppendLine($"{i + 1,3}: {f.Name}  ({f.DataType}) len={f.NucLength}");
                }
            }

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
                fn.Invoke(dest);

                // RETURN structure check (Delphi: RETURN.value[1] == 'E')
                var ret = SafeGetStructure(fn, "RETURN");
                string typ = GetString1(ret, 1);

                // RETURNTABLE message (Delphi reads row 1)
                string msg = null;
                var retTab = SafeGetTable(fn, "RETURNTABLE");
                if (retTab != null && retTab.RowCount > 0)
                {
                    var r0 = retTab[0];
                    msg = $"{GetString1(r0, 1)}/{GetString1(r0, 4)}";
                }

                if (string.Equals(typ, "E", StringComparison.OrdinalIgnoreCase))
                {
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
