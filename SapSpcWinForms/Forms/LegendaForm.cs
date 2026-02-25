using System;
using System.Windows.Forms;
using SapSpcWinForms.Services;

namespace SapSpcWinForms
{
    public partial class LegendaForm : Form
    {
        public LegendaForm()
        {
            InitializeComponent();
            TranslationService.ApplyLocalization(this);
        }

        private void CloseButton_Click(object sender, EventArgs e)
        {
            Close();
        }
    }
}
