import arcpy, json, urllib, urllib2, sys, os, getpass, pprint, string
sys.path.append('C:/Python27/Portalpy/')
import portalpy

#-------------------------------------------------------------
def readResponse(inLineStr):
    vArrItems = inLineStr.split(',')
    #print len(vArrItems)

    for vI in range(1,6,1):
        vArrItem = vArrItems[vI]
        if string.find(vArrItem, "total") <> -1:
            vStrTotal = vArrItem
        if string.find(vArrItem, "start") <> -1:
            vStrStart = vArrItem
        if string.find(vArrItem, "nextStart") <> -1:
            vStrnextStart = vArrItem


    vOutVal = dict()
    vOutVal['vTotal'] = vStrTotal.split(":")[1]
    vOutVal['vStrStart'] = vStrStart.split(":")[1]
    vOutVal['vStrnextStart'] = vStrnextStart.split(":")[1]
    return vOutVal
#-------------------------------------------------------------

def getAllItemsFUser(inUser, inTotal, inStart=1, inNxtStart=1):
    if inStart > inNxtStart:
        print inStart
        # Get user name and role
    userResp = portal.get_user(inUser)
    #print userResp['role']
    #print user['username'] + ":  " + userResp['role']

    # Construct url to search items by user
    searchURL = "{0}sharing/search".format(vActvPortalUrl)
    #print searchURL
    query = "owner: {0}".format(user['username'])
        
    params = urllib.urlencode({"q": query,"f": "pjson", "token": token, "Start": inNxtStart})
    request = urllib2.Request(searchURL, params)
    print "SiteHIT- {0}?q={1}&f={2}&token={3}".format(searchURL, query, "pjson", token)

    # Read information from item
    response = urllib2.urlopen(request)
    #print response.read()

    jsonResult = json.load(response)['results']
    print jsonResult
    if jsonResult:
        for n in jsonResult:
            #print n['title'] + "," + n['id'] + "," + n['type'] + "," + n['owner']

            # Write to csv based on search result json, here I returned owner, id, title, type, and url. There is more info you can write to csv as long as the key exists in result json.
            if n['url']:
                logger.write(n['owner'] + "," + n['id'] + "," + n['title'] + "," + n['type']+ "," + n['url'] + "\n")
            else:
                logger.write(n['owner'] + "," + n['id'] + "," + n['title'] + "," + n['type']+ "," + "\n")

        else:
            logger.write(user['username'] + ",,,," + "\n")

    #print "Start -Read next stream"
    response = urllib2.urlopen(request)
    vOutStr = readResponse(response.read())
    #print vOutStr['vStrnextStart']
    vOutTotal = int(vOutStr['vTotal'])
    vOutStart = int(vOutStr['vStrStart'])
    vOutNextStart = int(vOutStr['vStrnextStart'])

    if vOutNextStart <> -1:
        getAllItemsFUser(inUser, vOutTotal, vOutStart, vOutNextStart)
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
dir = r"C:\Joseph\Task\TASK_PreProdRefresh\Py"
#vActvPortalUrl = "https://jing7.maps.arcgis.com"
portalAdminUser     = "JejyJose1@TRANSPORT"
portalAdminPassword = "Transport12"

# Create csv file and write the header in csv
log_path = os.path.join(dir, 'log.csv')
logger = open(log_path,"w")
logger.write("owener,id,title,type,url" + "\n")

# For manual input
#portalAdminUser     = raw_input("Enter user name: ")
#portalAdminPassword = getpass.getpass("Enter password: ")
#portalAdminUser     = arcpy.GetParameterAsText(0)
#portalAdminPassword = arcpy.GetParameterAsText(1)

# Connect to Portal
portal = portalpy.Portal(vActvPortalUrl, portalAdminUser, portalAdminPassword)
pprint.pprint(portal)
token = portal.generate_token(portalAdminUser, portalAdminPassword)
#print token
users = portal.search_users('')

# Loop users
for user in users :
    #print user
    if user['username'] == 'JejyJose1@TRANSPORT':
    #if string.find( user['username'], "esri_") == -1:    
        #print user
        getAllItemsFUser(user['username'], 10)        

logger.close()
