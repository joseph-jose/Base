using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace dirBrowser
{
    public partial class frmSrchDir : Form
    {
        public frmSrchDir()
        {
            InitializeComponent();
        }

        public void addDetToGrid(string col1, string col2, string col3, string col4)
        {
            dtGrdLstAttr.Rows.Add();

            dtGrdLstAttr.Rows[dtGrdLstAttr.Rows.Count - 1].Cells[0].Value = col1;
            dtGrdLstAttr.Rows[dtGrdLstAttr.Rows.Count - 1].Cells[1].Value = col2;

            dtGrdLstAttr.Rows[dtGrdLstAttr.Rows.Count - 1].Cells[3].Value = col3;
            dtGrdLstAttr.Rows[dtGrdLstAttr.Rows.Count - 1].Cells[4].Value = col4;
        }

        public double  getFileSize(System.IO.DirectoryInfo inDir)
        {
            //System.IO.DirectoryInfo dir = new DirectoryInfo('Directory Fullpath');
            //FileSystemInfo[] filelist = dir.GetFileSystemInfos();
            double vDirSize = 0;
            System.IO.FileInfo[] fileInfos;
            fileInfos = inDir.GetFiles("*", System.IO.SearchOption.AllDirectories);
            for (int i = 0; i < fileInfos.Length; i++)
            {
                try
                {
                    vDirSize += fileInfos[i].Length;
                }
                catch { }
            }
            return vDirSize;
        }

        public void WalkDirectoryTree(System.IO.DirectoryInfo root, string inFldrName)
        {
            System.IO.FileInfo[] files = null;
            System.IO.DirectoryInfo[] subDirs = null;
            double vDirSize = 0;

            try
            {
                files = root.GetFiles("*.*");
            }
            catch (UnauthorizedAccessException e)
            {
                //log.Add(e.Message);
                addDetToGrid(e.Message.ToString(), "", "", "");
            }
            catch (System.IO.DirectoryNotFoundException e)
            {
                Console.WriteLine(e.Message);
            }

            if (files != null)
            {
                //foreach (System.IO.FileInfo fi in files)
                //{
                //    //Console.WriteLine(fi.FullName);
                //    addDetToGrid(fi.Name , fi.CreationTime.ToString("dd/mm/yy hh:mm:ss"), fi.Directory.ToString(), "");
                //}

                subDirs = root.GetDirectories();

                foreach (System.IO.DirectoryInfo dirInfo in subDirs)
                {
                    if (!(dirInfo.Name.ToUpper().IndexOf(inFldrName.ToUpper()) == -1))
                    {
                        vDirSize = getFileSize(dirInfo);
                        vDirSize = vDirSize / 1000;
                        vDirSize = vDirSize / 1064;
                        addDetToGrid(dirInfo.Name, dirInfo.CreationTime.ToString("dd/mm/yy hh:mm:ss"), dirInfo.FullName.ToString(), vDirSize.ToString("0.0"));
                    }
                    WalkDirectoryTree(dirInfo, inFldrName);                    
                }
            }
        }
        private void btnSearch_Click(object sender, EventArgs e)
        {
            System.IO.DirectoryInfo rootDir = new System.IO.DirectoryInfo(txtSrchDir.Text ) ;                        
            //= di.RootDirectory;
            WalkDirectoryTree(rootDir, txtFldrName.Text );
        }
    }
}
