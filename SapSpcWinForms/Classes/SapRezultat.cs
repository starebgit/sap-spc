using System;

namespace SapSpcWinForms
{
    public sealed class SapRezultat
    {
        public float vrednost { get; set; }
        public DateTime datum { get; set; }
        public TimeSpan cas { get; set; }
        public int vzorec { get; set; }
    }
}
