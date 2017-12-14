using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Diagnostics;
using System.Threading;

namespace testUrls
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            String vIdVal = "";
            vIdVal = textBox2.Text;
            vIdVal = string.Format(textBox1.Text, vIdVal);
            System.Diagnostics.Process.Start("iexplore", vIdVal);
        }

        private void button2_Click(object sender, EventArgs e)
        {
            for (int vI=0;vI< textBox3.Lines.Count(); vI++)
            {
                textBox2.Text = textBox3.Lines[vI];
                button1_Click(this, null);
                Thread.Sleep(5000);
            }            
        }

        private void button3_Click(object sender, EventArgs e)
        {
            String vIdVal = "";
            vIdVal = textBox5.Text;
            vIdVal = string.Format(textBox4.Text, vIdVal);
            System.Diagnostics.Process.Start("iexplore", vIdVal);
        }

        private void button4_Click(object sender, EventArgs e)
        {
            for (int vI = 0; vI < textBox3.Lines.Count(); vI++)
            {
                textBox5.Text = textBox3.Lines[vI];
                button3_Click(this, null);
                Thread.Sleep(5000);
            }
        }
    }
}
