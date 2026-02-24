namespace SapSpcWinForms
{
    partial class SemaforForm
    {
        private System.ComponentModel.IContainer components = null;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        private void InitializeComponent()
        {
            this.CloseButton = new System.Windows.Forms.Button();
            this.MachinesGrid = new System.Windows.Forms.DataGridView();
            ((System.ComponentModel.ISupportInitialize)(this.MachinesGrid)).BeginInit();
            this.SuspendLayout();
            // 
            // CloseButton
            // 
            this.CloseButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.CloseButton.Location = new System.Drawing.Point(800, 560);
            this.CloseButton.Name = "CloseButton";
            this.CloseButton.Size = new System.Drawing.Size(80, 28);
            this.CloseButton.TabIndex = 0;
            this.CloseButton.Text = "Zapri";
            this.CloseButton.UseVisualStyleBackColor = true;
            // 
            // MachinesGrid
            // 
            this.MachinesGrid.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
            | System.Windows.Forms.AnchorStyles.Left)
            | System.Windows.Forms.AnchorStyles.Right)));
            this.MachinesGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.MachinesGrid.Location = new System.Drawing.Point(12, 12);
            this.MachinesGrid.Name = "MachinesGrid";
            this.MachinesGrid.ReadOnly = true;
            this.MachinesGrid.RowTemplate.Height = 24;
            this.MachinesGrid.Size = new System.Drawing.Size(880, 528);
            this.MachinesGrid.TabIndex = 1;
            // 
            // SemaforForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(904, 600);
            this.Controls.Add(this.MachinesGrid);
            this.Controls.Add(this.CloseButton);
            this.Name = "SemaforForm";
            this.Text = "Semafor";
            ((System.ComponentModel.ISupportInitialize)(this.MachinesGrid)).EndInit();
            this.ResumeLayout(false);

        }

        private System.Windows.Forms.Button CloseButton;
        private System.Windows.Forms.DataGridView MachinesGrid;
    }
}
