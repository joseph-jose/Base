<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GISIdIn.aspx.cs" Inherits="GISIdIn" %>

<!DOCTYPE html>

<script language ="C#" runat = "server">

    object vGlobalArrRecs;
    int vGlobalRes = -1; //' Result of the Global function
    string vGlobalUrlPth = "";
    


</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <style>
        .errTxt {
	                font-family: 'verdana', 'helvetica', sans-serif;
                    border : none ;
                    color : red ;
	                font-size: medium  ; 
                    font-weight : bold;
        }

        .errTxt table {
                    color : black ;
	                font-size: medium  ; 
                    font-weight : normal ;
        }

        .errTxt table th {
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
<%--    <asp:ContentPlaceHolder ID="HeadContent" runat="server">
    </asp:ContentPlaceHolder>--%>
    <div ID="HeadContent" runat="server">
    </div>

</head>
<body>
   <form id="Form1" runat="server">
    <div class="page">
        <div class="header">
            <div class="title">
                 <h1 style="font-variant: normal" class="header">
                    Find an asset
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
                <table class="style1">
                    <tr>
                        <td><span class='errTxt'><asp:Label ID="Label1" runat="server" Text="Label"></asp:Label></span></td>
                    </tr>
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
