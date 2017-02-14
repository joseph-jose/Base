using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class MasterPage : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //string connectionString;
        //string t_serverName = Request.ServerVariables["SERVER_NAME"];
        //if (t_serverName.Equals("localhost") || t_serverName.Equals("wsldctgdw"))
        //{
        //    connectionString = ConfigurationManager.ConnectionStrings["sqlServer_dbDev"].ConnectionString;
        //}
        //else if (t_serverName.Equals("wsldctvgtw"))
        //{
        //    connectionString = ConfigurationManager.ConnectionStrings["sqlServer_dbTest"].ConnectionString;
        //}
        //else if (t_serverName.Equals("wsldctvgpw"))
        //{
        //    connectionString = ConfigurationManager.ConnectionStrings["sqlServer_dbProd"].ConnectionString;
        //}
    }
    public void Button1_Click(object sender, EventArgs e)
    {
        Button1.ForeColor = System.Drawing.Color.Bisque;
        Button1.Font.Bold = true;
    }
    public void Button2_Click(object sender, EventArgs e)
    {
        Button2.ForeColor = System.Drawing.Color.Bisque;
        Button2.Font.Bold = true;
    }
    public void Button3_Click(object sender, EventArgs e)
    {
        Button3.ForeColor = System.Drawing.Color.Bisque;
        Button3.Font.Bold = true;
    }
    public void Button4_Click(object sender, EventArgs e)
    {
        Button4.ForeColor = System.Drawing.Color.Bisque;
        Button4.Font.Bold = true;
    }
    public void Button5_Click(object sender, EventArgs e)
    {
        Button5.ForeColor = System.Drawing.Color.Bisque;
        Button5.Font.Bold = true;
    }

    public void Button6_Click(object sender, EventArgs e)
    {
        Button6.ForeColor = System.Drawing.Color.Bisque;
        Button6.Font.Bold = true;
    }

}
