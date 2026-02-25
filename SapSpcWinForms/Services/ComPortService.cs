using SapSpcWinForms.Data;

namespace SapSpcWinForms
{
    public static class ComPortService
    {
        public static string ResolveComPortDelphiLike(string rowComValue, int? currentStPost)
        {
            string cm = rowComValue ?? "";

            if (string.IsNullOrWhiteSpace(cm) && currentStPost.HasValue)
                cm = StrojnaDbRepository.GetComForPostOrEmpty(currentStPost.Value);

            return NormalizeComPortDelphiLike(cm);
        }

        public static string NormalizeComPortDelphiLike(string cm)
        {
            cm = (cm ?? "").Trim();
            if (string.IsNullOrWhiteSpace(cm))
                return "COM3";

            if (cm.StartsWith("COM", System.StringComparison.OrdinalIgnoreCase))
                return "COM" + cm.Substring(3).Trim();

            if (int.TryParse(cm, out int n) && n > 0)
                return "COM" + n;

            return cm;
        }
    }
}
