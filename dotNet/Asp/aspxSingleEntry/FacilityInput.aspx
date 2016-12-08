<%@ Page Title="" Language="C#" MasterPageFile="MasterPage.master" AutoEventWireup="true" CodeFile="FacilityInput.aspx.cs" Inherits="FacilityInput" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
           <asp:Label ID="LabelSide" runat="server" Font-Italic="true" ForeColor="#186C9D"
                   Style="z-index: 109; left: 190px; position: absolute; top: -60px; height: 39px;" Text="Facility Input"
                   Width="342px"  Font-Size="Large" Font-Bold="True"></asp:Label>
    <table width="830px">
        <tr>
            <td width="50%">
                <asp:Label ID="LblId" runat="server" BackColor="Transparent" BorderColor="#C0FFC0"
                Font-Size="Medium" ForeColor="Black" Text="Id" Width="100px" style="z-index: 103; left: 14px; "></asp:Label>
            </td>
            <td width="50%"><asp:TextBox 
                   ID="TxtId" runat="server" BackColor="White" BorderColor="#C0FFC0"
                    Font-Bold="True" Width="142px" 
                   style="z-index: 104; left: 142px; " MaxLength="8" 
                   Height="22px" ReadOnly="True">SM</asp:TextBox></td>
        </tr>
        <tr>
            <td width="50%">
                <asp:Label ID="LblCode" runat="server" BackColor="Transparent" BorderColor="#C0FFC0"
                Font-Size="Medium" ForeColor="Black" Text="Code" Width="100px" style="z-index: 103; left: 14px; "></asp:Label>
            </td>
            <td width="50%"><asp:TextBox 
                   ID="TxtCode" runat="server" BackColor="White" BorderColor="#C0FFC0"
                    Font-Bold="True" Width="217px" 
                   style="z-index: 104; left: 142px; " MaxLength="8" 
                   Height="22px" ReadOnly="True">SM</asp:TextBox></td>
        </tr>
        <tr>
            <td width="50%">
                <asp:Label ID="LblDesc" runat="server" BackColor="Transparent" BorderColor="#C0FFC0"
                Font-Size="Medium" ForeColor="Black" Text="Description" Width="100px" style="z-index: 103; left: 14px; "></asp:Label>
            </td>
            <td width="50%"><asp:TextBox 
                   ID="TxtDesc" runat="server" BackColor="White" BorderColor="#C0FFC0"
                    Font-Bold="True" Width="295px" 
                   style="z-index: 104; left: 142px; " MaxLength="8" 
                   Height="22px" ReadOnly="True">SM</asp:TextBox></td>
        </tr>
        <tr>
            <td width="50%">&nbsp;
            </td>
            <td width="50%">
                    <asp:Button ID="insBtn" runat="server" BackColor="#CCCCFF" BorderColor="#C0FFC0"
                        Height="37px" OnClick="insBtn_Click" Text="Save" Width="108px" style="z-index: 138; left: 397px; " />&nbsp;
                           <asp:Button ID="CancelBtn" runat="server" CommandName="Cancel" BackColor="#CCCCFF" BorderColor="#80FF80"
                               Height="37px" Style="z-index: 140; left: 244px;"
                               Text="Cancel" Width="115px" OnClick="CancelBtn_Click" />
            </td>
        </tr>

        <tr>
            <td width="50%">&nbsp;</td>
            <td width="50%">
                    <asp:TextBox ID="TextBox1" runat="server" Width="216px"></asp:TextBox>
                    <asp:Button ID="Button7" runat="server" OnClick="Button7_Click" Text="Button" />
                    <br />
                    <asp:Calendar ID="Calendar1" runat="server" OnSelectionChanged="Calendar1_SelectionChanged"></asp:Calendar>
            </td>
        </tr>

    </table>
</asp:Content>

