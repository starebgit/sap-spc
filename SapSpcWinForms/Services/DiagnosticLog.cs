using System;
using System.Diagnostics;

namespace SapSpcWinForms.Services
{
    internal static class DiagnosticLog
    {
        public static void Warn(string source, Exception ex)
        {
            if (string.IsNullOrWhiteSpace(source) || ex == null)
                return;

            Trace.WriteLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] {source}: {ex.GetType().Name}: {ex.Message}");
        }
    }
}
