VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} txfab_bytxt1 
   Caption         =   "Mref->Asbuilt by txt 1"
   ClientHeight    =   1620
   ClientLeft      =   36
   ClientTop       =   360
   ClientWidth     =   3396
   OleObjectBlob   =   "txfab_bytxt1.frx":0000
   ShowModal       =   0   'False
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "txfab_bytxt1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Dim pMxDocument As IMxDocument
Dim pMap As IMap
Dim pEnumLayer As IEnumLayer
Dim pLayer As IGeoFeatureLayer
Dim pId As New UID

Public ftype As String
Public objWMIService, colProcesses
Public Process As String
Public pCmdItmHSNxtID As ICommandItem
Public pCmdItmHSCrte As ICommandItem
Public pCmdItmHSDisp As ICommandItem
Public pCmdItmHSTxferLnr As ICommandItem
Public hsrun As String
Public unittype As String
Public comptype As String
Public getunitid As String
Public newast As Integer
Public mrefstr As String
Public newabn As String

Public pUID1 As New UID
Public pUID2 As New UID
Public pUID3 As New UID

Public pipelen As String
Public pipegisid As String
Public ffound As Integer 'feature found in get pipe length sub

Private Sub CommandButton1_Click()
   Response = MsgBox("Click OK to restart", , "Paused")
End Sub

Private Sub UserForm_Initialize()
pUID3.Value = "{846A7FB7-0175-41D6-AAF1-1B588C2ABC75}"
Set pCmdItmHSDisp = ThisDocument.CommandBars.Find(pUID3)
End Sub
Private Sub txfmref()

Dim time1, time2
  
    pCmdItmHSDisp.Execute
    SendKeys "%(l)"
    SendKeys "%(o)"
    SendKeys "{TAB 4}"
    SendKeys newabn
    SendKeys "^(u)"
    DoEvents
    time1 = Now
    time2 = Now + TimeValue("0:00:02")
    Do Until time1 >= time2
        time1 = Now()
    Loop
   
   SendKeys "^{F4}"
   DoEvents
End Sub
Private Sub chk_hs()
Dim objWMIService, colProcesses
Dim Process As String

Process = "IMSV732.exe"
Set objWMIService = GetObject("winmgmts:")
Set colProcesses = objWMIService.ExecQuery("Select * from Win32_Process where name='" & Process & "'")

  If colProcesses.Count Then
    hsrun = "y"
  Else
    hsrun = "n"
  End If
End Sub


Private Sub btntransferbyfile_Click()

    Dim sFileName As String
    Dim iFileNum As Integer
    Dim sBuf As String

    ' edit this:
    sFileName = "C:\DC\txfbytxt_in.txt"

    ' does the file exist?  simpleminded test:
    If Len(Dir$(sFileName)) = 0 Then
        Exit Sub
    End If

    iFileNum = FreeFile()
    Open sFileName For Input As iFileNum

    Do While Not EOF(iFileNum)
    
        Line Input #iFileNum, linefromfile
        lineitems = Split(linefromfile, ",")
        txtboxpipecomp = lineitems(0)
        newabn = lineitems(1)
        Getpipelenbycomp
        chk_hs
        If hsrun = "n" Then
          MsgBox "Hansen not running"
          Exit Sub
        End If
        txfmref
        'Debug.Print sBuf
        MsgBox "Read next line"
    Loop
    Close iFileNum
  MsgBox "Process completed"
End Sub

Public Sub Getpipelenbycomp()

Set pMxDocument = Application.Document
Set pMap = pMxDocument.FocusMap
pId = "{E156D7E5-22AF-11D3-9F99-00C04F6BC78E}"
Set pEnumLayer = pMap.Layers(pId, True)
pEnumLayer.Reset
Set pLayer = pEnumLayer.Next
Dim ctlyr As Integer
Dim pFc As IFeatureClass
Dim pQF As IQueryFilter
Dim pSelSet As ISelectionSet
Dim pFSel As IFeatureSelection
'Create the query filter
Set pQF = New QueryFilter

Dim strquery As String
strquery = "COMPKEY = '" & txtboxpipecomp & "'"
Debug.Print strquery
pQF.WhereClause = strquery

ffound = 0
  
Dim pEditor As IEditor
Set pEditor = Application.FindExtensionByName("ESRI Object Editor")

pMxDocument.FocusMap.ClearSelection
pMxDocument.ActiveView.Refresh
Dim layrname As String

mrefstr = ""
Do While Not pLayer Is Nothing '1
  'MsgBox pLayer.Name, 0
   'If pLayer.Name = layrname Then
   If pLayer.Name = "WL_ Pipe" Then
      
    Dim pActiveView As IActiveView
      
    'Dim pFc As IFeatureClass
    Dim strOIDName As String
    Set pFc = pLayer.FeatureClass
    strOIDName = pFc.OIDFieldName

    'Dim pFSel As IFeatureSelection
    Set pFSel = pLayer
    'Dim pSelSet As ISelectionSet
    Set pSelSet = pFSel.SelectionSet
    Dim pFCur As IFeatureCursor
    
    Dim pipeuidtype As String
    Dim pFeat As IFeature

    'Get the features that meet the where clause
    Set pSelSet = pFc.Select(pQF, esriSelectionTypeIDSet, esriSelectionOptionNormal, Nothing)
 
   'Perform the selection
  pFSel.SelectFeatures pQF, esriSelectionResultNew, False

    pSelSet.Search Nothing, False, pFCur
    ' Loop through the selected features
    'Dim pFeat As IFeature
    Dim ct1 As Integer
    ct1 = 1
    Set pFeat = pFCur.NextFeature
        If pFeat Is Nothing Then
         Else
           mrefstr = pFeat.Value(pFeat.Fields.FindField("MODIFYREF"))
           ffound = 1
           Exit Sub
        End If
    End If
    Set pLayer = pEnumLayer.Next

 Loop 'do1
End Sub



