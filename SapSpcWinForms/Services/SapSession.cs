using System;
using SAP.Middleware.Connector;

namespace SapSpcWinForms
{
    public static class SapSession
    {
        public static int? SelectedPrijavaIdent { get; set; }
        public static SapPrijava CurrentPrijava { get; set; }
        public const string DestinationName = "SAPSPC_DEST";
        private static bool _destRegistered;
        private static readonly object _destLock = new object();

        public static SapPrijava GetActivePrijava()
        {
            if (CurrentPrijava != null)
                return CurrentPrijava;

            var repo = new SapPrijavaRepository();

            CurrentPrijava = SelectedPrijavaIdent.HasValue
                ? repo.GetByIdent(SelectedPrijavaIdent.Value)
                : repo.GetDefault();

            return CurrentPrijava;
        }

        public static RfcDestination GetDestination()
        {
            EnsureDestinationRegistered();
            return RfcDestinationManager.GetDestination(DestinationName);
        }

        public static string GetPlant()
        {
            var p = GetActivePrijava();
            return string.Equals(p.Uporab?.Trim(), "rsg_rfc_1", StringComparison.OrdinalIgnoreCase)
                ? "0401"
                : "1061";
        }

        private static void EnsureDestinationRegistered()
        {
            if (_destRegistered) return;

            lock (_destLock)
            {
                if (_destRegistered) return;

                RfcDestinationManager.RegisterDestinationConfiguration(new DbDestinationConfig());
                _destRegistered = true;
            }
        }

        private sealed class DbDestinationConfig : IDestinationConfiguration
        {
            public bool ChangeEventsSupported() => false;
            public event RfcDestinationManager.ConfigurationChangeHandler ConfigurationChanged;

            public RfcConfigParameters GetParameters(string destinationName)
            {
                if (!string.Equals(destinationName, DestinationName, StringComparison.OrdinalIgnoreCase))
                    return null;

                var p = SapSession.GetActivePrijava();

                return new RfcConfigParameters
                {
                    { RfcConfigParameters.Name, DestinationName },
                    { RfcConfigParameters.AppServerHost, (p.Streznik ?? "").Trim() },
                    { RfcConfigParameters.SystemNumber, p.Sysnnum.ToString().PadLeft(2, '0') },
                    { RfcConfigParameters.Client, (p.Client ?? "").Trim() },
                    { RfcConfigParameters.User, (p.Uporab ?? "").Trim() },
                    { RfcConfigParameters.Password, p.Pass ?? "" },
                    { RfcConfigParameters.Language, string.IsNullOrWhiteSpace(p.Jezik) ? "EN" : p.Jezik.Trim() },
                    { RfcConfigParameters.PoolSize, "5" }
                };
            }
        }
    }
}
