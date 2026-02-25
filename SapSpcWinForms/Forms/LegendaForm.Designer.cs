namespace SapSpcWinForms
{
    partial class LegendaForm
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
            this.titleVarLabel = new System.Windows.Forms.Label();
            this.titleAttrLabel = new System.Windows.Forms.Label();
            this.redPanelVar = new System.Windows.Forms.Panel();
            this.yellowPanelVar = new System.Windows.Forms.Panel();
            this.whitePanelVar = new System.Windows.Forms.Panel();
            this.redLabelVar = new System.Windows.Forms.Label();
            this.yellowLabelVar = new System.Windows.Forms.Label();
            this.whiteLabelVar = new System.Windows.Forms.Label();
            this.redDescVar = new System.Windows.Forms.Label();
            this.yellowDescVar = new System.Windows.Forms.Label();
            this.whiteDescVar = new System.Windows.Forms.Label();
            this.redPanelAttr = new System.Windows.Forms.Panel();
            this.whitePanelAttr = new System.Windows.Forms.Panel();
            this.redLabelAttr = new System.Windows.Forms.Label();
            this.whiteLabelAttr = new System.Windows.Forms.Label();
            this.redDescAttr = new System.Windows.Forms.Label();
            this.whiteDescAttr = new System.Windows.Forms.Label();
            this.sepPanel = new System.Windows.Forms.Panel();
            this.SuspendLayout();
            // 
            // CloseButton
            // 
            this.CloseButton.Anchor = System.Windows.Forms.AnchorStyles.Bottom;
            this.CloseButton.Location = new System.Drawing.Point(200, 330);
            this.CloseButton.Name = "CloseButton";
            this.CloseButton.Size = new System.Drawing.Size(100, 32);
            this.CloseButton.TabIndex = 0;
            this.CloseButton.Text = "Zapri";
            this.CloseButton.UseVisualStyleBackColor = true;
            this.CloseButton.Click += new System.EventHandler(this.CloseButton_Click);
            // 
            // titleVarLabel
            // 
            this.titleVarLabel.AutoSize = true;
            this.titleVarLabel.Font = new System.Drawing.Font("Segoe UI", 11F, System.Drawing.FontStyle.Bold);
            this.titleVarLabel.Location = new System.Drawing.Point(150, 10);
            this.titleVarLabel.Name = "titleVarLabel";
            this.titleVarLabel.Size = new System.Drawing.Size(210, 20);
            this.titleVarLabel.TabIndex = 1;
            this.titleVarLabel.Text = "Variabilne karakteristike";
            this.titleVarLabel.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // redPanelVar
            // 
            this.redPanelVar.BackColor = System.Drawing.Color.Red;
            this.redPanelVar.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.redPanelVar.Location = new System.Drawing.Point(20, 45);
            this.redPanelVar.Name = "redPanelVar";
            this.redPanelVar.Size = new System.Drawing.Size(140, 26);
            this.redPanelVar.TabIndex = 2;
            // 
            // redLabelVar
            // 
            this.redLabelVar.AutoSize = true;
            this.redLabelVar.BackColor = System.Drawing.Color.Transparent;
            this.redLabelVar.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Bold);
            this.redLabelVar.ForeColor = System.Drawing.Color.Black;
            this.redLabelVar.Location = new System.Drawing.Point(6, 4);
            this.redLabelVar.Name = "redLabelVar";
            this.redLabelVar.Size = new System.Drawing.Size(108, 15);
            this.redLabelVar.TabIndex = 3;
            this.redLabelVar.Text = "Izven tolerance";
            // 
            // redDescVar
            // 
            this.redDescVar.AutoSize = true;
            this.redDescVar.BackColor = System.Drawing.Color.Transparent;
            this.redDescVar.Location = new System.Drawing.Point(180, 50);
            this.redDescVar.Name = "redDescVar";
            this.redDescVar.MaximumSize = new System.Drawing.Size(280, 0);
            this.redDescVar.Size = new System.Drawing.Size(300, 13);
            this.redDescVar.TabIndex = 4;
            this.redDescVar.Text = "Stroj naj se nemudoma zaustavi! Izvede naj se ustrezni ukrep in ponovna meritev";
            // 
            // yellowPanelVar
            // 
            this.yellowPanelVar.BackColor = System.Drawing.Color.Yellow;
            this.yellowPanelVar.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.yellowPanelVar.Location = new System.Drawing.Point(20, 85);
            this.yellowPanelVar.Name = "yellowPanelVar";
            this.yellowPanelVar.Size = new System.Drawing.Size(140, 26);
            this.yellowPanelVar.TabIndex = 5;
            // 
            // yellowLabelVar
            // 
            this.yellowLabelVar.AutoSize = true;
            this.yellowLabelVar.BackColor = System.Drawing.Color.Transparent;
            this.yellowLabelVar.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Bold);
            this.yellowLabelVar.ForeColor = System.Drawing.Color.Black;
            this.yellowLabelVar.Location = new System.Drawing.Point(6, 4);
            this.yellowLabelVar.Name = "yellowLabelVar";
            this.yellowLabelVar.Size = new System.Drawing.Size(126, 15);
            this.yellowLabelVar.TabIndex = 6;
            this.yellowLabelVar.Text = "Izven kontrolnih meja";
            // 
            // yellowDescVar
            // 
            this.yellowDescVar.AutoSize = true;
            this.yellowDescVar.BackColor = System.Drawing.Color.Transparent;
            this.yellowDescVar.Location = new System.Drawing.Point(180, 90);
            this.yellowDescVar.Name = "yellowDescVar";
            this.yellowDescVar.MaximumSize = new System.Drawing.Size(280, 0);
            this.yellowDescVar.Size = new System.Drawing.Size(260, 13);
            this.yellowDescVar.TabIndex = 7;
            this.yellowDescVar.Text = "Stroj lahko nadaljuje s delom. Izvede naj se ukrep in ponovna meritev";
            // 
            // whitePanelVar
            // 
            this.whitePanelVar.BackColor = System.Drawing.Color.White;
            this.whitePanelVar.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.whitePanelVar.Location = new System.Drawing.Point(20, 125);
            this.whitePanelVar.Name = "whitePanelVar";
            this.whitePanelVar.Size = new System.Drawing.Size(140, 26);
            this.whitePanelVar.TabIndex = 8;
            // 
            // whiteLabelVar
            // 
            this.whiteLabelVar.AutoSize = true;
            this.whiteLabelVar.BackColor = System.Drawing.Color.Transparent;
            this.whiteLabelVar.Font = new System.Drawing.Font("Segoe UI", 9F);
            this.whiteLabelVar.ForeColor = System.Drawing.Color.Black;
            this.whiteLabelVar.Location = new System.Drawing.Point(6, 4);
            this.whiteLabelVar.Name = "whiteLabelVar";
            this.whiteLabelVar.Size = new System.Drawing.Size(102, 15);
            this.whiteLabelVar.TabIndex = 9;
            this.whiteLabelVar.Text = "Normalna meritev";
            // 
            // whiteDescVar
            // 
            this.whiteDescVar.AutoSize = true;
            this.whiteDescVar.BackColor = System.Drawing.Color.Transparent;
            this.whiteDescVar.Location = new System.Drawing.Point(180, 130);
            this.whiteDescVar.Name = "whiteDescVar";
            this.whiteDescVar.MaximumSize = new System.Drawing.Size(280, 0);
            this.whiteDescVar.Size = new System.Drawing.Size(140, 13);
            this.whiteDescVar.TabIndex = 10;
            this.whiteDescVar.Text = "Stroj lahko nadaljuje s delom.";
            // 
            // sepPanel
            // 
            this.sepPanel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.sepPanel.Location = new System.Drawing.Point(12, 165);
            this.sepPanel.Name = "sepPanel";
            this.sepPanel.Size = new System.Drawing.Size(476, 4);
            this.sepPanel.TabIndex = 11;
            // 
            // titleAttrLabel
            // 
            this.titleAttrLabel.AutoSize = true;
            this.titleAttrLabel.Font = new System.Drawing.Font("Segoe UI", 11F, System.Drawing.FontStyle.Bold);
            this.titleAttrLabel.Location = new System.Drawing.Point(150, 175);
            this.titleAttrLabel.Name = "titleAttrLabel";
            this.titleAttrLabel.Size = new System.Drawing.Size(233, 20);
            this.titleAttrLabel.TabIndex = 12;
            this.titleAttrLabel.Text = "Atributivne karakteristike";
            // 
            // redPanelAttr
            // 
            this.redPanelAttr.BackColor = System.Drawing.Color.Red;
            this.redPanelAttr.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.redPanelAttr.Location = new System.Drawing.Point(20, 205);
            this.redPanelAttr.Name = "redPanelAttr";
            this.redPanelAttr.Size = new System.Drawing.Size(140, 26);
            this.redPanelAttr.TabIndex = 13;
            // 
            // redLabelAttr
            // 
            this.redLabelAttr.AutoSize = true;
            this.redLabelAttr.BackColor = System.Drawing.Color.Transparent;
            this.redLabelAttr.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Bold);
            this.redLabelAttr.ForeColor = System.Drawing.Color.Black;
            this.redLabelAttr.Location = new System.Drawing.Point(6, 4);
            this.redLabelAttr.Name = "redLabelAttr";
            this.redLabelAttr.Size = new System.Drawing.Size(94, 15);
            this.redLabelAttr.TabIndex = 14;
            this.redLabelAttr.Text = "Število slabih";
            // 
            // redDescAttr
            // 
            this.redDescAttr.AutoSize = true;
            this.redDescAttr.BackColor = System.Drawing.Color.Transparent;
            this.redDescAttr.Location = new System.Drawing.Point(180, 208);
            this.redDescAttr.Name = "redDescAttr";
            this.redDescAttr.MaximumSize = new System.Drawing.Size(280, 0);
            this.redDescAttr.Size = new System.Drawing.Size(300, 13);
            this.redDescAttr.TabIndex = 15;
            this.redDescAttr.Text = "Stroj naj se nemudoma zaustavi! Izvede naj se ustrezni ukrep in ponovna meritev";
            // 
            // whitePanelAttr
            // 
            this.whitePanelAttr.BackColor = System.Drawing.Color.White;
            this.whitePanelAttr.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.whitePanelAttr.Location = new System.Drawing.Point(20, 245);
            this.whitePanelAttr.Name = "whitePanelAttr";
            this.whitePanelAttr.Size = new System.Drawing.Size(140, 26);
            this.whitePanelAttr.TabIndex = 16;
            // 
            // whiteLabelAttr
            // 
            this.whiteLabelAttr.AutoSize = true;
            this.whiteLabelAttr.BackColor = System.Drawing.Color.Transparent;
            this.whiteLabelAttr.Font = new System.Drawing.Font("Segoe UI", 9F);
            this.whiteLabelAttr.ForeColor = System.Drawing.Color.Black;
            this.whiteLabelAttr.Location = new System.Drawing.Point(6, 4);
            this.whiteLabelAttr.Name = "whiteLabelAttr";
            this.whiteLabelAttr.Size = new System.Drawing.Size(53, 15);
            this.whiteLabelAttr.TabIndex = 17;
            this.whiteLabelAttr.Text = "Vsi dobri";
            // 
            // whiteDescAttr
            // 
            this.whiteDescAttr.AutoSize = true;
            this.whiteDescAttr.BackColor = System.Drawing.Color.Transparent;
            this.whiteDescAttr.Location = new System.Drawing.Point(180, 248);
            this.whiteDescAttr.Name = "whiteDescAttr";
            this.whiteDescAttr.MaximumSize = new System.Drawing.Size(280, 0);
            this.whiteDescAttr.Size = new System.Drawing.Size(140, 13);
            this.whiteDescAttr.TabIndex = 18;
            this.whiteDescAttr.Text = "Stroj lahko nadaljuje s delom.";
            // 
            // LegendaForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(500, 380);
            this.BackColor = System.Drawing.SystemColors.ControlLightLight;
            // add legend labels inside their colored panels so text is visible
            this.redPanelVar.Controls.Add(this.redLabelVar);
            this.yellowPanelVar.Controls.Add(this.yellowLabelVar);
            this.whitePanelVar.Controls.Add(this.whiteLabelVar);
            this.redPanelAttr.Controls.Add(this.redLabelAttr);
            this.whitePanelAttr.Controls.Add(this.whiteLabelAttr);
            // Add controls (panels contain their labels so don't add label controls twice)
            this.Controls.Add(this.whiteDescAttr);
            this.Controls.Add(this.whitePanelAttr);
            this.Controls.Add(this.redDescAttr);
            this.Controls.Add(this.redPanelAttr);
            this.Controls.Add(this.titleAttrLabel);
            this.Controls.Add(this.sepPanel);
            this.Controls.Add(this.whiteDescVar);
            this.Controls.Add(this.whitePanelVar);
            this.Controls.Add(this.yellowDescVar);
            this.Controls.Add(this.yellowPanelVar);
            this.Controls.Add(this.redDescVar);
            this.Controls.Add(this.redPanelVar);
            this.Controls.Add(this.titleVarLabel);
            this.Controls.Add(this.CloseButton);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "LegendaForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Legenda";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        private System.Windows.Forms.Button CloseButton;
        private System.Windows.Forms.Label titleVarLabel;
        private System.Windows.Forms.Label titleAttrLabel;
        private System.Windows.Forms.Panel redPanelVar;
        private System.Windows.Forms.Panel yellowPanelVar;
        private System.Windows.Forms.Panel whitePanelVar;
        private System.Windows.Forms.Label redLabelVar;
        private System.Windows.Forms.Label yellowLabelVar;
        private System.Windows.Forms.Label whiteLabelVar;
        private System.Windows.Forms.Label redDescVar;
        private System.Windows.Forms.Label yellowDescVar;
        private System.Windows.Forms.Label whiteDescVar;
        private System.Windows.Forms.Panel sepPanel;
        private System.Windows.Forms.Panel redPanelAttr;
        private System.Windows.Forms.Panel whitePanelAttr;
        private System.Windows.Forms.Label redLabelAttr;
        private System.Windows.Forms.Label whiteLabelAttr;
        private System.Windows.Forms.Label redDescAttr;
        private System.Windows.Forms.Label whiteDescAttr;
    }
}
