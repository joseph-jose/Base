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
using AppSample.App_Code;

namespace AppSample
{ 
public partial class MapsDataInput : System.Web.UI.Page
{

    protected void MonthChange(Object sender, MonthChangedEventArgs e)
    {
        Calendar1.Visible = true;
    }
    protected void DCMonthChange(Object sender, MonthChangedEventArgs e)
    {
        Calendar3.Visible = true;
    }

    protected void MyCalendar_SelectionChanged(object sender, System.EventArgs e)
    {
        DtTxtBox.Text = Calendar1.SelectedDate.ToShortDateString();
        Calendar1.Visible = false;
    }
    protected void DC_SelectionChanged(object sender, System.EventArgs e)
    {
        DCDateTxtBox.Text = Calendar3.SelectedDate.ToShortDateString();
        Calendar3.Visible = false;
    }

    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ((MasterPage)Page.Master).Button4_Click(sender, e); 
            Calendar1.Visible = false;
            Calendar3.Visible = false;            
            DCapTxtBox.Text = DropDownList1.SelectedItem.Value;
        }
        else
        {
            insBtn.Enabled = true;
        }
    }

    private string quoteStr(string inStr)
    {
        return "'" + inStr + "'";
    }

    protected void insBtn_Click(object sender, EventArgs e)
    {
        if ((DCRefTxtBox.Text == "SMTest") || (DCRefTxtBox.Text == "")) 
        {
            LabelErr.Text = "Enter Valid SM Reference";
        }
        else
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

            string vp_GISRef, vp_From, vp_StrtDate, vp_Desc, vp_Ref, vp_CapBy, vp_DataCapDt, vp_cmnts;
            //DCRef
            if (DCRefTxtBox.Text != "") vp_GISRef = quoteStr( DCRefTxtBox.Text);
            else
                vp_GISRef = "Null";
            //Requested By
            if (FromTxtBox.Text != "")
            {
                vp_From = quoteStr(FromTxtBox.Text);
            }
            else
            {
                vp_From = "Null";
            }
            //Date Requested Date_R
            if (DtTxtBox.Text != "")
            {
                vp_StrtDate = quoteStr(DtTxtBox.Text);
            }
            else
            {
                vp_StrtDate = "Null";
            }
            //Desc          
            if (DescTxtBox.Text != "")
            {
                vp_Desc = quoteStr(DescTxtBox.Text);
            }
            else
            {
                vp_Desc = "Null";
            }
            //Reference
            if (SrcTxtBox.Text != "")
            {
                vp_Ref = quoteStr(SrcTxtBox.Text);
            }
            else
            {
                vp_Ref = "Null";
            }

            //Captured By  p_CapBy
            if (DCapTxtBox.Text != "")
            {
                vp_CapBy = quoteStr(DCapTxtBox.Text);
            }
            else
            {
                vp_CapBy = "Null";
            }
            //Data Capture Date p_DataCapDt
            if (DCDateTxtBox.Text != "")
            {
                vp_DataCapDt = quoteStr(DCDateTxtBox.Text);
            }
            else
            {
                vp_DataCapDt = "Null";
            }

            //comments
            if (CmntTxtBox.Text != "")
            {
                vp_cmnts = quoteStr(CmntTxtBox.Text);
            }
            else
            {
                vp_cmnts = "Null";
            }

            String vSqlStr = "INSERT INTO GA_MAPS (GIS_REF,REQUESTED_BY,DATE_R,DESCRIPTION,REFERENCE,CAPTURED_BY,DATE_C,COMMENTS)VALUES ({0},{1},{2},{3},{4},{5},{6},{7})";
            vSqlStr = string.Format(vSqlStr, vp_GISRef, vp_From, vp_StrtDate, vp_Desc, vp_Ref, vp_CapBy, vp_DataCapDt, vp_cmnts);

            //SqlConnection conn;
            //SqlCommand cmd1;            
            //conn = new SqlConnection(connectionString);
            //cmd1 = new SqlCommand("INSERT INTO GISWSL.GA_MAPS (GIS_REF,REQUESTED_BY,DATE_R,DESCRIPTION,REFERENCE,CAPTURED_BY,DATE_C,COMMENTS)VALUES (@p_GISRef,@p_From,@p_StrtDate,@p_Desc,@p_Ref,@p_CapBy,@p_DataCapDt,@p_cmnts)", conn);
            ////cmd1 = new SqlCommand ("INSERT INTO GM_DATACAPTURE (GIS_REF,REQUESTED_BY,DATE_R,DESCRIPTION,LOCATION,REFERENCE,DRAWING_NOS,SURVEYED_BY,CAPTURED_BY,DATE_C,NETWORK,STATUS,COMMENTS)VALUES (:p_GISRef,:p_From,:p_StrtDate,:p_Desc,:p_Locn,:p_Ref,:p_AsBlt,:p_Oper,:p_CapBy,:p_DataCapDt,:p_netwrk,:p_status,:p_cmnts)",conn );
            //cmd1.Parameters.Add("@p_GISRef", System.Data.SqlDbType.VarChar);

            ////DCRef
            //if (DCRefTxtBox.Text != "")
            //{
            //    cmd1.Parameters["@p_GISRef"].Value = DCRefTxtBox.Text;
            //}
            //else
            //{
            //    cmd1.Parameters["@p_GISRef"].Value = DBNull.Value;
            //}
            //cmd1.Parameters.Add("@p_From", System.Data.SqlDbType.VarChar);
            ////Requested By
            //if (FromTxtBox.Text != "")
            //{
            //    cmd1.Parameters["@p_From"].Value = FromTxtBox.Text;
            //}
            //else
            //{
            //    cmd1.Parameters["@p_From"].Value = DBNull.Value;
            //}
            ////Date Requested Date_R
            //cmd1.Parameters.Add("@p_StrtDate", System.Data.SqlDbType.Date);
            //if (DtTxtBox.Text != "")
            //{
            //    cmd1.Parameters["@p_StrtDate"].Value = DtTxtBox.Text;
            //}
            //else
            //{
            //    cmd1.Parameters["@p_StrtDate"].Value = DBNull.Value;
            //}
            ////Desc          
            //cmd1.Parameters.Add("@p_Desc", System.Data.SqlDbType.VarChar);
            //if (DescTxtBox.Text != "")
            //{
            //    cmd1.Parameters["@p_Desc"].Value = DescTxtBox.Text;
            //}
            //else
            //{
            //    cmd1.Parameters["@p_Desc"].Value = DBNull.Value;
            //}
            ////Reference
            //cmd1.Parameters.Add("@p_Ref", System.Data.SqlDbType.VarChar);
            //if (SrcTxtBox.Text != "")
            //{
            //    cmd1.Parameters["@p_Ref"].Value = SrcTxtBox.Text;
            //}
            //else
            //{
            //    cmd1.Parameters["@p_Ref"].Value = DBNull.Value;
            //}

            ////Captured By  p_CapBy
            //cmd1.Parameters.Add("@p_CapBy", System.Data.SqlDbType.VarChar);
            //if (DCapTxtBox.Text != "")
            //{
            //    cmd1.Parameters["@p_CapBy"].Value = DCapTxtBox.Text;
            //}
            //else
            //{
            //    cmd1.Parameters["@p_CapBy"].Value = DBNull.Value;
            //}
            ////Data Capture Date p_DataCapDt
            //cmd1.Parameters.Add("@p_DataCapDt", System.Data.SqlDbType.Date);
            //if (DCDateTxtBox.Text != "")
            //{
            //    cmd1.Parameters["@p_DataCapDt"].Value = DCDateTxtBox.Text;
            //}
            //else
            //{
            //    cmd1.Parameters["@p_DataCapDt"].Value = DBNull.Value;
            //}

            ////comments
            //cmd1.Parameters.Add("@p_cmnts", System.Data.SqlDbType.VarChar);
            //if (CmntTxtBox.Text != "")
            //{
            //    cmd1.Parameters["@p_cmnts"].Value = CmntTxtBox.Text;
            //}
            //else
            //{
            //    cmd1.Parameters["@p_cmnts"].Value = DBNull.Value;
            //}

            try
            {

                //conn.Open();
                //cmd1.ExecuteNonQuery();
                AppSample.App_Code.cUtilFile.setDataFAccessTable(connectionString, vSqlStr);
                DCRefTxtBox.Text = "SM";

            }
            catch (Exception er)
            {
                PanelMain.Visible = false;

                Label16.Text += "-::-" + er.Message.ToString() + " Source: " + er.Source + "trace: " + er.StackTrace;
                Label16.Visible = true;
                Response.Write("-::-" + er.Message.ToString() + " Source: " + er.Source + "trace: " + er.StackTrace);
            }
            finally
            {
                Response.Redirect("MapsDataSearch.aspx");

                //if (conn.State == ConnectionState.Open)
                //{
                //    conn.Close();
                //    conn.Dispose();
                //}
            } 
        }
    }    

    protected void DtButton_ServerClick(object sender, EventArgs e)
    {
        Calendar1.Visible = true;
    }

    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        DCapTxtBox.Text = DropDownList1.SelectedItem.Value;
    }
    protected void DCapTxtBox_TextChanged(object sender, EventArgs e)
    {

    }

    protected void DCButton_Click(object sender, EventArgs e)
    {
        Calendar3.Visible = true;
    }



    protected void CancelBtn_Click(object sender, EventArgs e)
    {
        Session["ViewState"] = null;
        Response.Redirect("MapsInput.aspx");
    }
}

}

