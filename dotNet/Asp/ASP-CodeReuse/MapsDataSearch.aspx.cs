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
using System.Data.SqlClient;
using System.Data.OleDb;



public partial class MapsDataSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ((MasterPage)Page.Master).Button4_Click(sender, e);
            //string oradb = "Data Source=WSL;Max Pool Size=5;User Id=GMan;Password=GMantest;Pooling=true";
            string opr = DropDownList1.SelectedItem.Value;
            fRecords(opr, "none");
        }        
    }
    protected void OprSearchLink_Click(object sender, EventArgs e)
    {
        MultiView1.SetActiveView(View1);
        //string oradb = "Data Source=WSL;Max Pool Size=5;User Id=GMan;Password=GMantest;Pooling=true";
        string opr = DropDownList1.SelectedItem.Value;
        fRecords(opr, "none");
    }
    protected void DCSearchLink_Click(object sender, EventArgs e)
    {
        MultiView1.SetActiveView(View2);
        //string oradb = "Data Source=WSL;Max Pool Size=5;User Id=GMan;Password=GMantest;Pooling=true";        
        fRecords("none");
    }
    private void fRecords(string connectString)
    {
        string connectionString = "";
        connectionString = AppSample.App_Code.cUtilFile.getConnectionString();
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
        String vSqlStr = "SELECT GIS_REF from GA_MAPS order by GIS_REF DESC";
        DataTable vDtTbl = null;
        //SqlConnection conn;
        //SqlCommand cmd1;        
        //conn = new SqlConnection (connectionString);
        //cmd1 = new SqlCommand("SELECT GIS_REF from GISWSL.GA_MAPS order by GIS_REF DESC",conn );
        try
        {
            vDtTbl = AppSample.App_Code.cUtilFile.getDataFAccessTable(connectionString, vSqlStr);
            //    conn.Open();
            //    SqlDataReader dr = cmd1.ExecuteReader();
            //    DropDownList2.DataSource = dr;
            DropDownList2.DataSource = vDtTbl;
            DropDownList2.DataValueField = "GIS_REF";
            DropDownList2.DataBind();
            // DropDownList2.SelectedIndex = 0;            
            //    dr.Close();
            //    conn.Close();            
        }
        catch (Exception er)
        {
            Label1.Visible = true;
            Label1.Text += "-::-" + er.Message.ToString();
        }
        finally
        {
            //if (conn.State == ConnectionState.Open)
            //{
            //    conn.Dispose();
            //}
            vDtTbl = null;
        }
    }

    protected void fRecords(string userN, string connectString)
    {
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
        connectionString = AppSample.App_Code.cUtilFile.getConnectionString();
        lblMsg.Text = connectionString;

        String vSqlStr = string.Format("SELECT * from GA_MAPS where {0} order by GA_ID DESC", userN);
        DataTable vDtTbl = null;

        //SqlConnection conn;
        //SqlCommand cmd1;
        //conn = new SqlConnection(connectionString);
        //cmd1 = new SqlCommand("SELECT * from GISWSL.GA_MAPS where " + userN + " order by GA_ID DESC", conn);
        try
        {
            //conn.Open();
            //SqlDataReader dr = cmd1.ExecuteReader();
            //DataSet ds = new DataSet();
            //SqlDataAdapter da = new SqlDataAdapter(cmd1.CommandText.ToString(), conn);
            //da.Fill(ds);
            vDtTbl = AppSample.App_Code.cUtilFile.getDataFAccessTable(connectionString, vSqlStr);

            lblMsg.Text = vDtTbl.Rows.Count.ToString();

            GridView1.DataSource = vDtTbl;
            GridView1.DataKeyNames = new string[] { "GA_ID" };
            GridView1.DataBind();
            //dr.Close();
            //conn.Close();
        }
        catch (Exception er)
        {
            Label1.Visible = true;
            Label1.Text += "-::-" + er.Message.ToString();
        }
        finally
        {
            //if (conn.State == ConnectionState.Open)
            //{
            //    conn.Dispose();
            //}
            vDtTbl = null;
        }
    }

    protected void fRecords2(string userN, string connectString)
    {
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
        connectionString = AppSample.App_Code.cUtilFile.getConnectionString();

        String vSqlStr = string.Format("SELECT * from GA_MAPS where GIS_REF = '{0}' order by GA_ID DESC", userN);
        DataTable vDtTbl = null;


        //SqlConnection conn;
        //SqlCommand cmd1;
        //conn = new SqlConnection(connectionString);
        //cmd1 = new SqlCommand("SELECT * from GISWSL.GA_MAPS where GIS_REF = '" + userN + "' order by GA_ID DESC", conn);
        try
        {
            //conn.Open();
            //SqlDataReader dr = cmd1.ExecuteReader();

            vDtTbl = AppSample.App_Code.cUtilFile.getDataFAccessTable(connectionString, vSqlStr);

            //GridView2.DataSource = dr;
            GridView2.DataSource = vDtTbl;
            GridView2.DataKeyNames = new string[] { "GA_ID" };
            GridView2.DataBind();
            //dr.Close();
            //conn.Close();
            Label1.Text += "view2";
        }
        catch (Exception er)
        {
            Label1.Visible = true;
            Label1.Text += "-::-" + er.Message.ToString();
        }
        finally
        {
            //if (conn.State == ConnectionState.Open)
            //{
            //    conn.Dispose();
            //}
            vDtTbl = null;
        }
    }
    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        OprSearchLink_Click(sender,e);
    }

    protected void DropDownList2_SelectedIndexChanged(object sender, EventArgs e)
    {
        string oradb = "Data Source=WSL;Max Pool Size=5;User Id=GMan;Password=GMantest;Pooling=true";
        string opr = DropDownList2.SelectedItem.Value;
        fRecords2(opr, oradb);
    }

    protected void DropDownList2_Init(object sender, EventArgs e)
    {
    }
    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        int newPageIndex = e.NewPageIndex;
        string opr = DropDownList1.SelectedItem.Value;
        GridView1.PageIndex = newPageIndex;
        GridView1.SelectedIndex = -1;
        fRecords(opr, "none");        
    }
    protected void GridView1_PageIndexChanged(object sender, EventArgs e)
    {
    }
    protected void GridView1_Init(object sender, EventArgs e)
    {
    }
    protected void GridView2_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        int newPageIndex = e.NewPageIndex;
        string opr = DropDownList2.SelectedItem.Value;        
        GridView2.PageIndex = newPageIndex;
        GridView2.SelectedIndex = -1;
        fRecords(opr, "none");
    }
    private void BindDetails(int selRowInd, int id, string viewX)
    {
        int selRowIndex = selRowInd;
        int iId = id;
        string connectionString = "";
        
        connectionString = AppSample.App_Code.cUtilFile.getConnectionString(); 
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

        String vSqlStr = string.Format("SELECT * from GA_MAPS where GA_ID={0}", iId);
        DataTable vDtTbl = null;
        vDtTbl = AppSample.App_Code.cUtilFile.getDataFAccessTable (connectionString, vSqlStr);
        //vDtTbl = AppSample.App_code.cUtilFile.getDataFSQLTable(connectionString, vSqlStr);
        if (viewX == "one")
        {
            JRDetailsView1.DataSource = vDtTbl;
            JRDetailsView1.DataKeyNames = new string[] { "GA_ID" };
            JRDetailsView1.DataBind();
        }
        if (viewX == "two")
        {
            JRDetailsView2.DataSource = vDtTbl;
            JRDetailsView2.DataKeyNames = new string[] { "GA_ID" };
            JRDetailsView2.DataBind();
        }

        ////SqlConnection conn;
        ////SqlCommand cmd1;
        ////conn = new SqlConnection(connectionString);
        ////cmd1 = new SqlCommand("SELECT * from GA_MAPS where GA_ID=@p_iId", conn);
        //////cmd1 = new SqlCommand("SELECT * from GISWSL.GA_MAPS where GA_ID=@p_iId", conn);
        ////try
        ////{
        ////    conn.Open();
        ////    cmd1.Parameters.Add("@p_iId", System.Data.SqlDbType.Int);
        ////    cmd1.Parameters["@p_iId"].Value = iId;
        ////    SqlDataReader dr = cmd1.ExecuteReader();
        ////    if (viewX == "one")
        ////    {
        ////        JRDetailsView1.DataSource = dr;
        ////        JRDetailsView1.DataKeyNames = new string[] { "GA_ID" };
        ////        JRDetailsView1.DataBind();
        ////    }
        ////    if (viewX == "two")
        ////    {
        ////        JRDetailsView2.DataSource = dr;
        ////        JRDetailsView2.DataKeyNames = new string[] { "GA_ID" };
        ////        JRDetailsView2.DataBind();
        ////    }
        ////    dr.Close();
        ////    conn.Close();
        ////}
        ////catch (Exception er)
        ////{
        ////    Response.Write(er.Message.ToString());
        ////}
        ////finally
        ////{
        ////    if (conn.State == ConnectionState.Open)
        ////    {
        ////        conn.Dispose();
        ////    }
        ////}
    }      
    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        int selRowInd =GridView1.SelectedIndex;
        int id = (int)GridView1.DataKeys[selRowInd].Value;
        BindDetails(selRowInd, id, "one"); 
    }
    protected void DetailsView_ItemUpdating(object sender, DetailsViewUpdateEventArgs e, string view)
    {
        int iGM_ID=0;
        TextBox New_dateReqBox=null; 
        TextBox New_ReqFromBox=null; 
        TextBox New_descriBox=null;
        TextBox New_ReferBox=null;
        TextBox New_captureByBox=null;
        TextBox New_DCdtBox=null;
        TextBox New_cmntsBox=null;

        if(view == "one"){
        iGM_ID = (int)JRDetailsView1.DataKey.Value;
        New_dateReqBox = (TextBox)JRDetailsView1.FindControl("TextBoxDt");
        New_ReqFromBox = (TextBox)JRDetailsView1.FindControl("TextBox1");
        New_descriBox = (TextBox)JRDetailsView1.FindControl("TextBox2");
        New_ReferBox = (TextBox)JRDetailsView1.FindControl("TextBox4");
        New_captureByBox = (TextBox)JRDetailsView1.FindControl("TextBox10");
        New_DCdtBox = (TextBox)JRDetailsView1.FindControl("TextBoxDCapDt");
        New_cmntsBox = (TextBox)JRDetailsView1.FindControl("TextBox9");
        }
        if(view == "two"){
        iGM_ID = (int)JRDetailsView2.DataKey.Value;
        New_dateReqBox = (TextBox)JRDetailsView2.FindControl("TextBoxDt");
        New_ReqFromBox = (TextBox)JRDetailsView2.FindControl("TextBox1");
        New_descriBox = (TextBox)JRDetailsView2.FindControl("TextBox2");
        New_ReferBox = (TextBox)JRDetailsView2.FindControl("TextBox4"); 
        New_captureByBox = (TextBox)JRDetailsView2.FindControl("TextBox10");
        New_DCdtBox = (TextBox)JRDetailsView2.FindControl("TextBoxDCapDt");
        New_cmntsBox = (TextBox)JRDetailsView2.FindControl("TextBox9");
	    }
        //string oradb = "Data Source=WSL;Max Pool Size=10;User Id=GMan;Password=GMantest;Pooling=true";
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
        cmd1 = new SqlCommand("UPDATE GISWSL.GA_MAPS SET REQUESTED_BY=@p_From,DATE_R=@p_StrtDate,DESCRIPTION=@p_Desc, REFERENCE=@p_Ref, CAPTURED_BY=@p_CapBy,DATE_C=@p_DataCapDt,COMMENTS=@p_cmnts WHERE GA_ID=" + iGM_ID, conn);
        try
        {
            conn.Open();

            //Requested By
            cmd1.Parameters.Add("@p_From", System.Data.SqlDbType.VarChar);
            if (New_ReqFromBox.Text != "")
            {
                cmd1.Parameters["@p_From"].Value = New_ReqFromBox.Text;
            }
            else
            {
                cmd1.Parameters["@p_From"].Value = DBNull.Value;
            }
            //Date Requested Date_R
            cmd1.Parameters.Add("@p_StrtDate", System.Data.SqlDbType.Date);
            if (New_dateReqBox.Text != "")
            {
                cmd1.Parameters["@p_StrtDate"].Value = New_dateReqBox.Text;
            }
            else
            {
                cmd1.Parameters["@p_StrtDate"].Value = DBNull.Value;
            }
            //Desc          
            cmd1.Parameters.Add("@p_Desc", System.Data.SqlDbType.VarChar);
            if (New_descriBox.Text != "")
            {
                cmd1.Parameters["@p_Desc"].Value = New_descriBox.Text;
            }
            else
            {
                cmd1.Parameters["@p_Desc"].Value = DBNull.Value;
            }
            //Reference
            cmd1.Parameters.Add("@p_Ref", System.Data.SqlDbType.VarChar);
            if (New_ReferBox.Text != "")
            {
                cmd1.Parameters["@p_Ref"].Value = New_ReferBox.Text;
            }
            else
            {
                cmd1.Parameters["@p_Ref"].Value = DBNull.Value;
            }

            //Captured By  p_CapBy
            cmd1.Parameters.Add("@p_CapBy", System.Data.SqlDbType.VarChar);
            if (New_captureByBox.Text != "")
            {
                cmd1.Parameters["@p_CapBy"].Value = New_captureByBox.Text;
            }
            else
            {
                cmd1.Parameters["@p_CapBy"].Value = DBNull.Value;
            }
            //Data Capture Date p_DataCapDt
            cmd1.Parameters.Add("@p_DataCapDt", System.Data.SqlDbType.Date);
            if (New_DCdtBox.Text != "")
            {
                cmd1.Parameters["@p_DataCapDt"].Value = New_DCdtBox.Text;
            }
            else
            {
                cmd1.Parameters["@p_DataCapDt"].Value = DBNull.Value;
            }
            //comments
            cmd1.Parameters.Add("@p_cmnts", System.Data.SqlDbType.VarChar);
            if (New_cmntsBox.Text != "")
            {
                cmd1.Parameters["@p_cmnts"].Value = New_cmntsBox.Text;
            }
            else
            {
                cmd1.Parameters["@p_cmnts"].Value = DBNull.Value;
            }
            int temp = cmd1.ExecuteNonQuery();
            cmd1.Dispose();
            conn.Close();
        }
        catch (Exception er)
        {
            Response.Write(er.Message.ToString());
        }
        finally
        {
            if (conn.State == ConnectionState.Open)
            {
                conn.Dispose();
            }
        }
		if (view =="one"){
            JRDetailsView1.ChangeMode(DetailsViewMode.ReadOnly);
            DropDownList1_SelectedIndexChanged(sender, e);
            BindDetails(GridView1.SelectedIndex, (int)GridView1.DataKeys[GridView1.SelectedIndex].Value, "one");
		}

        if (view =="two"){
            JRDetailsView2.ChangeMode(DetailsViewMode.ReadOnly);
            DropDownList2_SelectedIndexChanged(sender, e);
            BindDetails(GridView2.SelectedIndex, (int)GridView2.DataKeys[GridView2.SelectedIndex].Value, "two");            
		}
    }

    protected void JRDetailsView1_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
    {
        DetailsView_ItemUpdating(sender, e, "one");
    }
    protected void JRDetailsView1_ModeChanging(object sender, DetailsViewModeEventArgs e)
    {
        JRDetailsView1.ChangeMode(e.NewMode); 
        int selRowInd = GridView1.SelectedIndex;
        int id = (int)GridView1.DataKeys[selRowInd].Value;        
        BindDetails(selRowInd, id,"one");
    }
    protected void JRDetailsView1_PageIndexChanging(object sender, DetailsViewPageEventArgs e)
    {
    }
    protected void JRDetailsView2_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
    {
        DetailsView_ItemUpdating(sender, e, "two");
    }
    protected void JRDetailsView2_ModeChanging(object sender, DetailsViewModeEventArgs e)
    {
        JRDetailsView2.ChangeMode(e.NewMode);
        int selRowInd = GridView2.SelectedIndex;
        int id = (int)GridView2.DataKeys[selRowInd].Value;
        BindDetails(selRowInd, id, "two");
    }
    protected void JRDetailsView2_PageIndexChanging(object sender, DetailsViewPageEventArgs e)
    {
    }
    protected void GridView2_SelectedIndexChanged(object sender, EventArgs e)
    {
            int selRowInd = GridView2.SelectedIndex;
            int id = (int)GridView2.DataKeys[selRowInd].Value;
            BindDetails(selRowInd, id, "two");
    }
    protected void MapsInput_Click(object sender, EventArgs e)
    {
        Response.Redirect("MapsInput.aspx");
    }
    
}
