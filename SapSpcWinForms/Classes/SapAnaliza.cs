using System;

namespace SapSpcWinForms
{
    public sealed class SapAnaliza
    {
        public string koda { get; set; }
        public string sarza { get; set; }
        public string operac { get; set; }
        public string pozic { get; set; }     // INSPCHAR
        public string naziv { get; set; }
        public DateTime zacDat { get; set; }
        public DateTime konDat { get; set; }
        public float predpis { get; set; }
        public float spMeja { get; set; }
        public float zgMeja { get; set; }
        public float dodatTol { get; set; }
    }
}
