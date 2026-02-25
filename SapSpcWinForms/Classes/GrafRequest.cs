using System.Collections.Generic;

namespace SapSpcWinForms
{
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
}
