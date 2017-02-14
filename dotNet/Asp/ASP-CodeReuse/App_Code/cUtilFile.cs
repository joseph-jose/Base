using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Data.Common;
using System.Data.OleDb;

namespace AppSample.App_Code
{
/// <summary>
/// Summary description for cUtilFile
/// </summary>
public static class cUtilFile
{
    //public cUtilFile()
    //{
    //    //
    //    // TODO: Add constructor logic here
    //    //
    //}

    //~cUtilFile()
    //{
    //}

    public static string getConnectionString()
    {
        string retConnStr = "";
        string t_serverName = HttpContext.Current.Request.ServerVariables["SERVER_NAME"];

            if (t_serverName.Equals("wsldctgdw"))
            {
                retConnStr = ConfigurationManager.ConnectionStrings["sqlServer_dbDev"].ConnectionString;
            }
            else if (t_serverName.Equals("wsldctvgtw"))
            {
                retConnStr = ConfigurationManager.ConnectionStrings["sqlServer_dbTest"].ConnectionString;
            }
            else if (t_serverName.Equals("wsldctvgpw") || t_serverName.Equals("gisweb"))
            {
                retConnStr = ConfigurationManager.ConnectionStrings["sqlServer_dbProd"].ConnectionString;
            }
            else
            {
                retConnStr = ConfigurationManager.ConnectionStrings["sqlAccess_dbLocal"].ConnectionString;
            }
            return retConnStr;
    }

    public static DataTable getDataFSQLTable(string inConnStr, string inSql)
    {
        DataTable retDtTbl = new DataTable();
        SqlConnection conn;
        SqlCommand cmd1;
        conn = new SqlConnection(inConnStr);
        //cmd1 = new SqlCommand("SELECT * from GA_MAPS where GA_ID=@p_iId", conn);
        cmd1 = new SqlCommand(inSql, conn);
        try
        {
            conn.Open();
            //cmd1.Parameters.Add("@p_iId", System.Data.SqlDbType.Int);
            //cmd1.Parameters["@p_iId"].Value = iId;
            SqlDataReader dr = cmd1.ExecuteReader();

            retDtTbl.Load(dr); 

            //if (viewX == "one")
            //{
            //    JRDetailsView1.DataSource = dr;
            //    JRDetailsView1.DataKeyNames = new string[] { "GA_ID" };
            //    JRDetailsView1.DataBind();
            //}
            //if (viewX == "two")
            //{
            //    JRDetailsView2.DataSource = dr;
            //    JRDetailsView2.DataKeyNames = new string[] { "GA_ID" };
            //    JRDetailsView2.DataBind();
            //}
            dr.Close();
            conn.Close();
        }
        catch (Exception er)
        {
            HttpContext.Current.Response.Write(er.Message.ToString());
        }
        finally
        {
            if (conn.State == ConnectionState.Open)
            {
                conn.Dispose();
            }
        }
        return retDtTbl;
    }


        public static DataTable getDataFAccessTable(string inConnStr, string inSql)
        {
            DbProviderFactory dbFactory;
            dbFactory = OleDbFactory.Instance;
            DbConnection cnADO = dbFactory.CreateConnection();
            //'Add the string to specify to use s engine with the database path
            cnADO.ConnectionString = inConnStr;
            //cnADO.Open();

            DataTable retDtTbl = new DataTable();
            //SqlConnection conn;
            //SqlCommand cmd1;
            DbCommand vDbCmd = dbFactory.CreateCommand();
            vDbCmd.Connection = cnADO;
            vDbCmd.CommandText = inSql;
            //conn = new SqlConnection(inConnStr);
            //cmd1 = new SqlCommand("SELECT * from GA_MAPS where GA_ID=@p_iId", conn);
            //cmd1 = new SqlCommand(inSql, cnADO);
            try
            {
                cnADO.Open();
                DbDataReader dr = vDbCmd.ExecuteReader();

                retDtTbl.Load(dr);

                dr.Close();
                cnADO.Close();
            }
            catch (Exception er)
            {
                throw er;
                //HttpContext.Current.Response.Write(er.Message.ToString());
            }
            finally
            {
                if (cnADO.State == ConnectionState.Open)
                {
                    cnADO.Dispose();
                }
            }
            return retDtTbl;
        }
        public static bool setDataFAccessTable(string inConnStr, string inSql)
        {
            bool vRetRes = false;

            DbProviderFactory dbFactory;
            dbFactory = OleDbFactory.Instance;
            DbConnection cnADO = dbFactory.CreateConnection();
            //'Add the string to specify to use s engine with the database path
            cnADO.ConnectionString = inConnStr;
            //cnADO.Open();

            //SqlConnection conn;
            //SqlCommand cmd1;
            DbCommand vDbCmd = dbFactory.CreateCommand();
            vDbCmd.Connection = cnADO;
            vDbCmd.CommandText = inSql;
            //conn = new SqlConnection(inConnStr);
            //cmd1 = new SqlCommand("SELECT * from GA_MAPS where GA_ID=@p_iId", conn);
            //cmd1 = new SqlCommand(inSql, cnADO);
            try
            {
                cnADO.Open();
                vDbCmd.ExecuteNonQuery();

                cnADO.Close();
                vRetRes = true;
            }
            catch (Exception er)
            {
                HttpContext.Current.Response.Write(er.Message.ToString());
            }
            finally
            {
                if (cnADO.State == ConnectionState.Open)
                {
                    cnADO.Dispose();
                }
            }
            return vRetRes;

        }


    }

}
