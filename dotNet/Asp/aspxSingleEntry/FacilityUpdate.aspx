<%@ Page Title="" Language="C#" MasterPageFile="MasterPage.master" AutoEventWireup="true" CodeFile="FacilityUpdate.aspx.cs" Inherits="FacilityUpdate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
           <asp:Label ID="LabelSide" runat="server" Font-Italic="true" ForeColor="#186C9D"
                   Style="z-index: 109; left: 190px; position: absolute; top: -60px; height: 39px;" Text="Facility Update"
                   Width="342px"  Font-Size="Large" Font-Bold="True"></asp:Label>
    <br />
    <asp:LinkButton ID="LinkButton1" runat="server" Width="217px" OnClick="LinkButton1_Click">Search by description</asp:LinkButton><asp:LinkButton ID="LinkButton2" runat="server" Width="159px" OnClick="LinkButton2_Click">Data Input</asp:LinkButton>
    <br />
    <br />
    <br />
    <br />
    <br />
    <asp:MultiView ID="MultiView1" runat="server">
        <asp:View ID="VwLst" runat="server">
            <asp:GridView ID="GrdLst" runat="server" AutoGenerateColumns="False" EnableModelValidation="True" ShowFooter="True" AllowPaging="True" OnPageIndexChanging="GrdLst_PageIndexChanging" PageSize="20" OnSelectedIndexChanged="GrdLst_SelectedIndexChanged">
                <Columns>
                    <asp:BoundField DataField="PW_Id" HeaderText="Id" />
                    <asp:BoundField DataField="PW_Ref" HeaderText="Code" />
                    <asp:BoundField DataField="PL_Type" HeaderText="Description" />
                    <asp:ButtonField CommandName="Select" Text="Edit.." />
                </Columns>
                <EditRowStyle BackColor="#0033CC" />
                <SelectedRowStyle BackColor="#6D80FC" />
            </asp:GridView>
            <br />

        </asp:View>
        <br />
        <asp:View ID="VwEdt" runat="server">
            <asp:DetailsView ID="DetailsItem" runat="server" Height="50px" Width="125px" AutoGenerateRows="False" EnableModelValidation="True" OnModeChanging="DetailsItem_ModeChanging" OnItemUpdating="DetailsItem_ItemUpdating">
                <Fields>
                    <asp:TemplateField HeaderText="Id">
                        <EditItemTemplate>
                            <asp:TextBox ID="TxtPWID" runat="server" Text='<%# Bind("PW_ID") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="TxtPWID" runat="server" Text='<%# Bind("PW_ID") %>'></asp:TextBox>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label3" runat="server" Text='<%# Bind("PW_ID") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Code">
                        <EditItemTemplate>
                            <asp:TextBox ID="TxtPWRef" runat="server" Text='<%# Bind("PW_Ref") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="TxtPWRef" runat="server" Text='<%# Bind("PW_Ref") %>'></asp:TextBox>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label2" runat="server" Text='<%# Bind("PW_Ref") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Description">
                        <EditItemTemplate>
                            <asp:TextBox ID="TxtPLType" runat="server" Text='<%# Bind("PL_Type") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="TxtPLType" runat="server" Text='<%# Bind("PL_Type") %>'></asp:TextBox>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("PL_Type") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:CommandField InsertVisible="False" ShowEditButton="True" />
                </Fields>

            </asp:DetailsView>
            <br />
            <asp:Button ID="Button1" runat="server" Text="Back" OnClick="Button1_Click" />
            <a href="www.msn.com">Back</a>
        </asp:View>
    </asp:MultiView>
</asp:Content>

