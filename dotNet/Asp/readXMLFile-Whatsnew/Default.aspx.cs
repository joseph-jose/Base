using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

public partial class Index : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string vSrvrName = "";

        vSrvrName = Request.ServerVariables["SERVER_NAME"].ToString();
        if (vSrvrName.Trim() == "localhost")
            vSrvrName = "wsldctgdw";
        if (vSrvrName.Trim() == "giswebtest")
            vSrvrName = "wsldctvgtw";
        if (vSrvrName.Trim() == "gisweb")
            vSrvrName = "wsldctvgpw";
        txtSrvr.Text = vSrvrName;

        if (vSrvrName == "wsldctgdw")
        {
            hlnkSrvrname.Text = "-(dev)";
        }
        else if (vSrvrName == "wsldctvgtw")
        {
            hlnkSrvrname.Text = "-(test)";
        }
        else if (vSrvrName == "giswebtest")
        {
            hlnkSrvrname.Text = "-(test)";
        }        
        else if (vSrvrName == "wsldctvgpw")
        {
            hlnkSrvrname.Text = "";
        }

        HttpBrowserCapabilities bc = Request.Browser;
        if (bc.Browser.IndexOf("Chrome") == -1)
        {
            LblBrw.Text = "IE";
            Response.Redirect("http://" + vSrvrName + "/watercareviewer/Index.aspx");
        }
        else
            LblBrw.Text = "CHROME";

        readWhatsNewInXmlFile();
    }

    private void readWhatsNewInXmlFile()
    {
        XmlReaderSettings vXmlReaderSettngs = new XmlReaderSettings();
        vXmlReaderSettngs.IgnoreWhitespace = true;

        //XmlReader vXmlRdr = XmlReader.Create("http://gisweb/GISDocs/WhatsNew/WhatsNew.xml", vXmlReaderSettngs);
        XmlReader vXmlRdr ;
        if (hlnkSrvrname.Text == "")
            vXmlRdr = XmlReader.Create("http://gisweb/GISDocs/WhatsNew/WhatsNew.xml", vXmlReaderSettngs);
        else
            vXmlRdr = XmlReader.Create("http://gisweb/GISDocs/WhatsNew/TestMachine/WhatsNew.xml", vXmlReaderSettngs);


        string vStr = "", vResStr = "";
        int vBulltCtr = 1;
        vXmlRdr.ReadToFollowing("marquee");
        vStr = vXmlRdr.GetAttribute("value").ToString();
        LblMrque.Text = vStr;
        vXmlRdr.ReadToFollowing("items");
        if ((vXmlRdr.Name.ToString() == "items") && (vXmlRdr.IsStartElement()))
        {
            vStr = "<div class=event><h3>{0}</h3><p>{1}</p></div>";
            vXmlRdr.ReadToFollowing("field");
            //vXmlInnrRdr = vXmlRdr.ReadSubtree();
            //while (vXmlRdr.ReadToNextSibling("Field")) 
            do
            {
                if (vBulltCtr == 5)
                {
                    break;
                }
                if (vXmlRdr.NodeType == XmlNodeType.Element)
                {
                    if (!(vXmlRdr.GetAttribute("dated") == ""))
                    {
                        vResStr = vResStr + string.Format(vStr, vXmlRdr.GetAttribute("dated"), vXmlRdr.GetAttribute("description"));
                    }
                    vBulltCtr++;
                    //Response.Write("New " + vXmlRdr.GetAttribute("dated") + vXmlRdr.NodeType.ToString());
                }
            }
            while (vXmlRdr.Read());

            LblWhatsNew.Text = vResStr;
        }


    }
}