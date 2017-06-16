
<!DOCTYPE html>
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Index" %>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>GIS Portal</title>
    <!--<script src="http://code.jquery.com/jquery-1.9.1.js"></script>-->
    <link type="text/css" href="css/style.css?v=1.9" rel="stylesheet"  charset= "utf-8" />
<!--    [if lte IE 7]>
    <link type="text/css" href="css/ie.css" rel="stylesheet"  charset= "utf-8" />
    <![endif]-->
</head>
<body>
    <form id="form1" runat="server">
    <div class="container">
        <div class="banner"><p><img src="images/bannerLeft.gif"/></p>
            <div class="coord">
                Quick Search:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <select id="SrchType" name="SrchType" class="drpfield" style="width:163px">
                    <option value="COMPKEY">Compkey</option>
                    <option value="EQUIPMENTID">Equip ID</option>
                    <option value="GISID">Gis ID</option>
                    <option value="UNITID">Unit ID</option>
                    <option value="DMSID">Datasource</option>
                </select>
			    <input type="text" value="Search" id="SrchId" name="SrchId" class="txtfield" onblur="javascript:if(this.value==''){this.value=this.defaultValue;}" onfocus="javascript:if(this.value==this.defaultValue){this.value='';}" />
                <img src="images\spotlight.png" onclick ="openSrchWindow()" /> <br />
                Coordinate Search :
                <input id="xCoord" name="xCoord" value="Easting"  onblur ="javascript:if(this.value==''){this.value=this.defaultValue;}" onfocus="javascript:if(this.value==this.defaultValue){this.value='';}" maxlength="20" style="width:160px" />
                <input id="yCoord" name="yCoord" value="Northing" onblur ="javascript:if(this.value==''){this.value=this.defaultValue;}" onfocus="javascript:if(this.value==this.defaultValue){this.value='';}" maxlength="20" style="width:168px" />
                <img src="images\spotlight.png" onclick ="srchCoOrd()" />
            </div>
        &nbsp;</div>
        <div class="bannerBot"><p><img src="images/bannerBottom.gif"/></p>
            <span><asp:HyperLink ID="hlnkSrvrname" runat="server" Visible="false"></asp:HyperLink>
            </span>
        </div>
        <div class="contend">
            <div class ="menu">
                        <table style="border:2px;background-color: #FFFFFF;  border-color: red ; height:500px;font: 14px arial bold;color:#1e3b58;">
                          <tr><td>
                                <a href="http://<% Response.Write(txtSrvr.Text.ToString());  %>/Gallery.aspx">&nbsp;</a>
                                </td></tr>
                            <tr><td style="width: 250px">
                                <a href="Default.aspx">Home</a>
                                </td></tr>
                            <tr><td>
                                <a href="Gallery.aspx?Type=retail">Retail</a>
                                </td></tr>
                            <tr><td>
                                <a href="Gallery.aspx?Type=service">Service delivery</a>
                                </td></tr>
                            <tr><td style="width: 300px">
                                <a href="Gallery.aspx?Type=infrastructure">Infrastructure delivery</a>
                                </td></tr>
                            <tr><td style="width: 300px">
                                <a href="Gallery.aspx?Type=statergy">Strategy & Planning</a>
                                </td></tr>
                            <tr><td>
                                <a href="Gallery.aspx?Type=corporate">Other apps</a>
                                </td></tr>
                            <tr><td>
                                <a href="Gallery.aspx?Type=mobapps">Mobile apps</a>
                                </td></tr>
                            <tr><td>
                                <a href="Gallery.aspx?Type=test">Test gallery</a>
                                </td></tr>
                            <tr><td>
                                <a href="Help.aspx">Help</a>
                                </td></tr>
                            <tr><td>
                                <a href="mailto:gisservices@water.co.nz">Contact us</a>
                                </td></tr>
                            <tr><td>&nbsp;
                                </td></tr>
                        </table>
            </div>
	        <div class="clear"></div>
            <br /><br />
           <div class ="infogallery">
                <p>
                <span><b>Home</b></span>
                    <span><asp:TextBox ID="txtSrvr" runat="server" Visible="false"></asp:TextBox><asp:TextBox ID="TextBox1" runat="server" Visible="False"></asp:TextBox>
                        <asp:Label ID="LblMrque" runat="server" Text="Label" Visible ="false"></asp:Label>
                        <asp:Label ID="LblWhatsNew" runat="server" Text="Label" Visible ="false"></asp:Label>
                        <asp:Label ID="LblBrw" runat="server" Text="Label" Visible ="false"></asp:Label>
                    </span>
                </p>
            </div>
            <div class ="thumbnailContainer">
                    <div class="thumbnail">
                        <img src="images/TNv.png" />
                        <a 
                        <%
                                switch (txtSrvr.Text)
                                {
                                    case "wsldctgdw":
                                    %>
                                    href="http://wsldctgdw/netview/NVG/" 
                                    <%
                                        break;
                                    case "wsldctvgtw":
                                    %>
                                    href="http://giswebtest/netview/NVG/" 
                                    <%
                                        break;
                                    case "wsldctvgpw":
                                    %>
                                    href="http://gisweb/netview/NVG/" 
                                    <%
                                    break;
                                }
                             %> >&nbsp;</a>
                            &nbsp;
                        </a>
                    </div>
                    <div class="thumbnail">
                        <img src="images/TNvCs.png" />
                        <a 
                        <%
                                switch (txtSrvr.Text)
                                {
                                    case "wsldctgdw":
                                    %>
                                    href="http://wsldctgdw/netview/NVR/" 
                                    <%
                                        break;
                                    case "wsldctvgtw":
                                    %>
                                    href="http://giswebtest/netview/NVR/" 
                                    <%
                                        break;
                                    case "wsldctvgpw":
                                    %>
                                    href="http://gisweb/netview/NVR/" 
                                    <%
                                    break;
                                }
                             %> >&nbsp;</a>
                    </div>
                    <div class="thumbnail">
                        <img src="images/TNvWo.png" />
                        <%--Changed for Rachael--%>
                        <a 
                        <%
                                switch (txtSrvr.Text)
                                {
                                    case "wsldctgdw":
                                    %>
                                    href="http://wsldctgdw/netview/NVSD/" 
                                    <%
                                        break;
                                    case "wsldctvgtw":
                                    %>
                                    href="http://giswebtest/netview/NVSD/" 
                                    <%
                                        break;
                                    case "wsldctvgpw":
                                    %>
                                    href="http://gisweb/netview/NVSD/" 
                                    <%
                                    break;
                                }
                             %> >&nbsp;</a>
                    </div>
                    <div class="thumbnail">
                        <%--Changed for Maureen--%>
                        <img src="images/TNvMsn.png" />
                        <a 
                        <%
                                switch (txtSrvr.Text)
                                {
                                    case "wsldctgdw":
                                    %>
                                    href="http://wsldctgdw/netview/NVMS/" 
                                    <%
                                        break;
                                    case "wsldctvgtw":
                                    %>
                                    href="http://giswebtest/netview/NVMS/" 
                                    <%
                                        break;
                                    case "wsldctvgpw":
                                    %>
                                    href="http://gisweb/netview/NVMS/" 
                                    <%
                                    break;
                                }
                             %> >&nbsp;</a>
                    </div>
                    <div class="thumbnail">
                        <img src="images/TNvKc.png" />
                            &nbsp;
                        </a>
                    </div>
                    <div class="thumbnail">
                        <img src="images/TNvProp.png" />
                        <a 
                        <%
                                switch (txtSrvr.Text)
                                {
                                    case "wsldctgdw":
                                    %>
                                    href="http://wsldctgdw/netview/NVP/" 
                                    <%
                                        break;
                                    case "wsldctvgtw":
                                    %>
                                    href="http://giswebtest/netview/NVP/" 
                                    <%
                                        break;
                                    case "wsldctvgpw":
                                    %>
                                    href="http://gisweb/netview/NVP/" 
                                    <%
                                    break;
                                }
                             %> >&nbsp;</a>
                    </div>
            </div>
            <% if (!(LblWhatsNew.Text.Trim() == "" )) { %>
 		        <div class="infoNewChanges" id="newfeatures">
			        <div class="top">
				        <div class="bot">
					        <div class="pad">
						        <h2>What's new</h2>
                                <% Response.Write(LblWhatsNew.Text.ToString());  %>
					        </div>
					        <div class="clear"></div>
				        </div>
			        </div>
<%--					<div class="pad">
						<h2>What's new</h2>
                        <% Response.Write(LblWhatsNew.Text.ToString());  %>
					</div>--%>
					<div class="clear"></div>
		        </div>
            <% } %>
	        <div class="clear"></div>
            <% if (!(LblMrque.Text.Trim() == "")) { %>
 		        <div class="infoMarquee">
                     <marquee scrolldelay="200"><% Response.Write(LblMrque.Text.ToString());  %></marquee>
 		        </div>
            <% } %>

	        <div class="clear"></div>
            <br /><br />
            </div>
        <div class="pgfooter"><img src="images/bannerFooter.gif"/>
            <p class="left">Copyright @ Watercare 2016. All rights reservered</p>
        </div>
    </div>

    <script >
        function srchSAPEquip() {
            var vUrlStr = "GISIdIn.aspx?equipmentId";
            var vSrchId = document.getElementById("EquipmentId").value.toString();
            //var vSrchId = $("#EquipmentId").val();
            if ((vSrchId.toUpperCase() == "SEARCH BY EQUIPMENT ID") || (vSrchId == "")) {
                //$("#EquipmentId").focus();
                document.getElementById("EquipmentId").focus();
                return;
            }

            vUrlStr = vUrlStr + "=" + vSrchId;
            //vUrlStr = "http://" + window.location.host + "/gisapps/ams/" + vUrlStr;
            //vUrlStr = "http://wsldctgdw/gisapps/ams/" + vUrlStr;
            vUrlStr = "http://<% Response.Write(txtSrvr.Text.ToString()); %>/gisapps/gis/" + vUrlStr;
            window.open(vUrlStr);
            //window.open("http://wsldctvgpw/gisapps/ams/" + vUrlStr);
        }
        function srchHansenComp() {
            var vUrlStr = "GISIdIn.aspx?CompKey";
            //var vSrchId = $("#CompKey").val();
            var vSrchId = document.getElementById("CompKey").value.toString();
            if ((vSrchId.toUpperCase() == "SEARCH BY COMPKEY") || (vSrchId == "")) {
                //$("#CompKey").focus();
                document.getElementById("CompKey").focus();
                return;
            }

            vUrlStr = vUrlStr + "=" + vSrchId;
            //vUrlStr = "http://"+window.location.host + "/gisapps/ams/" + vUrlStr;
            //vUrlStr = "http://wsldctgdw/gisapps/ams/" + vUrlStr;
            vUrlStr = "http://<% Response.Write(txtSrvr.Text.ToString());  %>/gisapps/gis/" + vUrlStr;
            window.open(vUrlStr);
            //window.open("http://wsldctvgpw/gisapps/ams/" + vUrlStr);
        }
        function srchGIS() {
            var vUrlStr = "GISIdIn.aspx?gisid";
            var vSrchId = document.getElementById("GisId").value.toString();
            //var vSrchId = $("#EquipmentId").val();
            if ((vSrchId.toUpperCase() == "SEARCH BY GIS ID") || (vSrchId == "")) {
                //$("#EquipmentId").focus();
                document.getElementById("GisId").focus();
                return;
            }

            vUrlStr = vUrlStr + "=" + vSrchId;
            //vUrlStr = "http://" + window.location.host + "/gisapps/ams/" + vUrlStr;
            //vUrlStr = "http://wsldctgdw/gisapps/ams/" + vUrlStr;
            vUrlStr = "http://<% Response.Write(txtSrvr.Text.ToString()); %>/gisapps/gis/" + vUrlStr;
            window.open(vUrlStr);
            //window.open("http://wsldctvgpw/gisapps/ams/" + vUrlStr);
        }
        function srchCoOrd() {
            //var vUrlStr = "http://watercare.maps.arcgis.com/apps/webappviewer/index.html?id=b14fd050486c4fdd9d2fed9366a6ea7f";
            var vUrlStr ;
            //vUrlStr = "http://watercare.maps.arcgis.com/apps/webappviewer/index.html?id=e46bdd5f7dd54bbd9d09cae93f208159";
            vUrlStr = "http://watercare.maps.arcgis.com/apps/webappviewer/index.html?id=93d8eaf8fa2749b9b079287a38216c63";
            var vEastingVal = document.getElementById("xCoord").value.toString();
            if ((vEastingVal.toUpperCase() == "EASTING") || (vEastingVal == "")) {
                document.getElementById("xCoord").focus();
                return;
            }
            if (isNaN(vEastingVal))
            {
                document.getElementById("xCoord").focus();
                alert('Easting should be a valid numeric value');
                return;
            }
            var vNorthingVal = document.getElementById("yCoord").value.toString();
            if ((vNorthingVal.toUpperCase() == "NORTHING") || (vNorthingVal == "")) {
                document.getElementById("yCoord").focus();
                return;
            }
            if (isNaN(vNorthingVal)) {
                document.getElementById("yCoord").focus();
                alert('Northing should be a valid numeric value');
                return;
            }
            vEastingVal = vEastingVal + "," + vNorthingVal;

            vUrlStr = vUrlStr + "&marker=" + vEastingVal;
            vUrlStr = vUrlStr + ",2193&level=10";

            window.open(vUrlStr, "Coordsearch");
        }

        function openSrchWindow() {
            var vUrlStr = "";
            var vSrchType = document.getElementById("SrchType").value.toString();
            if (vSrchType.toUpperCase() == "COMPKEY") {
                //vUrlStr = "GISSearchID.aspx?COMPKEY"
                vUrlStr = "GISIdIn.aspx?COMPKEY"
            }
            if (vSrchType.toUpperCase() == "EQUIPMENTID") {
                vUrlStr = "GISIdIn.aspx?EQUIPMENTID";
                //vUrlStr = "GISSearchID.aspx?EQUIPMENTID";
            }
            if (vSrchType.toUpperCase() == "GISID") {
                vUrlStr = "GISIdIn.aspx?GISID";
                //vUrlStr = "GISSearchID.aspx?GISID";
            }
            if (vSrchType.toUpperCase() == "UNITID") {
                vUrlStr = "GISIdIn.aspx?UNITID";
            }
            if (vSrchType.toUpperCase() == "DMSID") {
                vUrlStr = "GISDmsSearch.aspx?DMSID";
            }


            var vSrchType = document.getElementById("SrchId").value.toString();
            if ((vSrchType.toUpperCase() == "SEARCH") || (vSrchType == "")) {
                document.getElementById("SrchId").focus();
                return;
            }
            vUrlStr = vUrlStr + "=" + vSrchType;
            vUrlStr = "http://" + window.location.host + "/gisapps/gis/" + vUrlStr;
            window.open(vUrlStr, "Globalsearch");
        }

    </script>

    </form>
</body>
</html>
