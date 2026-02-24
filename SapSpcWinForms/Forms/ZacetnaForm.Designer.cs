namespace SapSpcWinForms
{
    partial class ZacetnaForm
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

        #region Windows Form Designer generated code

        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(ZacetnaForm));
            this.PrijavaAdminButton = new System.Windows.Forms.Button();
            this.PrijavljenLabel = new System.Windows.Forms.Label();
            this.LegendaButton = new System.Windows.Forms.Button();
            this.SemaforButton = new System.Windows.Forms.Button();
            this.KonecButton = new System.Windows.Forms.Button();
            this.topPanel = new System.Windows.Forms.Panel();
            this.machinesList = new System.Windows.Forms.ListBox();
            this.codesList = new System.Windows.Forms.ListBox();
            this.logoPicture = new System.Windows.Forms.PictureBox();
            this.companyLabel = new System.Windows.Forms.Label();
            this.KaraktiGrid = new System.Windows.Forms.DataGridView();
            this.attriGrid = new System.Windows.Forms.DataGridView();
            this.rightPanel = new System.Windows.Forms.Panel();
            this.TransferButton = new System.Windows.Forms.Button();
            this.TransferWithPedalButton = new System.Windows.Forms.Button();
            this.PrekinButton = new System.Windows.Forms.Button();
            this.SAPButton = new System.Windows.Forms.Button();
            this.MeritveButton = new System.Windows.Forms.Button();
            this.LegendaSideButton = new System.Windows.Forms.Button();
            this.SemaforSideButton = new System.Windows.Forms.Button();
            this.GrafButton = new System.Windows.Forms.Button();
            this.KonecSideButton = new System.Windows.Forms.Button();
            this.menuStrip = new System.Windows.Forms.MenuStrip();
            this.bazaNaServerjuToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.merilnaMestaServerToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.strojiServerToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.merilneMetodeServerToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.ukrepiServerToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.kontrolniPlaniServerToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.meritveServerToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.nastavitveToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.vpisStevKanalaToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.decimalkeToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.beriMeritveSettingsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.operacijeToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.dodatneKodeToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.informacijeToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.merilaInfoToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.prijavaInfoToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.adminToggleButton = new System.Windows.Forms.ToolStripButton();
            this.versionInfoLabel = new System.Windows.Forms.ToolStripLabel();
            this.variabilneTitleLabel = new System.Windows.Forms.Label();
            this.atributivneTitleLabel = new System.Windows.Forms.Label();
            this.topPanel.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.logoPicture)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.KaraktiGrid)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.attriGrid)).BeginInit();
            this.rightPanel.SuspendLayout();
            this.menuStrip.SuspendLayout();
            this.SuspendLayout();
            // 
            // PrijavaAdminButton
            // 
            this.PrijavaAdminButton.Location = new System.Drawing.Point(12, 12);
            this.PrijavaAdminButton.Name = "PrijavaAdminButton";
            this.PrijavaAdminButton.Size = new System.Drawing.Size(120, 24);
            this.PrijavaAdminButton.TabIndex = 0;
            this.PrijavaAdminButton.Text = "Prijava admin";
            this.PrijavaAdminButton.UseVisualStyleBackColor = true;
            this.PrijavaAdminButton.Visible = false;
            // 
            // PrijavljenLabel
            // 
            this.PrijavljenLabel.AutoSize = true;
            this.PrijavljenLabel.Location = new System.Drawing.Point(12, 44);
            this.PrijavljenLabel.Name = "PrijavljenLabel";
            this.PrijavljenLabel.Size = new System.Drawing.Size(59, 13);
            this.PrijavljenLabel.TabIndex = 1;
            this.PrijavljenLabel.Text = "Uporabnik";
            this.PrijavljenLabel.Visible = false;
            // 
            // LegendaButton
            // 
            this.LegendaButton.Location = new System.Drawing.Point(0, 0);
            this.LegendaButton.Name = "LegendaButton";
            this.LegendaButton.Size = new System.Drawing.Size(75, 23);
            this.LegendaButton.TabIndex = 0;
            // 
            // SemaforButton
            // 
            this.SemaforButton.Location = new System.Drawing.Point(0, 0);
            this.SemaforButton.Name = "SemaforButton";
            this.SemaforButton.Size = new System.Drawing.Size(75, 23);
            this.SemaforButton.TabIndex = 0;
            // 
            // KonecButton
            // 
            this.KonecButton.Location = new System.Drawing.Point(0, 0);
            this.KonecButton.Name = "KonecButton";
            this.KonecButton.Size = new System.Drawing.Size(75, 23);
            this.KonecButton.TabIndex = 0;
            // 
            // topPanel
            // 
            this.topPanel.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(224)))), ((int)(((byte)(243)))), ((int)(((byte)(242)))));
            this.topPanel.Controls.Add(this.machinesList);
            this.topPanel.Controls.Add(this.codesList);
            this.topPanel.Location = new System.Drawing.Point(0, 30);
            this.topPanel.Margin = new System.Windows.Forms.Padding(4);
            this.topPanel.Name = "topPanel";
            this.topPanel.Size = new System.Drawing.Size(1400, 220);
            this.topPanel.TabIndex = 1;
            // 
            // machinesList
            // 
            this.machinesList.FormattingEnabled = true;
            this.machinesList.ItemHeight = 16;
            this.machinesList.Location = new System.Drawing.Point(350, 20);
            this.machinesList.Margin = new System.Windows.Forms.Padding(4);
            this.machinesList.Name = "machinesList";
            this.machinesList.Size = new System.Drawing.Size(140, 100);
            this.machinesList.TabIndex = 9;
            // 
            // codesList
            // 
            this.codesList.FormattingEnabled = true;
            this.codesList.ItemHeight = 16;
            this.codesList.Location = new System.Drawing.Point(1300, 20);
            this.codesList.Margin = new System.Windows.Forms.Padding(4);
            this.codesList.Name = "codesList";
            this.codesList.Size = new System.Drawing.Size(140, 100);
            this.codesList.TabIndex = 8;
            // 
            // logoPicture
            // 
            this.logoPicture.Location = new System.Drawing.Point(47, 25);
            this.logoPicture.Margin = new System.Windows.Forms.Padding(4);
            this.logoPicture.Name = "logoPicture";
            this.logoPicture.Size = new System.Drawing.Size(147, 74);
            this.logoPicture.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.logoPicture.TabIndex = 10;
            this.logoPicture.TabStop = false;
            // 
            // companyLabel
            // 
            this.companyLabel.BackColor = System.Drawing.Color.White;
            this.companyLabel.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.companyLabel.ForeColor = System.Drawing.Color.Black;
            this.companyLabel.Location = new System.Drawing.Point(27, 98);
            this.companyLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.companyLabel.Name = "companyLabel";
            this.companyLabel.Size = new System.Drawing.Size(187, 22);
            this.companyLabel.TabIndex = 11;
            this.companyLabel.Text = "ETA Cerkno, d.o.o.";
            this.companyLabel.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // KaraktiGrid
            // 
            this.KaraktiGrid.BackgroundColor = System.Drawing.Color.White;
            this.KaraktiGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.KaraktiGrid.EnableHeadersVisualStyles = false;
            this.KaraktiGrid.Location = new System.Drawing.Point(27, 262);
            this.KaraktiGrid.Margin = new System.Windows.Forms.Padding(4);
            this.KaraktiGrid.Name = "KaraktiGrid";
            this.KaraktiGrid.RowHeadersWidth = 51;
            this.KaraktiGrid.RowTemplate.Height = 24;
            this.KaraktiGrid.Size = new System.Drawing.Size(1300, 260);
            this.KaraktiGrid.TabIndex = 2;
            // 
            // attriGrid
            // 
            this.attriGrid.BackgroundColor = System.Drawing.Color.White;
            this.attriGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.attriGrid.EnableHeadersVisualStyles = false;
            this.attriGrid.Location = new System.Drawing.Point(27, 562);
            this.attriGrid.Margin = new System.Windows.Forms.Padding(4);
            this.attriGrid.Name = "attriGrid";
            this.attriGrid.RowHeadersWidth = 51;
            this.attriGrid.RowTemplate.Height = 24;
            this.attriGrid.Size = new System.Drawing.Size(1300, 180);
            this.attriGrid.TabIndex = 3;
            // 
            // rightPanel
            // 
            this.rightPanel.BackColor = System.Drawing.Color.White;
            this.rightPanel.Controls.Add(this.logoPicture);
            this.rightPanel.Controls.Add(this.companyLabel);
            this.rightPanel.Controls.Add(this.TransferButton);
            this.rightPanel.Controls.Add(this.TransferWithPedalButton);
            this.rightPanel.Controls.Add(this.PrekinButton);
            this.rightPanel.Controls.Add(this.SAPButton);
            this.rightPanel.Controls.Add(this.MeritveButton);
            this.rightPanel.Controls.Add(this.LegendaSideButton);
            this.rightPanel.Controls.Add(this.SemaforSideButton);
            this.rightPanel.Controls.Add(this.GrafButton);
            this.rightPanel.Controls.Add(this.KonecSideButton);
            this.rightPanel.Location = new System.Drawing.Point(1400, 30);
            this.rightPanel.Margin = new System.Windows.Forms.Padding(4);
            this.rightPanel.Name = "rightPanel";
            this.rightPanel.Size = new System.Drawing.Size(260, 700);
            this.rightPanel.TabIndex = 4;
            // 
            // TransferButton
            // 
            this.TransferButton.Location = new System.Drawing.Point(27, 160);
            this.TransferButton.Margin = new System.Windows.Forms.Padding(4);
            this.TransferButton.Name = "TransferButton";
            this.TransferButton.Size = new System.Drawing.Size(187, 37);
            this.TransferButton.TabIndex = 0;
            this.TransferButton.Text = "Prenos meritev";
            this.TransferButton.UseVisualStyleBackColor = true;
            // 
            // TransferWithPedalButton
            // 
            this.TransferWithPedalButton.Location = new System.Drawing.Point(27, 209);
            this.TransferWithPedalButton.Margin = new System.Windows.Forms.Padding(4);
            this.TransferWithPedalButton.Name = "TransferWithPedalButton";
            this.TransferWithPedalButton.Size = new System.Drawing.Size(187, 37);
            this.TransferWithPedalButton.TabIndex = 1;
            this.TransferWithPedalButton.Text = "Prenos s stopalko";
            this.TransferWithPedalButton.UseVisualStyleBackColor = true;
            // 
            // PrekinButton
            // 
            this.PrekinButton.Location = new System.Drawing.Point(53, 258);
            this.PrekinButton.Margin = new System.Windows.Forms.Padding(4);
            this.PrekinButton.Name = "PrekinButton";
            this.PrekinButton.Size = new System.Drawing.Size(133, 30);
            this.PrekinButton.TabIndex = 2;
            this.PrekinButton.Text = "Prekini";
            this.PrekinButton.UseVisualStyleBackColor = true;
            // 
            // SAPButton
            // 
            this.SAPButton.Location = new System.Drawing.Point(27, 308);
            this.SAPButton.Margin = new System.Windows.Forms.Padding(4);
            this.SAPButton.Name = "SAPButton";
            this.SAPButton.Size = new System.Drawing.Size(187, 44);
            this.SAPButton.TabIndex = 3;
            this.SAPButton.Text = "Prepis v SAP";
            this.SAPButton.UseVisualStyleBackColor = true;
            this.SAPButton.Click += new System.EventHandler(this.SAPButton_Click);
            // 
            // MeritveButton
            // 
            this.MeritveButton.Location = new System.Drawing.Point(27, 357);
            this.MeritveButton.Margin = new System.Windows.Forms.Padding(4);
            this.MeritveButton.Name = "MeritveButton";
            this.MeritveButton.Size = new System.Drawing.Size(187, 37);
            this.MeritveButton.TabIndex = 4;
            this.MeritveButton.Text = "Meritve";
            this.MeritveButton.UseVisualStyleBackColor = true;
            this.MeritveButton.Click += new System.EventHandler(this.MeritveButton_Click);
            // 
            // LegendaSideButton
            // 
            this.LegendaSideButton.Location = new System.Drawing.Point(27, 431);
            this.LegendaSideButton.Margin = new System.Windows.Forms.Padding(4);
            this.LegendaSideButton.Name = "LegendaSideButton";
            this.LegendaSideButton.Size = new System.Drawing.Size(187, 37);
            this.LegendaSideButton.TabIndex = 5;
            this.LegendaSideButton.Text = "Legenda";
            this.LegendaSideButton.UseVisualStyleBackColor = true;
            this.LegendaSideButton.Click += new System.EventHandler(this.LegendaButton_Click);
            // 
            // SemaforSideButton
            // 
            this.SemaforSideButton.Location = new System.Drawing.Point(27, 480);
            this.SemaforSideButton.Margin = new System.Windows.Forms.Padding(4);
            this.SemaforSideButton.Name = "SemaforSideButton";
            this.SemaforSideButton.Size = new System.Drawing.Size(187, 37);
            this.SemaforSideButton.TabIndex = 6;
            this.SemaforSideButton.Text = "Semafor";
            this.SemaforSideButton.UseVisualStyleBackColor = true;
            this.SemaforSideButton.Click += new System.EventHandler(this.SemaforButton_Click);
            // 
            // GrafButton
            // 
            this.GrafButton.Enabled = false;
            this.GrafButton.Location = new System.Drawing.Point(27, 529);
            this.GrafButton.Margin = new System.Windows.Forms.Padding(4);
            this.GrafButton.Name = "GrafButton";
            this.GrafButton.Size = new System.Drawing.Size(187, 37);
            this.GrafButton.TabIndex = 7;
            this.GrafButton.Text = "Grafi";
            this.GrafButton.UseVisualStyleBackColor = true;
            // 
            // KonecSideButton
            // 
            this.KonecSideButton.Location = new System.Drawing.Point(27, 628);
            this.KonecSideButton.Margin = new System.Windows.Forms.Padding(4);
            this.KonecSideButton.Name = "KonecSideButton";
            this.KonecSideButton.Size = new System.Drawing.Size(187, 37);
            this.KonecSideButton.TabIndex = 8;
            this.KonecSideButton.Text = "Konec";
            this.KonecSideButton.UseVisualStyleBackColor = true;
            this.KonecSideButton.Click += new System.EventHandler(this.KonecButton_Click);
            // 
            // menuStrip
            // 
            this.menuStrip.ImageScalingSize = new System.Drawing.Size(20, 20);
            this.menuStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.bazaNaServerjuToolStripMenuItem,
            this.nastavitveToolStripMenuItem,
            this.operacijeToolStripMenuItem,
            this.informacijeToolStripMenuItem,
            this.adminToggleButton,
            this.versionInfoLabel});
            this.menuStrip.Location = new System.Drawing.Point(0, 0);
            this.menuStrip.Name = "menuStrip";
            this.menuStrip.ShowItemToolTips = true;
            this.menuStrip.Size = new System.Drawing.Size(1680, 31);
            this.menuStrip.TabIndex = 0;
            this.menuStrip.Text = "menuStrip";
            // 
            // bazaNaServerjuToolStripMenuItem
            // 
            this.bazaNaServerjuToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.merilnaMestaServerToolStripMenuItem,
            this.strojiServerToolStripMenuItem,
            this.merilneMetodeServerToolStripMenuItem,
            this.ukrepiServerToolStripMenuItem,
            this.kontrolniPlaniServerToolStripMenuItem,
            this.meritveServerToolStripMenuItem});
            this.bazaNaServerjuToolStripMenuItem.Name = "bazaNaServerjuToolStripMenuItem";
            this.bazaNaServerjuToolStripMenuItem.Size = new System.Drawing.Size(130, 27);
            this.bazaNaServerjuToolStripMenuItem.Text = "Baza na serverju";
            // 
            // merilnaMestaServerToolStripMenuItem
            // 
            this.merilnaMestaServerToolStripMenuItem.Name = "merilnaMestaServerToolStripMenuItem";
            this.merilnaMestaServerToolStripMenuItem.Size = new System.Drawing.Size(198, 26);
            this.merilnaMestaServerToolStripMenuItem.Text = "Merilna mesta";
            this.merilnaMestaServerToolStripMenuItem.Click += new System.EventHandler(this.MerilnaMestaServerMenuItem_Click);
            // 
            // strojiServerToolStripMenuItem
            // 
            this.strojiServerToolStripMenuItem.Name = "strojiServerToolStripMenuItem";
            this.strojiServerToolStripMenuItem.Size = new System.Drawing.Size(198, 26);
            this.strojiServerToolStripMenuItem.Text = "Stroji";
            this.strojiServerToolStripMenuItem.Click += new System.EventHandler(this.StrojiServerMenuItem_Click);
            // 
            // merilneMetodeServerToolStripMenuItem
            // 
            this.merilneMetodeServerToolStripMenuItem.Name = "merilneMetodeServerToolStripMenuItem";
            this.merilneMetodeServerToolStripMenuItem.Size = new System.Drawing.Size(198, 26);
            this.merilneMetodeServerToolStripMenuItem.Text = "Merilne metode";
            this.merilneMetodeServerToolStripMenuItem.Click += new System.EventHandler(this.MerilneMetodeServerMenuItem_Click);
            // 
            // ukrepiServerToolStripMenuItem
            // 
            this.ukrepiServerToolStripMenuItem.Name = "ukrepiServerToolStripMenuItem";
            this.ukrepiServerToolStripMenuItem.Size = new System.Drawing.Size(198, 26);
            this.ukrepiServerToolStripMenuItem.Text = "Ukrepi";
            this.ukrepiServerToolStripMenuItem.Click += new System.EventHandler(this.UkrepiServerMenuItem_Click);
            // 
            // kontrolniPlaniServerToolStripMenuItem
            // 
            this.kontrolniPlaniServerToolStripMenuItem.Name = "kontrolniPlaniServerToolStripMenuItem";
            this.kontrolniPlaniServerToolStripMenuItem.Size = new System.Drawing.Size(198, 26);
            this.kontrolniPlaniServerToolStripMenuItem.Text = "Kontrolni plani";
            this.kontrolniPlaniServerToolStripMenuItem.Click += new System.EventHandler(this.KontrolniPlaniServerMenuItem_Click);
            // 
            // meritveServerToolStripMenuItem
            // 
            this.meritveServerToolStripMenuItem.Name = "meritveServerToolStripMenuItem";
            this.meritveServerToolStripMenuItem.Size = new System.Drawing.Size(198, 26);
            this.meritveServerToolStripMenuItem.Text = "Meritve";
            this.meritveServerToolStripMenuItem.Click += new System.EventHandler(this.MeritveServerMenuItem_Click);
            // 
            // nastavitveToolStripMenuItem
            // 
            this.nastavitveToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.vpisStevKanalaToolStripMenuItem,
            this.decimalkeToolStripMenuItem,
            this.beriMeritveSettingsToolStripMenuItem});
            this.nastavitveToolStripMenuItem.Name = "nastavitveToolStripMenuItem";
            this.nastavitveToolStripMenuItem.Size = new System.Drawing.Size(92, 27);
            this.nastavitveToolStripMenuItem.Text = "Nastavitve";
            // 
            // vpisStevKanalaToolStripMenuItem
            // 
            this.vpisStevKanalaToolStripMenuItem.Name = "vpisStevKanalaToolStripMenuItem";
            this.vpisStevKanalaToolStripMenuItem.Size = new System.Drawing.Size(184, 26);
            this.vpisStevKanalaToolStripMenuItem.Text = "Vpis št. kanala";
            this.vpisStevKanalaToolStripMenuItem.Click += new System.EventHandler(this.VpisStevKanalaMenuItem_Click);
            // 
            // decimalkeToolStripMenuItem
            // 
            this.decimalkeToolStripMenuItem.Name = "decimalkeToolStripMenuItem";
            this.decimalkeToolStripMenuItem.Size = new System.Drawing.Size(184, 26);
            this.decimalkeToolStripMenuItem.Text = "Decimalke";
            this.decimalkeToolStripMenuItem.Click += new System.EventHandler(this.DecimalkeMenuItem_Click);
            // 
            // beriMeritveSettingsToolStripMenuItem
            // 
            this.beriMeritveSettingsToolStripMenuItem.Name = "beriMeritveSettingsToolStripMenuItem";
            this.beriMeritveSettingsToolStripMenuItem.Size = new System.Drawing.Size(184, 26);
            this.beriMeritveSettingsToolStripMenuItem.Text = "Beri meritve";
            this.beriMeritveSettingsToolStripMenuItem.Click += new System.EventHandler(this.BeriMeritveSettingsMenuItem_Click);
            // 
            // operacijeToolStripMenuItem
            // 
            this.operacijeToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.dodatneKodeToolStripMenuItem});
            this.operacijeToolStripMenuItem.Name = "operacijeToolStripMenuItem";
            this.operacijeToolStripMenuItem.Size = new System.Drawing.Size(87, 27);
            this.operacijeToolStripMenuItem.Text = "Operacije";
            // 
            // dodatneKodeToolStripMenuItem
            // 
            this.dodatneKodeToolStripMenuItem.Name = "dodatneKodeToolStripMenuItem";
            this.dodatneKodeToolStripMenuItem.Size = new System.Drawing.Size(187, 26);
            this.dodatneKodeToolStripMenuItem.Text = "Dodatne kode";
            this.dodatneKodeToolStripMenuItem.Click += new System.EventHandler(this.DodatneKodeMenuItem_Click);
            // 
            // informacijeToolStripMenuItem
            // 
            this.informacijeToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.merilaInfoToolStripMenuItem,
            this.prijavaInfoToolStripMenuItem});
            this.informacijeToolStripMenuItem.Name = "informacijeToolStripMenuItem";
            this.informacijeToolStripMenuItem.Size = new System.Drawing.Size(98, 27);
            this.informacijeToolStripMenuItem.Text = "Informacije";
            // 
            // merilaInfoToolStripMenuItem
            // 
            this.merilaInfoToolStripMenuItem.Name = "merilaInfoToolStripMenuItem";
            this.merilaInfoToolStripMenuItem.Size = new System.Drawing.Size(136, 26);
            this.merilaInfoToolStripMenuItem.Text = "Merila";
            this.merilaInfoToolStripMenuItem.Click += new System.EventHandler(this.MerilaInfoMenuItem_Click);
            // 
            // prijavaInfoToolStripMenuItem
            // 
            this.prijavaInfoToolStripMenuItem.Name = "prijavaInfoToolStripMenuItem";
            this.prijavaInfoToolStripMenuItem.Size = new System.Drawing.Size(136, 26);
            this.prijavaInfoToolStripMenuItem.Text = "Prijava";
            this.prijavaInfoToolStripMenuItem.Click += new System.EventHandler(this.PrijavaInfoMenuItem_Click);
            // 
            // adminToggleButton
            // 
            this.adminToggleButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.adminToggleButton.ForeColor = System.Drawing.Color.Green;
            this.adminToggleButton.Image = ((System.Drawing.Image)(resources.GetObject("adminToggleButton.Image")));
            this.adminToggleButton.Margin = new System.Windows.Forms.Padding(4, 1, 4, 2);
            this.adminToggleButton.Name = "adminToggleButton";
            this.adminToggleButton.Size = new System.Drawing.Size(77, 24);
            this.adminToggleButton.Text = "Prijava";
            this.adminToggleButton.Click += new System.EventHandler(this.AdminToggleButton_Click);
            // 
            // versionInfoLabel
            // 
            this.versionInfoLabel.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.versionInfoLabel.Font = new System.Drawing.Font("Segoe UI", 8F);
            this.versionInfoLabel.ForeColor = System.Drawing.Color.Gray;
            this.versionInfoLabel.Margin = new System.Windows.Forms.Padding(4, 1, 6, 2);
            this.versionInfoLabel.Name = "versionInfoLabel";
            this.versionInfoLabel.Size = new System.Drawing.Size(35, 24);
            this.versionInfoLabel.Text = "v2.0";
            // 
            // variabilneTitleLabel
            // 
            this.variabilneTitleLabel.Font = new System.Drawing.Font("Segoe UI", 10F, System.Drawing.FontStyle.Bold);
            this.variabilneTitleLabel.ForeColor = System.Drawing.Color.Black;
            this.variabilneTitleLabel.Location = new System.Drawing.Point(27, 222);
            this.variabilneTitleLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.variabilneTitleLabel.Name = "variabilneTitleLabel";
            this.variabilneTitleLabel.Size = new System.Drawing.Size(467, 32);
            this.variabilneTitleLabel.TabIndex = 5;
            this.variabilneTitleLabel.Text = "Variabilne karakteristike";
            // 
            // atributivneTitleLabel
            // 
            this.atributivneTitleLabel.Font = new System.Drawing.Font("Segoe UI", 10F, System.Drawing.FontStyle.Bold);
            this.atributivneTitleLabel.ForeColor = System.Drawing.Color.Black;
            this.atributivneTitleLabel.Location = new System.Drawing.Point(27, 530);
            this.atributivneTitleLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.atributivneTitleLabel.Name = "atributivneTitleLabel";
            this.atributivneTitleLabel.Size = new System.Drawing.Size(467, 32);
            this.atributivneTitleLabel.TabIndex = 6;
            this.atributivneTitleLabel.Text = "Atributivne karakteristike";
            // 
            // ZacetnaForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1680, 800);
            this.Controls.Add(this.rightPanel);
            this.Controls.Add(this.topPanel);
            this.Controls.Add(this.menuStrip);
            this.Controls.Add(this.variabilneTitleLabel);
            this.Controls.Add(this.KaraktiGrid);
            this.Controls.Add(this.atributivneTitleLabel);
            this.Controls.Add(this.attriGrid);
            this.MainMenuStrip = this.menuStrip;
            this.Margin = new System.Windows.Forms.Padding(4);
            this.Name = "ZacetnaForm";
            this.Text = "Program merilnega mesta";
            this.topPanel.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.logoPicture)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.KaraktiGrid)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.attriGrid)).EndInit();
            this.rightPanel.ResumeLayout(false);
            this.menuStrip.ResumeLayout(false);
            this.menuStrip.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button PrijavaAdminButton;
        private System.Windows.Forms.Label PrijavljenLabel;
        private System.Windows.Forms.Button LegendaButton;
        private System.Windows.Forms.Button SemaforButton;
        private System.Windows.Forms.Button KonecButton;
        private System.Windows.Forms.Panel topPanel;
        private System.Windows.Forms.ListBox machinesList;
        private System.Windows.Forms.ListBox codesList;
        private System.Windows.Forms.DataGridView KaraktiGrid;
        private System.Windows.Forms.DataGridView attriGrid;
        private System.Windows.Forms.Panel rightPanel;
        private System.Windows.Forms.Button TransferButton;
        private System.Windows.Forms.Button TransferWithPedalButton;
        private System.Windows.Forms.Button PrekinButton;
        private System.Windows.Forms.Button SAPButton;
        private System.Windows.Forms.Button MeritveButton;
        private System.Windows.Forms.Button LegendaSideButton;
        private System.Windows.Forms.Button SemaforSideButton;
        private System.Windows.Forms.Button GrafButton;
        private System.Windows.Forms.Button KonecSideButton;
        private System.Windows.Forms.MenuStrip menuStrip;
        private System.Windows.Forms.PictureBox logoPicture;
        private System.Windows.Forms.Label companyLabel;

        // menu fields
        private System.Windows.Forms.ToolStripMenuItem bazaNaServerjuToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem nastavitveToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem operacijeToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem informacijeToolStripMenuItem;
        // Baza na serverju
        private System.Windows.Forms.ToolStripMenuItem merilnaMestaServerToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem strojiServerToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem merilneMetodeServerToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem ukrepiServerToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem kontrolniPlaniServerToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem meritveServerToolStripMenuItem;
        // Nastavitve
        private System.Windows.Forms.ToolStripMenuItem vpisStevKanalaToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem decimalkeToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem beriMeritveSettingsToolStripMenuItem;
        // Operacije
        private System.Windows.Forms.ToolStripMenuItem dodatneKodeToolStripMenuItem;
        // Informacije
        private System.Windows.Forms.ToolStripMenuItem merilaInfoToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem prijavaInfoToolStripMenuItem;
        private System.Windows.Forms.ToolStripLabel versionInfoLabel;
        private System.Windows.Forms.ToolStripButton adminToggleButton;

        // Variabilne in atributne karakteristike title label
        private System.Windows.Forms.Label variabilneTitleLabel;
        private System.Windows.Forms.Label atributivneTitleLabel;
    }
}
