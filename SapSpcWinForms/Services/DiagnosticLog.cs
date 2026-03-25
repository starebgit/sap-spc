using System;
using System.Diagnostics;
using System.IO;

namespace SapSpcWinForms.Services
{
    internal static class DiagnosticLog
    {
        private static readonly object Sync = new object();

        private static string GetLogFilePath()
        {
            var root = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
            if (string.IsNullOrWhiteSpace(root))
                root = AppDomain.CurrentDomain.BaseDirectory ?? ".";

            var dir = Path.Combine(root, "SapSpcWinForms");
            Directory.CreateDirectory(dir);
            return Path.Combine(dir, "diagnostic.log");
        }

        private static void WriteLine(string line)
        {
            if (string.IsNullOrWhiteSpace(line))
                return;

            Trace.WriteLine(line);

            try
            {
                lock (Sync)
                {
                    File.AppendAllText(GetLogFilePath(), line + Environment.NewLine);
                }
            }
            catch
            {
                // never break app flow due to diagnostics I/O
            }
        }

        public static void Info(string source, string message)
        {
            if (string.IsNullOrWhiteSpace(source) || string.IsNullOrWhiteSpace(message))
                return;

            WriteLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] {source}: {message}");
        }

        public static void Warn(string source, Exception ex)
        {
            if (string.IsNullOrWhiteSpace(source) || ex == null)
                return;

            WriteLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] {source}: {ex.GetType().Name}: {ex.Message}");
        }

        public static void Warn(string source, string message)
        {
            if (string.IsNullOrWhiteSpace(source) || string.IsNullOrWhiteSpace(message))
                return;

            WriteLine($"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] {source}: WARN: {message}");
        }
    }
}
