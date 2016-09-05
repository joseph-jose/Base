<%@ Page Language="C#" Explicit="True" AspCompat="true" Debug="true" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Runtime.InteropServices" %>
<%@ Import Namespace="System.Threading" %>

<%--'Sample URL
'http://localhost:3322/GISSearchId.aspx?CompKey=3154682--%>

<script language = "C#" runat = "server">
    //Array[][]  vGlobalArrRecs;
    DataTable vGlobalArrRecs;
    int vGlobalRes = -1;    //' Result of the Global function
    string vGlobalUrlPth = "";
    #region "commonFns"

    void errTxt(string inMsg)
    {
        //'Response.Write(inMsg)
        string vStr;
        vStr = "<tr><td colspan='5'><span class='errTxt'><br/><br/><br/> {0} <br/><br/><br/><br/><br/><br/></span></td></tr>";
        vStr = string.Format(vStr, inMsg);
        Response.Write(vStr);
    }

    void getUrlNameKeyPair(ref string outQryParamStr, ref string outIDToSrchInt)
    {
        int vI;
        string vQryParamStr = "", vQryValStr = "";
        string ViDToSrchStr;
        ViDToSrchStr = "";
        for (vI = 0; vI < Request.QueryString.Keys.Count; vI++)
        {
            vQryParamStr = Request.QueryString.Keys[vI].ToString();
            vQryValStr = Request.QueryString[Request.QueryString.Keys[vI].ToString()];

            switch (vQryParamStr.ToUpper())
            {
                case ("EQUIPMENTID"):
                    ViDToSrchStr = vQryValStr;
                    break;
                case ("COMPKEY"):
                    ViDToSrchStr = vQryValStr;
                    break;
                case ("GISID"):
                    ViDToSrchStr = vQryValStr;
                    break;
                case ("GLOBALID"):
                    ViDToSrchStr = vQryValStr;
                    break;
            }
        }

        outIDToSrchInt = ViDToSrchStr;
        outQryParamStr = vQryParamStr.ToUpper();
    }



    public string getSqlFKey(string inKey, string inValue)
    {
        string vSqlText = "";
        switch (inKey.ToUpper())
        {
            case ("EQUIPMENTID"):
                vSqlText = "SELECT DISTINCT [gis_id] , [equip_id] , [status] , [fclass] FROM [WA_SAP_View] WHERE [status] <> 'REMOVED' and ([EQUIP_ID] = '{0}') ORDER BY [fclass] DESC";
                vSqlText = String.Format(vSqlText, inValue);
                break;
            case ("COMPKEY"):
                vSqlText = "SELECT DISTINCT [gis_id] , [compkey], [status], [fclass] FROM [GISWSL].[WAL_Hansen_View] WHERE ([status] <> 'RM') and ([compkey] = '{0}') ORDER BY [fclass] DESC";
                vSqlText = String.Format(vSqlText, inValue);
                break;
            case ("GISID"):
                vSqlText = "SELECT DISTINCT [gis_id] , [equip_id] , [status] , [fclass], 'SAP' as Source FROM [GISNet1].[GISWSL].[WA_SAP_View] WHERE [status] <> 'REMOVED' and ([GIS_ID] = '{0}') ";
                vSqlText = vSqlText + "UNION ALL ";
                vSqlText = vSqlText + "SELECT DISTINCT [gis_id] , [compkey], [status], [fclass], 'HANSEN' as Source FROM [GISWSL].[WAL_Hansen_View] WHERE ([status] <> 'RM') and ([GIS_ID] = '{1}') ";
                vSqlText = vSqlText + "ORDER BY [fclass] DESC";
                vSqlText = string.Format(vSqlText, inValue, inValue);
                break;
            case ("GLOBALID"):
                vSqlText = "SELECT DISTINCT [gis_id] , [equip_id] , [status] , [fclass] FROM [WA_SAP_View] WHERE [status] <> 'REMOVED' and ([GIS_ID] = '{0}') ORDER BY [fclass] DESC";
                vSqlText = string.Format(vSqlText, inValue);
                break;
        }
        return vSqlText;
    }

    private void getDbVals(ref string outSrvrName, ref string outSrvrPwd)
    {
        string vWebSrvrName = "";
        vWebSrvrName = Request.ServerVariables["SERVER_NAME"];

        switch (vWebSrvrName)
        {
            case ("wsldctgdw"):
                outSrvrName = "WSLDCTVGPD2";
                outSrvrPwd = "NetG15@wp01";
                break;
            case ("wsldctvgtw"):
                outSrvrName = "WSLDCTVGTD2";
                outSrvrPwd = "NetG15@wt01";
                break;
            case ("gisweb"):
                outSrvrName = "WSLDCTVGPD2";
                outSrvrPwd = "NetG15@wp01";
                break;
            case ("wsldctvgpw"):
                outSrvrName = "WSLDCTVGPD2";
                outSrvrPwd = "NetG15@wp01";
                break;
            default:
                outSrvrName = "WSLDCTVGPD2";
                outSrvrPwd = "NetG15@wp01";
                break;
        }
    }


    private DataTable getRecordsFId(string inSrchName , string inSrchKey , string inDbName )
    {
        DataTable vDtTbl = null;

        string vSrvrName = "";
        string vPsswrd = "";
        getDbVals(ref vSrvrName, ref vPsswrd);

        SqlCommand vSqlCmd = null ;
        SqlConnection vAdoConn = null;
        SqlDataReader vSqlRdr = null;

        try
        {
            vAdoConn = new SqlConnection();
            vAdoConn.ConnectionString = "Data Source={0};User ID=gisweb;Password={1};Initial Catalog={2}";
            vAdoConn.ConnectionString = string.Format(vAdoConn.ConnectionString, vSrvrName, vPsswrd, inDbName);
            vAdoConn.Open();


            string vSqlText ;
            vSqlCmd = new SqlCommand();
            vSqlCmd.Connection = vAdoConn ;
            vSqlText = getSqlFKey(inSrchName, inSrchKey);
            vSqlCmd.CommandText = vSqlText ;
            vSqlRdr = vSqlCmd.ExecuteReader();

            vDtTbl = new DataTable();
            vDtTbl.Load(vSqlRdr);
            return vDtTbl ;
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message.ToString());
            return vDtTbl;
        }
        finally
        {
            if (! (vSqlCmd == null))
            {
                vSqlCmd = null ;
            }
            if (! (vAdoConn == null))
            {
                vAdoConn.Close();
                vAdoConn = null;
            }
        }
    }

    private string buildOutStr(string inStr)
    {
        return "<td> " + inStr + "</td>";
    }


    #endregion


    #region "Hansen"
    private bool buildCompKeyUrls(DataRow inArr, ref string outStr)
    {
        bool vbuildCompKeyUrls = true;
        string vCompKey, vStatus, vFClass;
        string vTmpStr, vstrScale;

        //vCompKey = inArr[1, 0];
        //vStatus = inArr(2, 0);
        //vFClass = inArr(3, 0);
        vCompKey = inArr[1].ToString();
        vStatus = inArr[2].ToString();
        vFClass = inArr[3].ToString();

        if (vStatus.Trim() == "AB")
        {
            vTmpStr = "WL_FITTING,WL_HYDRANT,WL_METER,WL_VALVE,WWL_FITTING";
            if (!(vTmpStr.ToString().IndexOf(vFClass) == -1))
            {
                vbuildCompKeyUrls = false;
            }
        }


        if (vbuildCompKeyUrls)
        {
            if ((vFClass == "WT_Pipe") || (vFClass == "WWT_Pipe") || (vFClass == "WWT_PumpStation") || (vFClass == "WT_PumpStation"))
                vstrScale = "500";
            else if ((vFClass == "WT_TPlant") || (vFClass == "WWT_TPlant") || (vFClass == "WT_Reservoir"))
                vstrScale = "1000";
            else
                vstrScale = "1000";

            outStr = "http://" + Request.ServerVariables["SERVER_NAME"].ToString() + "/netview/index.html?feature=" + vFClass + "," + vCompKey + "&scale=" + vstrScale;
            vbuildCompKeyUrls = true;
        }
        return vbuildCompKeyUrls;
    }

    private int procCompKeyArr()
    {
        //'   -1  Function failure
        //'   0   Record not found
        //'   1   single Record found
        //'   2   Multiple record found
        //'   3   Asset out of service
        int vprocCompKeyArr = -1;

        string vUrlStr = "";

        int vTotRecFnd = -1;
        string vDsplyStr = "";

        if (vGlobalArrRecs == null)
            //'No records found in SAP-View
            //'Response.Write("No records found in Hansen")
            vprocCompKeyArr = 0;
        else
        {
            //'one records found
            if (vGlobalArrRecs.Rows.Count == 1)
            {
                if (buildCompKeyUrls(vGlobalArrRecs.Rows[0], ref vUrlStr) == true)
                    vprocCompKeyArr = 1;
                else
                    vprocCompKeyArr = 3;
            }
            else
            {
                //''Multiple records
                //'vTotRecFnd = displayMutipleHanesnRecs(vGlobalArrRecs, inIDVal, vDsplyStr)
                //'If vTotRecFnd = 0 Then
                //'    'Abondoned asset
                //'    procCompKeys = 2
                //'Else
                //'    procCompKeys = 1
                //'    Response.Write(vDsplyStr)
                //'End If
                if (buildCompKeyUrls(vGlobalArrRecs.Rows[0], ref vUrlStr) == true)
                    vprocCompKeyArr = 1;
                else
                    vprocCompKeyArr = 3;
            }

            vGlobalArrRecs = null;
        }
        vGlobalUrlPth = vUrlStr;

        return vprocCompKeyArr;
    }
    #endregion



</script>
<%
    try
    {

        //'Dim vResFn As Integer = -1   ' Result of the Global function
        //'   -1  Function failure
        //'   0   Record not found
        //'   1   single Record found
        //'   2   Multiple record found
        //'   3   Asset out of service    

        string vQryParamStr = "";
        string ViDToSrchStr = "";
        if (Request.QueryString.Keys.Count == 0)
        {
            Response.Write("Valid parameters not found");
            Response.End();
        }
        getUrlNameKeyPair(ref vQryParamStr, ref ViDToSrchStr);

        int vIDToSrchInt = -1;
        if (ViDToSrchStr == "")
        {
            vGlobalRes = -1;
            return;
            //GoTo NoErrHndlr
        }
        if (!(int.TryParse(ViDToSrchStr, out vIDToSrchInt)))
        {
            vGlobalRes = -2;
            return;
            //GoTo NoErrHndlr
        }
        else
        {
            if (vIDToSrchInt < 0)
            {
                vGlobalRes = -2;
                return;
                //GoTo NoErrHndlr;
            }
        }



        switch (vQryParamStr.ToUpper())
        {
            case "COMPKEY":
                vGlobalArrRecs = null;
                vGlobalArrRecs = getRecordsFId(vQryParamStr, ViDToSrchStr, "GISNet2");
                vGlobalRes = procCompKeyArr();
                break;
        }

        if (vGlobalRes == 1)
        {
            Response.Redirect(vGlobalUrlPth);
            Response.Flush();
        }

    }
    catch (Exception err)
    {
        //if (err is ThreadAbortException)
        //{
        //    Response.SuppressContent = true;
        //    ApplicationInstance.CompleteRequest();
        //    Response.End();
        //    Thread.Sleep(1);
        //}
        //else
        Response.Write("Error : " + err.Message.ToString());
    }

    //'Response.End()

%>


<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head runat="server">
    <title></title>
    <style>
        .errTxt {
	                font-family: 'verdana', 'helvetica', sans-serif;
                    border : none ;
                    color : red ;
	                font-size: medium  ; 
                    font-weight : bold;
        }

        .style12
        {
            width: 170px;
            font-weight: 600;
            font-size: large;
            display:inline-block 
        }
        .style13
        {
            width: 170px;
            font-weight: 300;
            font-size: large;
            display:inline-block 
        }

        /* DEFAULTS
        ----------------------------------------------------------*/

        body   
        {
            background: #b6b7bc;
            font-size: .80em;
            font-family: "Helvetica Neue", "Lucida Grande", "Segoe UI", Arial, Helvetica, Verdana, sans-serif;
            margin: 0px;
            padding: 0px;
            color: #696969;
        }

        a:link, a:visited
        {
            color: #034af3;
        }

        a:hover
        {
            color: #1d60ff;
            text-decoration: none;
        }

        a:active
        {
            color: #034af3;
        }

        p
        {
            margin-bottom: 10px;
            line-height: 1.6em;
            height: 121px;
            width: 924px;
            margin-left: 2px;
        }


        /* HEADINGS   
        ----------------------------------------------------------*/

        h1, h2, h3, h4, h5, h6
        {
            font-size: 1.5em;
            color: #666666;
            font-variant: small-caps;
            text-transform: none;
            font-weight: 200;
            margin-bottom: 0px;
        }

        h1
        {
            font-size: 1.6em;
            padding-bottom: 0px;
            margin-bottom: 0px;
        }

        /* PRIMARY LAYOUT ELEMENTS   
        ----------------------------------------------------------*/

        .page
        {
            width: 960px;
            background-color: #fff;
            margin: 20px auto 0px auto;
            border: 1px solid #496077;
        }

        .header
        {
            position: relative;
            margin: 0px;
            padding: 0px;
            background: #4b6c9e;
            width: 100%;
            top: 0px;
            left: 0px;
        }

        .header h1
        {
            font-weight: 700;
            margin: 0px;
            padding: 0px 0px 0px 20px;
            color: #f9f9f9;
            border: none;
            line-height: 2em;
            font-size: 2em;
        }

        .main
        {
            padding: 0px 12px;
            margin: 12px 8px 8px 8px;
            min-height: 420px;
        }


        .footer
        {
            color: #4e5766;
            padding: 8px 0px 0px 0px;
            margin: 0px auto;
            text-align: center;
            line-height: normal;
        }


        /* TAB MENU   
        ----------------------------------------------------------*/

        div.hideSkiplink
        {
            background-color:#3a4f63;
            width:100%;
            height: 15px;
        }


        .clear
        {
            clear: both;
        }

        .title
        {
            display: block;
            float: left;
            text-align: left;
            width: auto;
        }

    </style>
    <div ID="HeadContent" runat="server">
    </div>

</head>
<body>
    <form runat="server">
    <div class="page">
        <div class="header">
            <div class="title">
                 <h1 style="font-variant: normal" class="header">
                    Find an asset
                </h1>
            </div>
            <div class="clear hideSkiplink" style="display: block">
            </div>
        </div>
        <div class="main">
            <div ID="ContentPlaceHolder1" runat="server">
                <table class="style1">

            <%
    if (vGlobalRes == -1)
        errTxt("<span class='errTxt'><br/><br/><br/>GPF-><br /> Please contact <a href=mailto:GISServices@water.co.nz>GISServices</a> for more information <br/><br/><br/><br/><br/><br/></span>");
    else if (vGlobalRes == 0)
        errTxt("<span class='errTxt'><br/><br/><br/>This asset does not exist in GIS - please try a different search.<br/><br/><br/><br/><br/><br/></span>");
    else if (vGlobalRes == -2)
        errTxt("<span class='errTxt'><br/><br/><br/>Invalid value entered - please enter valid numeric value.<br/><br/>Please contact <a href=mailto:GISServices@water.co.nz>GISServices</a> for support<br/><br/><br/><br/></span>");
    else if (vGlobalRes == 2)
    {
                %>
                    <tr>
                        <td class="style12">Maximum Daily
                            &nbsp;</td>
                        <td class="style12">Maximum Flow
                            &nbsp;</td>
                        <td class="style12">Maximum Flow
                            &nbsp;</td>

                        <td class="style12">Fourth Column
                            &nbsp;</td>
                        <td class="style12">Fourth Column
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="style13">Maximum Daily
                            &nbsp;</td>
                        <td class="style13">Maximum Flow
                            &nbsp;</td>
                        <td class="style13">Maximum Flow
                            &nbsp;</td>

                        <td class="style13">Fourth Column
                            &nbsp;</td>
                        <td class="style13">Fourth Column
                            &nbsp;</td>
                    </tr>
            <%
                }
                %>
                </table>
            </div>
        </div>
        <div class="clear">
        </div>
    </div>
    <div class="footer">
        
    </div>
    </form>
</body>
</html>
