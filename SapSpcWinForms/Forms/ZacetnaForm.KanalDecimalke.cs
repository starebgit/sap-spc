using System.Globalization;
using System.Windows.Forms;

namespace SapSpcWinForms
{
    public partial class ZacetnaForm
    {
        // Delphi: stkanal / stdec
        private int _stKanal = 1;
        private int _stDec = 2;

        private void WireUpKanalDecimalke()
        {
            // safe to call multiple times
            KaraktiGrid.CellClick -= KaraktiGrid_CellClick;
            KaraktiGrid.CellClick += KaraktiGrid_CellClick;
        }

        private void KaraktiGrid_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0) return;

            // Delphi reads karakti.Cells[5,row] => your "Merilo"
            var txt = KaraktiGrid.Rows[e.RowIndex].Cells["Merilo"]?.Value?.ToString()?.Trim() ?? "";
            if (txt.Length <= 2 && int.TryParse(txt, out int kn) && kn > 0)
                _stKanal = kn;
        }

        private void ApplyDefaultKanalFromFirstRow()
        {
            if (KaraktiGrid.Rows.Count <= 0) return;

            var first = KaraktiGrid.Rows[0].Cells["Merilo"]?.Value?.ToString()?.Trim() ?? "";
            if (first.Length <= 2 && int.TryParse(first, out int kn) && kn > 0)
                _stKanal = kn;

            if (KaraktiGrid.Columns.Contains("Pozicija"))
                KaraktiGrid.CurrentCell = KaraktiGrid.Rows[0].Cells["Pozicija"];
        }

        private string FormatMeasurement(double value)
        {
            // Delphi fixed decimals
            return value.ToString("F" + _stDec, CultureInfo.CurrentCulture);
        }
    }
}
