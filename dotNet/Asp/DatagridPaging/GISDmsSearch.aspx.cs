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

        //SqlCommand vSqlCmd = null;
        //SqlConnection vAdoConn = null;
        //SqlDataReader vSqlRdr = null;

        try
        {
            DSSearch.ConnectionString = "Data Source={0};User ID=gisweb;Password={1};Initial Catalog={2}";
            DSSearch.ConnectionString = string.Format(DSSearch.ConnectionString, vSrvrName, vPsswrd, inDbName);
            DSSearch.SelectCommand = string.Format("SELECT TOP 1000 [FCLASS] ,[LAYER] ,[GIS_ID] ,[EQUIP_ID] ,[COMPKEY] ,[STATUS] ,[DMS_LINK] ,[PHOTO_LINK] ,[DATASOURCE] FROM [GISNet2].[GISWSL].[WA_Admin_View] where DATASOURCE like '%{0}%'", inSrchKey);
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
                    ViDToSrchStr = vQryValStr;
                    break;
                case "GISID":
                    ViDToSrchStr = vQryValStr;
                    break;
            }
        }

        outIDToSrchInt = ViDToSrchStr;
        outQryParamStr = vQryParamStr.ToUpper();
    }

    private void loadPages()
    {
        string vQryParamStr = "";
        string ViDToSrchStr = "";
        if (Request.QueryString.Keys.Count == 0)
        {
            Label1.Text = "Valid parameters not found";
            return;
        }
        getUrlNameKeyPair(out vQryParamStr, out ViDToSrchStr);

        if (ViDToSrchStr == "")
        {
            vGlobalRes = -1;
            return;
        }


        //logNtry(vQryParamStr, ViDToSrchStr, "GISAdmin");

        switch (vQryParamStr.ToUpper())
        {
            case "DMSID":
                if (!getRecordsFId(vQryParamStr, ViDToSrchStr, "GISNet1"))
                {
                    vGlobalRes = -2;
                }
                else
                    vGlobalRes = 11;
                //''if nothing is found- try hansen
                //if (vGlobalArrRecs.Rows.Count == 0)
                //    vGlobalRes = 20;
                //else
                //    vGlobalRes = procEquipmentArr();
                break;
            case "GISID":
                //vGlobalRes = procGISID(vQryParamStr, ViDToSrchStr);
                break;
        }
        //vGlobalArrRecs.Rows.Clear();
        //vGlobalArrRecs = null;
        if ((vGlobalRes == 1) || (vGlobalRes == 11) || (vGlobalRes == 21))
        {
            //Response.Redirect(vGlobalUrlPth);
            //Response.Flush();
        }

        //'   -2  Invalid value
        //'   -1  Function failure
        //'   0   Record not found
        //'   1   single Record found
        //'   2   Multiple record found

        if (vGlobalRes == -1)
            Label1.Text = "<br/><br/><br/>GPF-><br /> Please contact <a href=mailto:GISServices@water.co.nz>GISServices</a> for more information <br/><br/><br/><br/><br/><br/>";
        else if (vGlobalRes == 10)
            Label1.Text = "<br/><br/><br/>This asset does not exist in GIS - please try a different search.<br/><br/><br/><br/><br/><br/>";
        else if (vGlobalRes == 13)
            Label1.Text = "<br/><br/><br/>This asset does not exist in GIS - please try a different search.<br/><br/><br/><br/><br/><br/>";
        else if (vGlobalRes == 20)
            Label1.Text = "<br/><br/><br/>This asset does not exist in GIS - please try a different search.<br/><br/><br/><br/><br/><br/>";
        else if (vGlobalRes == 0)
            Label1.Text = "<br/><br/><br/>This asset does not exist in GIS - please try a different search.<br/><br/><br/><br/><br/><br/>";
        else if (vGlobalRes == -2)
            Label1.Text = "<br/><br/><br/>Invalid value entered - please enter valid numeric value.<br/><br/>Please contact <a href=mailto:GISServices@water.co.nz>GISServices</a> for support<br/><br/><br/><br/>";

    }

    protected void Page_Load(object sender, EventArgs e)
    {
        //http://localhost:6797/GISDmsSearch.aspx?DMSID=R0006515
        try
        {
            if (!IsPostBack)
            {
                loadPages();
            }
            //loadPages();
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
        //if (e.NewPageIndex >= 0)
        //{
        //    grdVw.PageIndex = e.NewPageIndex;
        //}
        ////e.Cancel = false;

        grdVw.PageIndex = e.NewPageIndex;
        loadPages();
    }
}