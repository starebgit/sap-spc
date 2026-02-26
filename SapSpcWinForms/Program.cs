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
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            TranslationService.SetCulture("sl");
            // start the new ZacetnaForm instead of original Form1 for the WPF port
            Application.Run(new ZacetnaForm());
        }
    }
}
