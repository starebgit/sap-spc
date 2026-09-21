using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using SapSpcWinForms.Services;

namespace SapSpcWinForms
{
    internal static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static int Main(string[] args)
        {
            // Tihi način za Task Scheduler: SapSpcWinForms.exe /porocilo [yyyy-MM-dd] [/test]
            // Brez okna pošlje e-poštno poročilo meritev izven mej za pretekli (ali podani) dan.
            if (args != null && args.Any(a => string.Equals(a, "/porocilo", StringComparison.OrdinalIgnoreCase)))
            {
                var dan = DateTime.Today.AddDays(-1);
                foreach (var a in args)
                {
                    if (DateTime.TryParseExact(a, "yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture,
                            System.Globalization.DateTimeStyles.None, out var d))
                        dan = d;
                }
                bool samoTest = args.Any(a => string.Equals(a, "/test", StringComparison.OrdinalIgnoreCase));
                return NocnoPorociloService.Run(dan, samoTest);
            }

            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            TranslationService.SetCulture("sl");
            // start the new ZacetnaForm instead of original Form1 for the WPF port
            Application.Run(new ZacetnaForm());
            return 0;
        }
    }
}
