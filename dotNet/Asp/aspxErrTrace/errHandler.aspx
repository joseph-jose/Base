<script language = "VB" runat = "server">
    Dim vGlobalArrRecs As Object
    Dim vGlobalRes As Integer = -1   ' Result of the Global function
    Dim vGlobalUrlPth As String = ""
    Dim vGlobalHnDet As String = ""
    'Dim vGlobalHeaderTxt As String = ""

    Sub Page_Error(ByVal src As Object, ByVal args As EventArgs) Handles MyBase.Error
        Dim e As System.Exception = Server.GetLastError()
        Trace.Write("Message", e.Message)
        Trace.Write("Source", e.Source)
        Trace.Write("Stack Trace", e.StackTrace)


        Response.Write("<TABLE  WIDTH=700 TABLE HEIGHT=10 BORDER=0 BORDERCOLOR=WHITE BGCOLOR=#0000A2 CELLPADDING=5>")
        Response.Write("<tr><td height=180 colspan=6 bgcolor=F8F8FF><font size=5 color=ff0000>Encountered an Error, Please contact <a href=mailto:GISServices@water.co.nz>GISServices</a> for more information </font></td></tr>")
        Response.Write("<tr><td height=2 colspan=6 bgcolor=F88FF>")
        Response.Write("Message" + e.Message)
        Response.Write("Source" + e.Source)
        Response.Write("Stack Trace" + e.StackTrace)
        Response.Write("</td></tr>")
        Response.Write("<tr><td height=2 colspan=6 bgcolor=F88FF></td></tr></table>")
        Context.ClearError()
    End Sub
</script>
<%
    'On Error GoTo ErrHndlr


    Dim vQryParamStr As String = ""
    Dim ViDToSrchStr As String = ""

    'Forcefully create an exception
    'Demo
    'ViDToSrchStr = Request.QueryString("Param1").ToString()

    If (Request.QueryString.Keys.Count = 0) Then
        'Call exception handler
        Throw New ApplicationException("Invalid parameter")
        vGlobalRes = -2
        'GoTo NoErrHndlr
    End If
%>

<%@ Page Language="VB" Debug="true" %>
<HTML>
<head>

    <title>Error handler</title>
    <style type="text/css">
        .auto-style1 {
            width: 100%;
        }
    </style>
</head>
   <body>
      <form id="form" runat="server">     
     
          <table class="auto-style1">
              <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
              </tr>
              <tr>
                  <td>&nbsp;</td>
                  <td>Error handler demo<br />
                  </td>
                  <td>&nbsp;</td>
              </tr>
              <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
              </tr>
          </table>
     
      </form>
   </body>
</HTML>
