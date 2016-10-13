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
using System.Runtime.InteropServices;
using System.Management;

//namespace SysWin32
//{
//    [DllImport("user32.dll")]
//    static extern int SetForegroundWindow(IntPtr point);
//}
//namespace SysWin32
//{
//    [DllImport("user32.dll", EntryPoint = "MessageBox")]
//    Int32 static MessageBox(Int32 hWnd, String* lpText, String* lpCaption,
//                      UInt32 uType);
//}

namespace getProcess
{
    public partial class Form1 : Form
    {
        [DllImport("msvcrt.dll")]
        public static extern int puts(string c);
        [DllImport("msvcrt.dll")]
        internal static extern int _flushall();
        [DllImport("user32.dll")]
        static extern int SetForegroundWindow(IntPtr point);

        public Process vPWProc;

        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string vLstMsg = "";
            textBox1.Text = ""; 
            listBox1.Items.Clear();
            Process[] getProcs = Process.GetProcesses();
            MessageBox.Show ( getProcs.Count().ToString());
            foreach (Process vProc in getProcs)
            {
                //vLstMsg = vProc.ProcessName + "," +  vProc.StartTime.ToString("hh:mmm:ss")  ;
                vLstMsg = vProc.ProcessName ;
                listBox1.Items.Add(vLstMsg);
                textBox1.Text = textBox1.Text + vLstMsg; 
            }
        }


        private void sendMsg(Process inProc)
        {
            IntPtr vPointer = inProc.MainWindowHandle;
            SetForegroundWindow(vPointer);
        }

    private void button2_Click(object sender, EventArgs e)
        {
            string vLstMsg = "";            

            Process[] vProcesses = Process.GetProcessesByName("IMSV732");
            foreach (Process vProc in vProcesses)
            {
                //vLstMsg = vProc.ProcessName + "," +  vProc.StartTime.ToString("hh:mmm:ss")  ;
                vLstMsg = vProc.ProcessName;
                listBox1.Items.Add(vLstMsg);
                textBox1.Text = textBox1.Text + vLstMsg;
                sendMsg(vProc);
                SendKeys.SendWait("%(D)");
                SendKeys.SendWait("JOSEPH");
                SendKeys.SendWait("{TAB 4}");
                SendKeys.SendWait("JOSEPH");
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            string[] c1;
            string vStrVal = listBox1.Items[listBox1.SelectedIndex].ToString();
            foreach (Process vProc in Process.GetProcessesByName(vStrVal) )
            {
                try
                {
                    using (ManagementObjectSearcher searcher = new ManagementObjectSearcher("SELECT CommandLine FROM Win32_Process WHERE ProcessId = " + vProc.Id))
                    {
                        foreach (ManagementObject mgmtObj in searcher.Get() )
                        {
                            c1 = mgmtObj["CommandLine"].ToString().Split(',');//.Split(""");
                            textBox2.Text = c1[c1.Length - 1];
                        }
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message.ToString());
                }
                //System.Threading.Thread.Sleep(100000);
            }
            //Dim cl() As String
            //For Each p As Process In Process.GetProcessesByName("notepad")
            //    Try
            //        Using searcher As New ManagementObjectSearcher("SELECT CommandLine FROM Win32_Process WHERE ProcessId = " & p.Id)
            //            For Each mgmtObj As ManagementObject In searcher.Get()
            //                cl = mgmtObj.Item("CommandLine").ToString().Split("""")
            //                Console.WriteLine(cl(cl.Length - 1))
            //            Next
            //        End Using
            //    Catch ex As Win32Exception
            //        'handle error
            //    End Try
            //Next
            //System.Threading.Thread.Sleep(1000000)

        }

        private void button4_Click(object sender, EventArgs e)
        {
            listBox1.Items.RemoveAt(listBox1.SelectedIndex);
            //listBox1.Items[listBox1.SelectedIndex]. 
        }

        private void getHansenHandle()
        {
            Process[] vProcesses = Process.GetProcessesByName("IMSV732");
            vPWProc = vProcesses[0];
        }

        private void closeWindowHandle()
        {
            vPWProc = null;
        }

        private void openLoadForm()
        {
            if (!(vPWProc == null))
            {
                sendMsg(vPWProc);
                SendKeys.SendWait("{TAB 1}");
                SendKeys.SendWait("^{l}");
                System.Threading.Thread.Sleep(3000);
                SendKeys.SendWait("^{s}");
                //SendKeys.SendWait(textBox6.Text );

                //SendKeys.SendWait("^{O}");
                //Application.DoEvents();
                //SendKeys.SendWait("^{S}");


                //SendKeys.SendWait("{HOME}");
                //SendKeys.SendWait("+{END}");
                //SendKeys.SendWait("^{INS}");

                //textBox3.Text = Clipboard.GetText();

                //SendKeys.SendWait("%(T)");
                //SendKeys.SendWait("{TAB 1}");
                //SendKeys.SendWait("{HOME}");
                //SendKeys.SendWait("+{END}");
                //SendKeys.SendWait("^{INS}");
                //textBox4.Text = Clipboard.GetText();            }
            }
        }
        private void copyContends()
        {
            if (!(vPWProc == null))
            {
                sendMsg(vPWProc);
                //SendKeys.SendWait("{TAB 1}");
                SendKeys.SendWait("{HOME}");
                SendKeys.SendWait("+{END}");
                SendKeys.SendWait("^{INS}");

                System.Threading.Thread.Sleep(3000);

                textBox3.Text = Clipboard.GetText();

                System.Threading.Thread.Sleep(3000);

                SendKeys.SendWait("%(T)");
                SendKeys.SendWait("{TAB 1}");
                SendKeys.SendWait("{HOME}");
                SendKeys.SendWait("+{END}");
                SendKeys.SendWait("^{INS}");
                textBox4.Text = Clipboard.GetText();
                System.Threading.Thread.Sleep(3000);
                SendKeys.SendWait("^{F4}");
            }
        }

        private void openAssetWindow()
        {
            if (!(vPWProc == null))
            {
                sendMsg(vPWProc);
                //SendKeys.SendWait("{TAB 1}");
                SendKeys.SendWait("%{A}");
                SendKeys.SendWait("{DOWN 3}");
                SendKeys.SendWait("{RIGHT 1}");
                Application.DoEvents();
                SendKeys.SendWait("{DOWN 3}");
                SendKeys.SendWait("{ENTER 1}");
                Application.DoEvents();
                SendKeys.SendWait("^{O}");
                SendKeys.SendWait("%{G}");
                Application.DoEvents();
                SendKeys.SendWait(textBox5.Text);
                Application.DoEvents();
                System.Threading.Thread.Sleep(3000);
                SendKeys.SendWait("{TAB 1}");
            }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            copyContends();

            //string vLstMsg = "";
            //Process[] vProcesses = Process.GetProcessesByName("IMSV732");
            //foreach (Process vProc in vProcesses)
            //{


            //    sendMsg(vProc);
            //    //SendKeys.SendWait("{TAB 1}");
            //    SendKeys.SendWait("{HOME}");
            //    SendKeys.SendWait("+{END}");
            //    SendKeys.SendWait("^{INS}");

            //    textBox3.Text =  Clipboard.GetText();

            //    SendKeys.SendWait("%(T)");
            //    SendKeys.SendWait("{TAB 1}");
            //    SendKeys.SendWait("{HOME}");
            //    SendKeys.SendWait("+{END}");
            //    SendKeys.SendWait("^{INS}");
            //    textBox4.Text = Clipboard.GetText();

            //}
        }
        private void button6_Click(object sender, EventArgs e)
        {
            //string vLstMsg = "";

            //Process[] vProcesses = Process.GetProcessesByName("IMSV732");
            //foreach (Process vProc in vProcesses)
            openAssetWindow();

        }

        private void button7_Click(object sender, EventArgs e)
        {
            getHansenHandle();
        }


        private void button8_Click(object sender, EventArgs e)
        {
            openLoadForm();
        }

        private void button9_Click(object sender, EventArgs e)
        {
            closeWindowHandle();
        }

        private void button10_Click(object sender, EventArgs e)
        {
            label1.Text = "Getting handler....";
            button7_Click(this, null);
            label1.Text = "Opening hansen window....";
            button6_Click(this, null);
            label1.Text = "Finding asset....";
            button8_Click(this, null);
            label1.Text = "Loading asset....";
            button5_Click(this, null);
            label1.Text = "Copying attributes....";
            button9_Click(this, null);
            label1.Text = "Completed";
        }
    }
}
