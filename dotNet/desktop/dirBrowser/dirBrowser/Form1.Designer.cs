namespace dirBrowser
{
    partial class frmSrchDir
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle3 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle();
            this.pnlTop = new System.Windows.Forms.Panel();
            this.statusStrip1 = new System.Windows.Forms.StatusStrip();
            this.pnlBottom = new System.Windows.Forms.Panel();
            this.pnlMiddl = new System.Windows.Forms.Panel();
            this.button2 = new System.Windows.Forms.Button();
            this.btnSearch = new System.Windows.Forms.Button();
            this.txtSrchDir = new System.Windows.Forms.TextBox();
            this.panel4 = new System.Windows.Forms.Panel();
            this.dtGrdLstAttr = new System.Windows.Forms.DataGridView();
            this.panel5 = new System.Windows.Forms.Panel();
            this.Column1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Column2 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Column3 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Column4 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Column5 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.txtFldrName = new System.Windows.Forms.TextBox();
            this.pnlMiddl.SuspendLayout();
            this.panel4.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dtGrdLstAttr)).BeginInit();
            this.panel5.SuspendLayout();
            this.SuspendLayout();
            // 
            // pnlTop
            // 
            this.pnlTop.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.pnlTop.Dock = System.Windows.Forms.DockStyle.Top;
            this.pnlTop.Location = new System.Drawing.Point(0, 0);
            this.pnlTop.Name = "pnlTop";
            this.pnlTop.Size = new System.Drawing.Size(649, 70);
            this.pnlTop.TabIndex = 0;
            // 
            // statusStrip1
            // 
            this.statusStrip1.Location = new System.Drawing.Point(0, 620);
            this.statusStrip1.Name = "statusStrip1";
            this.statusStrip1.Size = new System.Drawing.Size(649, 22);
            this.statusStrip1.TabIndex = 1;
            this.statusStrip1.Text = "statusStrip1";
            // 
            // pnlBottom
            // 
            this.pnlBottom.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.pnlBottom.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.pnlBottom.Location = new System.Drawing.Point(0, 551);
            this.pnlBottom.Name = "pnlBottom";
            this.pnlBottom.Size = new System.Drawing.Size(649, 69);
            this.pnlBottom.TabIndex = 2;
            // 
            // pnlMiddl
            // 
            this.pnlMiddl.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.pnlMiddl.Controls.Add(this.panel5);
            this.pnlMiddl.Controls.Add(this.panel4);
            this.pnlMiddl.Dock = System.Windows.Forms.DockStyle.Fill;
            this.pnlMiddl.Location = new System.Drawing.Point(0, 70);
            this.pnlMiddl.Name = "pnlMiddl";
            this.pnlMiddl.Size = new System.Drawing.Size(649, 481);
            this.pnlMiddl.TabIndex = 3;
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(262, 15);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(27, 23);
            this.button2.TabIndex = 2;
            this.button2.Text = "button2";
            this.button2.UseVisualStyleBackColor = true;
            // 
            // btnSearch
            // 
            this.btnSearch.Location = new System.Drawing.Point(181, 43);
            this.btnSearch.Name = "btnSearch";
            this.btnSearch.Size = new System.Drawing.Size(242, 23);
            this.btnSearch.TabIndex = 1;
            this.btnSearch.Text = "...";
            this.btnSearch.UseVisualStyleBackColor = true;
            this.btnSearch.Click += new System.EventHandler(this.btnSearch_Click);
            // 
            // txtSrchDir
            // 
            this.txtSrchDir.Location = new System.Drawing.Point(11, 17);
            this.txtSrchDir.Name = "txtSrchDir";
            this.txtSrchDir.Size = new System.Drawing.Size(245, 20);
            this.txtSrchDir.TabIndex = 0;
            this.txtSrchDir.Text = "C:\\Temp\\20170113";
            // 
            // panel4
            // 
            this.panel4.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panel4.Controls.Add(this.dtGrdLstAttr);
            this.panel4.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel4.Location = new System.Drawing.Point(0, 0);
            this.panel4.Name = "panel4";
            this.panel4.Size = new System.Drawing.Size(647, 479);
            this.panel4.TabIndex = 7;
            // 
            // dtGrdLstAttr
            // 
            this.dtGrdLstAttr.AllowUserToAddRows = false;
            this.dtGrdLstAttr.AllowUserToDeleteRows = false;
            this.dtGrdLstAttr.AllowUserToResizeRows = false;
            dataGridViewCellStyle3.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(224)))), ((int)(((byte)(224)))), ((int)(((byte)(224)))));
            this.dtGrdLstAttr.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle3;
            this.dtGrdLstAttr.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dtGrdLstAttr.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.Column1,
            this.Column2,
            this.Column3,
            this.Column4,
            this.Column5});
            this.dtGrdLstAttr.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dtGrdLstAttr.EditMode = System.Windows.Forms.DataGridViewEditMode.EditProgrammatically;
            this.dtGrdLstAttr.Location = new System.Drawing.Point(0, 0);
            this.dtGrdLstAttr.Name = "dtGrdLstAttr";
            this.dtGrdLstAttr.ReadOnly = true;
            this.dtGrdLstAttr.ShowEditingIcon = false;
            this.dtGrdLstAttr.Size = new System.Drawing.Size(645, 477);
            this.dtGrdLstAttr.TabIndex = 0;
            // 
            // panel5
            // 
            this.panel5.Controls.Add(this.txtFldrName);
            this.panel5.Controls.Add(this.btnSearch);
            this.panel5.Controls.Add(this.txtSrchDir);
            this.panel5.Controls.Add(this.button2);
            this.panel5.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panel5.Location = new System.Drawing.Point(0, 410);
            this.panel5.Name = "panel5";
            this.panel5.Size = new System.Drawing.Size(647, 69);
            this.panel5.TabIndex = 8;
            // 
            // Column1
            // 
            this.Column1.HeaderText = "Name";
            this.Column1.Name = "Column1";
            this.Column1.ReadOnly = true;
            // 
            // Column2
            // 
            this.Column2.HeaderText = "Create Date";
            this.Column2.Name = "Column2";
            this.Column2.ReadOnly = true;
            this.Column2.Width = 150;
            // 
            // Column3
            // 
            dataGridViewCellStyle4.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(224)))), ((int)(((byte)(224)))), ((int)(((byte)(224)))));
            this.Column3.DefaultCellStyle = dataGridViewCellStyle4;
            this.Column3.FillWeight = 50F;
            this.Column3.HeaderText = "-";
            this.Column3.MaxInputLength = 0;
            this.Column3.Name = "Column3";
            this.Column3.ReadOnly = true;
            this.Column3.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.Column3.Width = 25;
            // 
            // Column4
            // 
            this.Column4.HeaderText = "Folder Path";
            this.Column4.Name = "Column4";
            this.Column4.ReadOnly = true;
            // 
            // Column5
            // 
            this.Column5.HeaderText = "Size";
            this.Column5.Name = "Column5";
            this.Column5.ReadOnly = true;
            this.Column5.Width = 150;
            // 
            // txtFldrName
            // 
            this.txtFldrName.Location = new System.Drawing.Point(323, 17);
            this.txtFldrName.Name = "txtFldrName";
            this.txtFldrName.Size = new System.Drawing.Size(147, 20);
            this.txtFldrName.TabIndex = 3;
            // 
            // frmSrchDir
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(649, 642);
            this.Controls.Add(this.pnlMiddl);
            this.Controls.Add(this.pnlBottom);
            this.Controls.Add(this.statusStrip1);
            this.Controls.Add(this.pnlTop);
            this.Name = "frmSrchDir";
            this.Text = "Form1";
            this.pnlMiddl.ResumeLayout(false);
            this.panel4.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dtGrdLstAttr)).EndInit();
            this.panel5.ResumeLayout(false);
            this.panel5.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Panel pnlTop;
        private System.Windows.Forms.StatusStrip statusStrip1;
        private System.Windows.Forms.Panel pnlBottom;
        private System.Windows.Forms.Panel pnlMiddl;
        private System.Windows.Forms.TextBox txtSrchDir;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.Button btnSearch;
        private System.Windows.Forms.Panel panel4;
        private System.Windows.Forms.DataGridView dtGrdLstAttr;
        private System.Windows.Forms.Panel panel5;
        private System.Windows.Forms.DataGridViewTextBoxColumn Column1;
        private System.Windows.Forms.DataGridViewTextBoxColumn Column2;
        private System.Windows.Forms.DataGridViewTextBoxColumn Column3;
        private System.Windows.Forms.DataGridViewTextBoxColumn Column4;
        private System.Windows.Forms.DataGridViewTextBoxColumn Column5;
        private System.Windows.Forms.TextBox txtFldrName;
    }
}

