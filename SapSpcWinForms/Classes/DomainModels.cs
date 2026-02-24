using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;

namespace SapSpc.Domain
{
    // copied from existing WPF project for shared use
    public class Zapis
    {
        public long Ident { get; set; }
        public string Naziv { get; set; } = string.Empty;
        public float Vrednost { get; set; }
        public bool Izbran { get; set; }
        public string Koda { get; set; } = string.Empty;
        public int Diff { get; set; }
        public int Traj { get; set; }
    }

    // ... other models omitted for brevity, shared file can be expanded later
}
