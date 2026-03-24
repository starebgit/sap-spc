using System;
using SAP.Middleware.Connector;
using SapSpcWinForms.Services;

namespace SapSpcWinForms
{
    public static class SapSession
    {
        public static int? SelectedPrijavaIdent { get; set; }
        public static SapPrijava CurrentPrijava { get; set; }
        public const string DestinationName = "SAPSPC_DEST";
        private static bool _destRegistered;
        private static readonly object _destLock = new object();
        private static readonly DbDestinationConfig _dbDestinationConfig = new DbDestinationConfig();

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

        public static void SetSelectedPrijava(int ident)
        {
            lock (_destLock)
            {
                SelectedPrijavaIdent = ident;
                CurrentPrijava = null;
                RebindDestinationConfigurationLocked();
            }
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
                RebindDestinationConfigurationLocked();
            }
        }

        private static void RebindDestinationConfigurationLocked()
        {
            try
            {
                if (_destRegistered)
                    RfcDestinationManager.UnregisterDestinationConfiguration(_dbDestinationConfig);
            }
            catch (Exception ex)
            {
                DiagnosticLog.Warn("SapSession.RebindDestinationConfiguration.Unregister", ex);
            }

            RfcDestinationManager.RegisterDestinationConfiguration(_dbDestinationConfig);
            _destRegistered = true;
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
