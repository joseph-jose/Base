using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class GISDmsSearch : System.Web.UI.Page
{
    int vGlobalRes = -1; //' Result of the Global function

    private void getDbVals(out string outSrvrName, out string outSrvrPwd)
    {
        string vWebSrvrName = "";
        vWebSrvrName = Request.ServerVariables["SERVER_NAME"];

        switch (vWebSrvrName)
        {
            case "localhost":
                outSrvrName = "WSLDCTGDW";
                outSrvrPwd = "G1s@webd01";
                break;
            case "wsldctgdw":
                outSrvrName = "WSLDCTGDW";
                outSrvrPwd = "G1s@webd01";
                break;
            case "wsldctvgtw":
                outSrvrName = "WSLDCTVGTD2";
                outSrvrPwd = "NetG15@wt01";
                break;
            case "gisweb":
                outSrvrName = "WSLDCTVGPD2";
                outSrvrPwd = "NetG15@wp01";
                break;
            case "wsldctvgpw":
                outSrvrName = "WSLDCTVGPD2";
                outSrvrPwd = "NetG15@wp01";
                break;
            default:
                outSrvrName = "WSLDCTVGPD2";
                outSrvrPwd = "NetG15@wp01";
                break;
        }
    }

    private bool getRecordsFId(string inSrchName, string inSrchKey, string inDbName)
    {
        bool bRetFn = false;

        string vSrvrName = "";
        string vPsswrd = "";
        getDbVals(out vSrvrName, out vPsswrd);

        try
        {
            DSSearch.ConnectionString = "Data Source={0};User ID=gisweb;Password={1};Initial Catalog={2}";
            DSSearch.ConnectionString = string.Format(DSSearch.ConnectionString, vSrvrName, vPsswrd, inDbName);
            DSSearch.SelectCommand = string.Format("SELECT TOP 1000 [FCLASS] ,[LAYER] ,[GIS_ID] ,[EQUIP_ID] ,[COMPKEY] ,[STATUS] , [DATASOURCE] FROM [GISWSL].[WA_Netview_View] where DATASOURCE like '%{0}%'", inSrchKey);
            grdVw.DataSource = DSSearch;
            grdVw.DataBind();
            bRetFn = true;
            //vAdoConn = new SqlConnection();
            //vAdoConn.ConnectionString = "Data Source={0};User ID=gisweb;Password={1};Initial Catalog={2}";
            //vAdoConn.ConnectionString = string.Format(vAdoConn.ConnectionString, vSrvrName, vPsswrd, inDbName);
            //vAdoConn.Open();


            //string vSqlText;
            //vSqlCmd = new SqlCommand();
            //vSqlCmd.Connection = vAdoConn;
            //vSqlText = string.Format("SELECT TOP 1000 [FCLASS] ,[LAYER] ,[GIS_ID] ,[EQUIP_ID] ,[COMPKEY] ,[STATUS] ,[DMS_LINK] ,[PHOTO_LINK] ,[DATASOURCE] FROM [GISNet2].[GISWSL].[WA_Admin_View] where DATASOURCE like '%{0}%'", inSrchKey);
            //vSqlCmd.CommandText = vSqlText;
            //vSqlRdr = vSqlCmd.ExecuteReader();

            //vDtTbl = new DataTable();
            //vDtTbl.Load(vSqlRdr);
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message.ToString());
        }
        finally
        {
            //if (!(vSqlCmd == null))
            //{
            //    vSqlCmd = null;
            //}
            //if (!(vAdoConn == null))
            //{
            //    vAdoConn.Close();
            //    vAdoConn = null;
            //}
        }
        return bRetFn;
    }

    private void getUrlNameKeyPair(out string outQryParamStr, out string outIDToSrchInt)
    {
        string vQryParamStr, vQryValStr;
        vQryParamStr = "";
        string ViDToSrchStr;
        ViDToSrchStr = "";
        for (int vI = 0; vI < Request.QueryString.Keys.Count; vI++)
        {
            vQryParamStr = Request.QueryString.Keys[vI].ToString();
            vQryValStr = Request.QueryString[Request.QueryString.Keys[vI].ToString()];

            switch (vQryParamStr.ToUpper())
            {
                case "DMSID":
                    ViDToSrchStr = vQryValStr;
                    break;
                case "COMPKEY":
                    //ViDToSrchStr = vQryValStr;
                    break;
            }
        }

        outIDToSrchInt = ViDToSrchStr;
        outQryParamStr = vQryParamStr.ToUpper();
    }

    private bool valParams(out string voutQryParamStr, out string VoutiDToSrchStr)
    {
        bool vRetFn = true;

        getUrlNameKeyPair(out voutQryParamStr, out VoutiDToSrchStr);

        if (VoutiDToSrchStr == "")
        {
            vGlobalRes = -1;
            vRetFn = false;
            return vRetFn;
        }

        return vRetFn;
    }


    private void loadPages()
    {
        string vQryParamStr = "";
        string ViDToSrchStr = "";
        if (Request.QueryString.Keys.Count == 0)
        {
            Label1.Text = "Valid parameters not found";
            Label1.Visible = true;
            return;
        }
        //getUrlNameKeyPair(out vQryParamStr, out ViDToSrchStr);

        //if (ViDToSrchStr == "")
        //{
        //    vGlobalRes = -1;
        //    return;
        //}

        if (valParams(out vQryParamStr, out ViDToSrchStr))
        {
            switch (vQryParamStr.ToUpper())
            {
                case "DMSID":
                    if (!getRecordsFId(vQryParamStr, ViDToSrchStr, "GISNet1"))
                    {
                        vGlobalRes = -1;
                    }
                    else
                        vGlobalRes = 11;
                    break;
                case "GISID":
                    //vGlobalRes = procGISID(vQryParamStr, ViDToSrchStr);
                    break;
            }
        }

        //logNtry(vQryParamStr, ViDToSrchStr, "GISAdmin");

        ////vGlobalArrRecs.Rows.Clear();
        ////vGlobalArrRecs = null;
        //if ((vGlobalRes == 1) || (vGlobalRes == 11) || (vGlobalRes == 21))
        //{
        //    //Response.Redirect(vGlobalUrlPth);
        //    //Response.Flush();
        //}

        //'   -2  Invalid value
        //'   -1  Function failure
        //'   0   Record not found
        //'   10  Record not found
        //    11    Success of records  

        if (vGlobalRes == -1)
        {
            Label1.Text = "<br/><br/><br/>GPF-><br /> Please contact <a href=mailto:GISServices@water.co.nz>GISServices</a> for more information <br/><br/><br/><br/><br/><br/>";
            Label1.Visible = true;
        }
        else if (vGlobalRes == 10)
            Label1.Text = "<br/><br/><br/>This asset does not exist in GIS - please try a different search.<br/><br/><br/><br/><br/><br/>";
        else if (vGlobalRes == 0)
            Label1.Text = "<br/><br/><br/>This asset does not exist in GIS - please try a different search.<br/><br/><br/><br/><br/><br/>";

    }

    protected void Page_Load(object sender, EventArgs e)
    {
        //http://localhost:6797/GISDmsSearch.aspx?DMSID=R0006515
        try
        {
            loadPages();
        }
        catch (Exception ex)
        {
            Response.Write("Error : " + ex.Message.ToString());
        }
    }


    protected void grdVw_PageIndexChanged(object sender, EventArgs e)
    {
                //try
        //{
        //    loadPages();
        //}
        //catch (Exception ex)
        //{
        //    Response.Write("Error : " + ex.Message.ToString());
        //}

    }

    protected void grdVw_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        e.Cancel = false;
    }
}