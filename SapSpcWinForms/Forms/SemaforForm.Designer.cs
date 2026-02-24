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
            this.legendPanel = new System.Windows.Forms.Panel();
            this.legendVarLabel = new System.Windows.Forms.Label();
            this.legendAttrLabel = new System.Windows.Forms.Label();
            this.legendRed = new System.Windows.Forms.Panel();
            this.legendYellow = new System.Windows.Forms.Panel();
            this.legendWhite = new System.Windows.Forms.Panel();
            this.legendRedLabel = new System.Windows.Forms.Label();
            this.legendYellowLabel = new System.Windows.Forms.Label();
            this.legendWhiteLabel = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.MachinesGrid)).BeginInit();
            this.legendPanel.SuspendLayout();
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
            this.MachinesGrid.Location = new System.Drawing.Point(12, 120);
            this.MachinesGrid.Name = "MachinesGrid";
            this.MachinesGrid.ReadOnly = true;
            this.MachinesGrid.RowTemplate.Height = 24;
            this.MachinesGrid.Size = new System.Drawing.Size(880, 420);
            this.MachinesGrid.TabIndex = 1;
            // 
            // legendPanel
            // 
            this.legendPanel.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
            | System.Windows.Forms.AnchorStyles.Right)));
            this.legendPanel.BackColor = System.Drawing.SystemColors.ControlLight;
            this.legendPanel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.legendPanel.Controls.Add(this.legendVarLabel);
            this.legendPanel.Controls.Add(this.legendAttrLabel);
            this.legendPanel.Controls.Add(this.legendRed);
            this.legendPanel.Controls.Add(this.legendYellow);
            this.legendPanel.Controls.Add(this.legendWhite);
            this.legendPanel.Controls.Add(this.legendRedLabel);
            this.legendPanel.Controls.Add(this.legendYellowLabel);
            this.legendPanel.Controls.Add(this.legendWhiteLabel);
            this.legendPanel.Location = new System.Drawing.Point(12, 12);
            this.legendPanel.Name = "legendPanel";
            this.legendPanel.Size = new System.Drawing.Size(880, 90);
            this.legendPanel.TabIndex = 2;
            // 
            // legendVarLabel
            // 
            this.legendVarLabel.AutoSize = true;
            this.legendVarLabel.Font = new System.Drawing.Font("Segoe UI", 10F, System.Drawing.FontStyle.Bold);
            this.legendVarLabel.Location = new System.Drawing.Point(12, 8);
            this.legendVarLabel.Name = "legendVarLabel";
            this.legendVarLabel.Size = new System.Drawing.Size(189, 19);
            this.legendVarLabel.TabIndex = 0;
            this.legendVarLabel.Text = "Variabilne karakteristike";
            // 
            // legendAttrLabel
            // 
            this.legendAttrLabel.AutoSize = true;
            this.legendAttrLabel.Font = new System.Drawing.Font("Segoe UI", 10F, System.Drawing.FontStyle.Bold);
            this.legendAttrLabel.Location = new System.Drawing.Point(12, 48);
            this.legendAttrLabel.Name = "legendAttrLabel";
            this.legendAttrLabel.Size = new System.Drawing.Size(176, 19);
            this.legendAttrLabel.TabIndex = 1;
            this.legendAttrLabel.Text = "Atributivne karakteristike";
            // 
            // legendRed
            // 
            this.legendRed.BackColor = System.Drawing.Color.Red;
            this.legendRed.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.legendRed.Location = new System.Drawing.Point(220, 6);
            this.legendRed.Name = "legendRed";
            this.legendRed.Size = new System.Drawing.Size(120, 28);
            this.legendRed.TabIndex = 2;
            // 
            // legendYellow
            // 
            this.legendYellow.BackColor = System.Drawing.Color.Yellow;
            this.legendYellow.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.legendYellow.Location = new System.Drawing.Point(220, 44);
            this.legendYellow.Name = "legendYellow";
            this.legendYellow.Size = new System.Drawing.Size(120, 28);
            this.legendYellow.TabIndex = 3;
            // 
            // legendWhite
            // 
            this.legendWhite.BackColor = System.Drawing.Color.White;
            this.legendWhite.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.legendWhite.Location = new System.Drawing.Point(220, 26);
            this.legendWhite.Name = "legendWhite";
            this.legendWhite.Size = new System.Drawing.Size(120, 28);
            this.legendWhite.TabIndex = 4;
            // 
            // legendRedLabel
            // 
            this.legendRedLabel.AutoSize = true;
            this.legendRedLabel.Location = new System.Drawing.Point(350, 13);
            this.legendRedLabel.Name = "legendRedLabel";
            this.legendRedLabel.Size = new System.Drawing.Size(320, 13);
            this.legendRedLabel.TabIndex = 5;
            this.legendRedLabel.Text = "Stroj naj se nemudoma zaustavi! Izvede naj se ustrezni ukrep in ponovna meritev";
            // 
            // legendYellowLabel
            // 
            this.legendYellowLabel.AutoSize = true;
            this.legendYellowLabel.Location = new System.Drawing.Point(350, 51);
            this.legendYellowLabel.Name = "legendYellowLabel";
            this.legendYellowLabel.Size = new System.Drawing.Size(300, 13);
            this.legendYellowLabel.TabIndex = 6;
            this.legendYellowLabel.Text = "Stroj lahko nadaljuje s delom. Izvede naj se ustrezni ukrep in ponovna meritev";
            // 
            // legendWhiteLabel
            // 
            this.legendWhiteLabel.AutoSize = true;
            this.legendWhiteLabel.Location = new System.Drawing.Point(350, 33);
            this.legendWhiteLabel.Name = "legendWhiteLabel";
            this.legendWhiteLabel.Size = new System.Drawing.Size(160, 13);
            this.legendWhiteLabel.TabIndex = 7;
            this.legendWhiteLabel.Text = "Stroj lahko nadaljuje s delom.";
            // 
            // SemaforForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(904, 600);
            this.Controls.Add(this.legendPanel);
            this.Controls.Add(this.MachinesGrid);
            this.Controls.Add(this.CloseButton);
            this.Name = "SemaforForm";
            this.Text = "Semafor";
            ((System.ComponentModel.ISupportInitialize)(this.MachinesGrid)).EndInit();
            this.legendPanel.ResumeLayout(false);
            this.legendPanel.PerformLayout();
            this.ResumeLayout(false);

        }

        private System.Windows.Forms.Button CloseButton;
        private System.Windows.Forms.DataGridView MachinesGrid;
        private System.Windows.Forms.Panel legendPanel;
        private System.Windows.Forms.Label legendVarLabel;
        private System.Windows.Forms.Label legendAttrLabel;
        private System.Windows.Forms.Panel legendRed;
        private System.Windows.Forms.Panel legendYellow;
        private System.Windows.Forms.Panel legendWhite;
        private System.Windows.Forms.Label legendRedLabel;
        private System.Windows.Forms.Label legendYellowLabel;
        private System.Windows.Forms.Label legendWhiteLabel;
    }
}
