using System;
using System.Collections.Generic;

namespace SapSpcWinForms
{
    public sealed class SapWritePayload
    {
        public string Koda;
        public string Sarza;
        public string Operacija;
        public string NazivKT;
        public string Merilec;
        public string Orodje;
        public DateTime Cas;
        public List<SapMer> MerList;
        public List<SapEval> EvalList;
    }
}
