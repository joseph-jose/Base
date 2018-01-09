
<script language = "VB" runat = "server">
    Dim vGlobalArrRecs As Object
    Dim vGlobalRes As Integer = -1   ' Result of the Global function
    Dim vGlobalUrlPth As String = ""
    Dim vGlobalHnDet As String = ""
    'Dim vGlobalHeaderTxt As String = ""
#Region "commonFns"

    Sub errTxt(ByVal inMsg As String)
        Dim vStr As String
        vStr = "<tr><td colspan=""5"" class=""style12""><span class=""errTxt""><br/><br/><br/>GPF-><br /> {0} <br/><br/><br/><br/><br/><br/></span></td></tr>"
        vStr = String.Format(vStr, inMsg)
        Response.Write(vStr)
    End Sub

    Sub msgTxt(ByVal inMsg As String)
        Dim vStr As String
        'vStr = "<tr><td colspan=""5"" class=""style12""><span class=""errTxt""><br/><br/><br/><br /> {0} <br/><br/><br/><br/><br/><br/></span></td></tr>"
        vStr = "<span class=""errTxt""><br/><br/><br/><br /> {0} <br/><br/><br/><br/><br/><br/>"
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
                'vSqlText = "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey],[status]  ,[fclass] FROM [WA_Asset_View] WHERE [status] <> 'REMOVED' and ([EQUIP_ID] = '{0}') ORDER BY [fclass] DESC"
                vSqlText = "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey],[status]  ,[fclass] FROM [GISWSL].[WA_Netview_View] WHERE [status] <> 'REMOVED' and ([EQUIP_ID] = '{0}') ORDER BY [fclass] DESC"
                vSqlText = String.Format(vSqlText, inValue)
                Exit Select
            Case ("COMPKEY")
                'vSqlText = "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey],[status]  ,[fclass] FROM [GISWSL].[WA_Asset_View] WHERE ([status] <> 'RM') and ([compkey] = '{0}') ORDER BY [fclass] DESC"
                vSqlText = "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey],[status]  ,[fclass] FROM [GISWSL].[WA_Netview_View] WHERE ([status] <> 'RM') and ([compkey] = '{0}') ORDER BY [fclass] DESC"
                vSqlText = String.Format(vSqlText, inValue)
                Exit Select
            Case ("GISIDNET1")
                'vSqlText = "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey],[status]  ,[fclass], 'SAP' as Source FROM [GISWSL].[WA_Asset_View] WHERE [status] <> 'REMOVED' and ([GIS_ID] = '{0}') "
                vSqlText = "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey],[status]  ,[fclass], 'SAP' as Source FROM [GISWSL].[WA_Netview_View] WHERE [status] <> 'REMOVED' and ([GIS_ID] = '{0}') "
                vSqlText = vSqlText & "ORDER BY [fclass] DESC"
                vSqlText = String.Format(vSqlText, inValue, inValue)
                Exit Select
            Case ("GISIDNET2")
                'vSqlText = vSqlText & "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey],[status]  ,[fclass], 'HANSEN' as Source FROM [GISWSL].[WA_Asset_View] WHERE ([status] <> 'RM') and ([GIS_ID] = '{0}') "
                vSqlText = vSqlText & "SELECT DISTINCT [gis_id] , ISNULL([equip_id], 0)  [equip_id], ISNULL([compkey] , 0) [compkey],[status]  ,[fclass], 'HANSEN' as Source FROM [GISWSL].[WA_Netview_View] WHERE ([status] <> 'RM') and ([GIS_ID] = '{0}') "
                vSqlText = vSqlText & "ORDER BY [fclass] DESC"
                vSqlText = String.Format(vSqlText, inValue, inValue)
                Exit Select
        End Select
        Return vSqlText
    End Function

    Public Sub getDbVals(ByRef outSrvrName As String, ByRef outSrvrPwd As String)
        Dim vWebSrvrName As String = ""
        vWebSrvrName = Request.ServerVariables("SERVER_NAME")

        Select Case vWebSrvrName
            Case ("localhost")
                'TODO to be enabled
                outSrvrName = "WSLDCTGDW"
                outSrvrPwd = "G1s@webd01"
            Case ("wsldctgdw")
                'TODO to be enabled
                outSrvrName = "WSLDCTGDW"
                outSrvrPwd = "G1s@webd01"
            'outSrvrName = "WSLDCTVGPD2"
            'outSrvrPwd = "NetG15@wp01"
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

    Function execDbFetch(ByVal inSrvrName As String, ByVal inPsswrd As String, ByVal inDbName As String, ByVal inSql As String, Optional ByRef outFldNames As String = "") As Object
        execDbFetch = Nothing
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
            vObjConn.ConnectionString = String.Format(vObjConn.ConnectionString, inSrvrName, inPsswrd, inDbName)
            vObjConn.Open()

            vObjRst = Server.CreateObject("ADODB.Recordset")

            vObjRst.Open(inSql, vObjConn, , , 1)


            If Not vObjRst.eof Then
                execDbFetch = vObjRst.GetRows()
            End If

            Dim vFldNames As String
            vFldNames = ""
            For Each fldf In vObjRst.Fields
                vFldNames = vFldNames & fldf.Name & ","
            Next
            outFldNames = vFldNames
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

    Function getRecordsFId(ByVal inSrchName As String, ByVal inSrchKey As String, ByVal inDbName As String) As Object
        getRecordsFId = Nothing

        Dim vSrvrName As String = ""
        Dim vPsswrd As String = ""
        Call getDbVals(vSrvrName, vPsswrd)

        Dim vSqlText As String
        vSqlText = getSqlFKey(inSrchName, inSrchKey)
        getRecordsFId = execDbFetch(vSrvrName, vPsswrd, inDbName, vSqlText)

    End Function

    Function logNtry(ByVal inSrchName As String, ByVal inSrchKey As String, ByVal inDbName As String) As Boolean
        logNtry = False

        Dim vSrvrName As String = ""
        Dim vPsswrd As String = ""
        Call getDbVals(vSrvrName, vPsswrd)

        '*****************Open database*****************************************************************
        ' connect to database
        Dim vObjConn As Object
        'Dim vObjRst As Object
        vObjConn = Nothing
        'vObjRst = Nothing
        Try
            vObjConn = Server.CreateObject("ADODB.Connection")

            'vObjConn.ConnectionString = "Provider=SQLOLEDB;Data Source=" + vSrvrName + ";User ID=gisweb;Password=" + vPsswrd + ";Initial Catalog=GISNet1"
            'vObjConn.ConnectionString = "Provider=SQLNCLI10;Data Source={0};User ID=gisweb;Password={1};Initial Catalog={2}"
            vObjConn.ConnectionString = "Provider=SQLOLEDB;Data Source={0};User ID=gisweb;Password={1};Initial Catalog={2}"
            vObjConn.ConnectionString = String.Format(vObjConn.ConnectionString, vSrvrName, vPsswrd, inDbName)
            vObjConn.Open()

            'vObjRst = Server.CreateObject("ADODB.Recordset")
            Dim vSqlText As String
            vSqlText = "Insert into GISADMin.giswsl.WA_AppLogs (CurrUsr, CmdType, LogType, Msg, Fld1, Fld10) values ('{0}','{1}','{2}','{3}','{4}','{5}')"
            vSqlText = String.Format(vSqlText, "Internet", "WCAspApps", "ToGISIDSrch", inSrchName, inSrchKey, "")
            'vObjRst.Open(vSqlText, vObjConn, , , 1)
            vObjConn.Execute(vSqlText, "adExecuteNoRecords")

            logNtry = True
        Catch ex As Exception
            Response.Write(ex.Message.ToString())
        Finally
            'If (Not (vObjRst Is Nothing)) Then
            '    vObjRst.Close()
            '    vObjRst = Nothing
            'End If
            If (Not (vObjConn Is Nothing)) Then
                vObjConn.Close()
                vObjConn = Nothing
            End If
        End Try
    End Function

    Function buildOutStr(ByVal inStr As String) As String
        buildOutStr = "<td> " + inStr + "</td>"
    End Function


</script>

