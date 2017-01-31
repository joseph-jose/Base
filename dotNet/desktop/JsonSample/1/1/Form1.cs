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
using System.Net.Http;


namespace _1
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }



        private void button1_Click(object sender, EventArgs e)
        {
            dataGridView1.Columns[0].HeaderText = "ObjectID";
            dataGridView1.Columns[1].HeaderText = "MethaneReading";
            dataGridView1.Columns[2].HeaderText = "UniqueID";
            dataGridView1.Columns[3].HeaderText = "Misc";
            dataGridView1.Columns[4].HeaderText = "EditDate";
            dataGridView1.Columns[5].HeaderText = "Editor";
            dataGridView1.Columns[6].HeaderText = "CreationDate";
            dataGridView1.Columns[7].HeaderText = "Description";
            dataGridView1.Columns[8].HeaderText = "Observation";
            dataGridView1.Columns[9].HeaderText = "Creator";
            dataGridView1.Columns[10].HeaderText = "GlobalId";
            dataGridView1.Columns[11].HeaderText = "X";
            dataGridView1.Columns[12].HeaderText = "Y";


            WebClient vWClnt = new WebClient();
            vWClnt.Proxy = WebRequest.DefaultWebProxy;
            vWClnt.Proxy.Credentials = CredentialCache.DefaultCredentials;
            //Get request
            string vRetStr = vWClnt.DownloadString(textBox1.Text);

            textBox2.Text = vRetStr;
            //Extract it to hash table
            Hashtable vHshtable = (Hashtable)Procurios.Public.JSON.JsonDecode(vRetStr);
            //Get the features node
            ArrayList vFeatItms = (ArrayList)vHshtable["features"];

            DateTime vUnxDtTime;
            double vUnxDbl;
            //for each feature
            for (int i = 0; i < vFeatItms.Count; i++)
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
                string vEditDate = "";
                if (!(vAttrItms["EditDate"] == null))
                {
                    double.TryParse(vAttrItms["EditDate"].ToString(), out vUnxDbl);
                    vUnxDtTime = Procurios.Public.JSON.UnixTimeStampToDateTime2(vUnxDbl);
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

        private void button2_Click(object sender, EventArgs e)
        {
            string vObjIds = "";
            for (int i = 0; i < dataGridView1.RowCount; i++)
            {
                if (!(vObjIds == ""))
                {
                    vObjIds = vObjIds + ",";
                }
                vObjIds = vObjIds + dataGridView1.Rows[i].Cells[0].Value.ToString();
            }

            textBox3.Text = string.Format("http://services5.arcgis.com/PnnKqtqi3qfxnaPc/arcgis/rest/services/LabOfflineGdbT3/FeatureServer/0/queryAttachments?objectIds={0}&f=pjson&token=", vObjIds);

        }

        private void button3_Click(object sender, EventArgs e)
        {
            Queue<object> vQAttchInfo = new Queue<object>();

            WebClient vWbClnt2 = new WebClient();
            vWbClnt2.Proxy = WebRequest.DefaultWebProxy;
            vWbClnt2.Proxy.Credentials = CredentialCache.DefaultCredentials;
            textBox4.Text = vWbClnt2.DownloadString(textBox3.Text);

            Hashtable vHshtable = (Hashtable)Procurios.Public.JSON.JsonDecode(textBox4.Text);
            //Get the features node
            ArrayList vFeatItms = (ArrayList)vHshtable["attachmentGroups"];

            //for each feature
            for (int i = 0; i < vFeatItms.Count; i++)
            {
                Hashtable vFeature = (Hashtable)vFeatItms[i];
                //get the attributes
                string vParObjId = (vFeature["parentObjectId"] == null) ? "" : vFeature["parentObjectId"].ToString();

                ArrayList vAttchArrInfo = (ArrayList)vFeature["attachmentInfos"];
                Hashtable vAttchInfo = (Hashtable)vAttchArrInfo[0];

                //extract each attribute
                string vId = (vAttchInfo["id"] == null) ? "" : vAttchInfo["id"].ToString();
                vQAttchInfo.Enqueue(new Tuple<string, string>(vParObjId, vId));
            }
            populategrid(vQAttchInfo);
            vQAttchInfo.Clear();
            vQAttchInfo = null;


        }

        private void populategrid(Queue<object> inQueue)
        {
            string vObjId = "";
            string vPhtStr = "";
            for (int i = 0; i < dataGridView1.Rows.Count; i++)
            {
                vObjId = dataGridView1.Rows[i].Cells[0].Value.ToString();
                foreach (object v in inQueue)
                {
                    string p1 = ((Tuple<string, string>)v).Item1.ToString();
                    string p2 = ((Tuple<string, string>)v).Item2.ToString();
                    if (p1 == vObjId)
                    {
                        dataGridView1.Rows[i].Cells[dataGridView1.Columns.Count - 3].Value = p1;
                        dataGridView1.Rows[i].Cells[dataGridView1.Columns.Count - 2].Value = p2;
                        vPhtStr = string.Format("http://services5.arcgis.com/PnnKqtqi3qfxnaPc/ArcGIS/rest/services/LabOfflineGdbT3/FeatureServer/0/{0}/attachments/{1}", p1, p2);
                        dataGridView1.Rows[i].Cells[dataGridView1.Columns.Count - 1].Value = vPhtStr;
                    }
                }
            }
        }

        static async Task<HttpResponseMessage> CreateProductAsync(HttpClient inClnt, string urlStr, HttpContent inUrlContd)
        {
            HttpResponseMessage response = null;
            try
            {

                response = await inClnt.PostAsync(urlStr, inUrlContd);
                response.EnsureSuccessStatusCode();

                // Return the URI of the created resource.
                //return response.Headers.Location;

            }
            catch (Exception e)
            {
                MessageBox.Show(e.Message.ToString());
            }
            return response;
        }

        private string delObj(int inVal)
        {
            ////Method1 Post-Not working
            //WebClient vWbClnt = new WebClient();
            //vWbClnt.Proxy = WebRequest.DefaultWebProxy;
            //vWbClnt.Proxy.Credentials = CredentialCache.DefaultCredentials;
            ////string vRetStr = vWbClnt.UploadString("http://services5.arcgis.com/PnnKqtqi3qfxnaPc/ArcGIS/rest/services/LabOfflineGdbT3/FeatureServer/0/deleteFeatures", "POST", "objectIds=9221");
            //string vRetStr = vWbClnt.UploadString("http://services5.arcgis.com/PnnKqtqi3qfxnaPc/ArcGIS/rest/services/WalkPathT3/FeatureServer/0/deleteFeatures?objectIds=9221&f=pjson", "POST");
            //textBox4.Text = vRetStr;

            string vUrlStr = string.Format( "http://services5.arcgis.com/PnnKqtqi3qfxnaPc/ArcGIS/rest/services/WalkPathT3/FeatureServer/0/deleteFeatures?objectIds={0}&f=pjson", inVal);
            using (HttpClientHandler vClntHndlr = new HttpClientHandler())
            {
                vClntHndlr.Proxy = WebRequest.DefaultWebProxy;
                vClntHndlr.Proxy.Credentials = CredentialCache.DefaultCredentials;
                using (var client = new HttpClient(vClntHndlr))
                {
                    var urlParams = new Dictionary<string, string>
                    {
                        { "objectIds" , inVal.ToString() },
                        { "f" , "pjson"}
                    };
                    var vUrlContd = new FormUrlEncodedContent(urlParams);

                    //var vResponse = client.PostAsync("http://services5.arcgis.com/PnnKqtqi3qfxnaPc/ArcGIS/rest/services/WalkPathT3/FeatureServer/0/deleteFeatures?objectIds=9221&f=pjson", vUrlContd);
                    //var vResponse = client.DeleteAsync("http://services5.arcgis.com/PnnKqtqi3qfxnaPc/ArcGIS/rest/services/WalkPathT3/FeatureServer/0/deleteFeatures?objectIds=9813&f=pjson");
                    //var vResponse = CreateProductAsync(client, "http://services5.arcgis.com/PnnKqtqi3qfxnaPc/ArcGIS/rest/services/WalkPathT3/FeatureServer/0/deleteFeatures?objectIds=9221&f=pjson", vUrlContd);
                    //System.Threading.Tasks.Task<HttpResponseMessage> vTskRespMsg = vResponse;
                    System.Threading.Tasks.Task<HttpResponseMessage> vTskRespMsg = client.DeleteAsync(vUrlStr);


                    HttpResponseMessage vHttpResp = vTskRespMsg.Result;

                    //var vRetStr = vHttpResp.ToString();
                    //textBox4.Text = vRetStr;
                    return vHttpResp.ToString();
                }
            }
        }

        private void  button4_Click(object sender, EventArgs e)
        {
            //Queue<object> vQAttchInfo = new Queue<object>();

            //vQAttchInfo.Enqueue(new Tuple<int, int>(2, 1));
            //vQAttchInfo.Enqueue(new Tuple<int, int>(3, 1));
            //vQAttchInfo.Enqueue(new Tuple<int, int>(4, 1));
            //vQAttchInfo.Enqueue(new Tuple<int, int>(5, 1));

            //foreach (object v in vQAttchInfo)
            //{
            //    string p1 = ((Tuple<int, int>)v).Item1.ToString();
            //    string p2 = ((Tuple<int, int>)v).Item2.ToString();
            //}

            textBox4.Text = textBox4.Text +   delObj(9800);
            textBox4.Text = textBox4.Text + delObj(9803);
        }
    }
    
}
