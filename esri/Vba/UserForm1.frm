VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} UserForm1 
   Caption         =   "UserForm1"
   ClientHeight    =   6675
   ClientLeft      =   45
   ClientTop       =   375
   ClientWidth     =   7560
   OleObjectBlob   =   "UserForm1.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "UserForm1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub CommandButton1_Click()
    Dim vDoc As IMxDocument
    Set vDoc = ThisDocument
    
  
    
    Dim pFieldInfo As IFieldInfo
    Dim pLayerFields As ILayerFields
    
    Set pLayerFields = vDoc.SelectedLayer
    Dim vI As Integer
    For vI = 0 To pLayerFields.FieldCount - 1
        Set pFieldInfo = pLayerFields.FieldInfo(vI)
        If pFieldInfo.Visible Then
            'pFieldInfo.Visible = False
'            MsgBox pFieldInfo.Alias
            ListBox1.AddItem (pFieldInfo.Alias)
        End If
    Next
    
End Sub
