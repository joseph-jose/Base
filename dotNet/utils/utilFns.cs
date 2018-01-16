using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Threading.Tasks;
using Microsoft.VisualBasic;
using System.Reflection;

namespace WindowsFormsApplication1
{

    struct structDataType
    {
        public string Value;
        public int Count;
    }

    class utilFns
    {
        public static bool intimateDuplicates(string inCommaDelimStr)
        {
            bool vBoolRes = false;
            List<string> vLst = new List<string>();
            try
            {
                vLst = inCommaDelimStr.Split(',').ToList<string>();
                var duplicates = from item in vLst
                                 group item by item into g
                                 let count = g.Count()
                                 where g.Count() > 1
                                 select new structDataType { Value = g.Key, Count = count };
                foreach (structDataType s in duplicates)
                {
                    //vDataType = (structDataType)s;
                    MessageBox.Show("Duplicate Value for " + s.Value.ToString() + " occurs " + s.Count.ToString() + " times");
                    vBoolRes = true;
                }
            }
            finally
            {
                vLst = null;
            }
            return vBoolRes;
        }

        public static void transferMsg2()
        {
            System.Type vType;
            vType = System.Type.GetTypeFromProgID("winmgmts:");
            Object vObj = null;
            //vObj = System.Runtime.InteropServices.Marshal.GetActiveObject("winmgmts:");
            vObj = System.Runtime.InteropServices.Marshal.GetActiveObject("winmgmt");
            //vObj = System.Runtime.InteropServices.Marshal.GetActiveObject("Excel.Application");
            if (!(vObj == null))
            {
                MessageBox.Show("Hello");
                vObj = null;
            }
        }

        public static void transferMsg()
        {
            System.Type vType;

            object vObj = null;
            object vMthdObj = null;
            Object vExeQryRes = null;


            vObj = Microsoft.VisualBasic.Interaction.GetObject("winmgmts:");

            vType = vObj.GetType();

            if (!(vObj == null))
            {
                vObj = null;
                MessageBox.Show("hello");

                MethodInfo vMtdInfo = vType.GetMethod("ExecQuery");
                if ((vMthdObj == null))
                {
                    MessageBox.Show("Methodfound");
                }
                //vMthdObj = vMtdInfo.Invoke(vObj, ["Select * from Win32_Process where name='IMSV732.exe'"]);
                //vExeQryRes = (vType)vObj.ExecQuery("Select * from Win32_Process where name='IMSV732.exe'");

                //if (vExeQryRes.Count)
                //  MessageBox.Show("y");
                //else
                //    MessageBox.Show("n");
            }
        }


        #region "UnixTime"

        public static DateTime UnixTimeStampToDateTime(double unixTimeStamp)
        {
            // Unix timestamp is seconds past epoch
            System.DateTime dtDateTime = new DateTime(1970, 1, 1, 0, 0, 0, 0);
            dtDateTime = dtDateTime.AddSeconds(unixTimeStamp).ToLocalTime();
            return dtDateTime;
        }

        public static double DateTimeToUnixTimestamp(DateTime dateTime)
        {
            return (dateTime - UnixEpoch.ToLocalTime()).TotalSeconds;
            //return (dateTime - UnixEpoch.ToLocalTime()).TotalMilliseconds; 

            //return (dateTime - new DateTime(1970, 1, 1).ToLocalTime()).TotalSeconds;
            //return (dateTime - new DateTime(1970, 1, 1)).TotalSeconds;
        }

        static readonly DateTime UnixEpoch = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
        static readonly double MaxUnixSeconds = (DateTime.MaxValue - UnixEpoch).TotalSeconds;

        public static DateTime UnixTimeStampToDateTime2(double unixTimeStamp)
        {
            return unixTimeStamp > MaxUnixSeconds
               ? UnixEpoch.AddMilliseconds(unixTimeStamp)
               : UnixEpoch.AddSeconds(unixTimeStamp);

            //return unixTimeStamp > MaxUnixSeconds
            //   ? UnixEpoch.AddMilliseconds(unixTimeStamp)
            //   : UnixEpoch.AddSeconds(unixTimeStamp);
        }

        #endregion

    }


}
