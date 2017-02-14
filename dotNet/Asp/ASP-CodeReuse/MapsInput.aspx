<%@ Page Language="C#" MasterPageFile="MasterPage.master" AutoEventWireup="true" CodeFile="MapsInput.aspx.cs" Inherits="AppSample.MapsDataInput" Title="Maps Data  Input" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div>
           <asp:Panel id="PanelMain" runat="server" style="POSITION:relative; z-index: 100; left: 20px; top: -18px;" Width="795px" Height="420px" BackColor="#E6E6FA" BorderWidth="0px" BorderColor="#CCCCFF" ForeColor="Beige" >
            
        <asp:Label ID="Label1" runat="server"  BackColor="Transparent" BorderColor="Transparent" BorderStyle="None" Font-Bold="True" Font-Size="Medium" ForeColor="Blue" Height="24px"
            Text="Enter    New  Map   details" Width="749px" style="z-index: 100; font-family:Microsoft Sans Serif; left: 20px; position: absolute; top: 10px"></asp:Label>
               &nbsp;&nbsp;<br />
               &nbsp;<asp:Label ID="Label6" runat="server" BackColor="Navy"
                   BorderColor="Navy" ForeColor="Transparent" Height="1px" Width="744px" style="z-index: 102; left: 20px; position: absolute; top: 34px"></asp:Label><asp:Label
                ID="LabelErr" runat="server" Font-Bold="True" Font-Size="Smaller" ForeColor="Red" style="z-index: 100; left: 570px; position: absolute; top: 40px" Height="73px" Width="218px"></asp:Label>
               &nbsp; &nbsp; 
               <asp:Label ID="Label10" runat="server" Font-Bold="true" Font-Italic="True" ForeColor="#186C9D" Height="40px"
                   Style="z-index: 109; left: 170px; position: absolute; top: -60px" Text="Special maps (sm)"
                   Width="342px" Font-Size="X-Large"></asp:Label> 
               <asp:Label ID="Label17" runat="server" Text="GM_ID---:" Width="81px" Visible="False"></asp:Label>&nbsp;&nbsp;&nbsp;
               &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp;&nbsp;<br />
               &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="DCRefTxtBox" ErrorMessage="SM Map Reference required" style="z-index: 101; left: 152px; position: absolute; top: 49px"></asp:RequiredFieldValidator><br />
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;<asp:TextBox ID="TextBox1" runat="server" BackColor="LemonChiffon" BorderColor="#C0FFC0"
            Font-Bold="True" ReadOnly="True" Visible="False" style="z-index: 102; left: 159px; position: absolute; top: 35px"></asp:TextBox>
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
        &nbsp;&nbsp;&nbsp; &nbsp; &nbsp;
               &nbsp;&nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
               <asp:Label ID="Label2" runat="server" BackColor="Transparent" BorderColor="#C0FFC0"
            Font-Size="Medium" ForeColor="Black" Text="Map Ref" Width="100px" style="z-index: 103; left: 14px; position: absolute; top: 77px"></asp:Label>
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;<asp:TextBox 
                   ID="DCRefTxtBox" runat="server" BackColor="White" BorderColor="#C0FFC0"
            Font-Bold="True" Width="142px" 
                   style="z-index: 104; left: 142px; position: absolute; top: 67px" MaxLength="8" 
                   Height="22px" ReadOnly="True">SM</asp:TextBox>
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;
               <asp:RangeValidator id="valRange" runat="server"
            ControlToValidate="DtTxtBox"
            MaximumValue="31/12/2020"
            MinimumValue="1/1/2006"
            Type="Date"
            ErrorMessage="* The date must be between 1/1/2006 and 31/12/2020" Display="static" style="z-index: 105; left: 335px; position: absolute; top: 51px"></asp:RangeValidator><br />
        <br />
        &nbsp;
               <asp:Label ID="Label4" runat="server" BackColor="Transparent" BorderColor="#C0FFC0" Font-Size="Medium"
            ForeColor="Black" Text="Requested By" Width="119px" style="z-index: 106; left: 14px; position: absolute; top: 127px"></asp:Label>
        &nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;
               <asp:TextBox ID="FromTxtBox" runat="server" BackColor="White" BorderColor="#C0FFC0"
            Font-Bold="True" style="z-index: 107; left: 142px; position: absolute; top: 117px" Width="300px" MaxLength="20" Height="22px"></asp:TextBox>
        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;
               &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
               <asp:Label
            ID="Label3" runat="server" BackColor="Transparent" BorderColor="#C0FFC0" Font-Size="Medium"
            ForeColor="Black" Text="Date" Width="39px" style="z-index: 108; left: 491px; position: absolute; top: 125px" Height="20px"></asp:Label>&nbsp;&nbsp;&nbsp;
               &nbsp;
        <asp:TextBox ID="DtTxtBox" runat="server" BackColor="White" BorderColor="#C0FFC0"
            Font-Bold="True" style="z-index: 109; left: 550px; position: absolute; top: 117px" MaxLength="10" Width="142px" Height="22px"></asp:TextBox>&nbsp;&nbsp;
            <asp:Button ID="DtButton" runat="server" OnClick="DtButton_ServerClick" Text="..." Width="22px" style="z-index: 110; left: 700px; position: absolute; top: 120px" />&nbsp;
            
             <asp:Panel ID="PanelDate" style="position:absolute; z-index: 111; left: 531px; top: -51px;" runat="server" Height="159px" Width="201px">  
             <asp:Calendar ID="Calendar1" runat="server" Height="97px" Width="117px" OnVisibleMonthChanged="MonthChange" OnSelectionChanged="MyCalendar_SelectionChanged" WeekendDayStyle-Wrap="true" BackColor="#99FFCC" BorderColor="Black" ForeColor="RoyalBlue" style="z-index: 100; left: 3px; position: absolute; top: 2px">

				<titlestyle font-size="14px" font-bold="True" borderwidth="2px" />
				<dayheaderstyle font-size="12px" font-bold="True" />
				<todaydaystyle backcolor="Black" forecolor="White" />
				<othermonthdaystyle forecolor="#CCCCCC" />						
                 <WeekendDayStyle ForeColor="Silver" Wrap="True" />
			</asp:Calendar>
</asp:Panel>
               &nbsp;&nbsp;&nbsp;<br />
               <br />
               &nbsp;
        <br />
        <br />
               &nbsp;
        <asp:Label ID="Label5" runat="server" BackColor="Transparent" BorderColor="#C0FFC0" Font-Size="Medium"
            ForeColor="Black" Text="Description" style="z-index: 112; left: 14px; position: absolute; top: 167px" Width="98px"></asp:Label>
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<asp:TextBox ID="DescTxtBox" runat="server" BackColor="White" BorderColor="#C0FFC0"
            Font-Bold="True" Rows="3" Width="574px" style="z-index: 113; left: 142px; position: absolute; top: 167px" Height="44px" MaxLength="50"></asp:TextBox>
        &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
        &nbsp; &nbsp;&nbsp;<br />
               <br />
        <br />
               &nbsp;
        <asp:Label ID="Label7" runat="server" BackColor="Transparent" BorderColor="#C0FFC0" Font-Size="Medium"
            ForeColor="Black" Text="Reference" style="z-index: 116; left: 14px; position: absolute; top: 249px" Width="70px"></asp:Label>&nbsp; &nbsp; &nbsp;
               &nbsp;&nbsp; &nbsp; &nbsp;
               <asp:TextBox ID="SrcTxtBox" runat="server" BackColor="White" BorderColor="#C0FFC0"
            Font-Bold="True" style="z-index: 117; left: 142px; position: absolute; top: 239px" Height="22px" Width="300px" MaxLength="30"></asp:TextBox>
        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<br />
        <br />
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp;
        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;&nbsp;
               <asp:Label ID="Label13" runat="server" BackColor="Transparent" BorderColor="#C0FFC0"
            Font-Size="Medium" ForeColor="Black" Text="Date" style="z-index: 122; left: 491px; position: absolute; top: 298px"></asp:Label>
               &nbsp;&nbsp;
               <asp:TextBox ID="DCDateTxtBox" runat="server" BackColor="White" BorderColor="#C0FFC0"
            Font-Bold="True" style="z-index: 123; left: 550px; position: absolute; top: 288px" Width="142px" MaxLength="10" Height="22px"></asp:TextBox>
               <asp:Button ID="DCButton" runat="server" OnClick="DCButton_Click" Text="..." Width="22px" style="z-index: 124; left: 700px; position: absolute; top: 292px" />&nbsp; &nbsp;&nbsp;<asp:Panel ID="Panel1" style="position:absolute; z-index: 125; left: 530px; top: 126px;" runat="server" Height="159px" Width="195px">
                   <asp:Calendar ID="Calendar3" runat="server" Height="100px" Width="150px" WeekendDayStyle-Wrap="true" BackColor="#99FFCC" BorderColor="Black" ForeColor="RoyalBlue" CellPadding="1" OnSelectionChanged="DC_SelectionChanged" OnVisibleMonthChanged="DCMonthChange" style="z-index: 100; left: 5px; position: absolute; top: 5px">
                       <todaydaystyle backcolor="Black" forecolor="White" />
                       <WeekendDayStyle ForeColor="Silver" Wrap="True" />
                       <othermonthdaystyle forecolor="#CCCCCC" />
                       <dayheaderstyle font-size="12px" font-bold="True" />
                       <titlestyle font-size="14px" font-bold="True" borderwidth="2px" />
                   </asp:Calendar>
               </asp:Panel>
               &nbsp; &nbsp;&nbsp; &nbsp;<br />
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<br />
               <br />
               <br />
               <br />
               <br />
               <br />
        &nbsp; <asp:Label ID="Label14" runat="server" BackColor="Transparent" BorderColor="#C0FFC0"
            Font-Size="Medium" ForeColor="Black" Text="Done By" Height="19px" Width="113px" style="z-index: 126; left: 14px; position: absolute; top: 298px"></asp:Label>
               &nbsp;&nbsp;<asp:TextBox ID="DCapTxtBox" runat="server" BackColor="White" BorderColor="#C0FFC0"
            Font-Bold="True" OnTextChanged="DCapTxtBox_TextChanged" OnDataBinding="DropDownList1_SelectedIndexChanged" style="z-index: 127; left: 142px; position: absolute; top: 289px" MaxLength="10" Height="22px" Width="142px"></asp:TextBox>
               &nbsp;&nbsp; &nbsp;<asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="true" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged" style="z-index: 128; left: 301px; position: absolute; top: 294px" Width="119px">
                   <asp:ListItem Value=" ">Select</asp:ListItem>
               
                <asp:ListItem Value='asawant'>asawant</asp:ListItem>
               <asp:ListItem Value='bsingh'>bsingh</asp:ListItem>
               <asp:ListItem Value='mcuevas'>mcuevas</asp:ListItem>
                <asp:ListItem Value='mpatel'>mpatel</asp:ListItem>   
               <asp:ListItem Value='nperrie'>nperrie</asp:ListItem>
               <asp:ListItem Value='pshih'>pshih</asp:ListItem> 
                <asp:ListItem Value='ralmeida'>ralmeida</asp:ListItem>             
               <asp:ListItem Value='rvrooyen'>rvrooyen</asp:ListItem>
               <asp:ListItem Value='rzhang'>rzhang</asp:ListItem>
                <asp:ListItem Value='sdangwal'>sdangwal</asp:ListItem>
               <asp:ListItem Value='skalluru'>skalluru</asp:ListItem>
               <asp:ListItem Value='smoodley'>smoodley</asp:ListItem>
               <asp:ListItem Value='snaidoo'>snaidoo</asp:ListItem>

               </asp:DropDownList>
               &nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp;<br />
        <br />
               <br />
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;<br />
               &nbsp;<br />
               <br />
               &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;<br />
               <br />
               &nbsp;
               <asp:Label ID="Label15" runat="server" BackColor="Transparent" BorderColor="#C0FFC0"
            Font-Size="Medium" ForeColor="Black" Text="Comments" style="z-index: 136; left: 14px; position: absolute; top: 340px" Width="92px" Height="21px"></asp:Label>
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<asp:TextBox ID="CmntTxtBox" runat="server" BackColor="White" BorderColor="#C0FFC0"
            Font-Bold="True" Columns="30" Rows="3" style="z-index: 137; left: 142px; position: absolute; top: 339px" Width="574px" MaxLength="50" ></asp:TextBox><br />
               <br />
               <br />
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
               &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
        <asp:Button ID="insBtn" runat="server" BackColor="#CCCCFF" BorderColor="#C0FFC0"
            Height="37px" OnClick="insBtn_Click" Text="Save" Width="108px" style="z-index: 138; left: 397px; position: absolute; top: 401px" />&nbsp;<br />
               <asp:Button ID="CancelBtn" runat="server" CommandName="Cancel" BackColor="#CCCCFF" BorderColor="#80FF80"
                   Height="37px" Style="z-index: 140; left: 244px; position: absolute; top: 401px"
                   Text="Cancel" Width="115px" OnClick="CancelBtn_Click" />
               </asp:Panel>
        &nbsp;&nbsp;
               
               <asp:Label ID="Label16" runat="server" BackColor="#FFFF80" 
               BorderStyle="Double" BorderWidth="1px"
                   ForeColor="#FF8000" Height="29px" Text="Err:->" Width="772px" 
               Visible="False" style="z-index: 102; left: 4px; position: absolute; top: 484px"></asp:Label>
        &nbsp;&nbsp;
        <br />        <br /> <br />

        </div>


</asp:Content>

