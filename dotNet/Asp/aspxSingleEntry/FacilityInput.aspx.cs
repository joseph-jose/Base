using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class FacilityInput : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void CancelBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("..\\GAdmin\\FacilityUpdate.aspx"); 
    }
    protected void insBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("..\\GAdmin\\FacilityUpdate.aspx"); 
    }
}