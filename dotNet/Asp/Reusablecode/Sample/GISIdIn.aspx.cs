using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Threading;
//TODO- Replace all opening URLs with one URL
public partial class GISIdIn : System.Web.UI.Page
{
    DataTable vGlobalArrRecs ;
    int vGlobalRes = -1  ; //' Result of the Global function
    string vGlobalUrlPth = "";
    string cUrlPath = "http://watercare.maps.arcgis.com/apps/webappviewer/index.html?id=d354aed8761043e3b5e34d841f04731f";
    
    #region "CommonFns"
    private void errTxt(string inMsg )
    {
        Response.Write(inMsg);
    }

    private void getUrlNameKeyPair(out string outQryParamStr , out string  outIDToSrchInt )
    {
        string vQryParamStr, vQryValStr ;
        vQryParamStr = "";
        string ViDToSrchStr ;
        ViDToSrchStr = "";
        for (int vI=0; vI < Request.QueryString.Keys.Count ; vI++)
        {
            vQryParamStr = Request.QueryString.Keys[vI].ToString();
            vQryValStr = Request.QueryString[Request.QueryString.Keys[vI].ToString()];
        
            switch (vQryParamStr.ToUpper())
            {
                case "EQUIPMENTID":
                    ViDToSrchStr = vQryValStr;
                    break;
                case "COMPKEY":
                    ViDToSrchStr = vQryValStr;
                    break;
                case "GISID":
                    ViDToSrchStr = vQryValStr;
                    break;
                case "UNITID":
                    ViDToSrchStr = vQryValStr;
                    break;
            }
        }
    
        outIDToSrchInt = ViDToSrchStr;
        outQryParamStr = vQryParamStr.ToUpper();
    }

    private string getSqlFKey(string inKey , string inValue )
    {
        string vSqlText = "";
            switch (inKey.ToUpper())
            {
                case "EQUIPMENTID":
                    //vSqlText = "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey]  ,[status]  ,[fclass]  ,[NetViewLayer] FROM [GISNet2].[GISWSL].[WA_Asset_View] WHERE [status] <> 'REMOVED' and ([EQUIP_ID] = '{0}') ORDER BY [fclass] DESC";
                    vSqlText = "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey]  ,[status]  ,[fclass]  ,Layer as [NetViewLayer] FROM [GISWSL].[WA_Netview_View] WHERE [status] <> 'REMOVED' and ([EQUIP_ID] = '{0}') ORDER BY [fclass] DESC";
                    vSqlText = String.Format(vSqlText, inValue);
                    break;
                case "COMPKEY":
                    //vSqlText = "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey] ,[status]  ,[fclass]  ,[NetViewLayer] FROM [GISNet2].[GISWSL].[WA_Asset_View] WHERE ([status] <> 'RM') and ([compkey] = '{0}') ORDER BY [fclass] DESC";
                    vSqlText = "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey] ,[status]  ,[fclass]  ,Layer as [NetViewLayer] FROM [GISWSL].[WA_Netview_View] WHERE ([status] <> 'RM') and ([compkey] = '{0}') ORDER BY [fclass] DESC";
                    vSqlText = String.Format(vSqlText, inValue);
                    break;
                case "GISIDNET1":
                    //vSqlText = "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey] ,[status]  ,[fclass]  ,[NetViewLayer], 'SAP' as Source FROM [GISNet2].[GISWSL].[WA_Asset_View] WHERE [status] <> 'REMOVED' and ([GIS_ID] = '{0}') ";
                    vSqlText = "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey] ,[status]  ,[fclass]  ,Layer as [NetViewLayer], 'SAP' as Source FROM [GISWSL].[WA_Netview_View] WHERE [status] <> 'REMOVED' and ([GIS_ID] = '{0}') ";
                    vSqlText = vSqlText + "ORDER BY [fclass] DESC";
                    vSqlText = String.Format(vSqlText, inValue, inValue);
                    break;
                case "GISIDNET2":
                    //vSqlText = "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey] ,[status]  ,[fclass]  ,[NetViewLayer], 'HANSEN' as Source FROM [GISNet2].[GISWSL].[WA_Asset_View] WHERE ([status] <> 'RM') and ([GIS_ID] = '{0}') ";
                    vSqlText = "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey] ,[status]  ,[fclass]  ,Layer as [NetViewLayer], 'HANSEN' as Source FROM [GISWSL].[WA_Netview_View] WHERE ([status] <> 'RM') and ([GIS_ID] = '{0}') ";
                    vSqlText = vSqlText + "ORDER BY [fclass] DESC";
                    vSqlText = String.Format(vSqlText, inValue, inValue);
                    break;
                case "UNITID":
                    vSqlText = "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey] , [UnitId], [UnitId2] ,[status]  ,[fclass]  ,Layer as [NetViewLayer], 'HANSEN' as Source FROM [GISWSL].[WA_Netview_View] WHERE ([status] <> 'RM') and (([UNITID] = '{0}') or ([UNITID2] = '{1}')) ";
                    vSqlText = vSqlText + "ORDER BY [fclass] DESC";
                    vSqlText = String.Format(vSqlText, inValue, inValue);
                    break;
        }
        return vSqlText ;
    }

    private void getDbVals(out string  outSrvrName , out string outSrvrPwd )
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
                break ;
            case "wsldctvgtw":
                outSrvrName = "WSLDCTVGTD2";
                outSrvrPwd = "NetG15@wt01";
                break ;
            case "giswebtest":
                outSrvrName = "WSLDCTVGTD2";
                outSrvrPwd = "NetG15@wt01";
                break;
            case "gisweb":
                outSrvrName = "WSLDCTVGPD2";
                outSrvrPwd = "NetG15@wp01";
                break ;
            case "wsldctvgpw":
                outSrvrName = "WSLDCTVGPD2";
                outSrvrPwd = "NetG15@wp01";
                break ;
            default :
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
        getDbVals(out vSrvrName, out vPsswrd);
    
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

    private bool logNtry(string inSrchName , string inSrchKey , string inDbName ) 
    {
        bool vLogNtry = false ;
        
        string vSrvrName = "";
        string vPsswrd = "";

        getDbVals(out vSrvrName, out vPsswrd);
    
        //'*****************Open database*****************************************************************
        //' connect to database
        
        //Object vObjConn ;
        SqlCommand vSqlCmd = null ;
        System.Data.SqlClient.SqlConnection vAdoConn = null;

        //vObjConn = null ;
        try
        {
            //vObjConn = Server.CreateObject("ADODB.Connection");
            vAdoConn = new SqlConnection();
                    
            //vAdoConn.ConnectionString = "Provider=SQLOLEDB;Data Source={0};User ID=gisweb;Password={1};Initial Catalog={2}";
            vAdoConn.ConnectionString = "Data Source={0};User ID=gisweb;Password={1};Initial Catalog={2}";
            vAdoConn.ConnectionString = string.Format(vAdoConn.ConnectionString, vSrvrName, vPsswrd, inDbName);
            vAdoConn.Open();
    
            string vSqlText ;
            vSqlCmd = new SqlCommand();
            vSqlCmd.Connection = vAdoConn ;
            vSqlText = "Insert into GISADMin.giswsl.WA_AppLogs (CurrUsr, CmdType, LogType, Msg, Fld1, Fld10) values ('{0}','{1}','{2}','{3}','{4}','{5}')";
            vSqlText = String.Format(vSqlText, "Internet", "WCAspApps", "ToGISIDSrch", inSrchName, inSrchKey, "");
            vSqlCmd.CommandText = vSqlText ;
            vSqlCmd.ExecuteNonQuery(); 
            
            vLogNtry = true;
            return vLogNtry;
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message.ToString());
            return false;
        }
        finally 
        {
            if (!(vSqlCmd == null))
            {
                vSqlCmd = null;
            }

            if (! (vAdoConn == null )) 
            {
                vAdoConn.Close();
                vAdoConn = null;
            }
        }
    }

    
    private string buildOutStr(string inStr )
    {
        return "<td> " + inStr + "</td>";
    }
    #endregion

    #region "SAP"
    private bool buildSAPMultiKeyUrls(DataRow inArr, out string outStr)
    {
        bool vbuildSAPKeyUrls = false;
        string vGISId, vEquipId, vStatus, vFClass, vNvLayer;
        string vTmpStr ;

        vGISId = inArr[0].ToString();
        vEquipId = inArr[1].ToString();
        vStatus = inArr[3].ToString();
        vFClass = inArr[4].ToString();
        vNvLayer = inArr[5].ToString();

        //outStr = "http://watercare.maps.arcgis.com/apps/webappviewer/index.html?id=d354aed8761043e3b5e34d841f04731f&query={0},GIS_ID={1}";
        outStr = "cURLPATH&query={0},GIS_ID={1}";
        outStr = outStr.Replace("cURLPATH", cUrlPath);

        outStr = String.Format(outStr, vNvLayer, vGISId);

        vTmpStr = "<tr><td><a href='{0}'>{1}</a></td><td>{2}</td></tr>";
        vTmpStr = string.Format(vTmpStr, outStr , vEquipId, vNvLayer );
        outStr = vTmpStr;

        vbuildSAPKeyUrls = true;
        return vbuildSAPKeyUrls;
    }

    private bool buildSAPKeyUrls(DataRow inArr , out string outStr) 
    {
        bool vbuildSAPKeyUrls = false;
        string vGISId, vEquipId, vStatus, vFClass, vNvLayer;
        //string vTmpStr, vstrScale ;

        vGISId = inArr[0].ToString();
        vEquipId = inArr[1].ToString();
        vStatus = inArr[3].ToString();
        vFClass = inArr[4].ToString();
        vNvLayer = inArr[5].ToString();

        //if ((vFClass=="WT_Pipe") || (vFClass=="WWT_Pipe") || (vFClass=="WWT_PumpStation") || (vFClass=="WT_PumpStation")) 
        //    vstrScale = "500";
        //else if ((vFClass=="WT_TPlant") || (vFClass=="WWT_TPlant") || (vFClass=="WT_Reservoir")) 
        //    vstrScale = "1000";
        //else
        //    vstrScale = "1000";

        //outStr = "http://watercare.maps.arcgis.com/apps/webappviewer/index.html?id=d354aed8761043e3b5e34d841f04731f&query={0},GIS_ID={1}";
        outStr = "cURLPATH&query={0},GIS_ID={1}";
        outStr = outStr.Replace("cURLPATH", cUrlPath);
        outStr = String.Format(outStr, vNvLayer, vGISId);

        vbuildSAPKeyUrls = true ;
        return vbuildSAPKeyUrls;
    }

    private bool displayMutipleSAPRecs(out string outStr)
    {
        bool vdisplayMutipleSAPRecs = false;
        string vUrlMultiStr = "", vTmpUrlStr = "";
        for (int i = 0; i < vGlobalArrRecs.Rows.Count; i++)
        {
            buildSAPMultiKeyUrls(vGlobalArrRecs.Rows[i], out vTmpUrlStr);
            //if (!(vUrlMultiStr == ""))
            //{
            //    vUrlMultiStr = vUrlMultiStr + "<br/>";
            //}
            vUrlMultiStr = vUrlMultiStr + vTmpUrlStr;
        }

        outStr = vUrlMultiStr;
        outStr = "<br/><br/><br/><table border=1 width='900px'><tr><th>EquipmentId</th><th>Layer</th></tr>" + outStr + "</table>";

        vdisplayMutipleSAPRecs = true;
        return vdisplayMutipleSAPRecs;
    }
    private int procEquipmentArr()
    {
        //'   -1  Function failure
        //'   20   Record not found
        //'   21   single Record found
        //'   23   multiple Record found
        //'   2   Multiple record found
        //'   3   Asset out of service        
        string vUrlStr = "";
        //int vTotRecFnd = -1;
        //string vDsplyStr = "";
        
        int vprocEquipmentArr = -1;
    
        if (vGlobalArrRecs.Rows.Count == 0)
        {
            //'No records found in SAP-View
            vprocEquipmentArr = 20;
            //'Response.Write("No records found in SAPView")
        }
        else
        {
            //'one records found
            if (vGlobalArrRecs.Rows.Count == 1)
            {                
                if (buildSAPKeyUrls(vGlobalArrRecs.Rows[0] , out vUrlStr) == true) 
                {
                    vprocEquipmentArr = 21;
                }
            }
            else
            {
                //'--To be enabled later
                //''Multiple records
                //'vTotRecFnd = displayMutipleSAPRecs(vGlobalArrRecs, inIDVal, vDsplyStr)
                //'If vTotRecFnd = 0 Then
                //'    'Abondoned asset
                //'    procEquipmentIDs = 2
                //'Else
                //'    procEquipmentIDs = 1
                //'    Response.Write(vDsplyStr)
                //'End If

                //if (buildSAPKeyUrls(vGlobalArrRecs.Rows[0], out vUrlStr) == true)
                //{
                //    vprocEquipmentArr = 21;
                //}

                if (displayMutipleSAPRecs(out vUrlStr))
                {
                    vprocEquipmentArr = 23;
                }
            }        
        }
        vGlobalUrlPth = vUrlStr;
        return vprocEquipmentArr;
    }
    #endregion

    #region "UnitId"

    private bool buildUnitIdUrls(DataRow inArr, out string outStr)
    {
        bool vbuildSAPKeyUrls = false;
        string vGISId, vEquipId, vStatus, vFClass, vNvLayer;
        //string vTmpStr, vstrScale ;

        vGISId = inArr[0].ToString();
        vEquipId = inArr[2].ToString();
        vStatus = inArr[5].ToString();
        vFClass = inArr[6].ToString();
        vNvLayer = inArr[7].ToString();

        //outStr = "http://watercare.maps.arcgis.com/apps/webappviewer/index.html?id=d354aed8761043e3b5e34d841f04731f&query={0},GIS_ID={1}";
        outStr = "cURLPATH&query={0},GIS_ID={1}";
        outStr = outStr.Replace("cURLPATH", cUrlPath);
    
        outStr = String.Format(outStr, vNvLayer, vGISId);

        vbuildSAPKeyUrls = true;
        return vbuildSAPKeyUrls;
    }

    private bool buildUnitIdMultiKeyUrls(DataRow inArr, out string outStr)
    {
        bool vbuildSAPKeyUrls = false;
        string vGISId, vCompKey, vEquipId, vUnitId, vUnitId2, vStatus, vFClass, vNvLayer;
        string vTmpStr;

        vGISId = inArr[0].ToString();
        vEquipId = inArr[1].ToString();
        vCompKey = inArr[2].ToString();
        vUnitId = inArr[3].ToString();
        vUnitId2 = inArr[4].ToString();
        vStatus = inArr[5].ToString();
        vFClass = inArr[6].ToString();
        vNvLayer = inArr[7].ToString();

        //outStr = "http://watercare.maps.arcgis.com/apps/webappviewer/index.html?id=d354aed8761043e3b5e34d841f04731f&query={0},GIS_ID={1}";
        outStr = "cURLPATH&query={0},GIS_ID={1}";
        outStr = outStr.Replace("cURLPATH", cUrlPath);

        outStr = String.Format(outStr, vNvLayer, vGISId);

        if ((vCompKey.Length > 1) && (vEquipId.Length < 2))
            vGISId = "CompKey:"+ vCompKey;
        if ((vCompKey.Length < 2) && (vEquipId.Length > 1))
            vGISId = "EquipmentId:"+ vEquipId;
        if ((vCompKey.Length < 2) && (vEquipId.Length < 2))
            vGISId = "Asset";

        vTmpStr = "<tr><td><a href='{0}'>{1}</a></td><td>{2}</td><td>{3}</td><td>{4}</td></tr>";
        vTmpStr = string.Format(vTmpStr, outStr, vGISId, vUnitId, vUnitId2, vNvLayer);
        outStr = vTmpStr;

        vbuildSAPKeyUrls = true;
        return vbuildSAPKeyUrls;
    }

    private bool displayMutipleUnitIdRecs(out string outStr)
    {
        bool vdisplayMutipleSAPRecs = false;
        string vUrlMultiStr = "", vTmpUrlStr = "";
        for (int i = 0; i < vGlobalArrRecs.Rows.Count; i++)
        {
            buildUnitIdMultiKeyUrls(vGlobalArrRecs.Rows[i], out vTmpUrlStr);
            vUrlMultiStr = vUrlMultiStr + vTmpUrlStr;
        }

        outStr = vUrlMultiStr;
        outStr = "<br/><br/><br/><table border=1 width='900px'><tr><th>&nbsp;</th><th>UnitId</th><th>UnitId2</th><th>Layer</th></tr>" + outStr + "</table>";

        vdisplayMutipleSAPRecs = true;
        return vdisplayMutipleSAPRecs;
    }
    private int procUnitIdArr()
    {
        //'   -1  Function failure
        //'   30   Record not found
        //'   31   single Record found
        //'   33   multiple Record found
        string vUrlStr = "";
        //int vTotRecFnd = -1;
        //string vDsplyStr = "";

        int vprocEquipmentArr = -1;

        if (vGlobalArrRecs.Rows.Count == 0)
        {
            //'No records found 
            vprocEquipmentArr = 30;
            //'Response.Write("No records found in SAPView")
        }
        else
        {
            //'one records found
            if (vGlobalArrRecs.Rows.Count == 1)
            {
                if (buildUnitIdUrls(vGlobalArrRecs.Rows[0], out vUrlStr) == true)
                {
                    vprocEquipmentArr = 31;
                }
            }
            else
            {

                if (displayMutipleUnitIdRecs(out vUrlStr))
                {
                    vprocEquipmentArr = 33;
                }
            }
        }
        vGlobalUrlPth = vUrlStr;
        return vprocEquipmentArr;
    }
    #endregion

    #region "Hansen"    
    private bool buildCompKeyUrls(DataRow inArr , out string outStr ) 
    {
        bool vbuildCompKeyUrls = true;
        string vGISId, vCompKey, vStatus, vFClass, vNvLayer;
        string vTmpStr, vstrScale;

        vGISId = inArr[0].ToString();
        vCompKey = inArr[2].ToString();
        vStatus = inArr[3].ToString();
        vFClass = inArr[4].ToString();
        vNvLayer = inArr[5].ToString();

        outStr = "";

        if ((vFClass == "AB"))
        {
        }

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
            {
                vstrScale = "500";
            }
            else if ((vFClass == "WT_TPlant") || (vFClass == "WWT_TPlant") || (vFClass=="WT_Reservoir")) 
            {
                vstrScale = "1000";
            }
            else
                vstrScale = "1000";

            //outStr = "http://watercare.maps.arcgis.com/apps/webappviewer/index.html?id=d354aed8761043e3b5e34d841f04731f&query={0},GIS_ID={1}";
            outStr = "cURLPATH&query={0},GIS_ID={1}";
            outStr = outStr.Replace("cURLPATH", cUrlPath);

            outStr = String.Format(outStr, vNvLayer, vGISId);

            vbuildCompKeyUrls = true;
        }
        return vbuildCompKeyUrls ;
    }
    
    private int procCompKeyArr() 
    {
        //'   -1  Function failure
        //'   10   Record not found
        //'   11   single Record found
        //'   13  Assets present but not valid to view
        //'   2   Multiple record found
        //'   3   Asset out of service
        int vProcCompKeyArr = -1;

        string vUrlStr = "";

        int vTotRecFnd = -1;
        string vDsplyStr = "";

        if (vGlobalArrRecs.Rows.Count == 0)
        {
            //'No records found in SAP-View
            //'Response.Write("No records found in Hansen")
            vProcCompKeyArr = 10;
        }
        else
        {
            //'one records found
            if (vGlobalArrRecs.Rows.Count == 1)
            {
                if (buildCompKeyUrls(vGlobalArrRecs.Rows[0], out vUrlStr) == true)
                    vProcCompKeyArr = 11;
                else
                    vProcCompKeyArr = 13;
            }
            else
            {
                //''Multiple records
                //Tobe handled later

                if (buildCompKeyUrls(vGlobalArrRecs.Rows[0], out vUrlStr) == true)
                    vProcCompKeyArr = 11;
                else
                    vProcCompKeyArr = 13;
            }
        }
        //vGlobalArrRecs.Rows.Clear();
        //vGlobalArrRecs = null;
        vGlobalUrlPth = vUrlStr;
        return vProcCompKeyArr;
    }
    #endregion

#region "GISID"
    
    private int procGISID(string inQryParam , string inIDVal )
    {
        //'   -1  Function failure
        //'   0   Record not found
        //'   1   single Record found
        //'   2   Multiple record found
        //'   3   Asset out of service
        int vprocGISID = -1;
        
        string vEquipId = "", vCompKey="";
        
        vGlobalArrRecs = null ;

        vGlobalArrRecs = getRecordsFId("GISIDNET1", inIDVal.ToString(), "GISNet1");
        
        if (vGlobalArrRecs.Rows.Count == 0) 
        {
            Response.Write("No records found in Hansen");
            vprocGISID = 0;
            ////'No records found in SAP-View
            //vGlobalArrRecs = getRecordsFId("GISIDNET1", inIDVal.ToString(), "GISNet1");
            //if (vGlobalArrRecs.Rows.Count == 0) 
            //{
            //    //'No records found in SAP-View
            //    Response.Write("No records found in Hansen");
            //    vprocGISID = 0;
            //}
            //else
            //{
            //    vTmpStr = vGlobalArrRecs.Rows[0][5].ToString();
            //    vprocGISID = procCompKeyArr();
            //}
        }
        else
        {

            vEquipId = vGlobalArrRecs.Rows[0][1].ToString();
            vCompKey = vGlobalArrRecs.Rows[0][2].ToString();
            if (vEquipId == "0")
                vprocGISID = procCompKeyArr();
            else
                vprocGISID = procEquipmentArr();
        }
            return vprocGISID;
     }


    #endregion

    private bool valParams(out string voutQryParamStr , out string VoutiDToSrchStr)
    {
        bool vRetFn = true;

        //string vQryParamStr = "";
        //string ViDToSrchStr = "";

        getUrlNameKeyPair(out voutQryParamStr, out VoutiDToSrchStr);

        int vIDToSrchInt = -1;
        if (VoutiDToSrchStr == "")
        {
            vGlobalRes = -1;
            vRetFn = false;
            return vRetFn;
        }

        if (voutQryParamStr == "UNITID")
        {
            if (VoutiDToSrchStr.ToUpper() == "NA")
            {
                vGlobalRes = -2;
                vRetFn = false;
                return vRetFn;
            }
        }
        else
        { 
            if (!(int.TryParse(VoutiDToSrchStr, out vIDToSrchInt)))
            {
                vGlobalRes = -2;
                vRetFn = false;
                return vRetFn;
            }
            else
            {
                if (vIDToSrchInt < 0)
                {
                    vGlobalRes = -3;
                    vRetFn = false;
                    return vRetFn;
                }
                if (!(voutQryParamStr == "GISID") && (vIDToSrchInt < 10))
                {
                    vGlobalRes = -3;
                    vRetFn = false;
                    return vRetFn;
                }
            }
        }
        return vRetFn;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            string vQryParamStr = "";
            string ViDToSrchStr = "";
            if (Request.QueryString.Keys.Count == 0)
            {
                Label1.Text = "Valid parameters not found";
                return;
            }
            //getUrlNameKeyPair(out vQryParamStr, out ViDToSrchStr);

            //int vIDToSrchInt = -1;
            //if (ViDToSrchStr == "") 
            //{
            //    vGlobalRes = -1;
            //    Label1.Text = "GPF-><br /> Please contact <a href=mailto:GISServices@water.co.nz>GISServices</a> for more information";
            //    return;
            //}

            //if (!(int.TryParse (ViDToSrchStr, out vIDToSrchInt))) 
            //{
            //    vGlobalRes = -2;
            //    Label1.Text = "Invalid value entered - please enter valid numeric value.<br/><br/>Please contact <a href=mailto:GISServices@water.co.nz>GISServices</a> for support";
            //    return;
            //}
            //else
            //{
            //    if (vIDToSrchInt < 10) 
            //    {
            //        vGlobalRes = -2;
            //        Label1.Text = "Invalid value entered - please enter valid numeric value.<br/><br/>Please contact <a href=mailto:GISServices@water.co.nz>GISServices</a> for support";
            //        return;
            //    }
            //}
            //logNtry(vQryParamStr, ViDToSrchStr, "GISAdmin");

            //todo - All should change to Net1
            if (valParams(out vQryParamStr, out ViDToSrchStr))
            {
                switch (vQryParamStr.ToUpper())
                {
                    case "EQUIPMENTID":
                        vGlobalArrRecs = null;
                        vGlobalArrRecs = getRecordsFId(vQryParamStr, ViDToSrchStr, "GISNet1");
                        //''if nothing is found- try hansen
                        if (vGlobalArrRecs.Rows.Count == 0)
                            vGlobalRes = 20;
                        else
                            vGlobalRes = procEquipmentArr();
                        break;

                    case "COMPKEY":
                        vGlobalArrRecs = null;
                        vGlobalArrRecs = getRecordsFId(vQryParamStr, ViDToSrchStr, "GISNet1");
                        vGlobalRes = procCompKeyArr();
                        break;
                    case "GISID":
                        vGlobalRes = procGISID(vQryParamStr, ViDToSrchStr);
                        break;
                    case "UNITID":
                        vGlobalArrRecs = null;
                        vGlobalArrRecs = getRecordsFId(vQryParamStr, ViDToSrchStr, "GISNet1");
                        vGlobalRes = procUnitIdArr();
                        break;
                }
                vGlobalArrRecs.Rows.Clear();
                vGlobalArrRecs = null;
            }


            if ((vGlobalRes == 1) || (vGlobalRes == 11) || (vGlobalRes == 21) || (vGlobalRes == 31)) 
            {
                Response.Redirect(vGlobalUrlPth);
                Response.Flush();
            }

            //'   -3  Assets with CompKey & EquipId < 10
            //'   -2  Invalid value
            //'   -1  Function failure
            //'   0   Record not found
            //'   1   single Record found
            //'   2   Multiple record found
            //'   CompKey values
            //    '   10   Record not found
            //    '   13  Assets present but not valid to view
            //'   EquipKey values
            //    '   20   Record not found
            if (vGlobalRes == -1)
                Label1.Text = "<br/><br/><br/>GPF-><br /> Please contact <a href=mailto:GISServices@water.co.nz>GISServices</a> for more information <br/><br/><br/><br/><br/><br/>";
            //'Hansen resultset  
            //'   10   Record not found
            //'   11   single Record found
            //'   13  Assets present but not valid to view                    
            else if (vGlobalRes == 10)
                Label1.Text = "<br/><br/><br/>This asset does not exist in GIS - please try a different search.<br/><br/><br/><br/><br/><br/>";
            else if (vGlobalRes == 13)
                Label1.Text = "<br/><br/><br/>This asset does not exist in GIS - please try a different search.<br/><br/><br/><br/><br/><br/>";
            //'SAP reslultset                    
            //'   20   Record not found
            //'   21   single Record found                    
            else if (vGlobalRes == 20)
                Label1.Text = "<br/><br/><br/>This asset does not exist in GIS - please try a different search.<br/><br/><br/><br/><br/><br/>";
            else if (vGlobalRes == 30)
                Label1.Text = "<br/><br/><br/>This asset does not exist in GIS - please try a different search.<br/><br/><br/><br/><br/><br/>";
            else if (vGlobalRes == 0)
                Label1.Text = "<br/><br/><br/>This asset does not exist in GIS - please try a different search.<br/><br/><br/><br/><br/><br/>";
            else if (vGlobalRes == -2)
                Label1.Text = "<br/><br/><br/>Invalid value entered - please enter valid value.<br/><br/>Please contact <a href=mailto:GISServices@water.co.nz>GISServices</a> for support<br/><br/><br/><br/>";
            else if (vGlobalRes == -3)
                Label1.Text = "<br/><br/><br/>This asset does not exist in GIS - please try a different search.<br/><br/><br/><br/><br/><br/>";
            else if (vGlobalRes == 23)
                Label1.Text = vGlobalUrlPth;
            else if (vGlobalRes == 33)
                Label1.Text = vGlobalUrlPth;

        }
        catch (Exception ex)
        {
            if (ex is ThreadAbortException)
            {
                Response.SuppressContent = true;
                ApplicationInstance.CompleteRequest();
                Response.End();
                Thread.Sleep(1);
            }
            else
                Response.Write("Error : " + ex.Message.ToString());
        }

    }
}