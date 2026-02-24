using System;

namespace SapSpcWinForms
{
    public static class MerilnoMestoState
    {
        public static int? CurrentStPost { get; set; }
        public static string CurrentMestoOpis { get; set; }
        public static event Action StateChanged;

        public static void Set(int? stPost, string opis)
        {
            CurrentStPost = stPost;
            CurrentMestoOpis = opis;
            StateChanged?.Invoke();
        }
    }
}
