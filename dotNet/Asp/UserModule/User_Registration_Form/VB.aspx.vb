Imports System.Data
Imports System.Configuration
Imports System.Data.SqlClient
Partial Class VB
    Inherits System.Web.UI.Page

    Protected Sub RegisterUser(sender As Object, e As EventArgs)
        Dim userId As Integer = 0
        Dim constr As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString
        Using con As New SqlConnection(constr)
            Using cmd As New SqlCommand("Insert_User")
                Using sda As New SqlDataAdapter()
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@Username", txtUsername.Text.Trim())
                    cmd.Parameters.AddWithValue("@Password", txtPassword.Text.Trim())
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim())
                    cmd.Connection = con
                    con.Open()
                    userId = Convert.ToInt32(cmd.ExecuteScalar())
                    con.Close()
                End Using
            End Using
            Dim message As String = String.Empty
            Select Case userId
                Case -1
                    message = "Username already exists.\nPlease choose a different username."
                    Exit Select
                Case -2
                    message = "Supplied email address has already been used."
                    Exit Select
                Case Else
                    message = "Registration successful.\nUser Id: " + userId.ToString()
                    Exit Select
            End Select
            ClientScript.RegisterStartupScript([GetType](), "alert", (Convert.ToString("alert('") & message) + "');", True)
        End Using
    End Sub
End Class
