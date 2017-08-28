# Name: Grant permissions to datasets
# Description: permissions to usrs on dataset level


# Import system modules
import arcpy


# Set Server Enviromnent
#Env="ProdMaster"
#Env="ProdReplica"
#Env="TestMaster"
#Env="TestReplica"
Env="NewDev"


# Set Database
inDB="\GISNet1"
#inDB="\GISNet2"
#inDB="\GISBase"
#inDB="\GISExternal"


#Production=============================================================================
if Env=="ProdMaster" :
  if inDB=="\GISNet1" : inDBConn = "N:\SDEConn\ProdMaster\Z_ProdGISWSL@Net1Master.sde"
  if inDB=="\GISNet2" : inDBConn = "N:\SDEConn\ProdMaster\Z_ProdGISWSL@Net2Master.sde"
  if inDB=="\GISBase" : inDBConn = "N:\SDEConn\ProdMaster\Z_ProdGISWSL@BaseMaster.sde"  
  if inDB=="\GISExternal" : inDBConn = "N:\SDEConn\ProdMaster\Z_ProdGISWSL@ExternalMaster.sde"
if Env=="ProdReplica" :
  if inDB=="\GISNet1" : inDBConn = "N:\SDEConn\ProdReplica\Z_ProdGISWSL@Net1Replica.sde"
  if inDB=="\GISNet2" : inDBConn = "N:\SDEConn\ProdReplica\Z_ProdGISWSL@Net2Replica.sde"
  if inDB=="\GISBase" : inDBConn = "N:\SDEConn\ProdReplica\Z_ProdGISWSL@BaseReplica.sde"
#Test      =============================================================================
if Env=="TestMaster" :
  if inDB=="\GISNet1" : inDBConn = "N:\SDEConn\TestMaster\Z_TestGISWSL@Net1Master.sde"
  if inDB=="\GISNet2" : inDBConn = "N:\SDEConn\TestMaster\Z_TestGISWSL@Net2Master.sde"
  if inDB=="\GISBase" : inDBConn = "N:\SDEConn\TestMaster\Z_TestGISWSL@BaseMaster.sde"
  if inDB=="\GISExternal" : inDBConn = "N:\SDEConn\TestMaster\Z_TestGISWSL@ExternalMaster.sde"
if Env=="TestReplica" :
  if inDB=="\GISNet1" : inDBConn = "N:\SDEConn\TestReplica\Z_TestGISWSL@Net1Replica.sde"
  if inDB=="\GISNet2" : inDBConn = "N:\SDEConn\TestReplica\Z_TestGISWSL@Net2Replica.sde"
  if inDB=="\GISBase" : inDBConn = "N:\SDEConn\TestReplica\Z_TestGISWSL@BaseReplica.sde"
#Development============================================================================
if Env=="NewDev" :
  if inDB=="\GISNet1" : inDBConn = "N:\SDEConn\NewDev\Z_DevGISWSL@Net1.sde"
  if inDB=="\GISNet2" : inDBConn = "N:\SDEConn\NewDev\Z_DevGISWSL@Net2.sde"
  if inDB=="\GISBase" : inDBConn = "N:\SDEConn\NewDev\Z_DevGISWSL@Base.sde"
  if inDB=="\GISExternal" : inDBConn = "N:\SDEConn\NewDev\Z_DevGISWSL@Ext.sde"



inDBOwn=".GISWSL."
inDBConnOwn=inDBConn+inDB+inDBOwn
inDatasets = (
             "Water",
             "Wastewater",
             "OtherAsset",
             "NonWSL",
             "DCWebWSL",
             "Other",
             "Property",
             "Survey",
             "WaterOther",
             "WastewaterOther"
             )

import os
# set time and date
localtime = time.asctime( time.localtime(time.time()) )
# Open a file
filename = __file__
logfilename = os.path.basename(__file__)
logfilename = logfilename[0:(len(logfilename)-3)] +".log"
fo = open(logfilename, "w")
fo.write( "Log file to record script status:!\n");
fo.write( "============================================================================= \n");
fo.write( localtime + "\n");
fo.write( "Using " + inDBConnOwn + "\n");

try:
#Grant Privileges to dataset==========================================================================
    #Execute ChangePrivileges
    print "Using " + inDBConnOwn
    print "Applying privileges in " + Env + " for " + inDB
    for inDataset in inDatasets:
        print""
        print "Revoke privileges to " + inDataset
##        arcpy.ChangePrivileges_management(inDBConnOwn+inDataset, "gisviewer", "REVOKE", "REVOKE")
##        arcpy.ChangePrivileges_management(inDBConnOwn+inDataset, "giseditor", "REVOKE", "REVOKE")
##        arcpy.ChangePrivileges_management(inDBConnOwn+inDataset, "gisadmin", "REVOKE", "REVOKE")
        print "Applying privileges to " + inDataset
        arcpy.ChangePrivileges_management(inDBConnOwn+inDataset, "gisviewer", "GRANT", "AS_IS")
        arcpy.ChangePrivileges_management(inDBConnOwn+inDataset, "giseditor", "GRANT", "GRANT")
        arcpy.ChangePrivileges_management(inDBConnOwn+inDataset, "gisadmin", "GRANT", "GRANT")
        
        #Messages
        print "Privileges applied to " + inDataset
    
except Exception, err:
    print err


 
#display complete
filename = __file__
fo.write (filename + " Completed\n")
fo.write("\n")
# Close opend file
fo.close()

print "SDE permissions granted"
