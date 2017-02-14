<%@ Page Language="C#" MasterPageFile="MasterPage.master" AutoEventWireup="true" CodeFile="MapsDataSearch.aspx.cs" Inherits="MapsDataSearch" Title="Map Data Update" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
           <asp:Label ID="LabelSide" runat="server" Font-Italic="true" ForeColor="#186C9D"
                   Style="z-index: 109; left: 190px; position: absolute; top: -60px; height: 39px;" Text="Special Maps (SM)"
                   Width="342px"  Font-Size="Large" Font-Bold="True"></asp:Label>
    <br />
    <asp:LinkButton ID="OprSearchLink" runat="server" OnClick="OprSearchLink_Click" Width="177px">Search</asp:LinkButton>
    &nbsp;
    <asp:LinkButton
        ID="DCSearchLink" runat="server" OnClick="DCSearchLink_Click" Width="177px">Search By Map Ref</asp:LinkButton>
    &nbsp;
    <asp:LinkButton
        ID="MapsInput" runat="server" OnClick="MapsInput_Click" Width="177px">Maps Data Input </asp:LinkButton>
    &nbsp;
    &nbsp;
     &nbsp;&nbsp;&nbsp;&nbsp;
    <br />
    <asp:Label ID="Label1" runat="server" Visible="False" Width="553px"></asp:Label><br />
    &nbsp;
    <asp:Panel ID="Panel1" runat="server" Height="277px" Style="z-index: 100; left: 5px;
        position: absolute; top: 86px" Width="776px">
    <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">
    <asp:View id="View1" runat="server">
        List Jobs:&nbsp;<asp:DropDownList ID="DropDownList1" runat="server" Height="23px"
            Width="119px" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged" AutoPostBack="True">
            <asp:ListItem Value="DATE_C IS NULL">Incomplete</asp:ListItem>
            <asp:ListItem Value="CAPTURED_BY ='asawant'">A Sawant</asp:ListItem>
            <asp:ListItem Value="CAPTURED_BY ='bsingh'">B Singh</asp:ListItem>
            <asp:ListItem Value="CAPTURED_BY ='cdentrem'">C d'Entremont</asp:ListItem>
            <asp:ListItem Value="CAPTURED_BY ='mcuevas'">M Cuevas</asp:ListItem>
            <asp:ListItem Value="CAPTURED_BY ='mpatel'">M Patel </asp:ListItem>
            <asp:ListItem Value="CAPTURED_BY ='nkhandri'">N Khandrika </asp:ListItem> 
            <asp:ListItem Value="CAPTURED_BY ='pshih'">P Shih</asp:ListItem>           
            <asp:ListItem Value="CAPTURED_BY ='ralmeida'">R Almeida</asp:ListItem>   
            <asp:ListItem Value="CAPTURED_BY ='rkolla'">R Kolla</asp:ListItem>            
            <asp:ListItem Value="CAPTURED_BY ='rvrooyen'">R van Rooyen </asp:ListItem> 
            <asp:ListItem Value="CAPTURED_BY ='rzhang'">R Zhang</asp:ListItem>                                
            <asp:ListItem Value="CAPTURED_BY ='sdangwal'">S Dangwal</asp:ListItem> 
            <asp:ListItem Value="CAPTURED_BY ='skalluru'">S Kalluru </asp:ListItem>
            <asp:ListItem Value="CAPTURED_BY ='smoodley'">S Moodley</asp:ListItem>
            <asp:ListItem Value="CAPTURED_BY ='snaidoo'">S Naidoo</asp:ListItem>            
            <asp:ListItem Value="CAPTURED_BY ='syang'">S Yang </asp:ListItem>
            <asp:ListItem Value="CAPTURED_BY ='tfong'">T Fong</asp:ListItem>           
            <asp:ListItem Value="CAPTURED_BY not in('asawant','bsingh','cdentrem','mcuevas','mpatel','nkhandri','pshih','ralmeida','rkolla','rvanrooyen','rzhang','sdangwal','skalluru','smoodley','snaidoo','syang','tfong') OR CAPTURED_BY IS NULL">Other</asp:ListItem>
            </asp:DropDownList><br />
        <asp:Label ID="lblMsg" runat="server" Text="Label"></asp:Label>
        <asp:DetailsView ID="JRDetailsView1" runat="server" Height="60px" 
            RowStyle-BackColor="#EFEFEF" Width="600px" BorderColor="Gray" 
            AutoGenerateRows="False" OnModeChanging="JRDetailsView1_ModeChanging" 
            OnItemUpdating="JRDetailsView1_ItemUpdating" 
            OnPageIndexChanging="JRDetailsView1_PageIndexChanging" 
            FieldHeaderStyle-BorderColor="black" FieldHeaderStyle-Font-Bold="true" 
            GridLines="Horizontal" BackColor="#C6E6FD">
        
            <RowStyle BackColor="#C6E6FD" />
            <FieldHeaderStyle BorderColor="Black" Font-Bold="True" />
            <Fields>
                <asp:BoundField DataField="GIS_REF" HeaderText="Map Ref" ReadOnly="true" />
                <asp:TemplateField HeaderText="Requested By">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox1" runat="server" MaxLength="8" 
                            Text='<%# Bind("REQUESTED_BY") %>' Width="200px"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("REQUESTED_BY") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Date Requested">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBoxDt" runat="server" MaxLength="10" 
                            Text='<%# Bind("DATE_R", "{0:dd-MM-yyyy}") %>' Width="200px"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label1" runat="server" 
                            Text='<%# Bind("DATE_R", "{0:dd-MM-yyyy}") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Description">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox2" runat="server" MaxLength="45" 
                            Text='<%# Bind("DESCRIPTION") %>' TextMode="SingleLine" Width="350px"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label4" runat="server" Text='<%# Bind("DESCRIPTION") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Reference">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox4" runat="server" MaxLength="30" 
                            Text='<%# Bind("REFERENCE") %>' Width="200px"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label6" runat="server" Text='<%# Bind("REFERENCE") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Done By">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox10" runat="server" MaxLength="10" 
                            Text='<%# Bind("CAPTURED_BY") %>' Width="200px"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label12" runat="server" Text='<%# Bind("CAPTURED_BY") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Date Completed">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBoxDCapDt" runat="server" MaxLength="10" 
                            Text='<%# Bind("DATE_C", "{0:dd-MM-yyyy}") %>' Width="200px"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label2" runat="server" 
                            Text='<%# Bind("DATE_C", "{0:dd-MM-yyyy}") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Comments">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox9" runat="server" MaxLength="50" 
                            Text='<%# Bind("COMMENTS") %>' TextMode="SingleLine" Width="350px"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label11" runat="server" Text='<%# Bind("COMMENTS") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:CommandField ControlStyle-Font-Bold="true" ShowEditButton="True" 
                    UpdateText="Save">
                <ControlStyle Font-Bold="True" />
                <ItemStyle Width="300px" />
                </asp:CommandField>
            </Fields>
            <AlternatingRowStyle BackColor="#BBF1FF" />
    </asp:DetailsView>
       
        
        <asp:GridView ID="GridView1"  runat="server" AUTOGENERATECOLUMNS="False" 
            PageSize="20" AllowPaging="True" Width="737px" 
            OnPageIndexChanging="GridView1_PageIndexChanging" PagerStyle-BackColor="Silver" 
            Font-Bold="False" OnInit="GridView1_Init" 
            OnPageIndexChanged="GridView1_PageIndexChanged" 
            OnSelectedIndexChanged="GridView1_SelectedIndexChanged" Height="254px" 
            BackColor="#C6E6FD" >
        <columns>
        <asp:BOUNDFIELD DataField="GIS_REF" HeaderText="Map Ref" >
            <ItemStyle Width="50px" />
        </asp:BOUNDFIELD>
  <asp:TemplateField HeaderText="Date Requested">   
   <itemtemplate>
    <asp:Label ID="reqDt" runat="server"
      Text='<%# Bind("DATE_R", "{0:dd-MMM-yyyy}") %>'>
    </asp:Label>
   </itemtemplate>
      <ItemStyle Width="80px" />
  </asp:TemplateField>
  <asp:BOUNDFIELD DataField="REQUESTED_BY" HeaderText="Requested By" >
      <ItemStyle Width="75px" />
  </asp:BOUNDFIELD>
  <asp:BOUNDFIELD DataField="DESCRIPTION" HeaderText="Description" >
      <ItemStyle Width="125px" />
  </asp:BOUNDFIELD>  
  <asp:BOUNDFIELD DataField="REFERENCE" HeaderText="Reference">
      <ItemStyle Width="125px" />
  </asp:BOUNDFIELD>
  <asp:BOUNDFIELD DataField="CAPTURED_BY" HeaderText="Done By">
      <ItemStyle Width="75px" />
  </asp:BOUNDFIELD>
  

  <asp:BOUNDFIELD DataField="COMMENTS" HeaderText="Comments">
      <ItemStyle Width="100px" />
  </asp:BOUNDFIELD>
            <asp:ButtonField CommandName="Select" ItemStyle-Width="40px" Text="more..." >
            <ItemStyle Width="40px" />
            </asp:ButtonField>
</columns>
            <PagerStyle BackColor="Black" Font-Bold="True" Font-Size="10pt" Font-Underline="True" ForeColor="White" />

            <SelectedRowStyle BackColor="#6D80FC" />
            <AlternatingRowStyle BackColor="#BBF1FF" />

        </asp:GridView>
    </asp:View>
        <asp:View id="View2" runat="server">
            Map Ref:
            <asp:DropDownList ID="DropDownList2" runat="server" Width="167px" AutoPostBack="True" OnSelectedIndexChanged="DropDownList2_SelectedIndexChanged">
            </asp:DropDownList><br />
            <br />
        
        <asp:DetailsView ID="JRDetailsView2" runat="server" Height="60px" 
                RowStyle-BackColor="#EFEFEF" Width="600px" BorderColor="#C6E6FD" 
                AutoGenerateRows="False" OnModeChanging="JRDetailsView2_ModeChanging" 
                OnItemUpdating="JRDetailsView2_ItemUpdating" 
                OnPageIndexChanging="JRDetailsView2_PageIndexChanging" 
                FieldHeaderStyle-BorderColor="black" FieldHeaderStyle-Font-Bold="true" 
                GridLines="Horizontal">
        
            <RowStyle BackColor="#C6E6FD" />
            <FieldHeaderStyle BorderColor="Black" Font-Bold="True" />
            <Fields>
                <asp:BoundField DataField="GIS_REF" HeaderText="Map Ref" ReadOnly="true" />
                <asp:TemplateField HeaderText="Requested By">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox1" runat="server" MaxLength="8" 
                            Text='<%# Bind("REQUESTED_BY") %>' Width="200px"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("REQUESTED_BY") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Date Requested">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBoxDt" runat="server" MaxLength="10" 
                            Text='<%# Bind("DATE_R", "{0:dd-MM-yyyy}") %>' Width="200px"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label1" runat="server" 
                            Text='<%# Bind("DATE_R", "{0:dd-MM-yyyy}") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Description">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox2" runat="server" MaxLength="45" 
                            Text='<%# Bind("DESCRIPTION") %>' TextMode="SingleLine" Width="350px"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label4" runat="server" Text='<%# Bind("DESCRIPTION") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Reference">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox4" runat="server" MaxLength="30" 
                            Text='<%# Bind("REFERENCE") %>' Width="200px"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label6" runat="server" Text='<%# Bind("REFERENCE") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Done By">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox10" runat="server" MaxLength="10" 
                            Text='<%# Bind("CAPTURED_BY") %>' Width="200px"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label12" runat="server" Text='<%# Bind("CAPTURED_BY") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Date Completed">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBoxDCapDt" runat="server" MaxLength="10" 
                            Text='<%# Bind("DATE_C", "{0:dd-MM-yyyy}") %>' Width="200px"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label2" runat="server" 
                            Text='<%# Bind("DATE_C", "{0:dd-MM-yyyy}") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Comments">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox9" runat="server" MaxLength="50" 
                            Text='<%# Bind("COMMENTS") %>' TextMode="SingleLine" Width="350px"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label11" runat="server" Text='<%# Bind("COMMENTS") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:CommandField ControlStyle-Font-Bold="true" ShowEditButton="True" 
                    UpdateText="Save">
                <ControlStyle Font-Bold="True" />
                <ItemStyle Width="300px" />
                </asp:CommandField>
            </Fields>
            <AlternatingRowStyle BackColor="#BBF1FF" />
    </asp:DetailsView>
            <asp:GridView ID="GridView2" runat="server" 
                OnPreRender="DropDownList2_SelectedIndexChanged" AUTOGENERATECOLUMNS="False" 
                Width="750px" OnSelectedIndexChanged="GridView2_SelectedIndexChanged" 
                BackColor="#C6E6FD">
            <Columns>
                    <asp:BOUNDFIELD DataField="GIS_REF" HeaderText="Map Ref">
                        <ItemStyle Width="50px" />
                    </asp:BOUNDFIELD>
                  <asp:TemplateField HeaderText="Date Requested" >                     <itemtemplate>
                   <asp:Label ID="reqDt" runat="server" Text='<%# Bind("DATE_R", "{0:dd-MMM-yyyy}") %>'> </asp:Label>
                   </itemtemplate>                  
                      <ItemStyle Width="80px" />
                  </asp:TemplateField>
                                        
                    <asp:BoundField DataField="REQUESTED_BY" HeaderText="Requested By" SortExpression="REQUESTED_BY">
                        <ItemStyle Width="75px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="DESCRIPTION" HeaderText="Description" SortExpression="DESCRIPTION" >
                        <ItemStyle Width="125px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="REFERENCE" HeaderText="Reference" SortExpression="REFERENCE">
                        <ItemStyle Width="125px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="CAPTURED_BY" HeaderText="Done By" SortExpression="CAPTURED_BY" >
                        <ItemStyle Width="75px" />
                    </asp:BoundField>
                   
                    <asp:BoundField DataField="COMMENTS" HeaderText="Comments" SortExpression="COMMENTS" />
                <asp:ButtonField CommandName="Select" ItemStyle-Width="40px" Text="more..." >
                    <ItemStyle Width="40px" />
                    </asp:ButtonField>
            </Columns>
                <SelectedRowStyle BackColor="#6D80FC" />
                <AlternatingRowStyle BackColor="#BBF1FF" />
            </asp:GridView>
        </asp:View>
        

    </asp:MultiView></asp:Panel>
    <br />
</asp:Content>

