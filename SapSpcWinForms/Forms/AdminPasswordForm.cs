using System;
using System.Windows.Forms;

namespace SapSpcWinForms
{
    public partial class AdminPasswordForm : Form
    {
        public AdminPasswordForm()
        {
            InitializeComponent();
        }

        public string Password
        {
            get { return this.passwordTextBox.Text; }
        }

        private void okButton_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void cancelButton_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }
    }
}
