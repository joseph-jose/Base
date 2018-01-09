<%@ Page Language="VB" Explicit="True" AspCompat="true" Debug="true" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="ADODB" %>
<%@ Import Namespace="System.Globalization" %>

<!-- #include virtual="/inc/Common.aspx">

<script language = "VB" runat = "server">
    Dim vGlobalArrRecs As Object
    Dim vGlobalRes As Integer = -1   ' Result of the Global function
    Dim vGlobalUrlPth As String = ""
    Dim vGlobalHnDet As String = ""
    'Dim vGlobalHeaderTxt As String = ""
#Region "commonFns"

    'Sub errTxt(ByVal inMsg As String)
    '    Dim vStr As String
    '    vStr = "<tr><td colspan=""5"" class=""style12""><span class=""errTxt""><br/><br/><br/>GPF-><br /> {0} <br/><br/><br/><br/><br/><br/></span></td></tr>"
    '    vStr = String.Format(vStr, inMsg)
    '    Response.Write(vStr)
    'End Sub

    'Sub msgTxt(ByVal inMsg As String)
    '    Dim vStr As String
    '    'vStr = "<tr><td colspan=""5"" class=""style12""><span class=""errTxt""><br/><br/><br/><br /> {0} <br/><br/><br/><br/><br/><br/></span></td></tr>"
    '    vStr = "<span class=""errTxt""><br/><br/><br/><br /> {0} <br/><br/><br/><br/><br/><br/>"
    '    vStr = String.Format(vStr, inMsg)
    '    Response.Write(vStr)
    'End Sub

    'Sub getUrlNameKeyPair(ByRef outQryParamStr As String, ByRef outIDToSrchInt As String)
    '    Dim vI As Integer
    '    Dim vQryParamStr, vQryValStr As String
    '    Dim ViDToSrchStr As String
    '    ViDToSrchStr = ""
    '    For vI = 0 To Request.QueryString.Keys.Count - 1
    '        vQryParamStr = Request.QueryString.Keys(vI).ToString()
    '        vQryValStr = Request.QueryString(Request.QueryString.Keys(vI).ToString())

    '        Select Case vQryParamStr.ToUpper()
    '            Case ("EQUIPMENTID")
    '                ViDToSrchStr = vQryValStr
    '                Exit For
    '            Case ("COMPKEY")
    '                ViDToSrchStr = vQryValStr
    '                Exit For
    '            Case ("GISID")
    '                ViDToSrchStr = vQryValStr
    '                Exit For
    '            Case ("GLOBALID")
    '                ViDToSrchStr = vQryValStr
    '                Exit For
    '        End Select
    '    Next

    '    outIDToSrchInt = ViDToSrchStr
    '    outQryParamStr = vQryParamStr.ToUpper()
    'End Sub

    'Function getSqlFKey(ByVal inKey As String, ByVal inValue As String) As String
    '    Dim vSqlText As String = ""
    '    Select Case inKey.ToUpper()
    '        Case ("EQUIPMENTID")
    '            'vSqlText = "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey],[status]  ,[fclass] FROM [WA_Asset_View] WHERE [status] <> 'REMOVED' and ([EQUIP_ID] = '{0}') ORDER BY [fclass] DESC"
    '            vSqlText = "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey],[status]  ,[fclass] FROM [GISWSL].[WA_Netview_View] WHERE [status] <> 'REMOVED' and ([EQUIP_ID] = '{0}') ORDER BY [fclass] DESC"
    '            vSqlText = String.Format(vSqlText, inValue)
    '            Exit Select
    '        Case ("COMPKEY")
    '            'vSqlText = "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey],[status]  ,[fclass] FROM [GISWSL].[WA_Asset_View] WHERE ([status] <> 'RM') and ([compkey] = '{0}') ORDER BY [fclass] DESC"
    '            vSqlText = "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey],[status]  ,[fclass] FROM [GISWSL].[WA_Netview_View] WHERE ([status] <> 'RM') and ([compkey] = '{0}') ORDER BY [fclass] DESC"
    '            vSqlText = String.Format(vSqlText, inValue)
    '            Exit Select
    '        Case ("GISIDNET1")
    '            'vSqlText = "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey],[status]  ,[fclass], 'SAP' as Source FROM [GISWSL].[WA_Asset_View] WHERE [status] <> 'REMOVED' and ([GIS_ID] = '{0}') "
    '            vSqlText = "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey],[status]  ,[fclass], 'SAP' as Source FROM [GISWSL].[WA_Netview_View] WHERE [status] <> 'REMOVED' and ([GIS_ID] = '{0}') "
    '            vSqlText = vSqlText & "ORDER BY [fclass] DESC"
    '            vSqlText = String.Format(vSqlText, inValue, inValue)
    '            Exit Select
    '        Case ("GISIDNET2")
    '            'vSqlText = vSqlText & "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey],[status]  ,[fclass], 'HANSEN' as Source FROM [GISWSL].[WA_Asset_View] WHERE ([status] <> 'RM') and ([GIS_ID] = '{0}') "
    '            vSqlText = vSqlText & "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey],[status]  ,[fclass], 'HANSEN' as Source FROM [GISWSL].[WA_Netview_View] WHERE ([status] <> 'RM') and ([GIS_ID] = '{0}') "
    '            vSqlText = vSqlText & "ORDER BY [fclass] DESC"
    '            vSqlText = String.Format(vSqlText, inValue, inValue)
    '            Exit Select
    '    End Select
    '    Return vSqlText
    'End Function

    'Sub getDbVals(ByRef outSrvrName As String, ByRef outSrvrPwd As String)
    '    Dim vWebSrvrName As String = ""
    '    vWebSrvrName = Request.ServerVariables("SERVER_NAME")

    '    Select Case vWebSrvrName
    '        Case ("localhost")
    '            'TODO to be enabled
    '            outSrvrName = "WSLDCTGDW"
    '            outSrvrPwd = "G1s@webd01"
    '        Case ("wsldctgdw")
    '            'TODO to be enabled
    '            outSrvrName = "WSLDCTGDW"
    '            outSrvrPwd = "G1s@webd01"
    '        'outSrvrName = "WSLDCTVGPD2"
    '        'outSrvrPwd = "NetG15@wp01"
    '        Case ("wsldctvgtw")
    '            outSrvrName = "WSLDCTVGTD2"
    '            outSrvrPwd = "NetG15@wt01"
    '        Case ("gisweb")
    '            outSrvrName = "WSLDCTVGPD2"
    '            outSrvrPwd = "NetG15@wp01"
    '        Case ("wsldctvgpw")
    '            outSrvrName = "WSLDCTVGPD2"
    '            outSrvrPwd = "NetG15@wp01"
    '        Case Else
    '            outSrvrName = "WSLDCTVGPD2"
    '            outSrvrPwd = "NetG15@wp01"
    '    End Select
    'End Sub

    'Function execDbFetch(ByVal inSrvrName As String, ByVal inPsswrd As String, ByVal inDbName As String, ByVal inSql As String, Optional ByRef outFldNames As String = "") As Object
    '    execDbFetch = Nothing
    '    '*****************Open database*****************************************************************
    '    ' connect to database
    '    Dim vObjConn As Object
    '    Dim vObjRst As Object
    '    vObjConn = Nothing
    '    vObjRst = Nothing
    '    Try
    '        vObjConn = Server.CreateObject("ADODB.Connection")

    '        'vObjConn.ConnectionString = "Provider=SQLOLEDB;Data Source=" + vSrvrName + ";User ID=gisweb;Password=" + vPsswrd + ";Initial Catalog=GISNet1"
    '        vObjConn.ConnectionString = "Provider=SQLOLEDB;Data Source={0};User ID=gisweb;Password={1};Initial Catalog={2}"
    '        vObjConn.ConnectionString = String.Format(vObjConn.ConnectionString, inSrvrName, inPsswrd, inDbName)
    '        vObjConn.Open()

    '        vObjRst = Server.CreateObject("ADODB.Recordset")

    '        vObjRst.Open(inSql, vObjConn, , , 1)


    '        If Not vObjRst.eof Then
    '            execDbFetch = vObjRst.GetRows()
    '        End If

    '        Dim vFldNames As String
    '        vFldNames = ""
    '        For Each fldf In vObjRst.Fields
    '            vFldNames = vFldNames & fldf.Name & ","
    '        Next
    '        outFldNames = vFldNames
    '    Catch ex As Exception
    '        Response.Write(ex.Message.ToString())
    '    Finally
    '        If (Not (vObjRst Is Nothing)) Then
    '            vObjRst.Close()
    '            vObjRst = Nothing
    '        End If
    '        If (Not (vObjConn Is Nothing)) Then
    '            vObjConn.Close()
    '            vObjConn = Nothing
    '        End If
    '    End Try
    'End Function

    'Function getRecordsFId(ByVal inSrchName As String, ByVal inSrchKey As String, ByVal inDbName As String) As Object
    '    getRecordsFId = Nothing

    '    Dim vSrvrName As String = ""
    '    Dim vPsswrd As String = ""
    '    getDbVals(vSrvrName, vPsswrd)

    '    Dim vSqlText As String
    '    vSqlText = getSqlFKey(inSrchName, inSrchKey)
    '    getRecordsFId = execDbFetch(vSrvrName, vPsswrd, inDbName, vSqlText)

    'End Function

    'Function logNtry(ByVal inSrchName As String, ByVal inSrchKey As String, ByVal inDbName As String) As Boolean
    '    logNtry = False

    '    Dim vSrvrName As String = ""
    '    Dim vPsswrd As String = ""
    '    getDbVals(vSrvrName, vPsswrd)

    '    '*****************Open database*****************************************************************
    '    ' connect to database
    '    Dim vObjConn As Object
    '    'Dim vObjRst As Object
    '    vObjConn = Nothing
    '    'vObjRst = Nothing
    '    Try
    '        vObjConn = Server.CreateObject("ADODB.Connection")

    '        'vObjConn.ConnectionString = "Provider=SQLOLEDB;Data Source=" + vSrvrName + ";User ID=gisweb;Password=" + vPsswrd + ";Initial Catalog=GISNet1"
    '        'vObjConn.ConnectionString = "Provider=SQLNCLI10;Data Source={0};User ID=gisweb;Password={1};Initial Catalog={2}"
    '        vObjConn.ConnectionString = "Provider=SQLOLEDB;Data Source={0};User ID=gisweb;Password={1};Initial Catalog={2}"
    '        vObjConn.ConnectionString = String.Format(vObjConn.ConnectionString, vSrvrName, vPsswrd, inDbName)
    '        vObjConn.Open()

    '        'vObjRst = Server.CreateObject("ADODB.Recordset")
    '        Dim vSqlText As String
    '        vSqlText = "Insert into GISADMin.giswsl.WA_AppLogs (CurrUsr, CmdType, LogType, Msg, Fld1, Fld10) values ('{0}','{1}','{2}','{3}','{4}','{5}')"
    '        vSqlText = String.Format(vSqlText, "Internet", "WCAspApps", "ToGISIDSrch", inSrchName, inSrchKey, "")
    '        'vObjRst.Open(vSqlText, vObjConn, , , 1)
    '        vObjConn.Execute(vSqlText, "adExecuteNoRecords")

    '        logNtry = True
    '    Catch ex As Exception
    '        Response.Write(ex.Message.ToString())
    '    Finally
    '        'If (Not (vObjRst Is Nothing)) Then
    '        '    vObjRst.Close()
    '        '    vObjRst = Nothing
    '        'End If
    '        If (Not (vObjConn Is Nothing)) Then
    '            vObjConn.Close()
    '            vObjConn = Nothing
    '        End If
    '    End Try
    'End Function

    'Function buildOutStr(ByVal inStr As String) As String
    '    buildOutStr = "<td> " + inStr + "</td>"
    'End Function

    ''--To be enabled later
    '''Function will not be required
    ''Function displayMutipleSAPRecs(inArrRes As Object, ByRef outLstRecFndIdx As Integer, ByRef outStr As String) As Integer
    ''    ''Where (a[2] = "OOS")
    ''    'Dim vValidRecs = From a In inArrRes
    ''    '        Order By a(1)
    ''    '        Select a
    ''    'For Each ar In vValidRecs
    ''    '    Response.Write(ar(0)(2).ToString())
    ''    '    'Response.Write(ar.ToString())
    ''    'Next

    ''    'Duplicate records found in values 10017375 , 10018007

    ''    displayMutipleSAPRecs = 0
    ''    outLstRecFndIdx = -1
    ''    outStr = ""
    ''    Dim vWidth As Integer = 0
    ''    Dim vLength As Integer = 0
    ''    Dim vJ As Integer
    ''    Dim vI As Integer
    ''    Dim vCntRec As Integer = 0
    ''    Dim vLstRecIdxFnd As Integer = -1

    ''    Dim vRecIdx As Integer = 0

    ''    Dim vResStr As String = ""

    ''    Dim vtmpStr As String
    ''    vWidth = inArrRes.GetLength(0)
    ''    vLength = inArrRes.GetLength(1)


    ''    For vI = 0 To vLength - 1
    ''        vtmpStr = inArrRes(2, vI)
    ''        If Not ((vtmpStr = "REMOVED")) Then
    ''            vCntRec = vCntRec + 1
    ''            vLstRecIdxFnd = vI
    ''            For vJ = 0 To vWidth - 1
    ''                vResStr = vResStr + buildOutStr(inArrRes(vJ, vI))
    ''            Next
    ''            vResStr = "<tr>" & vResStr & "</tr>"
    ''        End If
    ''    Next
    ''    If (vCntRec > 0) Then
    ''        outLstRecFndIdx = vLstRecIdxFnd
    ''        outStr = vResStr
    ''        'Response.Write(vResStr)
    ''    End If
    ''    displayMutipleSAPRecs = vCntRec
    ''End Function    
#End Region

#Region "SAP"

    Function procEquipmentArr(ByVal inArr As Array) As Integer
        '   -1  Function failure
        '   20   Record not found
        '   21   single Record found
        '   2   Multiple record found
        '   3   Asset out of service        
        Dim vUrlStr As String = ""
        Dim vTotRecFnd As Integer = -1
        Dim vDsplyStr As String = ""

        procEquipmentArr = -1

        Dim vGisId, vCompKey, vEquipId, vStatus, vFClass As String
        vGisId = ""
        vCompKey = ""
        vEquipId = ""
        vStatus = ""
        vFClass = ""


        If (vGlobalArrRecs Is Nothing) Then
            'No records found in SAP-View
            procEquipmentArr = 20
            'Response.Write("No records found in SAPView")
        Else
            'one records found
            If vGlobalArrRecs.GetLength(1) = 1 Then
                vGisId = vGlobalArrRecs(0, 0)
                vEquipId = vGlobalArrRecs(1, 0)
                vCompKey = vGlobalArrRecs(2, 0)
                vStatus = vGlobalArrRecs(3, 0)
                vFClass = vGlobalArrRecs(4, 0)
            Else
                '--To be enabled later
                ''Multiple records
                'vTotRecFnd = displayMutipleSAPRecs(vGlobalArrRecs, inIDVal, vDsplyStr)
                'If vTotRecFnd = 0 Then
                '    'Abondoned asset
                '    procEquipmentIDs = 2
                'Else
                '    procEquipmentIDs = 1
                '    Response.Write(vDsplyStr)
                'End If
                vGisId = vGlobalArrRecs(0, 0)
                vEquipId = vGlobalArrRecs(1, 0)
                vCompKey = vGlobalArrRecs(2, 0)
                vStatus = vGlobalArrRecs(3, 0)
                vFClass = vGlobalArrRecs(4, 0)
            End If
            procEquipmentArr = 21
        End If
        vGlobalArrRecs = Nothing

        'buildSAPKeyUrls(vEquipId, vStatus, vFClass)
        vFClass = String.Format("[GISNet1].[GISWSL].[{0}]", vFClass)
        buildUrlsFGisId(vGisId, vStatus, vFClass)
    End Function
#End Region

#Region "Hansen"
    Function printTable(ByVal arrayHdr, ByVal arrayT, ByVal comptype) As String
        Dim strT, lnRowCounter, lnColumnCounter
        strT = ""
        For lnRowCounter = 0 To UBound(arrayT, 2)
            For lnColumnCounter = 0 To UBound(arrayT, 1)

                If IsDBNull(arrayT(lnColumnCounter, lnRowCounter)) Then

                ElseIf arrayHdr(lnColumnCounter) Like "Reliability*" Then

                ElseIf arrayHdr(lnColumnCounter + 1) Like "Reliability*" Then
                    strT = strT & "<tr><td><b>" & arrayHdr(lnColumnCounter) & "</b></td><td > " & arrayT(lnColumnCounter, lnRowCounter) & "</td><td >" & arrayT(lnColumnCounter + 1, lnRowCounter) & "</td></tr>"


                Else
                    strT = strT & "<tr><td><b>" & arrayHdr(lnColumnCounter) & "</b></td><td > " & arrayT(lnColumnCounter, lnRowCounter) & "</td><td ></td></tr>"

                End If
            Next
        Next
        'Response.Write(strT)
        vGlobalHnDet = "<table id='hTable' border=0><thead id='hThread'><tr><th>Field</th><th>Data</th><th>Reliability</th></tr></thead><tbody id='hTBody'>"
        'vGlobalHnDet = "<table border=2><thead ><tr><th>Field</th><th>Data</th><th>Reliability</th></tr></thead><tbody >"
        vGlobalHnDet = vGlobalHnDet & strT
        vGlobalHnDet = vGlobalHnDet & "</tbody></table>"
        'vGlobalHnDet = "<table border=1><tr><td>Field</td><td>Data</td><td>Reliability</td></tr>" & strT & "</table>"
        printTable = strT
    End Function

    Sub getHansenDetails(ByVal inCompKey As String, ByVal inCompType As String)
        'Declare variables and read Request parameters into these.
        Dim vFldNames As String
        Dim compkey, comptype, comptypeTemp, validasset
        compkey = inCompKey
        comptype = inCompType
        comptypeTemp = "-1"


        ' error check and assign comptype
        If Len(comptype) < 1 Then
            comptype = ""
        ElseIf Len(comptype) = 2 Then
            Select Case comptype
                'New netview
                'Case "38", "41", "45", "43", "46", "12", "67", "70", "99", "21", "26", "24", "35", "22", "15", "69", "98", "42"
                Case "38", "41", "45", "43", "46", "12", "67", "70", "99", "21", "26", "24", "35", "22", "15", "69", "98", "42", "44"
                    'New netview end
                    'multilayerUpgrade
                    comptype = comptype
                Case Else
                    comptype = ""
            End Select

        ElseIf Len(comptype) > 2 Then
            Select Case comptype
                'Case Water Backflow is added for the reason of water Backflow form dated 26/06/2012 in dd/mm/yyyy format
                Case "Backflow"
                    comptype = "38"
                Case "Node"
                    comptype = "43"
                    comptypeTemp = "24"
                Case "Hydrant"
                    comptype = "12"
                Case "Main"
                    comptype = "41"
                    comptypeTemp = "21"
                Case "Serviceline"
                    comptype = "45"
                    comptypeTemp = "26"
                Case "Storage Unit"
                    comptype = "67"
                Case "Plant"
                    comptype = "99"
                Case "Valve"
                    comptype = "46"
                    comptypeTemp = "35"
                Case "Node"
                    comptype = "24"
                Case "Valve"
                    comptype = "35"
                Case "Manhole"
                    comptype = "22"
                Case "Main"
                    comptype = "21"
                Case "Serviceline"
                    comptype = "26"
                Case "Pump Station"
                    comptype = "15"
                Case "Miscellaneous"
                    comptype = "69"
                    comptypeTemp = "70"
                Case "Water Meter"
                    comptype = "42"
                    comptypeTemp = "1"
                Case "Water Misc"
                    comptype = "70"
                    comptypeTemp = "2"
                Case "Tank"
                    comptype = "67"
                Case "Facility"
                    comptype = "4"
                'New netview
                Case "Pump"
                    comptype = "44"
                'New netview

                Case Else
                    comptype = ""
            End Select
        End If

        Select Case comptype
            'New netview
            'Case "38", "41", "45", "43", "46", "12", "67", "70", "99", "21", "26", "24", "35", "22", "15", "69", "98", "4", "42"
            Case "38", "41", "45", "43", "46", "12", "67", "70", "99", "21", "26", "24", "35", "22", "15", "69", "98", "4", "42", "44"
                'New netview
                validasset = "yes"
            Case Else
                validasset = "no"
        End Select
        If (validasset = "yes") Then
            If IsNumeric(compkey) Then
                validasset = "yes"
            Else
                validasset = "no"
            End If
        End If

        If (validasset = "no") Then

            Response.Write("<tr><td>Invalid compkey number, please try again...</td><td></td><td></td></tr>")

        Else
            '*******************************************************************************************************************
            Dim arrayHdr
            Dim sqlText, arrayResult, arrayResult2 'sqlCodeDescript, arrayCodeDescript


            If comptype = 21 Then
                'Reliability RPLAN not found in Lookup table
                'sqlText = "SELECT IMSV7.COMPSMN.COMPKEY AS 'Comp Key',  IMSV7.COMPSMN.ASBLT AS 'As-Built', IMSV7.COMPSMN.UNITTYPE AS 'Main Line Type',IMSV7.COMPSMN.PIPETYPE AS 'Material', IMSV7.COMPSMN.UNITID AS 'UnitId1', IMSV7.COMPSMN.UNITID2 AS 'UnitId2', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELMATL= IMSV7.TBL3034.CODE)  AS 'Reliability Material', IMSV7.COMPSMN.PIPEDIAM AS 'Diameter',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELDIA= IMSV7.TBL3034.CODE)  AS 'Reliability Diameter', IMSV7.COMPSMN.INSTDATE AS 'Installation Date',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELDATE= IMSV7.TBL3034.CODE)  AS 'Reliability Date', IMSV7.COMPSMN.SERVSTAT AS 'Status',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELSTATUS= IMSV7.TBL3034.CODE)  AS 'Reliability Status', IMSV7.COMPSMN.OWN AS 'Owner',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELOWN= IMSV7.TBL3034.CODE)  AS 'Reliability Owner', IMSV7.XSMN.OLDID AS 'Old Id', IMSV7.XSMN.OLDCOMPKEY AS 'Old Comp Key', IMSV7.XSMN.OLDOWNER AS 'Old Owner' FROM IMSV7.COMPSMN LEFT OUTER JOIN IMSV7.XSMN ON IMSV7.COMPSMN.COMPKEY = IMSV7.XSMN.COMPKEY INNER JOIN IMSV7.COMPTYPE ON IMSV7.COMPSMN.MAINCOMP1 = IMSV7.COMPTYPE.COMPTYPE INNER JOIN  IMSV7.COMPTYPE AS COMPTYPE_1 ON IMSV7.COMPSMN.MAINCOMP2 = COMPTYPE_1.COMPTYPE WHERE (IMSV7.COMPSMN.COMPKEY = '" + compkey + "')"
                sqlText = "SELECT IMSV7.COMPSMN.COMPKEY AS 'Compkey',  IMSV7.COMPSMN.ASBLT AS 'As-Built', IMSV7.COMPSMN.UNITTYPE AS 'Main Line Type', IMSV7.COMPSMN.UNITID AS 'UnitId', IMSV7.COMPSMN.UNITID2 AS 'UnitId2', IMSV7.COMPSMN.PIPETYPE AS 'Material', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELMATL= IMSV7.TBL3034.CODE)  AS 'Reliability Material', IMSV7.COMPSMN.PIPEDIAM AS 'Diameter',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELDIA= IMSV7.TBL3034.CODE)  AS 'Reliability Diameter', IMSV7.COMPSMN.INSTDATE AS 'Installation Date', IMSV7.XSMN.RELDATE  AS 'Reliability Date', IMSV7.COMPSMN.SERVSTAT AS 'Status',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELSTATUS= IMSV7.TBL3034.CODE)  AS 'Reliability Status', IMSV7.COMPSMN.OWN AS 'Owner',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELOWN= IMSV7.TBL3034.CODE)  AS 'Reliability Owner', IMSV7.XSMN.OLDID AS 'Old Id', IMSV7.XSMN.OLDCOMPKEY AS 'Old Compkey', IMSV7.XSMN.OLDOWNER AS 'Old Owner', IMSV7.XSMN.LINDATE AS 'Lining Date', IMSV7.XSMN.LINING as 'Lining type' FROM IMSV7.COMPSMN LEFT OUTER JOIN IMSV7.XSMN ON IMSV7.COMPSMN.COMPKEY = IMSV7.XSMN.COMPKEY INNER JOIN IMSV7.COMPTYPE ON IMSV7.COMPSMN.MAINCOMP1 = IMSV7.COMPTYPE.COMPTYPE INNER JOIN  IMSV7.COMPTYPE AS COMPTYPE_1 ON IMSV7.COMPSMN.MAINCOMP2 = COMPTYPE_1.COMPTYPE WHERE (IMSV7.COMPSMN.COMPKEY = '" + compkey + "')"
                'sqlText = "SELECT IMSV7.COMPSMN.COMPKEY AS 'Compkey',  IMSV7.COMPSMN.ASBLT AS 'As-Built', IMSV7.COMPSMN.UNITTYPE AS 'Main Line Type',IMSV7.COMPSMN.PIPETYPE AS 'Material', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELMATL= IMSV7.TBL3034.CODE)  AS 'Reliability Material', IMSV7.COMPSMN.UNITID AS 'UnitId', IMSV7.COMPSMN.UNITID2 AS 'UnitId2', IMSV7.COMPSMN.PIPEDIAM AS 'Diameter',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELDIA= IMSV7.TBL3034.CODE)  AS 'Reliability Diameter', IMSV7.COMPSMN.INSTDATE AS 'Installation Date',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELDATE= IMSV7.TBL3034.CODE)  AS 'Reliability Date', IMSV7.COMPSMN.SERVSTAT AS 'Status',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELSTATUS= IMSV7.TBL3034.CODE)  AS 'Reliability Status', IMSV7.COMPSMN.OWN AS 'Owner',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELOWN= IMSV7.TBL3034.CODE)  AS 'Reliability Owner', IMSV7.XSMN.OLDID AS 'Old Id', IMSV7.XSMN.OLDCOMPKEY AS 'Old Compkey', IMSV7.XSMN.OLDOWNER AS 'Old Owner' FROM IMSV7.COMPSMN LEFT OUTER JOIN IMSV7.XSMN ON IMSV7.COMPSMN.COMPKEY = IMSV7.XSMN.COMPKEY INNER JOIN IMSV7.COMPTYPE ON IMSV7.COMPSMN.MAINCOMP1 = IMSV7.COMPTYPE.COMPTYPE INNER JOIN  IMSV7.COMPTYPE AS COMPTYPE_1 ON IMSV7.COMPSMN.MAINCOMP2 = COMPTYPE_1.COMPTYPE WHERE (IMSV7.COMPSMN.COMPKEY = '" + compkey + "')"
                'Reliability RPLAN not found in Lookup table end
            ElseIf (comptype = 38) Then
                sqlText = "SELECT  A.COMPKEY AS 'Compkey',A.ASBLT AS 'As-Built',A.UNITTYPE AS 'Backflow Type', A.UNITID AS 'UnitId', A.MODELNO AS 'Model Number',A.BFSIZE as 'Backflow Size',A.SERNO AS 'Serial Number',A.LOC AS 'Location',A.INSTDATE AS 'Installation Date',C.LAST_TEST AS 'Last Inspection Date',A.OWN AS 'Owner',A.SERVSTAT AS 'Status' FROM IMSV7.COMPWBF A LEFT OUTER JOIN dbo.UVW_BACKFLOW C ON A.COMPKEY = C.COMPKEY WHERE (A.COMPKEY ='" + compkey + "')"
            ElseIf (comptype = 41) Then
                sqlText = "SELECT IMSV7.COMPWMN.COMPKEY AS 'Compkey',  IMSV7.COMPWMN.ASBLT AS 'As-Built',IMSV7.COMPWMN.UNITTYPE AS 'Main Line Type', IMSV7.COMPWMN.UNITID AS 'UnitId', IMSV7.COMPWMN.UNITID2 AS 'UnitId2',IMSV7.COMPWMN.PIPETYPE AS 'Material', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XWMN.RELMATL= IMSV7.TBL3034.CODE)  AS 'Reliability Material', IMSV7.COMPWMN.DIAM AS 'Diameter',  (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XWMN.RELDIA= IMSV7.TBL3034.CODE)  AS 'Reliability Diameter', IMSV7.COMPWMN.INSTDATE AS 'Installation Date', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XWMN.RELDATE= IMSV7.TBL3034.CODE)  AS 'Reliability Date', IMSV7.COMPWMN.SERVSTAT AS 'Status', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XWMN.RELSTATUS= IMSV7.TBL3034.CODE)  AS 'Reliability Status', IMSV7.COMPWMN.OWN AS 'Owner', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XWMN.RELOWN= IMSV7.TBL3034.CODE)  AS 'Reliability Owner', IMSV7.XWMN.HYDGRLN as 'Hydr grade line', IMSV7.XWMN.OLDID AS 'Old Id',IMSV7.XWMN.OLDCOMPKEY AS 'Old Compkey', IMSV7.XWMN.OLDOWNER AS 'Old Owner' FROM IMSV7.COMPWMN LEFT OUTER JOIN IMSV7.XWMN ON IMSV7.COMPWMN.COMPKEY = IMSV7.XWMN.COMPKEY INNER JOIN IMSV7.COMPTYPE ON IMSV7.COMPWMN.MAINCOMP1 = IMSV7.COMPTYPE.COMPTYPE INNER JOIN  IMSV7.COMPTYPE AS COMPTYPE_1 ON IMSV7.COMPWMN.MAINCOMP2 = COMPTYPE_1.COMPTYPE WHERE     (IMSV7.COMPWMN.COMPKEY = '" + compkey + "')"
            ElseIf (comptype = 45) Then
                'SELECT     IMSV7.COMPWSL.COMPKEY, IMSV7.COMPTYPE.COMPCODE FROM  IMSV7.COMPWSL INNER JOIN IMSV7.XWSL ON IMSV7.COMPWSL.COMPKEY = IMSV7.XWSL.COMPKEY CROSS JOIN IMSV7.COMPTYPE WHERE (IMSV7.COMPWSL.COMPKEY = 6526328) AND (IMSV7.COMPTYPE.COMPTYPE = 45)              
                sqlText = "SELECT    IMSV7.COMPWSL.COMPKEY AS 'Compkey',IMSV7.COMPWSL.ASBLT AS 'As-Built', IMSV7.COMPWSL.UNITTYPE AS 'Service Line Type', IMSV7.COMPWSL.UNITID AS 'UnitId', IMSV7.COMPWSL.PIPETYPE AS 'Material', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XWSL.RELMATL= IMSV7.TBL3034.CODE)  AS 'Reliability Material', IMSV7.COMPWSL.DIAM AS 'Diameter',  (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XWSL.RELDIA= IMSV7.TBL3034.CODE)  AS 'Reliability Diameter',ROUND(IMSV7.COMPWSL.PIPELEN,2) AS 'Length', IMSV7.COMPWSL.INSTDATE AS 'Installation Date', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XWSL.RELDATE= IMSV7.TBL3034.CODE)  AS 'Reliability Date', IMSV7.COMPWSL.SERVSTAT AS 'Status', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XWSL.RELSTATUS= IMSV7.TBL3034.CODE)  AS 'Reliability Status', IMSV7.COMPWSL.OWN AS 'Owner',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XWSL.RELOWN= IMSV7.TBL3034.CODE)  AS 'Reliability Owner', IMSV7.XWSL.HYDGRLN as 'Hydr grade line', IMSV7.XWSL.OLDID AS 'Old Id',IMSV7.XWSL.OLDCOMPKEY AS 'Old Compkey', IMSV7.XWSL.OLDOWNER AS 'Old Owner' FROM  IMSV7.COMPWSL LEFT OUTER JOIN IMSV7.XWSL ON IMSV7.COMPWSL.COMPKEY = IMSV7.XWSL.COMPKEY CROSS JOIN IMSV7.COMPTYPE WHERE (IMSV7.COMPWSL.COMPKEY = '" + compkey + "'AND IMSV7.COMPTYPE.COMPTYPE = " + comptype + ")"

                '"SELECT     IMSV7.COMPWSL.COMPKEY AS 'Compkey', IMSV7.COMPWSL.UNITID AS 'Unit Id', IMSV7.COMPWSL.AREA AS 'Area', IMSV7.COMPWSL.SUBAREA AS 'Sub Area', IMSV7.COMPWSL.DISTRICT AS 'District',IMSV7.COMPWSL.ASBLT AS 'As-Built', IMSV7.COMPWSL.UNITTYPE AS 'Unit Type', IMSV7.COMPWSL.PIPETYPE AS 'Pipe Type', IMSV7.COMPWSL.DIAM AS 'Diameter (mm)', ROUND(IMSV7.COMPWSL.PIPELEN,2) AS 'Pipe Length (M)', IMSV7.COMPWSL.INSTDATE AS 'Installation Date', IMSV7.COMPWSL.SERVSTAT AS 'Status', IMSV7.COMPWSL.OWN AS 'Owner', IMSV7.XWSL.HYDGRLN, IMSV7.XWSL.OLDID AS 'Old Id',IMSV7.XWSL.OLDCOMPKEY AS 'Old Compkey', IMSV7.XWSL.OLDOWNER AS 'Old Owner' FROM IMSV7.COMPWSL INNER JOIN IMSV7.XWSL ON IMSV7.COMPWSL.COMPKEY = IMSV7.XWSL.COMPKEY WHERE (IMSV7.COMPWSL.COMPKEY ='" + compkey + "')"
            ElseIf (comptype = 26) Then
                'Reliability RPLAN not found in Lookup table
                'sqlText = "SELECT  IMSV7.COMPSSL.COMPKEY AS 'Compkey', IMSV7.COMPSSL.ASBLT AS 'As-Built', IMSV7.COMPSSL.UNITTYPE AS 'Service Line Type', IMSV7.COMPSSL.UNITID AS 'UnitId', IMSV7.COMPSSL.PIPETYPE AS 'Material', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSSL.RELMATL= IMSV7.TBL3034.CODE)  AS 'Reliability Material', IMSV7.COMPSSL.DIAM AS 'Diameter', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSSL.RELDIA= IMSV7.TBL3034.CODE)  AS 'Reliability Diameter', IMSV7.COMPSSL.INSTDATE AS 'Installation Date', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSSL.RELDATE= IMSV7.TBL3034.CODE)  AS 'Reliability Date', IMSV7.COMPSSL.SERVSTAT AS 'Status', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSSL.RELSTATUS= IMSV7.TBL3034.CODE)  AS 'Reliability Status', IMSV7.COMPSSL.OWN AS 'Owner', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSSL.RELOWN= IMSV7.TBL3034.CODE)  AS 'Reliability Owner', IMSV7.COMPSSL.OWNCOND AS 'Owner Cond', IMSV7.COMPSSL.MUNICOND as 'Condition', IMSV7.XSSL.OLDID AS 'Old Id', IMSV7.XSSL.OLDCOMPKEY AS 'Old Compkey', IMSV7.XSSL.OLDOWNER AS 'Old Owner' FROM IMSV7.COMPSSL LEFT OUTER JOIN IMSV7.XSSL ON IMSV7.COMPSSL.COMPKEY = IMSV7.XSSL.COMPKEY  WHERE (IMSV7.COMPSSL.COMPKEY ='" + compkey + "')"
                sqlText = "SELECT  IMSV7.COMPSSL.COMPKEY AS 'Compkey', IMSV7.COMPSSL.ASBLT AS 'As-Built', IMSV7.COMPSSL.UNITTYPE AS 'Service Line Type', IMSV7.COMPSSL.UNITID AS 'UnitId', IMSV7.COMPSSL.PIPETYPE AS 'Material', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSSL.RELMATL= IMSV7.TBL3034.CODE)  AS 'Reliability Material', IMSV7.COMPSSL.DIAM AS 'Diameter', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSSL.RELDIA= IMSV7.TBL3034.CODE)  AS 'Reliability Diameter', IMSV7.COMPSSL.INSTDATE AS 'Installation Date', IMSV7.XSSL.RELDATE  AS 'Reliability Date', IMSV7.COMPSSL.SERVSTAT AS 'Status', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSSL.RELSTATUS= IMSV7.TBL3034.CODE)  AS 'Reliability Status', IMSV7.COMPSSL.OWN AS 'Owner', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSSL.RELOWN= IMSV7.TBL3034.CODE)  AS 'Reliability Owner', IMSV7.COMPSSL.OWNCOND AS 'Owner Cond', IMSV7.COMPSSL.MUNICOND as 'Condition', IMSV7.XSSL.OLDID AS 'Old Id', IMSV7.XSSL.OLDCOMPKEY AS 'Old Compkey', IMSV7.XSSL.OLDOWNER AS 'Old Owner', IMSV7.XSSL.LINDATE AS 'Lining Date',  IMSV7.XSSL.LINING AS 'Lining type' FROM IMSV7.COMPSSL LEFT OUTER JOIN IMSV7.XSSL ON IMSV7.COMPSSL.COMPKEY = IMSV7.XSSL.COMPKEY  WHERE (IMSV7.COMPSSL.COMPKEY ='" + compkey + "')"
                'Reliability RPLAN not found in Lookup table

            ElseIf (comptype = 46) Then
                sqlText = "SELECT  IMSV7.COMPWV.COMPKEY AS 'Compkey', IMSV7.COMPWV.ASBLT AS 'As-Built', IMSV7.COMPWV.UNITTYPE AS 'Valve Type', IMSV7.COMPWV.UNITID AS 'UnitId', IMSV7.COMPWV.VALVESTAT as 'Valve Status', IMSV7.COMPWV.VALVESZ as 'Valve Size', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XWV.RELDIA= IMSV7.TBL3034.CODE)  AS 'Reliability Size', IMSV7.COMPWV.INSTDATE AS 'Installation Date', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XWV.RELDATE= IMSV7.TBL3034.CODE)  AS 'Reliability Date', IMSV7.COMPWV.SERVSTAT AS 'Status', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XWV.RELSTATUS= IMSV7.TBL3034.CODE)  AS 'Reliability Status', IMSV7.COMPWV.OWN AS 'Owner', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XWV.RELOWN= IMSV7.TBL3034.CODE)  AS 'Reliability Owner',IMSV7.XWV.OLDID AS 'Old Id', IMSV7.XWV.OLDCOMPKEY AS 'Old Compkey', IMSV7.XWV.OLDOWNER AS 'Old Owner' FROM IMSV7.COMPWV LEFT OUTER JOIN IMSV7.XWV ON IMSV7.COMPWV.COMPKEY = IMSV7.XWV.COMPKEY WHERE (IMSV7.COMPWV.COMPKEY ='" + compkey + "')"

            ElseIf (comptype = 12) Then
                sqlText = "SELECT     IMSV7.COMPHY.COMPKEY AS 'Compkey', IMSV7.COMPHY.ASBLT AS 'As-Built', IMSV7.COMPHY.UNITTYPE AS 'Hydrant Type', IMSV7.COMPHY.UNITID AS 'UnitId', IMSV7.COMPHY.BARRELSIZE as 'Barrel Size',IMSV7.COMPHY.INSTDATE AS 'Installation Date', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XHY.RELDATE= IMSV7.TBL3034.CODE)  AS 'Reliability Date', IMSV7.COMPHY.SERVSTAT AS 'Status',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XHY.RELSTATUS= IMSV7.TBL3034.CODE)  AS 'Reliability Status', IMSV7.COMPHY.OWN AS 'Owner',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XHY.RELOWN= IMSV7.TBL3034.CODE)  AS 'Reliability Owner', IMSV7.XHY.HYDGRLN as 'Hydr grade line', IMSV7.XHY.OLDID AS 'Old Id', IMSV7.XHY.OLDCOMPKEY AS 'Old Compkey', IMSV7.XHY.OLDOWNER AS 'Old Owner' FROM IMSV7.COMPHY LEFT OUTER JOIN IMSV7.XHY ON IMSV7.COMPHY.COMPKEY = IMSV7.XHY.COMPKEY WHERE (IMSV7.COMPHY.COMPKEY ='" + compkey + "')"

            ElseIf (comptype = 43) Then
                sqlText = "SELECT IMSV7.COMPWND.COMPKEY AS 'Compkey', IMSV7.COMPWND.ASBLT AS 'As-Built', IMSV7.COMPWND.UNITTYPE AS 'Node Type', IMSV7.COMPWND.UNITID AS 'UnitId', IMSV7.COMPWND.INSTDATE AS 'Installation Date', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XWND.RELDATE= IMSV7.TBL3034.CODE)  AS 'Reliability Date', IMSV7.COMPWND.SERVSTAT AS 'Status', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XWND.RELSTATUS= IMSV7.TBL3034.CODE)  AS 'Reliability Status',  IMSV7.COMPWND.OWN AS 'Owner', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XWND.RELOWN= IMSV7.TBL3034.CODE)  AS 'Reliability Owner',  IMSV7.XWND.OLDID AS 'Old Id', IMSV7.XWND.OLDCOMPKEY AS 'Old Compkey', IMSV7.XWND.OLDOWNER AS 'Old Owner' FROM IMSV7.COMPWND LEFT OUTER JOIN IMSV7.XWND ON IMSV7.COMPWND.COMPKEY = IMSV7.XWND.COMPKEY WHERE (IMSV7.COMPWND.COMPKEY ='" + compkey + "')"
                'multilayerUpgrade
            ElseIf (comptype = 4) Then
                sqlText = "SELECT IMSV7.COMPFAC.COMPKEY AS 'Compkey', IMSV7.COMPFAC.ASBLT AS 'As-Built', IMSV7.COMPFAC.UNITTYPE AS 'Storage Type', IMSV7.COMPFAC.UNITID AS 'UnitId', IMSV7.COMPFAC.INSTDATE AS 'Installation Date', IMSV7.COMPFAC.SERVSTAT AS 'Status', IMSV7.COMPFAC.OWN AS 'Owner', IMSV7.COMPFAC.FACDESC  as 'Description', IMSV7.XWSU.OLDID AS 'Old Id', IMSV7.XWSU.OLDCOMPKEY AS 'Old Compkey', IMSV7.XWSU.OLDOWNER AS 'Old Owner' FROM IMSV7.COMPFAC LEFT OUTER JOIN IMSV7.XWSU ON IMSV7.COMPFAC.COMPKEY = IMSV7.XWSU.COMPKEY WHERE (IMSV7.COMPFAC.COMPKEY='" + compkey + "')"
                'IMSV7.COMPFAC.DPTH as 'Depth', 
            ElseIf (comptype = 42) Then
                'New Netview
                'sqlText = "SELECT IMSV7.COMPWMTR.COMPKEY AS 'Compkey', IMSV7.COMPWMTR.UNITID AS 'Meter #', IMSV7.COMPWMTR.ASBLT AS 'As-Built', IMSV7.COMPWMTR.UNITTYPE AS 'Storage Type',   IMSV7.COMPWMTR.INSTDATE AS 'Installation Date', IMSV7.COMPWMTR.SERVSTAT AS 'Status', IMSV7.COMPWMTR.OWN AS 'Owner', IMSV7.XWSU.OLDID AS 'Old Id', IMSV7.XWSU.OLDCOMPKEY AS 'Old Compkey', IMSV7.XWSU.OLDOWNER AS 'Old Owner' FROM IMSV7.COMPWMTR LEFT OUTER JOIN IMSV7.XWSU ON IMSV7.COMPWMTR.COMPKEY = IMSV7.XWSU.COMPKEY WHERE (IMSV7.COMPWMTR.COMPKEY='" + compkey + "')"
                sqlText = "SELECT IMSV7.COMPWMTR.COMPKEY AS 'Compkey', IMSV7.COMPWMTR.UNITID AS 'Meter #', IMSV7.COMPWMTR.ASBLT AS 'As-Built', IMSV7.COMPWMTR.UNITTYPE AS 'Meter Type',   IMSV7.COMPWMTR.INSTDATE AS 'Installation Date', IMSV7.COMPWMTR.SERVSTAT AS 'Status', IMSV7.COMPWMTR.OWN AS 'Owner', IMSV7.XWSU.OLDID AS 'Old Id', IMSV7.XWSU.OLDCOMPKEY AS 'Old Compkey', IMSV7.XWSU.OLDOWNER AS 'Old Owner', COMPWMTR.ADDRQUAL as 'Address Qualifier' FROM IMSV7.COMPWMTR LEFT OUTER JOIN IMSV7.XWSU ON IMSV7.COMPWMTR.COMPKEY = IMSV7.XWSU.COMPKEY WHERE (IMSV7.COMPWMTR.COMPKEY='" + compkey + "')"
                'New Netview end
            ElseIf (comptype = 67) Then
                sqlText = "SELECT IMSV7.COMPWSU.COMPKEY AS 'Compkey', IMSV7.COMPWSU.ASBLT AS 'As-Built', IMSV7.COMPWSU.UNITTYPE AS 'Storage Type', IMSV7.COMPWSU.UNITID AS 'UnitId', IMSV7.COMPWSU.DPTH as 'Depth', IMSV7.COMPWSU.INSTDATE AS 'Installation Date', IMSV7.COMPWSU.SERVSTAT AS 'Status', IMSV7.COMPWSU.OWN AS 'Owner', IMSV7.COMPWSU.SUDESC as 'Description', IMSV7.XWSU.OLDID AS 'Old Id', IMSV7.XWSU.OLDCOMPKEY AS 'Old Compkey', IMSV7.XWSU.OLDOWNER AS 'Old Owner' FROM IMSV7.COMPWSU LEFT OUTER JOIN IMSV7.XWSU ON IMSV7.COMPWSU.COMPKEY = IMSV7.XWSU.COMPKEY WHERE (IMSV7.COMPWSU.COMPKEY ='" + compkey + "')"

            ElseIf (comptype = 99) Then
                sqlText = "SELECT IMSV7.COMPWPL.COMPKEY AS 'Compkey', IMSV7.COMPWPL.ASBLT AS 'As-Built', IMSV7.COMPWPL.UNITTYPE AS 'Plant Type', IMSV7.COMPWPL.UNITID AS 'UnitId', IMSV7.COMPWPL.INSTDATE AS 'Installation Date', IMSV7.COMPWPL.OWN AS 'Owner' FROM IMSV7.COMPWPL  WHERE (IMSV7.COMPWPL.COMPKEY ='" + compkey + "')"
                'New netview
                'http://wsldctvgpw/GISApps/AMS/hansen.aspx?compkey=7109581&comptype=Pump
                'http://gisweb/GISApps/GIS/gisidout.aspx?gisid=1568807&Vtype=1
            ElseIf (comptype = 44) Then
                sqlText = "Select IMSV7.COMPWP.COMPKEY As 'Compkey', IMSV7.COMPWP.ASBLT AS 'As-Built', IMSV7.COMPWP.UNITTYPE AS 'Plant Type', IMSV7.COMPWP.UNITID AS 'UnitId', IMSV7.COMPWP.INSTDATE AS 'Installation Date', IMSV7.COMPWP.OWN AS 'Owner'  From [HansenReporting].[IMSV7].[COMPWP] Where (IMSV7.[COMPWP].COMPKEY ='" + compkey + "')"
                'New netview end
            ElseIf (comptype = 35) Then
                sqlText = "SELECT  IMSV7.COMPSV.COMPKEY AS 'Compkey', IMSV7.COMPSV.ASBLT AS 'As-Built', IMSV7.COMPSV.UNITTYPE AS 'Valve Type', IMSV7.COMPSV.UNITID AS 'UnitId',  IMSV7.COMPSV.INSTDATE AS 'Installation Date', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSV.RELDATE= IMSV7.TBL3034.CODE)  AS 'Reliability Date',  IMSV7.COMPSV.SERVSTAT AS 'Status',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSV.RELSTATUS= IMSV7.TBL3034.CODE)  AS 'Reliability Status', IMSV7.COMPSV.OWN AS 'Owner',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSV.RELOWN= IMSV7.TBL3034.CODE)  AS 'Reliability Owner', IMSV7.XSV.OLDID AS 'Old Id', IMSV7.XSV.OLDCOMPKEY AS 'Old Compkey', IMSV7.XSV.OLDOWNER AS 'Old Owner' FROM IMSV7.COMPSV LEFT OUTER JOIN IMSV7.XSV ON IMSV7.COMPSV.COMPKEY = IMSV7.XSV.COMPKEY  WHERE (IMSV7.COMPSV.COMPKEY ='" + compkey + "')"

            ElseIf (comptype = 24) Then
                sqlText = "SELECT  IMSV7.COMPSND.COMPKEY AS 'Compkey', IMSV7.COMPSND.ASBLT AS 'As-Built', IMSV7.COMPSND.UNITTYPE AS 'Node Type', IMSV7.COMPSND.UNITID AS 'UnitId', IMSV7.COMPSND.INSTDATE AS 'Installation Date',  (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSND.RELDATE= IMSV7.TBL3034.CODE)  AS 'Reliability Date', IMSV7.COMPSND.SERVSTAT AS 'Status', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSND.RELSTATUS= IMSV7.TBL3034.CODE)  AS 'Reliability Status',  IMSV7.COMPSND.OWN AS 'Owner', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSND.RELOWN= IMSV7.TBL3034.CODE)  AS 'Reliability Owner', IMSV7.XSND.OLDID AS 'Old Id', IMSV7.XSND.OLDCOMPKEY AS 'Old Compkey', IMSV7.XSND.OLDOWNER AS 'Old Owner' FROM IMSV7.COMPSND LEFT OUTER JOIN IMSV7.XSND ON IMSV7.COMPSND.COMPKEY = IMSV7.XSND.COMPKEY  WHERE (IMSV7.COMPSND.COMPKEY ='" + compkey + "')"

            ElseIf (comptype = 22) Then
                sqlText = "SELECT IMSV7.COMPSMH.COMPKEY AS 'Compkey', IMSV7.COMPSMH.ASBLT AS 'As-Built', IMSV7.COMPSMH.UNITTYPE AS 'Manhole Type',  IMSV7.COMPSMH.UNITID AS 'UnitId',  IMSV7.COMPSMH.BARLDIAM as 'Lid Width/Dia', IMSV7.COMPSMH.DROPMH as 'Drop MH',IMSV7.COMPSMH.INSTDATE AS 'Installation Date',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMH.RELDATE= IMSV7.TBL3034.CODE)  AS 'Reliability Date', IMSV7.COMPSMH.SERVSTAT AS 'Status',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMH.RELSTATUS= IMSV7.TBL3034.CODE)  AS 'Reliability Status', IMSV7.COMPSMH.OWN AS 'Owner', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMH.RELOWN= IMSV7.TBL3034.CODE)  AS 'Reliability Owner',IMSV7.XSMH.OLDID AS 'Old Id', IMSV7.XSMH.OLDCOMPKEY AS 'Old Compkey', IMSV7.XSMH.OLDOWNER AS 'Old Owner' FROM IMSV7.COMPSMH LEFT OUTER JOIN IMSV7.XSMH ON IMSV7.COMPSMH.COMPKEY = IMSV7.XSMH.COMPKEY  WHERE (IMSV7.COMPSMH.COMPKEY ='" + compkey + "')"

            ElseIf (comptype = 15) Then
                sqlText = "SELECT  IMSV7.COMPLS.COMPKEY AS 'Compkey', IMSV7.COMPLS.ASBLT AS 'As-Built', IMSV7.COMPLS.UNITTYPE AS 'Pump Station Type',  IMSV7.COMPLS.UNITID AS 'UnitId', IMSV7.COMPLS.INSTDATE AS 'Installation Date', IMSV7.COMPLS.SERVSTAT AS 'Status', IMSV7.COMPLS.OWN AS 'Owner',IMSV7.XLS.OLDID AS 'Old Id', IMSV7.XLS.OLDCOMPKEY AS 'Old Compkey',IMSV7.XLS.OLDOWNER AS 'Old Owner' FROM IMSV7.COMPLS LEFT OUTER JOIN IMSV7.XLS ON IMSV7.COMPLS.COMPKEY = IMSV7.XLS.COMPKEY  WHERE (IMSV7.COMPLS.COMPKEY ='" + compkey + "')"

            ElseIf (comptype = 69) Then
                sqlText = "SELECT  IMSV7.COMPSMS.COMPKEY AS 'Compkey', IMSV7.COMPSMS.ASBLT AS 'As-Built', IMSV7.COMPSMS.UNITTYPE AS 'Misc. Type', IMSV7.COMPSMS.UNITID AS 'UnitId', IMSV7.COMPSMS.DIAM AS 'Diameter', IMSV7.COMPSMS.MATL as 'Material', IMSV7.COMPSMS.COND as 'Condition', IMSV7.COMPSMS.INSTDATE AS 'Installation Date', IMSV7.COMPSMS.SERVSTAT AS 'Status', IMSV7.COMPSMS.OWN AS 'Owner', IMSV7.XSMS.OLDID AS 'Old Id', IMSV7.XSMS.OLDCOMPKEY AS 'Old Compkey',IMSV7.XSMS.OLDOWNER AS 'Old Owner' FROM IMSV7.COMPSMS LEFT OUTER JOIN IMSV7.XSMS ON IMSV7.COMPSMS.COMPKEY = IMSV7.XSMS.COMPKEY  WHERE (IMSV7.COMPSMS.COMPKEY ='" + compkey + "')"

            ElseIf (comptype = 70) Then
                sqlText = "SELECT     IMSV7.COMPWMS.COMPKEY AS 'Compkey', IMSV7.COMPWMS.ASBLT AS 'As-Built', IMSV7.COMPWMS.UNITTYPE AS 'Misc Type', IMSV7.COMPWMS.UNITID AS 'UnitId', IMSV7.COMPWMS.DIAM as 'Diameter',IMSV7.COMPWMS.INSTDATE AS 'Installation Date', IMSV7.COMPWMS.SERVSTAT AS 'Status', IMSV7.COMPWMS.OWN AS 'Owner', IMSV7.XWMS.OLDID AS 'Old Id', IMSV7.XWMS.OLDCOMPKEY AS 'Old Compkey', IMSV7.XWMS.OLDOWNER AS 'Old Owner' FROM IMSV7.COMPWMS LEFT OUTER JOIN IMSV7.XWMS ON IMSV7.COMPWMS.COMPKEY = IMSV7.XWMS.COMPKEY WHERE (IMSV7.COMPWMS.COMPKEY ='" + compkey + "')"

            ElseIf (comptype = 98) Then
                sqlText = "SELECT  IMSV7.COMPSPL.COMPKEY AS 'Compkey', IMSV7.COMPSPL.ASBLT AS 'As-Built', IMSV7.COMPSPL.UNITTYPE AS 'Plant Type', IMSV7.COMPSPL.UNITID AS 'UnitId', IMSV7.COMPSPL.INSTDATE AS 'Installation Date', IMSV7.COMPSPL.SERVSTAT AS 'Status', IMSV7.COMPSPL.OWN AS 'Owner',IMSV7.XSPL.OLDID AS 'Old Id', IMSV7.XSPL.OLDCOMPKEY AS 'Old Compkey',IMSV7.XSPL.OLDOWNER AS 'Old Owner' FROM IMSV7.COMPSPL LEFT OUTER JOIN IMSV7.XSPL ON IMSV7.COMPSPL.COMPKEY = IMSV7.XSPL.COMPKEY  WHERE (IMSV7.COMPSPL.COMPKEY ='" + compkey + "')"

            Else
                'do nothing
            End If

            'Response.Write(comptype)
            'Response.Write(sqlText)

            Dim vSrvrName As String = ""
            Dim vPsswrd As String = ""
            'Call getDbVals(vSrvrName, vPsswrd)

            'arrayResult = execDbFetch(vSrvrName, vPsswrd, "HansenReporting", sqlText, vFldNames)

            'If no records returned for the given request, display no record found message
            If (arrayResult Is Nothing) Then
                If comptypeTemp <> "-1" Then
                    comptype = comptypeTemp
                    If comptype = 21 Then
                        'Reliability RPLAN not found in Lookup table
                        'sqlText = "SELECT IMSV7.COMPSMN.COMPKEY AS 'Compkey',  IMSV7.COMPSMN.ASBLT AS 'As-Built', IMSV7.COMPSMN.UNITTYPE AS 'Main Line Type', IMSV7.COMPSMN.UNITID AS 'UnitId', IMSV7.COMPSMN.UNITID2 AS 'UnitId2', IMSV7.COMPSMN.PIPETYPE AS 'Material', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELMATL= IMSV7.TBL3034.CODE)  AS 'Reliability Material', IMSV7.COMPSMN.PIPEDIAM AS 'Diameter',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELDIA= IMSV7.TBL3034.CODE)  AS 'Reliability Diameter', IMSV7.COMPSMN.INSTDATE AS 'Installation Date',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELDATE= IMSV7.TBL3034.CODE)  AS 'Reliability Date', IMSV7.COMPSMN.SERVSTAT AS 'Status',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELSTATUS= IMSV7.TBL3034.CODE)  AS 'Reliability Status', IMSV7.COMPSMN.OWN AS 'Owner',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELOWN= IMSV7.TBL3034.CODE)  AS 'Reliability Owner', IMSV7.XSMN.OLDID AS 'Old Id', IMSV7.XSMN.OLDCOMPKEY AS 'Old Compkey', IMSV7.XSMN.OLDOWNER AS 'Old Owner', IMSV7.XSMN.LINDATE AS 'Lining Date', IMSV7.XSMN.LINING as 'Lining type' FROM IMSV7.COMPSMN LEFT OUTER JOIN IMSV7.XSMN ON IMSV7.COMPSMN.COMPKEY = IMSV7.XSMN.COMPKEY INNER JOIN IMSV7.COMPTYPE ON IMSV7.COMPSMN.MAINCOMP1 = IMSV7.COMPTYPE.COMPTYPE INNER JOIN  IMSV7.COMPTYPE AS COMPTYPE_1 ON IMSV7.COMPSMN.MAINCOMP2 = COMPTYPE_1.COMPTYPE WHERE (IMSV7.COMPSMN.COMPKEY = '" + compkey + "')"
                        sqlText = "SELECT IMSV7.COMPSMN.COMPKEY AS 'Compkey',  IMSV7.COMPSMN.ASBLT AS 'As-Built', IMSV7.COMPSMN.UNITTYPE AS 'Main Line Type', IMSV7.COMPSMN.UNITID AS 'UnitId', IMSV7.COMPSMN.UNITID2 AS 'UnitId2', IMSV7.COMPSMN.PIPETYPE AS 'Material', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELMATL= IMSV7.TBL3034.CODE)  AS 'Reliability Material', IMSV7.COMPSMN.PIPEDIAM AS 'Diameter',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELDIA= IMSV7.TBL3034.CODE)  AS 'Reliability Diameter', IMSV7.COMPSMN.INSTDATE AS 'Installation Date', IMSV7.XSMN.RELDATE  AS 'Reliability Date', IMSV7.COMPSMN.SERVSTAT AS 'Status',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELSTATUS= IMSV7.TBL3034.CODE)  AS 'Reliability Status', IMSV7.COMPSMN.OWN AS 'Owner',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSMN.RELOWN= IMSV7.TBL3034.CODE)  AS 'Reliability Owner', IMSV7.XSMN.OLDID AS 'Old Id', IMSV7.XSMN.OLDCOMPKEY AS 'Old Compkey', IMSV7.XSMN.OLDOWNER AS 'Old Owner', IMSV7.XSMN.LINDATE AS 'Lining Date', IMSV7.XSMN.LINING as 'Lining type' FROM IMSV7.COMPSMN LEFT OUTER JOIN IMSV7.XSMN ON IMSV7.COMPSMN.COMPKEY = IMSV7.XSMN.COMPKEY INNER JOIN IMSV7.COMPTYPE ON IMSV7.COMPSMN.MAINCOMP1 = IMSV7.COMPTYPE.COMPTYPE INNER JOIN  IMSV7.COMPTYPE AS COMPTYPE_1 ON IMSV7.COMPSMN.MAINCOMP2 = COMPTYPE_1.COMPTYPE WHERE (IMSV7.COMPSMN.COMPKEY = '" + compkey + "')"
                        'Reliability RPLAN not found in Lookup table end
                    ElseIf (comptype = 24) Then
                        sqlText = "SELECT  IMSV7.COMPSND.COMPKEY AS 'Compkey', IMSV7.COMPSND.ASBLT AS 'As-Built', IMSV7.COMPSND.UNITTYPE AS 'Node Type', IMSV7.COMPSND.UNITID AS 'UnitId', IMSV7.COMPSND.INSTDATE AS 'Installation Date',  (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSND.RELDATE= IMSV7.TBL3034.CODE)  AS 'Reliability Date', IMSV7.COMPSND.SERVSTAT AS 'Status', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSND.RELSTATUS= IMSV7.TBL3034.CODE)  AS 'Reliability Status',  IMSV7.COMPSND.OWN AS 'Owner', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSND.RELOWN= IMSV7.TBL3034.CODE)  AS 'Reliability Owner', IMSV7.XSND.OLDID AS 'Old Id', IMSV7.XSND.OLDCOMPKEY AS 'Old Compkey', IMSV7.XSND.OLDOWNER AS 'Old Owner' FROM IMSV7.COMPSND LEFT OUTER JOIN IMSV7.XSND ON IMSV7.COMPSND.COMPKEY = IMSV7.XSND.COMPKEY  WHERE (IMSV7.COMPSND.COMPKEY ='" + compkey + "')"

                    ElseIf (comptype = 35) Then
                        sqlText = "SELECT  IMSV7.COMPSV.COMPKEY AS 'Compkey', IMSV7.COMPSV.ASBLT AS 'As-Built', IMSV7.COMPSV.UNITTYPE AS 'Valve Type', IMSV7.COMPSV.UNITID AS 'UnitId', IMSV7.COMPSV.INSTDATE AS 'Installation Date', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSV.RELDATE= IMSV7.TBL3034.CODE)  AS 'Reliability Date',  IMSV7.COMPSV.SERVSTAT AS 'Status',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSV.RELSTATUS= IMSV7.TBL3034.CODE)  AS 'Reliability Status', IMSV7.COMPSV.OWN AS 'Owner',(SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSV.RELOWN= IMSV7.TBL3034.CODE)  AS 'Reliability Owner', IMSV7.XSV.OLDID AS 'Old Id', IMSV7.XSV.OLDCOMPKEY AS 'Old Compkey', IMSV7.XSV.OLDOWNER AS 'Old Owner' FROM IMSV7.COMPSV LEFT OUTER JOIN IMSV7.XSV ON IMSV7.COMPSV.COMPKEY = IMSV7.XSV.COMPKEY  WHERE (IMSV7.COMPSV.COMPKEY ='" + compkey + "')"

                    ElseIf (comptype = 26) Then
                        sqlText = "SELECT  IMSV7.COMPSSL.COMPKEY AS 'Compkey', IMSV7.COMPSSL.ASBLT AS 'As-Built', IMSV7.COMPSSL.UNITTYPE AS 'Service Line Type', IMSV7.COMPSSL.UNITID AS 'UnitId', IMSV7.COMPSSL.PIPETYPE AS 'Material', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSSL.RELMATL= IMSV7.TBL3034.CODE)  AS 'Reliability Material', IMSV7.COMPSSL.DIAM AS 'Diameter', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSSL.RELDIA= IMSV7.TBL3034.CODE)  AS 'Reliability Diameter', IMSV7.COMPSSL.INSTDATE AS 'Installation Date', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSSL.RELDATE= IMSV7.TBL3034.CODE)  AS 'Reliability Date', IMSV7.COMPSSL.SERVSTAT AS 'Status', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSSL.RELSTATUS= IMSV7.TBL3034.CODE)  AS 'Reliability Status', IMSV7.COMPSSL.OWN AS 'Owner', (SELECT IMSV7.TBL3034.DESCRIPT FROM IMSV7.TBL3034 WHERE  IMSV7.XSSL.RELOWN= IMSV7.TBL3034.CODE)  AS 'Reliability Owner', IMSV7.COMPSSL.OWNCOND AS 'Owner Cond', IMSV7.COMPSSL.MUNICOND as 'Condition', IMSV7.XSSL.OLDID AS 'Old Id', IMSV7.XSSL.OLDCOMPKEY AS 'Old Compkey', IMSV7.XSSL.OLDOWNER AS 'Old Owner', IMSV7.XSSL.LINDATE AS 'Lining Date',  IMSV7.XSSL.LINING AS 'Lining type' FROM IMSV7.COMPSSL LEFT OUTER JOIN IMSV7.XSSL ON IMSV7.COMPSSL.COMPKEY = IMSV7.XSSL.COMPKEY  WHERE (IMSV7.COMPSSL.COMPKEY ='" + compkey + "')"

                    ElseIf (comptype = 70) Then
                        sqlText = "SELECT     IMSV7.COMPWMS.COMPKEY AS 'Compkey', IMSV7.COMPWMS.ASBLT AS 'As-Built', IMSV7.COMPWMS.UNITTYPE AS 'Misc Type', IMSV7.COMPWMS.UNITID AS 'UnitId1', IMSV7.COMPWMS.DIAM as 'Diameter',IMSV7.COMPWMS.INSTDATE AS 'Installation Date', IMSV7.COMPWMS.SERVSTAT AS 'Status', IMSV7.COMPWMS.OWN AS 'Owner', IMSV7.XWMS.OLDID AS 'Old Id', IMSV7.XWMS.OLDCOMPKEY AS 'Old Compkey', IMSV7.XWMS.OLDOWNER AS 'Old Owner' FROM IMSV7.COMPWMS LEFT OUTER JOIN IMSV7.XWMS ON IMSV7.COMPWMS.COMPKEY = IMSV7.XWMS.COMPKEY WHERE (IMSV7.COMPWMS.COMPKEY ='" + compkey + "')"
                    End If
                    'arrayResult = execDbFetch(vSrvrName, vPsswrd, "HansenReporting", sqlText, vFldNames)

                    If (arrayResult Is Nothing) Then
                        If (compkey = 0) Then
                            Response.Write("<tr><td colspan='3'><span class='errTxt'><br/><br/><br/>Asset not in Hansen,<br /> Please contact <a href=mailto:GISServices@water.co.nz>GISServices</a> for more information <br/><br/><br/><br/><br/><br/></span></td></tr>")
                        ElseIf (compkey = 2) Then
                            Response.Write("<tr><td colspan='3'><span class='errTxt'><br/><br/><br/>Asset transferred to SAP,<br /> Please click Equipment Id in Netview for more information <br/><br/><br/><br/><br/><br/></span></td></tr>")
                        Else
                            Response.Write("<tr><td>No records found, please try again...</td><td></td><td></td></tr>")
                        End If
                    Else
                        'arrayResult = objRst.GetRows
                        'Dim strT
                        'strT = ""
                        'Dim fldf

                        'For Each fldf In objRst.Fields
                        '    strT = strT & fldf.Name & ","
                        'Next
                        'arrayHdr = Split(strT, ",")
                        arrayHdr = Split(vFldNames, ",")

                        Call printTable(arrayHdr, arrayResult, comptype)
                    End If

                Else
                    '20140123
                    'Response.Write("<tr><td colspan='3'><span class='errTxt'>Click here</span></td></tr>")
                    If (compkey = 0) Then
                        Response.Write("<tr><td colspan='3'><span class='errTxt'><br/><br/><br/>Asset not in Hansen,<br /> Please contact <a href=mailto:GISServices@water.co.nz>GISServices</a> for more information <br/><br/><br/><br/><br/><br/></span></td></tr>")
                    ElseIf (compkey = 2) Then
                        Response.Write("<tr><td colspan='3'><span class='errTxt'><br/><br/><br/>Asset transferred to SAP,<br /> Please click Equipment Id in Netview for more information<br/><br/><br/><br/><br/><br/></span></td></tr>")
                    ElseIf (compkey = 3) Then
                        Response.Write("<tr><td colspan='3'><span class='errTxt'><br/><br/><br/>Asset is still in SAP,<br /> Please click Equipment Id in Netview for more information<br/><br/><br/><br/><br/><br/></span></td></tr>")
                    Else
                        Response.Write("<tr><td>No records found, please try again...</td><td></td><td></td></tr>")
                    End If
                    'Response.Write("<tr><td>No records found, please try again...</td><td></td><td></td></tr>")
                    '20140123                            
                End If

            Else
                'arrayResult = objRst.GetRows
                'Dim strT
                'strT = ""
                'Dim fldf

                'For Each fldf In objRst.Fields
                '    strT = strT & fldf.Name & ","
                'Next
                'arrayHdr = Split(strT, ",")
                arrayHdr = Split(vFldNames, ",")

                Call printTable(arrayHdr, arrayResult, comptype)
            End If
        End If

    End Sub

    Function execSpFetch(ByVal inSrvrName As String, ByVal inPsswrd As String, ByVal inDbName As String, ByVal inTbl As String, ByVal inValue As String) As DataTable
        execSpFetch = Nothing
        Dim vSqlConn As SqlConnection
        Dim vSqlAdptr As SqlDataAdapter
        Dim vCommnd As New SqlCommand
        vSqlConn = Nothing
        vSqlAdptr = Nothing
        vCommnd = Nothing
        Try
            Dim vSqlTxt As String = "Data Source={0};User ID=gisweb;Password={1};Initial Catalog={2}"
            vSqlTxt = String.Format(vSqlTxt, inSrvrName, inPsswrd, inDbName)
            vSqlConn = New SqlConnection(vSqlTxt)

            vSqlConn.Open()
            vCommnd = New SqlCommand("GISWSL.buildSQLfGisId", vSqlConn)
            vCommnd.CommandType = CommandType.StoredProcedure
            vCommnd.Parameters.Add(New SqlParameter("@inTable", SqlDbType.VarChar, 40)).Value = inTbl
            vCommnd.Parameters.Add(New SqlParameter("@inGISIdValue", SqlDbType.Int, 10)).Value = inValue
            vCommnd.ExecuteNonQuery()

            Dim vDtTable As DataTable = New DataTable()
            vSqlAdptr = New SqlDataAdapter(vCommnd)
            vSqlAdptr.Fill(vDtTable)
            execSpFetch = vDtTable
        Catch ex As Exception
            Response.Write(ex.Message.ToString())
        Finally
            If (Not (vSqlAdptr Is Nothing)) Then
                vSqlAdptr.Dispose()
                vSqlAdptr = Nothing
            End If
            If (Not (vCommnd Is Nothing)) Then
                vCommnd.Dispose()
                vCommnd = Nothing
            End If
            If (Not (vSqlConn Is Nothing)) Then
                vSqlConn.Close()
                vSqlConn = Nothing
            End If

        End Try
    End Function
    Function buildUrlsFGisId(ByVal inGISId As String, ByVal inStatus As String, ByVal infClass As String) As Boolean
        buildUrlsFGisId = True

        Dim vSrvrName As String = ""
        Dim vPsswrd As String = ""
        'getDbVals(vSrvrName, vPsswrd)

        Dim vSqlText As String

        Dim vDtTable As DataTable
        vDtTable = execSpFetch(vSrvrName, vPsswrd, "GISAdmin", infClass, inGISId)

        Dim vCompKey, vEquipId, vCompType, vDMSLnk, vPhtLnk, vAcctNo, vMeterNo, vConsentNo As String

        If vDtTable.Rows.Count > 0 Then
            '    If vGlobalArrRecs.GetLength(1) > 0 Then
            'CompKey 
            If IsDBNull(vDtTable.Rows(0)(1)) Then
                vCompKey = ""
            Else
                vCompKey = vDtTable.Rows(0)(1)
            End If
            If IsDBNull(vDtTable.Rows(0)(2)) Then
                vEquipId = ""
            Else
                vEquipId = vDtTable.Rows(0)(2)
            End If

            'Dim vIntKey As Integer
            'If (Not (vCompKey = "") And Not (vEquipId = "")) Then
            '    vIntKey = vCompKey
            '    If (vIntKey < 10) Then
            '        vCompKey = ""
            '    End If
            'ElseIf (Not (vCompKey = "")) Then
            '    vIntKey = vCompKey
            '    If (vIntKey < 10) Then
            '        Label1.Text = String.Format("CompKey : {0} [Asset details not available]", vCompKey)
            '        vCompKey = ""
            '    End If
            'ElseIf (Not (vEquipId = "")) Then
            '    vIntKey = vEquipId
            '    If (vIntKey < 10) Then
            '        Label1.Text = String.Format("Equipment Id : {0} [Asset details not available]", vEquipId)
            '        vEquipId = ""
            '    End If
            'End If

            'To be added
            If (vEquipId.Length() = 1) And (vCompKey.Length() > 1) Then
                vEquipId = ""
            End If
            If (vEquipId.Length() > 1) And (vCompKey.Length() = 1) Then
                vCompKey = ""
            End If
            If (vEquipId.Length() = 0) And (vCompKey.Length() = 0) Then
                Label1.Text = String.Format("Equipment Id : {0} [Asset details not available]", vEquipId)
                vEquipId = ""
                vCompKey = ""
            End If
            'eg for gisid=2597141
            If (vEquipId.Length() = 1) And (vCompKey.Length() = 1) Then
                vEquipId = ""
                vCompKey = ""
            End If
            'eg for gisid=2597141 end
            vCompKey = vCompKey.Trim()
            vEquipId = vEquipId.Trim()

            If (Not (vCompKey = "")) Then
                'vGlobalHeaderTxt = String.Format("Details of CompKey :{0}", vCompKey)
                Label1.Text = String.Format("Compkey : {0}", vCompKey)
            End If
            If (Not (vEquipId = "")) Then
                'vGlobalHeaderTxt = String.Format("Details of Equipment Id :{0}", vEquipId)
                Label1.Text = String.Format("Equipment Id : {0}", vEquipId)
            End If


            If ((IsDBNull(vDtTable.Rows(0)(3))) Or (vDtTable.Rows(0)(3).ToString() = "")) Then
                vCompType = ""
            Else
                vCompType = vDtTable.Rows(0)(3)
            End If
            vCompType = vCompType.Trim()
            If ((IsDBNull(vDtTable.Rows(0)(4))) Or (vDtTable.Rows(0)(4).ToString().Trim() = "")) Then
                vDMSLnk = ""
            Else
                vDMSLnk = vDtTable.Rows(0)(4)
            End If
            vDMSLnk = vDMSLnk.Trim()
            If ((IsDBNull(vDtTable.Rows(0)(5))) Or (vDtTable.Rows(0)(5).ToString().Trim() = "")) Then
                vPhtLnk = ""
            Else
                vPhtLnk = vDtTable.Rows(0)(5)
            End If
            vPhtLnk = vPhtLnk.Trim()
            'For connections - All accounts
            If ((IsDBNull(vDtTable.Rows(0)(6))) Or (vDtTable.Rows(0)(6).ToString().Trim() = "")) Then
                vAcctNo = ""
            Else
                vAcctNo = vDtTable.Rows(0)(6)
            End If
            vAcctNo = vAcctNo.Trim()
            'For water quality report
            If ((IsDBNull(vDtTable.Rows(0)(7))) Or (vDtTable.Rows(0)(7).ToString().Trim() = "")) Then
                vMeterNo = ""
            Else
                vMeterNo = vDtTable.Rows(0)(7)
            End If
            vMeterNo = vMeterNo.Trim()
            'Consent #
            If ((IsDBNull(vDtTable.Rows(0)(8))) Or (vDtTable.Rows(0)(8).ToString().Trim() = "")) Then
                vConsentNo = ""
            Else
                vConsentNo = vDtTable.Rows(0)(8)
            End If
            vConsentNo = vConsentNo.Trim()

            buildUrlsFGisId = True
        End If
        vGlobalArrRecs = Nothing

        vSrvrName = Request.ServerVariables("SERVER_NAME")

        '20160808
        'If (Not (vCompKey = "")) Then
        '    getHansenDetails(vCompKey, vCompType)
        '    'vCompKey = String.Format("<a target='_blank' href='http://{0}/GISApps/AMS/hansen.aspx?compkey={1}&comptype={2}'>&nbsp;Hansen Report&nbsp;</a>", vSrvrName, vCompKey, vCompType)
        '    vCompKey = "&nbsp;Hansen&nbsp;"
        'End If
        'If (Not (vEquipId = "")) Then
        '    vEquipId = String.Format("<a target='_blank' href='http://sapwpeap1.water.internal:8001/sap/bc/gui/sap/its/zie03_disp?~transaction=IE03%20RM63E-EQUNR={0}'>&nbsp;SAP&nbsp;</a>", vEquipId)
        'End If
        If (vCompKey.Length() > 1) Then
            getHansenDetails(vCompKey, vCompType)
            vCompKey = "&nbsp;Hansen&nbsp;"
        Else
            vCompKey = ""
        End If
        If (vEquipId.Length() > 1) Then
            vEquipId = String.Format("<a target='_blank' href='http://sapwpeap1.water.internal:8001/sap/bc/gui/sap/its/zie03_disp?~transaction=IE03%20RM63E-EQUNR={0}'>&nbsp;SAP&nbsp;</a>", vEquipId)
        Else
            vEquipId = ""
        End If
        '20160808
        If (Not (vDMSLnk = "")) Then
            vDMSLnk = String.Format("&nbsp;<a target='_blank' href='http://{0}/GISApps/DMS/PLink_DwgInfo.aspx?PW_Ref={1}'>ProjectWise</a>&nbsp;", vSrvrName, vDMSLnk)
        End If
        If (Not (vPhtLnk = "")) Then
            vPhtLnk = String.Format("&nbsp;<a target='_blank' href='http://{0}/gisapps/Photos/photoList.aspx?PH_LINK={1}'>Photos</a>&nbsp;", vSrvrName, vPhtLnk)
        End If
        'Will not work as it is not in view
        If (Not (vAcctNo = "")) Then
            vAcctNo = String.Format("&nbsp;<a target='_blank' href='http://{0}/GISApps/AMS/hansenCon.aspx?acctnopfix={1}'>Connections</a>&nbsp;", vSrvrName, vAcctNo)
        End If
        If (Not (vMeterNo = "")) Then
            vMeterNo = String.Format("&nbsp;<a target='_blank' href='http://{0}/GISApps/Other/Meter.aspx?meter_no={1}'>Water Quality</a>&nbsp;", vSrvrName, vMeterNo)
        End If
        'Will not work as it is not in view
        If (Not (vConsentNo = "")) Then
            vConsentNo = String.Format("&nbsp;<a target='_blank' href='http://{0}/GISApps/Other/twa.aspx?consenttno={1}'>Trade Waste Enquiry</a>&nbsp;", vSrvrName, vMeterNo)
        End If


        'vGlobalUrlPth = "<tr><td class='style14'>{0}</td><td class='style14'>{1}</td><td class='style14'>{2}</td><td class='style14'>{3}</td><td class='style14'>{4}</td></tr>"
        vGlobalUrlPth = ""

        If (Not (vCompKey = "")) Then
            vSrvrName = "<span class=""style15"">{0}</span>"
            'vSrvrName = "<p><br/>{0}<br/></p>"
            vSrvrName = String.Format(vSrvrName, vCompKey)
            vGlobalUrlPth = vGlobalUrlPth & vSrvrName
        End If
        If (Not (vEquipId = "")) Then
            vSrvrName = "<span class=""style14"">{0}</span>"
            'vSrvrName = "<p><br/>{0}<br/></p>"
            vSrvrName = String.Format(vSrvrName, vEquipId)
            vGlobalUrlPth = vGlobalUrlPth & vSrvrName
        End If
        If (Not (vDMSLnk = "")) Then
            vSrvrName = "<span class=""style14"">{0}</span>"
            'vSrvrName = "<p><br/>{0}<br/></p>"
            vSrvrName = String.Format(vSrvrName, vDMSLnk)
            vGlobalUrlPth = vGlobalUrlPth & vSrvrName
        End If
        If (Not (vPhtLnk = "")) Then
            vSrvrName = "<span class=""style14"">{0}</span>"
            'vSrvrName = "<p><br/>{0}<br/></p>"
            vSrvrName = String.Format(vSrvrName, vPhtLnk)
            vGlobalUrlPth = vGlobalUrlPth & vSrvrName
        End If
        If (Not (vAcctNo = "")) Then
            vSrvrName = "<span class=""style14"">{0}</span>"
            'vSrvrName = "<p><br/>{0}<br/></p>"
            vSrvrName = String.Format(vSrvrName, vAcctNo)
            vGlobalUrlPth = vGlobalUrlPth & vSrvrName
        End If
        If (Not (vMeterNo = "")) Then
            vSrvrName = "<span class=""style14"">{0}</span>"
            'vSrvrName = "<p><br/>{0}<br/></p>"
            vSrvrName = String.Format(vSrvrName, vMeterNo)
            vGlobalUrlPth = vGlobalUrlPth & vSrvrName
        End If
        If (Not (vConsentNo = "")) Then
            vSrvrName = "<span class=""style14"">{0}</span>"
            'vSrvrName = "<p><br/>{0}<br/></p>"
            vSrvrName = String.Format(vSrvrName, vConsentNo)
            vGlobalUrlPth = vGlobalUrlPth & vSrvrName
        End If


        'vGlobalUrlPth = String.Format(vGlobalUrlPth, vCompKey, vDMSLnk, vPhtLnk, "", "")
        vGlobalUrlPth = vGlobalUrlPth.Replace("'", """")
    End Function

    Function procCompKeyArr(ByVal inArr As Array) As Integer
        '   -1  Function failure
        '   10   Record not found
        '   11   single Record found
        '   13  Assets present but not valid to view
        '   2   Multiple record found
        '   3   Asset out of service
        procCompKeyArr = -1

        Dim vUrlStr As String = ""

        Dim vTotRecFnd As Integer = -1
        Dim vDsplyStr As String = ""

        Dim vGISId, vCompKey, vEquipId, vStatus, vFClass As String
        vGISId = ""
        vCompKey = ""
        vEquipId = ""
        vStatus = ""
        vFClass = ""
        If (vGlobalArrRecs Is Nothing) Then
            'No records found in SAP-View
            'Response.Write("No records found in Hansen")
            procCompKeyArr = 10
        Else
            'one records found
            If vGlobalArrRecs.GetLength(1) = 1 Then
                vGISId = vGlobalArrRecs(0, 0)
                vEquipId = vGlobalArrRecs(1, 0)
                vCompKey = vGlobalArrRecs(2, 0)
                vStatus = vGlobalArrRecs(3, 0)
                vFClass = vGlobalArrRecs(4, 0)
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
                vGISId = vGlobalArrRecs(0, 0)
                vEquipId = vGlobalArrRecs(1, 0)
                vCompKey = vGlobalArrRecs(2, 0)
                vStatus = vGlobalArrRecs(3, 0)
                vFClass = vGlobalArrRecs(4, 0)
            End If
            procCompKeyArr = 11
        End If
        vGlobalArrRecs = Nothing
        vFClass = String.Format("[GISNet1].[GISWSL].[{0}]", vFClass)
        buildUrlsFGisId(vGISId, vStatus, vFClass)
    End Function
#End Region

#Region "GISID"
    Function procGisIdArr(ByVal inArr As Array) As Integer
        '   -1  Function failure
        '   30   Record not found
        '   31   single Record found
        '   2   Multiple record found
        '   3   Asset out of service        
        Dim vUrlStr As String = ""
        Dim vTotRecFnd As Integer = -1
        Dim vDsplyStr As String = ""

        procGisIdArr = -1

        Dim vGisId, vCompKey, vEquipId, vStatus, vFClass As String
        vGisId = ""
        vCompKey = ""
        vEquipId = ""
        vStatus = ""
        vFClass = ""


        If (vGlobalArrRecs Is Nothing) Then
            'No records found in SAP-View
            procGisIdArr = 30
            'Response.Write("No records found in SAPView")
        Else
            'one records found
            If vGlobalArrRecs.GetLength(1) = 1 Then
                vGisId = vGlobalArrRecs(0, 0)
                vEquipId = vGlobalArrRecs(1, 0)
                vCompKey = vGlobalArrRecs(2, 0)
                vStatus = vGlobalArrRecs(3, 0)
                vFClass = vGlobalArrRecs(4, 0)
            Else
                '--To be enabled later
                ''Multiple records
                'vTotRecFnd = displayMutipleSAPRecs(vGlobalArrRecs, inIDVal, vDsplyStr)
                'If vTotRecFnd = 0 Then
                '    'Abondoned asset
                '    procEquipmentIDs = 2
                'Else
                '    procEquipmentIDs = 1
                '    Response.Write(vDsplyStr)
                'End If
                vGisId = vGlobalArrRecs(0, 0)
                vEquipId = vGlobalArrRecs(1, 0)
                vCompKey = vGlobalArrRecs(2, 0)
                vStatus = vGlobalArrRecs(3, 0)
                vFClass = vGlobalArrRecs(4, 0)
            End If
            procGisIdArr = 31
        End If
        vGlobalArrRecs = Nothing

        'buildSAPKeyUrls(vEquipId, vStatus, vFClass)
        vFClass = String.Format("[GISNet1].[GISWSL].[{0}]", vFClass)
        buildUrlsFGisId(vGisId, vStatus, vFClass)
    End Function


    Function procGISID(ByVal inQryParam As String, ByVal inIDVal As String) As Integer
        '   -1  Function failure
        '   0   Record not found
        '   1   single Record found
        '   2   Multiple record found
        '   3   Asset out of service
        procGISID = -1

        Dim vEquipId, vCompKey As String
        vEquipId = ""
        vCompKey = ""

        vGlobalArrRecs = Nothing

        'vGlobalArrRecs = getRecordsFId("GISIDNET1", inIDVal.ToString(), "GISNet1")

        If (vGlobalArrRecs Is Nothing) Then
            ''No records found in SAP-View
            'vGlobalArrRecs = getRecordsFId("GISIDNET2", inIDVal.ToString(), "GISNet2")
            'If (vGlobalArrRecs Is Nothing) Then
            '    'No records found in SAP-View
            '    Response.Write("No records found in Hansen")
            '    procGISID = 0
            'Else
            '    vTmpStr = vGlobalArrRecs(4, 0)
            '    procGISID = procCompKeyArr(vGlobalArrRecs)
            'End If

            Response.Write("No records found in Hansen")
            procGISID = 0
        Else
            vEquipId = vGlobalArrRecs(1, 0)
            vCompKey = vGlobalArrRecs(2, 0)

            If (vEquipId.Length() = 1) And (vCompKey.Length() > 1) Then
                procGISID = procCompKeyArr(vGlobalArrRecs)
            End If
            If (vEquipId.Length() > 1) And (vCompKey.Length() = 1) Then
                procGISID = procEquipmentArr(vGlobalArrRecs)
            End If
            If (vEquipId.Length() = 1) And (vCompKey.Length() = 1) Then
                'procGISID = 21
                procGISID = procGisIdArr(vGlobalArrRecs)
            End If
            'If (vEquipId = "0") Then
            '    procGISID = procCompKeyArr(vGlobalArrRecs)
            'End If
            'If (vCompKey = "0") Then
            '    procGISID = procEquipmentArr(vGlobalArrRecs)
            'End If
        End If


    End Function

#End Region


</script>
<%
    On Error GoTo ErrHndlr

    'Dim vResFn As Integer = -1   ' Result of the Global function
    '   -2  Invalid value
    '   -1  Function failure
    '   0   Record not found
    '   1   single Record found
    '   2   Multiple record found

    Dim vQryParamStr As String = ""
    Dim ViDToSrchStr As String = ""
    If (Request.QueryString.Keys.Count = 0) Then
        'Response.Write("Valid parameters not found")
        'Response.End()
        vGlobalRes = -2
        GoTo NoErrHndlr
    End If
    If (Request.QueryString("VType") = Nothing) Then
        'Response.Write("Parameter vType expected")
        'Response.End()
        vGlobalRes = -2
        GoTo NoErrHndlr
    End If

    'getUrlNameKeyPair(vQryParamStr, ViDToSrchStr)

    Dim vIDToSrchInt As Integer = -1
    If (ViDToSrchStr = "") Then
        'Response.Write("Valid parameters not passed")
        'Response.End()
        vGlobalRes = -2
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

    'SELECT TOP 1000 *  FROM [GISNet2].[GISWSL].[O_CONNECTION]  where GISID = 2103597
    'SELECT TOP 1000 *  FROM [GISNet2].[GISWSL].[O_TRADEWASTE]  where GIS_ID = 343162

    'logNtry(vQryParamStr, ViDToSrchStr, "GISAdmin")

    Dim vType As String
    vType = Request.QueryString("VType").ToString()
    If (vType = 1) Then
        Select Case vQryParamStr.ToUpper()
            Case ("EQUIPMENTID")
                vGlobalArrRecs = Nothing
                'vGlobalArrRecs = getRecordsFId(vQryParamStr, ViDToSrchStr, "GISNet1")
                ''if nothing is found- try hansen
                If vGlobalArrRecs Is Nothing Then
                    vGlobalRes = 20
                Else
                    vGlobalRes = procEquipmentArr(vGlobalArrRecs)
                End If
            Case ("COMPKEY")
                vGlobalArrRecs = Nothing
                'vGlobalArrRecs = getRecordsFId(vQryParamStr, ViDToSrchStr, "GISNet1")
                vGlobalRes = procCompKeyArr(vGlobalArrRecs)
            Case ("GISID")
                vGlobalRes = procGISID(vQryParamStr, ViDToSrchStr)
        End Select
    ElseIf (vType = 2) Then
    ElseIf (vType = 3) Then

    End If


    'If ((vGlobalRes = 1) or (vGlobalRes = 11) or (vGlobalRes = 21)) Then
    '    Response.Redirect(vGlobalUrlPth)
    '    'Response.Write(vGlobalUrlPth)
    '    Response.Flush()
    'End If

    GoTo NoErrHndlr
ErrHndlr:
    Response.Write("Error : " + Err.Description.ToString())

    'Response.Redirect("http://" & Session("Server") & "/GISApps/GenericError.aspx" + "?ErrDesc=" + Err.Number.ToString())
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
        .errTxt a:link, a:visited
        {
            color:blue   ;
        }
        .style12
        {
            width: 100%;
            font-weight: 600;
            font-size: medium;
            display:inline-block 
        }
        .style13
        {
            width: 170px;
            font-weight: 300;
            font-size: large;
            display:inline-block 
        }
        .style14
        {
            color : #ffffff ;
            width: 180px;
            height: 30px;
            background : #4b6c9e;
            /*background : #3e4043;*/
            font-weight: 800;
            font-size: large;
            display:inline-block ;
            margin: 10px
        }
        .style14 a:link, a:visited
        {
            color: #FFFFFF;
            text-decoration: none;
        }

        .style14 a:hover
        {
            color: #4b2c84;
        }

        .style15
        {
            /*border-style:outset ;*/
            color : #ffffff ;
            width: 180px;
            height: 30px;
            background : #7c8ca4;
            /*background : #3e4043;*/
            font-weight: 800;
            font-size: large;
            display:inline-block ;
            margin: 0px 10px 10px 0px;
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

        /*a:link, a:visited
        {
            color: #FFFFFF;
        }

        a:hover
        {
            color: #1d60ff;
            text-decoration: none;
        }

        a:active
        {
            color: #034af3;
        }*/

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
            width: 700px;
            background-color: #fff;
            margin: 0px auto 0px auto;
            border: 1px solid #496077;
        }

        .header
        {
            position: relative;
            margin: 0px;
            padding: 0px;
            /*background: #4b6c9e;*//*blue*/
            /*background: #3e4043;*/ /*black*/
            background: #464545;
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
            border-color : red;
            border: 5px;
            padding: 0px 12px;
            margin: 12px 8px 8px 8px;
            min-height: 10px;
        }

        #ContentPlaceHolder1 
        {
            /*background-color:green ;*/
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
            /*background-color:#3a4f63;*/ /*LightBlack*/
            background-color:#4b6c9e;
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



        #hTable
        {
            font-family: "Lucida Sans Unicode" , "Lucida Grande" , Sans-Serif;
            font-size: 12px;
            /*top: 100px;
            left: 45px;
            position: absolute;
            */
            width: 480px;
            text-align: left;
        }
        
        #hThread th
        {
            font-size: 13px;
            font-weight: normal;
            padding: 2px;
            /*background: #b9c9fe;*/
            background: #7c8ca4;
            border-top: 4px solid #aabcfe;
            border-bottom: 1px solid #fff;
            height:30px;
            /*color: #039;*/
            color : #FFFFFF;
        }


        #hTBody td
        {
            padding: 8px;
            background: #e8edff;
            
            color: #669;
            border-top: 1px solid transparent;
        }

    </style>
<%--    <asp:ContentPlaceHolder ID="HeadContent" runat="server">
    </asp:ContentPlaceHolder>--%>
    <div ID="HeadContent" runat="server">
    </div>

</head>
<body>
    <form runat="server">
    <div class="page">
        <div class="header">
            <div class="title">
                 <h1 style="font-variant: normal" class="header">
                     Asset Links
                </h1>
            </div>
            <%--<div class="loginDisplay">
                <asp:LoginView ID="HeadLoginView" runat="server" EnableViewState="false">
                    <AnonymousTemplate>
                        [ <a href="~/Account/Login.aspx" ID="HeadLoginStatus" runat="server">Log In</a> ]
                    </AnonymousTemplate>
                    <LoggedInTemplate>
                        Welcome <span class="bold"><asp:LoginName ID="HeadLoginName" runat="server" /></span>!
                        [ <asp:LoginStatus ID="HeadLoginStatus" runat="server" LogoutAction="Redirect" LogoutText="Log Out" LogoutPageUrl="~/"/> ]
                    </LoggedInTemplate>
                </asp:LoginView>
            </div>--%>
            <div class="clear hideSkiplink" style="display: block">
            </div>
        </div>
        <div class="main">
<%--            <asp:ContentPlaceHolder ID="MainContent" runat="server"/>--%>
            <div ID="ContentPlaceHolder1" runat="server">
                <table border="0" width="655px">
<%--    
    '   -2  Invalid value
    '   -1  Function failure
    '   0   Record not found
    '   1   single Record found
    '   2   Multiple record found
    '   CompKey values
        '   10   Record not found
        '   13  Assets present but not valid to view
    '   EquipKey values
        '   20   Record not found

    --%> 
                    <tr>
                        <td colspan="5" class="style12" ><%-- <% Response.Write(vGlobalHeaderTxt)%> --%>
                            <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="5" class="style12" ><asp:Label ID="LabelMsg" style="z-index: 2; display:block; height: 10px; 
                            width: 600px; background-color: #F5F3F1;" runat="server" BackColor="#fffffF" Font-Overline="False" 
                                    Font-Size="Large" Font-Names="arial" ForeColor="Red" Visible="False" ></asp:Label><br />
                        </td>
                    </tr>
                    <tr><td colspan="5" class="style12">
            <%
                If (vGlobalRes = -1) Then
                    Call errTxt("Please contact <a href=mailto:GISServices@water.co.nz>GISServices</a> for more information ")
                    Response.Write("</td></tr>")
                    'Hansen resultset  
                    '   10   Record not found
                    '   11   single Record found
                    '   13  Assets present but not valid to view                    
                ElseIf (vGlobalRes = 10) Then
                    Call msgTxt("This asset does not exist in GIS - please try a different search.")
                    Response.Write("</td></tr>")
                ElseIf (vGlobalRes = 13) Then
                    Call msgTxt("This asset does not exist in GIS - please try a different search.")
                    Response.Write("</td></tr>")
                    'SAP reslultset                    
                    '   20   Record not found
                    '   21   single Record found                    
                ElseIf (vGlobalRes = 20) Then
                    Call msgTxt("This asset does not exist in GIS - please try a different search. ")
                    Response.Write("</td></tr>")
                ElseIf (vGlobalRes = 30) Then
                    Call msgTxt("This asset does not exist in GIS - please try a different search. ")
                    Response.Write("</td></tr>")
                ElseIf (vGlobalRes = 0) Then
                    Call msgTxt("This asset does not exist in GIS - please try a different search.")
                    Response.Write("</td></tr>")
                ElseIf (vGlobalRes = -3) Then
                    Call errTxt("Invalid value passed - please pass valid value.<br/><br/>Please contact <a href=mailto:GISServices@water.co.nz>GISServices</a> for support")
                ElseIf (vGlobalRes = -2) Then
                    Call msgTxt("Valid value not passed for information<br/><br/>Please contact <a href=mailto:GISServices@water.co.nz>GISServices</a> for support")
                    Response.Write("</td></tr>")
                ElseIf (vGlobalRes = 11) Then
                    If (Not (vGlobalUrlPth = "")) Then
                        Response.Write(vGlobalUrlPth)
                        Response.Write("</td></tr>")
                        Response.Write("<tr><td>" & vGlobalHnDet & "</td></tr>")
                    Else
                        Call msgTxt("No additional details available for asset")
                    End If
                ElseIf (vGlobalRes = 21) Then
                    If (Not (vGlobalUrlPth = "")) Then
                        Response.Write(vGlobalUrlPth)
                        Response.Write("</td></tr>")
                    Else
                        Call msgTxt("No additional details available for asset")
                    End If
                ElseIf (vGlobalRes = 31) Then
                    If (Not (vGlobalUrlPth = "")) Then
                        Response.Write(vGlobalUrlPth)
                        Response.Write("</td></tr>")
                    Else
                        Call msgTxt("No additional details available for asset")
                    End If
                ElseIf (vGlobalRes = 2) Then
                    'Below not enabled - Not there in previous functionality
                %>                        
                    <tr>
                        <td class="style12"> Maximum Flow </td>
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
