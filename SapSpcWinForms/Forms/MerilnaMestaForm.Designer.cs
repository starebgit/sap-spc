namespace SapSpcWinForms
{
    partial class MerilnaMestaForm
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
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.urejanjeToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.vpisMerilnegaMestaToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.brisiMerilnoMestoToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.panelTop = new System.Windows.Forms.Panel();
            this.labelMerilnoMesto = new System.Windows.Forms.Label();
            this.labelInfo1 = new System.Windows.Forms.Label();
            this.labelInfo2 = new System.Windows.Forms.Label();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.menuStrip1.SuspendLayout();
            this.panelTop.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            this.SuspendLayout();
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.urejanjeToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(900, 24);
            this.menuStrip1.TabIndex = 0;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // urejanjeToolStripMenuItem
            // 
            this.urejanjeToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.vpisMerilnegaMestaToolStripMenuItem,
            this.brisiMerilnoMestoToolStripMenuItem});
            this.urejanjeToolStripMenuItem.Name = "urejanjeToolStripMenuItem";
            this.urejanjeToolStripMenuItem.Size = new System.Drawing.Size(63, 20);
            this.urejanjeToolStripMenuItem.Text = "Urejanje";
            // 
            // vpisMerilnegaMestaToolStripMenuItem
            // 
            this.vpisMerilnegaMestaToolStripMenuItem.Name = "vpisMerilnegaMestaToolStripMenuItem";
            this.vpisMerilnegaMestaToolStripMenuItem.Size = new System.Drawing.Size(190, 22);
            this.vpisMerilnegaMestaToolStripMenuItem.Text = "Vpis merilnega mesta";
            this.vpisMerilnegaMestaToolStripMenuItem.Click += new System.EventHandler(this.vpisMerilnegaMestaToolStripMenuItem_Click);
            // 
            // brisiMerilnoMestoToolStripMenuItem
            // 
            this.brisiMerilnoMestoToolStripMenuItem.Name = "brisiMerilnoMestoToolStripMenuItem";
            this.brisiMerilnoMestoToolStripMenuItem.Size = new System.Drawing.Size(190, 22);
            this.brisiMerilnoMestoToolStripMenuItem.Text = "Briši merilno mesto";
            this.brisiMerilnoMestoToolStripMenuItem.Click += new System.EventHandler(this.brisiMerilnoMestoToolStripMenuItem_Click);
            // 
            // panelTop
            // 
            this.panelTop.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(224)))), ((int)(((byte)(243)))), ((int)(((byte)(242)))));
            this.panelTop.Controls.Add(this.labelInfo2);
            this.panelTop.Controls.Add(this.labelInfo1);
            this.panelTop.Controls.Add(this.labelMerilnoMesto);
            this.panelTop.Dock = System.Windows.Forms.DockStyle.Top;
            this.panelTop.Location = new System.Drawing.Point(0, 0);
            this.panelTop.Name = "panelTop";
            this.panelTop.Size = new System.Drawing.Size(900, 60);
            this.panelTop.TabIndex = 1;
            // 
            // labelMerilnoMesto
            // 
            this.labelMerilnoMesto.AutoSize = true;
            this.labelMerilnoMesto.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Bold);
            this.labelMerilnoMesto.Location = new System.Drawing.Point(12, 10);
            this.labelMerilnoMesto.Name = "labelMerilnoMesto";
            this.labelMerilnoMesto.Size = new System.Drawing.Size(114, 16);
            this.labelMerilnoMesto.TabIndex = 0;
            this.labelMerilnoMesto.Text = "Merilno mesto:";
            // 
            // labelInfo1
            // 
            this.labelInfo1.AutoSize = true;
            this.labelInfo1.Location = new System.Drawing.Point(400, 10);
            this.labelInfo1.Name = "labelInfo1";
            this.labelInfo1.Size = new System.Drawing.Size(188, 13);
            this.labelInfo1.TabIndex = 1;
            // 
            // labelInfo2
            // 
            this.labelInfo2.AutoSize = true;
            this.labelInfo2.Location = new System.Drawing.Point(400, 30);
            this.labelInfo2.Name = "labelInfo2";
            this.labelInfo2.Size = new System.Drawing.Size(171, 13);
            this.labelInfo2.TabIndex = 2;
            // 
            // dataGridView1
            // 
            this.dataGridView1.AllowUserToAddRows = true;
            this.dataGridView1.AllowUserToDeleteRows = true;
            this.dataGridView1.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dataGridView1.BackgroundColor = System.Drawing.Color.White;
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dataGridView1.Location = new System.Drawing.Point(0, 60);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.Size = new System.Drawing.Size(900, 416);
            this.dataGridView1.TabIndex = 2;
            // 
            // MerilnaMestaForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(900, 500);
            this.Controls.Add(this.dataGridView1);
            this.Controls.Add(this.panelTop);
            this.Name = "MerilnaMestaForm";
            this.Text = "Merilna mesta";
            this.Load += new System.EventHandler(this.MerilnaMestaForm_Load);
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.MerilnaMestaForm_FormClosing);
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.panelTop.ResumeLayout(false);
            this.panelTop.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();
        }

        #endregion

        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem urejanjeToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem vpisMerilnegaMestaToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem brisiMerilnoMestoToolStripMenuItem;
        private System.Windows.Forms.Panel panelTop;
        private System.Windows.Forms.Label labelMerilnoMesto;
        private System.Windows.Forms.Label labelInfo1;
        private System.Windows.Forms.Label labelInfo2;
        private System.Windows.Forms.DataGridView dataGridView1;
    }
}
