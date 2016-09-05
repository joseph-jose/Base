<%@ Page Language="VB" Explicit="True" AspCompat="true" Debug="true" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="ADODB" %>
<%@ Import Namespace="System.Globalization" %>

<%--'Sample URL
'http://localhost:3322/GISSearchId.aspx?CompKey=3154682--%>

<script language = "VB" runat = "server">
    Dim vGlobalArrRecs As Object
    Dim vGlobalRes As Integer = -1   ' Result of the Global function
    Dim vGlobalUrlPth As String = ""
#Region "commonFns"

    Sub errTxt(ByVal inMsg As String)
        'Response.Write(inMsg)
        Dim vStr As String
        vStr = "<tr><td colspan=""5""><span class=""errTxt""><br/><br/><br/> {0} <br/><br/><br/><br/><br/><br/></span></td></tr>"
        vStr = String.Format(vStr, inMsg)
        Response.Write(vStr)
    End Sub

    Sub getUrlNameKeyPair(ByRef outQryParamStr As String, ByRef outIDToSrchInt As String)
        Dim vI As Integer
        Dim vQryParamStr, vQryValStr As String
        Dim ViDToSrchStr As String
        ViDToSrchStr = ""
        For vI = 0 To Request.QueryString.Keys.Count - 1
            vQryParamStr = Request.QueryString.Keys(vI).ToString()
            vQryValStr = Request.QueryString(Request.QueryString.Keys(vI).ToString())

            Select Case vQryParamStr.ToUpper()
                Case ("EQUIPMENTID")
                    ViDToSrchStr = vQryValStr
                    Exit For
                Case ("COMPKEY")
                    ViDToSrchStr = vQryValStr
                    Exit For
                Case ("GISID")
                    ViDToSrchStr = vQryValStr
                    Exit For
                Case ("GLOBALID")
                    ViDToSrchStr = vQryValStr
                    Exit For
            End Select
        Next

        outIDToSrchInt = ViDToSrchStr
        outQryParamStr = vQryParamStr.ToUpper()
    End Sub

    Function getSqlFKey(ByVal inKey As String, ByVal inValue As String) As String
        Dim vSqlText As String = ""
        Select Case inKey.ToUpper()
            Case ("EQUIPMENTID")
                vSqlText = "SELECT DISTINCT [gis_id] , [equip_id] , [status] , [fclass] FROM [WA_SAP_View] WHERE [status] <> 'REMOVED' and ([EQUIP_ID] = '{0}') ORDER BY [fclass] DESC"
                vSqlText = String.Format(vSqlText, inValue)
                Exit Select
            Case ("COMPKEY")
                'vSqlText = "SELECT DISTINCT [gis_id] , [equip_id] , [status] , [fclass] FROM [WA_SAP_View] WHERE [status] <> 'REMOVED' and ([GIS_ID] = '{0}') ORDER BY [fclass] DESC"
                vSqlText = "SELECT DISTINCT [gis_id] , [compkey], [status], [fclass] FROM [GISWSL].[WAL_Hansen_View] WHERE ([status] <> 'RM') and ([compkey] = '{0}') ORDER BY [fclass] DESC"
                vSqlText = String.Format(vSqlText, inValue)
                Exit Select
            Case ("GISID")
                vSqlText = "SELECT DISTINCT [gis_id] , [equip_id] , [status] , [fclass], 'SAP' as Source FROM [GISNet1].[GISWSL].[WA_SAP_View] WHERE [status] <> 'REMOVED' and ([GIS_ID] = '{0}') "
                vSqlText = vSqlText & "UNION ALL "
                vSqlText = vSqlText & "SELECT DISTINCT [gis_id] , [compkey], [status], [fclass], 'HANSEN' as Source FROM [GISWSL].[WAL_Hansen_View] WHERE ([status] <> 'RM') and ([GIS_ID] = '{1}') "
                vSqlText = vSqlText & "ORDER BY [fclass] DESC"
                vSqlText = String.Format(vSqlText, inValue, inValue)
                Exit Select
            Case ("GLOBALID")
                vSqlText = "SELECT DISTINCT [gis_id] , [equip_id] , [status] , [fclass] FROM [WA_SAP_View] WHERE [status] <> 'REMOVED' and ([GIS_ID] = '{0}') ORDER BY [fclass] DESC"
                vSqlText = String.Format(vSqlText, inValue)
                Exit Select
        End Select
        Return vSqlText
    End Function

    Sub getDbVals(ByRef outSrvrName As String, ByRef outSrvrPwd As String)
        Dim vWebSrvrName As String = ""
        vWebSrvrName = Request.ServerVariables("SERVER_NAME")

        Select Case vWebSrvrName
            Case ("wsldctgdw")
                'TODO to be enabled
                'outSrvrName = "WSLDCTGDW"
                'outSrvrPwd = "G1s@webd01"
                outSrvrName = "WSLDCTVGPD2"
                outSrvrPwd = "NetG15@wp01"
            Case ("wsldctvgtw")
                outSrvrName = "WSLDCTVGTD2"
                outSrvrPwd = "NetG15@wt01"
            Case ("gisweb")
                outSrvrName = "WSLDCTVGPD2"
                outSrvrPwd = "NetG15@wp01"
            Case ("wsldctvgpw")
                outSrvrName = "WSLDCTVGPD2"
                outSrvrPwd = "NetG15@wp01"
            Case Else
                outSrvrName = "WSLDCTVGPD2"
                outSrvrPwd = "NetG15@wp01"
        End Select
    End Sub

    Function getRecordsFId(ByVal inSrchName As String, ByVal inSrchKey As String, ByVal inDbName As String) As Object
        getRecordsFId = Nothing

        Dim vSrvrName As String = ""
        Dim vPsswrd As String = ""
        getDbVals(vSrvrName, vPsswrd)

        '*****************Open database*****************************************************************
        ' connect to database
        Dim vObjConn As Object
        Dim vObjRst As Object
        vObjConn = Nothing
        vObjRst = Nothing
        Try
            vObjConn = Server.CreateObject("ADODB.Connection")

            'vObjConn.ConnectionString = "Provider=SQLOLEDB;Data Source=" + vSrvrName + ";User ID=gisweb;Password=" + vPsswrd + ";Initial Catalog=GISNet1"
            vObjConn.ConnectionString = "Provider=SQLOLEDB;Data Source={0};User ID=gisweb;Password={1};Initial Catalog={2}"
            vObjConn.ConnectionString = String.Format(vObjConn.ConnectionString, vSrvrName, vPsswrd, inDbName)
            vObjConn.Open()

            vObjRst = Server.CreateObject("ADODB.Recordset")
            Dim vSqlText As String
            vSqlText = getSqlFKey(inSrchName, inSrchKey)

            vObjRst.Open(vSqlText, vObjConn, , , 1)

            If Not vObjRst.eof Then
                getRecordsFId = vObjRst.GetRows()
            End If
        Catch ex As Exception
            Response.Write(ex.Message.ToString())
        Finally
            If (Not (vObjRst Is Nothing)) Then
                vObjRst.Close()
                vObjRst = Nothing
            End If
            If (Not (vObjConn Is Nothing)) Then
                vObjConn.Close()
                vObjConn = Nothing
            End If
        End Try
    End Function

    Function buildOutStr(ByVal inStr As String) As String
        buildOutStr = "<td> " + inStr + "</td>"
    End Function


#End Region


#Region "Hansen"
    Function buildCompKeyUrls(ByVal inArr As Array, ByRef outStr As String) As Boolean

        buildCompKeyUrls = True
        Dim vCompKey, vStatus, vFClass As String
        Dim vTmpStr, vstrScale As String

        vCompKey = inArr(1, 0)
        vStatus = inArr(2, 0)
        vFClass = inArr(3, 0)


        If (vStatus.Trim() = "AB") Then
            vTmpStr = "WL_FITTING,WL_HYDRANT,WL_METER,WL_VALVE,WWL_FITTING"
            If (Not (vTmpStr.ToString().IndexOf(vFClass) = -1)) Then
                buildCompKeyUrls = False
            End If
        End If


        If buildCompKeyUrls Then
            If (vFClass.Equals("WT_Pipe") Or vFClass.Equals("WWT_Pipe") Or vFClass.Equals("WWT_PumpStation") Or vFClass.Equals("WT_PumpStation")) Then
                vstrScale = "500"
            ElseIf (vFClass.Equals("WT_TPlant") Or vFClass.Equals("WWT_TPlant") Or vFClass.Equals("WT_Reservoir")) Then
                vstrScale = "1000"
            Else
                vstrScale = "1000"
            End If


            outStr = "http://" & Request.ServerVariables("SERVER_NAME").ToString() & "/netview/index.html?feature=" & vFClass & "," & vCompKey & "&scale=" & vstrScale
            buildCompKeyUrls = True
        End If
    End Function

    Function procCompKeyArr(ByVal inArr As Array) As Integer
        '   -1  Function failure
        '   0   Record not found
        '   1   single Record found
        '   2   Multiple record found
        '   3   Asset out of service
        procCompKeyArr = -1

        Dim vUrlStr As String = ""

        Dim vTotRecFnd As Integer = -1
        Dim vDsplyStr As String = ""

        If (vGlobalArrRecs Is Nothing) Then
            'No records found in SAP-View
            'Response.Write("No records found in Hansen")
            procCompKeyArr = 0
        Else
            'one records found
            If vGlobalArrRecs.GetLength(1) = 1 Then
                If (buildCompKeyUrls(vGlobalArrRecs, vUrlStr) = True) Then
                    procCompKeyArr = 1
                Else
                    procCompKeyArr = 3
                End If

            Else
                ''Multiple records
                'vTotRecFnd = displayMutipleHanesnRecs(vGlobalArrRecs, inIDVal, vDsplyStr)
                'If vTotRecFnd = 0 Then
                '    'Abondoned asset
                '    procCompKeys = 2
                'Else
                '    procCompKeys = 1
                '    Response.Write(vDsplyStr)
                'End If
                If (buildCompKeyUrls(vGlobalArrRecs, vUrlStr) = True) Then
                    procCompKeyArr = 1
                Else
                    procCompKeyArr = 3
                End If
            End If

            vGlobalArrRecs = Nothing
        End If
        vGlobalUrlPth = vUrlStr
    End Function
#End Region



</script>
<%
    On Error GoTo ErrHndlr

    'Dim vResFn As Integer = -1   ' Result of the Global function
    '   -1  Function failure
    '   0   Record not found
    '   1   single Record found
    '   2   Multiple record found
    '   3   Asset out of service    

    Dim vQryParamStr As String = ""
    Dim ViDToSrchStr As String = ""
    If (Request.QueryString.Keys.Count = 0) Then
        Response.Write("Valid parameters not found")
        Response.End()
    End If
    getUrlNameKeyPair(vQryParamStr, ViDToSrchStr)

    Dim vIDToSrchInt As Integer = -1
    If (ViDToSrchStr = "") Then
        vGlobalRes = -1
        GoTo NoErrHndlr
    End If
    If (Not (Integer.TryParse(ViDToSrchStr, vIDToSrchInt))) Then
        vGlobalRes = -2
        GoTo NoErrHndlr
    Else
        If (vIDToSrchInt < 0) Then
            vGlobalRes = -2
            GoTo NoErrHndlr
        End If
    End If



    Select Case vQryParamStr.ToUpper()
        Case ("COMPKEY")
            vGlobalArrRecs = Nothing
            vGlobalArrRecs = getRecordsFId(vQryParamStr, ViDToSrchStr, "GISNet2")
            vGlobalRes = procCompKeyArr(vGlobalArrRecs)
    End Select

    If (vGlobalRes = 1) Then
        Response.Redirect(vGlobalUrlPth)
        Response.Flush()
    End If

    GoTo NoErrHndlr
ErrHndlr:
    Response.Write("Error : " + Err.Description.ToString())

NoErrHndlr:

    'Response.End()

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
                If (vGlobalRes = -1) Then
                    Call errTxt("<span class='errTxt'><br/><br/><br/>GPF-><br /> Please contact <a href=mailto:GISServices@water.co.nz>GISServices</a> for more information <br/><br/><br/><br/><br/><br/></span>")
                ElseIf (vGlobalRes = 0) Then
                    Call errTxt("<span class='errTxt'><br/><br/><br/>This asset does not exist in GIS - please try a different search.<br/><br/><br/><br/><br/><br/></span>")
                ElseIf (vGlobalRes = -2) Then
                    Call errTxt("<span class='errTxt'><br/><br/><br/>Invalid value entered - please enter valid numeric value.<br/><br/>Please contact <a href=mailto:GISServices@water.co.nz>GISServices</a> for support<br/><br/><br/><br/></span>")
                ElseIf (vGlobalRes = 2) Then
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
            End If
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
