namespace SapSpcWinForms
{
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
}
