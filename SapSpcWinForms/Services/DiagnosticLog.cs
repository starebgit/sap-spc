using System;
using System.Diagnostics;

namespace SapSpcWinForms.Services
{
    internal static class DiagnosticLog
    {
        public static void Info(string source, string message)
        {
            if (string.IsNullOrWhiteSpace(source) || string.IsNullOrWhiteSpace(message))
                return;

            Trace.WriteLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] {source}: {message}");
        }

        public static void Warn(string source, Exception ex)
        {
            if (string.IsNullOrWhiteSpace(source) || ex == null)
                return;

            Trace.WriteLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] {source}: {ex.GetType().Name}: {ex.Message}");
        }

        public static void Warn(string source, string message)
        {
            if (string.IsNullOrWhiteSpace(source) || string.IsNullOrWhiteSpace(message))
                return;

            Trace.WriteLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] {source}: WARN: {message}");
        }
    }
}
