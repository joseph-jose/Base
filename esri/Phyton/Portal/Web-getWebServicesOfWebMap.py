import arcpy, json, urllib, urllib2, sys, os, getpass, pprint, string
sys.path.append('C:/Python27/Portalpy/')
import portalpy

#-------------------------------------------------------------

def getLayerOfWebMap(inVLinestr, inWebmapJson, inWebmapUrl):
    request = urllib2.Request(inWebmapJson)
    #print(r"---------Level-2-" + inVLinestr )
    #print "SiteHIT- {0}?q={1}&f={2}&token={3}".format(searchURL, query, "pjson", token)

    # Read information from item
    response = urllib2.urlopen(request)
    #print response.read()

    #vStrOutLine = inVLinestr
    #print inVLinestr
    vStrOutLine = ""
    vtmpStrOutLine = ""
    vtmp2StrOutLine = ""
    vArrInLineStr = []
    vArrInLineStr = inVLinestr.split(",")
    vtmp2StrOutLine = vtmp2StrOutLine + vArrInLineStr[0] + ","
    vtmp2StrOutLine = vtmp2StrOutLine + vArrInLineStr[1] + ","
    vtmp2StrOutLine = vtmp2StrOutLine + vArrInLineStr[2] + ","
    vtmp2StrOutLine = vtmp2StrOutLine + vArrInLineStr[3] + ","

    jsonResult = json.load(response)
    #print(r"---------Level-2.1-" + json.dumps(jsonResult) )
    #print jsonResult
    if jsonResult:
        #print jsonResult['operationalLayers']
        for n in jsonResult['operationalLayers']:
            print r"---------------------"
            #print inVLinestr
            #print jsonResult['operationalLayers']
            #print n
            vtmpStrOutLine = ""
            if 'title' in n:
                vtmpStrOutLine = vtmpStrOutLine +  n['title']
            else:
                vtmpStrOutLine = vtmpStrOutLine +  "," + r"null"
            if 'id' in n:
                vtmpStrOutLine = vtmpStrOutLine +  "," + n['id']
            else:
                vtmpStrOutLine = vtmpStrOutLine +  "," + r"null"
            if 'url' in n:
                vtmpStrOutLine = vtmpStrOutLine +  "," + n['url']
            else:
                vtmpStrOutLine = vtmpStrOutLine +  "," + r"null"
            if 'layerType' in n:
                vtmpStrOutLine = vtmpStrOutLine +  "," + n['layerType']
            else:
                vtmpStrOutLine = vtmpStrOutLine +  "," + r"null"
            #print(vtmpStrOutLine)
            #print(vtmp2StrOutLine)
            vtmpStrOutLine = vtmpStrOutLine.rstrip()
            vtmp2StrOutLine = vtmp2StrOutLine.rstrip()
            vStrOutLine = os.path.join(vtmpStrOutLine , "," , vtmp2StrOutLine) 
            #vStrOutLine = vtmp2StrOutLine + vtmpStrOutLine
            print (vStrOutLine).encode('utf8')
            loggerW.write((vStrOutLine).encode('utf8') + "\n")
            print r"---------------------"
            #print inVLinestr + "," + n['title'] + "," + n['id'] + "," + n['url'] 
            #loggerW.write(inVLinestr + "," + n['title'] + "," + n['id'] + "," + n['url']  + "\n")

            # Write to csv based on search result json, here I returned owner, id, title, type, and url. There is more info you can write to csv as long as the key exists in result json.
            #if n['url']:
            #    logger.write(n['owner'] + "," + n['id'] + "," + n['title'] + "," + n['type']+ "," + n['url'] + "\n")
            #else:
            #    logger.write(n['owner'] + "," + n['id'] + "," + n['title'] + "," + n['type']+ "," + "\n")

    else:
        print("No valid JSON response \n")


#-------------------------------------------------------------
def processLine(inVLinestr, inToken):
    vItmLocation = r"sharing/rest/content/items/"
    vItmJson = r"/data?f=json&token="
    vItmWebMap = r"home/item.html?id="

    vWebMapId = inVLinestr.split(",")[1]

    #https://atalgispsu01.aucklandtransport.govt.nz:7443/arcgis/
    #sharing/rest/content/items/
    #9b81a0daa0ca4ffd9ef6b4d031bb1ec7
    #/data?f=json&token=oDyymHdEn9YEVlE-mwWcFdKJWR6ConagGVxkrzRYnFgZ4gVpuP6jIex67zHrEr7Vshtg_6N-tjc1bqTSPRVaibk7MRS3kDORcReQSKEk4cIdVbQzjOVSzD35PPcu3NDyxJ39NbqbuS2VZ5kPC2tD7ZU9GBQAd-Ia4S4R-FiHpVo.    
    vWebmapJson = "{0}{1}{2}{3}{4}".format(vActvPortalUrl, vItmLocation,vWebMapId,vItmJson, inToken)
    #https://atalgispsu01.aucklandtransport.govt.nz/arcgis/
    #home/item.html?id=9b81a0daa0ca4ffd9ef6b4d031bb1ec7    
    vWebmapUrl = "{0}{1}{2}".format(vActvPortalUrl, vItmWebMap,vWebMapId)

    #print vWebmapJson
    #print vWebmapUrl
    #print(r"---------Level-1-" + inVLinestr )
    getLayerOfWebMap(inVLinestr, vWebmapJson, vWebmapUrl)

#-------------------------------------------------------------
        

#vActvPortalUrl = arcpy.GetActivePortalURL()
#vActvPortalUrl = "https://atalgispu01.aucklandtransport.govt.nz:7443/arcgis/"
#vActvPortalUrl = "https://atalgispsp01.aucklandtransport.govt.nz:7443/arcgis/"
vActvPortalUrl = "https://atalgispsu01.aucklandtransport.govt.nz:7443/arcgis/"
#print vActvPortalUrl
#arcpy.SignInToPortal(arcpy.GetActivePortalURL(), 'JejyJose1@TRANSPORT', 'Transport12')
#print(arcpy.GetPortalInfo(portal_URL=arcpy.GetActivePortalURL()))
#token = arcpy.GetSigninToken()
#if token is not None:
#    print(token['token'])


log_dict = []

# Update this segment
dir = r"C:\Joseph\Task\TASK_PreProdRefresh\Py\readCSV"
#vActvPortalUrl = "https://jing7.maps.arcgis.com"
portalAdminUser     = "JejyJose1@TRANSPORT"
portalAdminPassword = "Transport12"

# Create csv file and write the header in csv
log_path = os.path.join(dir, 'AllItemsInPortal.csv')
log_pathW = os.path.join(dir, 'AllWebServicesInWebMap.csv')
loggerR = open(log_path,"r")
loggerW = open(log_pathW,"w")

loggerW.write("LayerTitle,LayerId,LayerURL,LayerType,User,WebMapId,WebMap,Type \n")


# For manual input
#portalAdminUser     = raw_input("Enter user name: ")
#portalAdminPassword = getpass.getpass("Enter password: ")
#portalAdminUser     = arcpy.GetParameterAsText(0)
#portalAdminPassword = arcpy.GetParameterAsText(1)

# Connect to Portal
portal = portalpy.Portal(vActvPortalUrl, portalAdminUser, portalAdminPassword)
#pprint.pprint(portal)
token = portal.generate_token(portalAdminUser, portalAdminPassword)
#print token

for vLine in loggerR:
    #print(r"---------Level-0-" +vLine)
    processLine(vLine, token)
    


loggerR.close()
loggerW.close()
