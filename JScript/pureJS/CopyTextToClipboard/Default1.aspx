<%@ Page Language="C#" %>

<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="utf-8" />
    <title></title>    
    <style type="text/css">
        .auto-style1 {
            width: 100%;
        }
    </style>
    <script type="text/javascript">

    <%
        HttpBrowserCapabilities bc;
        bc = Request.Browser;

        if (bc.Browser.IndexOf("Chrome") == -1)
        {
    %>
        function ClipBoard()
        {

            var copyText = document.getElementById('pwRefTextBox').value;
            alert(copyText);
            //document.execCommand('copy',false,null);
            window.clipboardData.setData("Text",copyText);
        }

    <%
        }
        else
        {
    %>
        function ClipBoard()
        {

            var copyText = document.getElementById('pwRefTextBox').value;
            ////document.execCommand('copy',false,null);
            //window.clipboardData.setData("Text",copyText);

            //alert('hello');
            //clipboardData.setData('text/plain', 'hello world');
            //preventDefault();
            alert('hello');
			document.getElementById('pwRefTextBox').select();
            document.execCommand('copy',false,null);

            alert('hello');
        }
//       document.addEventListener('copy', function(e){
//            e.clipboardData.setData('text/plain', 'hello world345');
//            e.preventDefault();
//        });

    <%
        }
     %>

    </script>
</head>
<body>
    <form id="form1" runat="server">   

        <table class="auto-style1">
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>PW Ref</td>
                <td>
                    <input id="pwRefTextBox" name="PW_REF" type="text" /><input id="Button1" type="button" value="button" onclick="ClipBoard()" /></td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
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
</html>
