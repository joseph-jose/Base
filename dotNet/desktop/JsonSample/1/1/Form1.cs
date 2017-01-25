using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Net;
using System.Collections;


namespace _1
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        static readonly DateTime UnixEpoch = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
        static readonly double MaxUnixSeconds = (DateTime.MaxValue - UnixEpoch).TotalSeconds;

        public static DateTime UnixTimeStampToDateTime2(double unixTimeStamp)
        {
            return unixTimeStamp > MaxUnixSeconds
               ? UnixEpoch.AddMilliseconds(unixTimeStamp)
               : UnixEpoch.AddSeconds(unixTimeStamp);
        }

        public static DateTime UnixTimeStampToDateTime(double unixTimeStamp)
        {
            // Unix timestamp is seconds past epoch
            System.DateTime dtDateTime = new DateTime(1970, 1, 1, 0, 0, 0, 0);
            dtDateTime = dtDateTime.AddSeconds(unixTimeStamp).ToLocalTime();
            return dtDateTime;
        }

        public static double DateTimeToUnixTimestamp(DateTime dateTime)
        {
            return (dateTime - new DateTime(1970, 1, 1).ToLocalTime()).TotalSeconds;
        }


        //jjose
        public static double DateTimeToUnixTimestamp3(DateTime dateTime)
        {
            DateTime UnixEpoch = new DateTime(1970, 1, 1, 0, 0, 0);
            UnixEpoch = UnixEpoch.ToLocalTime();

            return (dateTime - UnixEpoch).TotalMilliseconds;
        }

        public static DateTime UnixTimeStampToDateTime3(double unixTimeStamp)
        {
            DateTime UnixEpoch = new DateTime(1970, 1, 1, 0, 0, 0);
            UnixEpoch = UnixEpoch.ToLocalTime();
            return UnixEpoch.AddMilliseconds(unixTimeStamp);
        }
        //jjose

        private void button1_Click(object sender, EventArgs e)
        {

            WebClient vWClnt = new WebClient();
            vWClnt.Proxy = WebRequest.DefaultWebProxy;
            vWClnt.Proxy.Credentials = CredentialCache.DefaultCredentials;
            //Get request
            string vRetStr = vWClnt.DownloadString(textBox1.Text);

            textBox2.Text = vRetStr;
            //Extract it to hash table
            Hashtable vHshtable = (Hashtable) Procurios.Public.JSON.JsonDecode(vRetStr);
            //Get the features node
            ArrayList vFeatItms = (ArrayList) vHshtable["features"];

            DateTime  vUnxDtTime;
            double vUnxDbl;
            //for each feature
            for (int i = 0; i < vFeatItms.Count ; i++)
            {
                Hashtable vFeature = (Hashtable)vFeatItms[i];
                //get the attributes
                Hashtable vAttrItms = (Hashtable)vFeature["attributes"];
                //extract each attribute
                string vObjId = (vAttrItms["OBJECTID"] == null) ? "" : vAttrItms["OBJECTID"].ToString();
                string vMethaneReading = (vAttrItms["MethaneReading"] == null) ? "" : vAttrItms["MethaneReading"].ToString();
                string vUniqueID = (vAttrItms["UniqueID"] == null) ? "" : vAttrItms["UniqueID"].ToString();
                string vMisc = (vAttrItms["Misc"] == null) ? "" : vAttrItms["Misc"].ToString();
                //string vEditDate = (vAttrItms["EditDate"] == null) ? "" : vAttrItms["EditDate"].ToString();
                string vEditDate="";
                if (!(vAttrItms["EditDate"] == null))
                {
                    double.TryParse(vAttrItms["EditDate"].ToString(), out vUnxDbl);
                    vUnxDtTime = UnixTimeStampToDateTime2(vUnxDbl);
                    vEditDate = vUnxDtTime.ToString("dd-mmm-yyyy"); 
                }
                string vEditor = (vAttrItms["Editor"] == null) ? "" : vAttrItms["Editor"].ToString();
                string vCreationDate = (vAttrItms["CreationDate"] == null) ? "" : vAttrItms["CreationDate"].ToString();
                string vDescription = (vAttrItms["Description"] == null) ? "" : vAttrItms["Description"].ToString();
                string vObservation = (vAttrItms["Observation"] == null) ? "" : vAttrItms["Observation"].ToString();
                string vCreator = (vAttrItms["Creator"] == null) ? "" : vAttrItms["Creator"].ToString();
                string vGlobalId = (vAttrItms["GlobalID"] == null) ? "" : vAttrItms["GlobalID"].ToString();
                //get the geometry
                vAttrItms = (Hashtable)vFeature["geometry"];
                //extract geometry
                string vx = (vAttrItms["x"] == null) ? "" : vAttrItms["x"].ToString();
                string vy = (vAttrItms["y"] == null) ? "" : vAttrItms["y"].ToString();

                dataGridView1.Rows.Add(vObjId, vMethaneReading, vUniqueID, vMisc, vEditDate, vEditor, vCreationDate, vDescription, vObservation, vCreator, vGlobalId, vx, vy);

                //double dtime = (double)LogRecord["time"];
                //string source = (string)LogRecord["source"];
                //string machine = (string)LogRecord["machine"];
                //string user = (string)LogRecord["user"];
                //double code = (double)LogRecord["code"];
                //string elapsed = (string)LogRecord["elapsed"];
                //string process = (string)LogRecord["process"];
                //string thread = (string)LogRecord["thread"];
                //string methodName = (string)LogRecord["methodName"];

                //string scale = "NULL";

                //string size_x = "NULL";
                //string size_y = "NULL";

                //string minx = "NULL";
                //string miny = "NULL";
                //string maxx = "NULL";
                //string maxy = "NULL";

                //string Shape = "NULL";

                //DateTime dttime = UnixTimeStampToDateTime2(dtime);

                //dttime = dttime.ToLocalTime();

                //long lcode = (long)code;

                //if (message.Length > 4000) message = message.Substring(0, 4000);
                //if (methodName.Length > 50) methodName = methodName.Substring(0, 50);

                //message = message.Replace("'", "''");

                //if (message.Contains("Extent:"))
                //{
                //    string[] vals = message.Split(';');

                //    string[] tmp_extent = vals[0].Split(':');
                //    string[] tmp_size = vals[1].Split(':');
                //    string[] tmp_scale = vals[2].Split(':');

                //    string[] tmp_sizes = tmp_size[1].Split(',');
                //    string[] tmp_extents = tmp_extent[1].Split(',');

                //    scale = tmp_scale[1];

                //    size_x = tmp_sizes[0];
                //    size_y = tmp_sizes[1];

                //    minx = tmp_extents[0];
                //    miny = tmp_extents[1];
                //    maxx = tmp_extents[2];
                //    maxy = tmp_extents[3];

                //    Shape = "'POLYGON((" + minx + " " + miny + "," + minx + " " + maxy + "," + maxx + " " + maxy + "," + maxx + " " + miny + "," + minx + " " + miny + "))'";

                //    Shape = "geometry::STPolyFromText(" + Shape + ", " + srid + ")";
                //}

            }


        }
    }
}
