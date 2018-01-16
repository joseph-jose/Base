<%@ Page Language="VB" Debug="true" %>
<HTML>
<head>
    <title>Download Manager</title>
</head>
   <script runat="server" language="VB">
       Sub Page_Load()
           If (Not Page.IsPostBack) Then
               Dim filePath As String = Request.QueryString("File")
               Dim fs
               fs = Server.CreateObject("Scripting.FileSystemObject")
               If fs.FileExists(filePath) = True Then
                   Dim temp() As String = Split(filePath, "\")
                   Dim file As String = temp(UBound(temp))
                   file = Server.UrlEncode(file)
                   If (file IsNot Nothing) Then
                       Response.AddHeader("Content-Disposition", "attachment; filename= " + "" + file + "")
                       Response.WriteFile(filePath)
                       'Response.Flush()
                       'Response.Close()
                       Response.End()
                   End If
               Else
                   Server.Transfer("PLink_Error.aspx")
               End If

           End If
       End Sub
   </script>
   <body>
      <form id="form" runat="server">

      </form>
   </body>
</HTML>
