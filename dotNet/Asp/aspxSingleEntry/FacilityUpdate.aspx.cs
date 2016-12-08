using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class FacilityUpdate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ((MasterPage)Page.Master).Button4_Click(sender, e);
            fRecords();
        }  
    }

    private void fRecords()
    {
        MultiView1.SetActiveView(VwLst);  

        string connectionString = "";
        string t_serverName = Request.ServerVariables["SERVER_NAME"];
        if (t_serverName.Equals("localhost") || t_serverName.Equals("wsldctgdw"))
        {
            connectionString = ConfigurationManager.ConnectionStrings["sqlServer_dbDev"].ConnectionString;
        }
        else if (t_serverName.Equals("wsldctvgtw"))
        {
            connectionString = ConfigurationManager.ConnectionStrings["sqlServer_dbTest"].ConnectionString;
        }
        else if (t_serverName.Equals("wsldctvgpw") || t_serverName.Equals("gisweb"))
        {
            connectionString = ConfigurationManager.ConnectionStrings["sqlServer_dbProd"].ConnectionString;
        }
        //connectionString = "Data Source=WSLDCTVGPD2;Initial Catalog=GISAdmin;Integrated Security=True";
        SqlConnection conn;
        SqlCommand cmd1;
        conn = new SqlConnection(connectionString);
        cmd1 = new SqlCommand("SELECT * FROM [GISWSL].[WA_PWLINK] order by [PW_ID] DESC", conn);
        try
        {
            conn.Open();
            SqlDataReader dr = cmd1.ExecuteReader();

            DataSet ds = new DataSet();
            SqlDataAdapter da = new SqlDataAdapter(cmd1.CommandText.ToString(), conn);
            da.Fill(ds);
            GrdLst.DataSource = ds;
            GrdLst.DataKeyNames = new string[] { "PW_ID" };
            GrdLst.DataBind();
            dr.Close();
            conn.Close();
        }
        catch (Exception er)
        {
            Response.Write(er.Message.ToString());
        }
        finally
        {
            cmd1.Dispose();
            conn.Dispose();
        }
    }

    protected void LinkButton1_Click(object sender, EventArgs e)
    {
        MultiView1.SetActiveView(VwLst);  
    }
    protected void LinkButton2_Click(object sender, EventArgs e)
    {
        Response.Redirect("..\\GAdmin\\FacilityInput.aspx");
    }

    protected void GrdLst_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GrdLst.PageIndex = e.NewPageIndex; ;
        GrdLst.SelectedIndex = -1;
        fRecords();

    }

    private void BindDetails(int id)
    {
        int iId = id;
        string connectionString = "";
        string t_serverName = Request.ServerVariables["SERVER_NAME"];
        if (t_serverName.Equals("localhost") || t_serverName.Equals("wsldctgdw"))
        {
            connectionString = ConfigurationManager.ConnectionStrings["sqlServer_dbDev"].ConnectionString;
        }
        else if (t_serverName.Equals("wsldctvgtw"))
        {
            connectionString = ConfigurationManager.ConnectionStrings["sqlServer_dbTest"].ConnectionString;
        }
        else if (t_serverName.Equals("wsldctvgpw") || t_serverName.Equals("gisweb"))
        {
            connectionString = ConfigurationManager.ConnectionStrings["sqlServer_dbProd"].ConnectionString;
        }
        SqlConnection conn;
        SqlCommand cmd1;
        conn = new SqlConnection(connectionString);

        connectionString = "SELECT * from GISWSL.WA_PWLINK where PW_ID=" + iId.ToString();
        cmd1 = new SqlCommand(connectionString, conn);
        try
        {
            conn.Open();
            //cmd1.Parameters.Add("@p_iId", System.Data.SqlDbType.Int);
            //cmd1.Parameters["@p_iId"].Value = iId;
            SqlDataReader dr = cmd1.ExecuteReader();
            DetailsItem.DataSource = dr;
            DetailsItem.DataKeyNames = new string[] { "PW_ID" };
            DetailsItem.DataBind();

            dr.Close();
            conn.Close();
        }
        catch (Exception er)
        {
            Response.Write(er.Message.ToString());
        }
        finally
        {
            cmd1.Dispose();
            conn.Dispose();
        }
    } 
    protected void GrdLst_SelectedIndexChanged(object sender, EventArgs e)
    {
        int selRowInd = GrdLst.SelectedIndex;
        int id = (int)GrdLst.DataKeys[selRowInd].Value;
        BindDetails( id);
        MultiView1.SetActiveView(VwEdt);
    }
    protected void DetailsItem_ModeChanging(object sender, DetailsViewModeEventArgs e)
    {
        DetailsItem.ChangeMode(e.NewMode);
        int selRowInd = GrdLst.SelectedIndex;
        int id = (int)GrdLst.DataKeys[selRowInd].Value;
        BindDetails(id);
    }


    protected void DetailsView_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
    {
        int iGM_ID = 0;

        string connectionString = "";
        //string t_serverName = Request.ServerVariables["SERVER_NAME"];
        //if (t_serverName.Equals("localhost") || t_serverName.Equals("wsldctgdw"))
        //{
        //    connectionString = ConfigurationManager.ConnectionStrings["sqlServer_dbDev"].ConnectionString;
        //}
        //else if (t_serverName.Equals("wsldctvgtw"))
        //{
        //    connectionString = ConfigurationManager.ConnectionStrings["sqlServer_dbTest"].ConnectionString;
        //}
        //else if (t_serverName.Equals("wsldctvgpw") || t_serverName.Equals("gisweb"))
        //{
        //    connectionString = ConfigurationManager.ConnectionStrings["sqlServer_dbProd"].ConnectionString;
        //}

        //SqlConnection conn;
        //SqlCommand cmd1;
        //conn = new SqlConnection(connectionString);

        connectionString = "UPDATE GISWSL.WA_PWLINK SET PW_REF='@PW_REF', PL_TYPE='@PL_TYPE' WHERE PW_ID=@PW_ID";
        string strVal = "";
        iGM_ID = (int)DetailsItem.DataKey.Value;
        connectionString = connectionString.Replace("@PW_ID", iGM_ID.ToString());

        strVal = (DetailsItem.FindControl("TxtPWRef") as TextBox).Text;
        connectionString = connectionString.Replace("@PW_REF", strVal);
        strVal = (DetailsItem.FindControl("TxtPLType") as TextBox).Text;
        connectionString = connectionString.Replace("@PL_TYPE", strVal);

        Response.Write(connectionString);

        //cmd1 = new SqlCommand(connectionString, conn);
        //try
        //{
        //    conn.Open();

        //    int temp = cmd1.ExecuteNonQuery();
        //    cmd1.Dispose();
        //    conn.Close();
        //}
        //catch (Exception er)
        //{
        //    Response.Write(er.Message.ToString());
        //}
        //finally
        //{
        //    cmd1.Dispose();
        //    conn.Dispose();
        //}

        DetailsItem.ChangeMode(DetailsViewMode.ReadOnly);
        BindDetails((int)GrdLst.DataKeys[GrdLst.SelectedIndex].Value);

    }
    protected void DetailsItem_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
    {
        DetailsView_ItemUpdating(sender, e);
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        MultiView1.SetActiveView(VwLst);
    }
}