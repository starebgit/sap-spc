using System;
using System.Globalization;
using System.Threading;
using System.Windows.Forms;
using SapSpcWinForms.Properties;

namespace SapSpcWinForms.Services
{
    internal static class TranslationService
    {
        private const string DefaultLanguageCode = "sl";

        public static string CurrentLanguageCode
        {
            get
            {
                var code = (Settings.Default.UiLanguage ?? string.Empty).Trim().ToLowerInvariant();
                return NormalizeLanguageCode(code);
            }
        }

        public static void SetCulture(string languageCode)
        {
            var normalized = NormalizeLanguageCode(languageCode);
            var culture = BuildCulture(normalized);

            Thread.CurrentThread.CurrentUICulture = culture;
            Thread.CurrentThread.CurrentCulture = culture;
            Resources.Culture = culture;

            Settings.Default.UiLanguage = normalized;
            Settings.Default.Save();
        }

        public static void InitializeFromSettings()
        {
            SetCulture(CurrentLanguageCode);
        }

        public static string Translate(string key)
        {
            if (string.IsNullOrWhiteSpace(key))
                return string.Empty;

            var value = Resources.ResourceManager.GetString(key, Resources.Culture ?? Thread.CurrentThread.CurrentUICulture);
            return string.IsNullOrEmpty(value) ? key : value;
        }

        public static void ApplyLocalization(Control root)
        {
            if (root == null)
                return;

            ApplyControl(root);
        }

        private static void ApplyControl(Control control)
        {
            var key = control.Name + ".Text";
            var localized = Resources.ResourceManager.GetString(key, Resources.Culture ?? Thread.CurrentThread.CurrentUICulture);
            if (!string.IsNullOrEmpty(localized))
                control.Text = localized;

            if (control is MenuStrip menuStrip)
                ApplyToolStripItems(menuStrip.Items);

            foreach (Control child in control.Controls)
                ApplyControl(child);
        }

        private static void ApplyToolStripItems(ToolStripItemCollection items)
        {
            foreach (ToolStripItem item in items)
            {
                var key = item.Name + ".Text";
                var localized = Resources.ResourceManager.GetString(key, Resources.Culture ?? Thread.CurrentThread.CurrentUICulture);
                if (!string.IsNullOrEmpty(localized))
                    item.Text = localized;

                if (item is ToolStripDropDownItem dropDown && dropDown.DropDownItems.Count > 0)
                    ApplyToolStripItems(dropDown.DropDownItems);
            }
        }

        private static string NormalizeLanguageCode(string code)
        {
            if (string.IsNullOrWhiteSpace(code))
                return DefaultLanguageCode;

            switch (code.Trim().ToLowerInvariant())
            {
                case "sl":
                case "sl-si":
                    return "sl";
                case "de":
                case "de-de":
                    return "de";
                case "en":
                case "en-us":
                case "en-gb":
                    return "en";
                default:
                    return DefaultLanguageCode;
            }
        }

        private static CultureInfo BuildCulture(string languageCode)
        {
            switch (languageCode)
            {
                case "de":
                    return CultureInfo.GetCultureInfo("de-DE");
                case "en":
                    return CultureInfo.GetCultureInfo("en-US");
                default:
                    return CultureInfo.GetCultureInfo("sl-SI");
            }
        }
    }
}
