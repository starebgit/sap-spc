using System;

namespace SapSpcWinForms
{
    public sealed class SemaforRow
    {
        public string Naziv { get; set; } = "";
        public int Status { get; set; } = 9;               // 1/2/3/9 like Delphi
        public int DiffMinutes { get; set; } = 0;          // pp^.diff
        public DateTime NextBaseTime { get; set; } = DateTime.Today; // Fzacetna.acas[...] equivalent
    }
}
