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
        Calendar1.Visible = false;
    }
    protected void CancelBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("~\\FacilityUpdate.aspx"); 
    }
    protected void insBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("~\\FacilityUpdate.aspx"); 
    }

    protected void Button7_Click(object sender, EventArgs e)
    {
        Calendar1.VisibleDate = DateTime.Now;
        Calendar1.Visible = true; 
    }

    protected void Calendar1_SelectionChanged(object sender, EventArgs e)
    {
        TextBox1.Text = Calendar1.SelectedDate.ToString("dd/MMM/yyyy") ;  
    }
}