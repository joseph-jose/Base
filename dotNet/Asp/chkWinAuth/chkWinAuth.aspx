<HTML>
<HEAD> 
<!--
// DMS_Edit.aspx  -- to add, modify, create dms projectwise links
// also can search based on pw_link.
// Ram Kolla(rkolla@water.co.nz, 11/8/2009)

// Overview: Manage and list PW_Link information
// provides capability to create and modify
// DMSLink layers
// Input:
// Output:
// Exceptions/ Error handling:

// Fixes:

//Todo:
// Need to add more dropdown items under TYPE to accomodate other environments of Projectwise

// Modifications;
// 1.Modified classic asp into aspx
// Ram Kolla (rkolla@water.co.nz), 11/8/2010 
// 2.Documentation and comments
// Ram Kolla (rkolla@water.co.nz, 26/8/2011 9.17am 
// 3. Transmission
// Shaun Naidoo 26-10-2012
-->

<TITLE>GIS ProjectWise Link</TITLE>
<%@Page Language="VB" Trace="False" Explicit="True" aspcompat=true debug=true%>
<%@Import Namespace="System.Data.SqlClient" %>
<%@Import Namespace="System.Data" %>
<%@Import Namespace="System.Data.OleDb" %>
<%@Import Namespace="ADODB" %>
<%@Import Namespace="System.Globalization" %>

</HEAD>

<BODY>

<!--Start of asp code-->



    
<%  



    Dim rolesArray() As String


    rolesArray = Roles.GetRolesForUser()

    Dim vRoleCnt As Integer
    vRoleCnt = UBound(rolesArray)

    Response.Write(vRoleCnt)
    Response.Write("<br/>")

    If User.IsInRole("WATER\GISEditor") Then
        Response.Write("IsEditor")
    Else
        Response.Write("IsNotEditor")
    End If





%>

</BODY>
</HTML>