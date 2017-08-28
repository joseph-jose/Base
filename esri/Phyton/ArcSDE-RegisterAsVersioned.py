# Name: RegisterAsVersioned.py
# Description: Register As Versioned in Datasets


# Import system modules
import arcpy


# Set Server Enviromnent
#Env="ProdMaster"
#Env="ProdReplica"
#Env="TestMaster"
#Env="TestReplica"
Env="DevNew"


# Set Database
#inDB="\GISNet1"
inDB="\GISNet2"
#inDB="\GISBase"
#inDB="\GISExternal"
#inDB="\GISStaging"


#Production=============================================================================
if Env=="ProdMaster" :
  if inDB=="\GISNet1" : inDBConn = "N:\SDEConn\ProdMaster\Z_ProdGISWSL@Net1Master.sde"
  if inDB=="\GISNet2" : inDBConn = "N:\SDEConn\ProdMaster\Z_ProdGISWSL@Net2Master.sde"
  if inDB=="\GISBase" : inDBConn = "N:\SDEConn\ProdMaster\Z_ProdGISWSL@BaseMaster.sde"
  if inDB=="\GISStaging" : inDBConn = "N:\SDEConn\ProdMaster\Z_ProdGISWSL@StagingMaster.sde"
if Env=="ProdReplica" :
  if inDB=="\GISNet1" : inDBConn = "N:\SDEConn\ProdReplica\Z_ProdGISWSL@Net1Replica.sde"
  if inDB=="\GISNet2" : inDBConn = "N:\SDEConn\ProdReplica\Z_ProdGISWSL@Net2Replica.sde"
  if inDB=="\GISBase" : inDBConn = "N:\SDEConn\ProdReplica\Z_ProdGISWSL@BaseReplica.sde"
#Test      =============================================================================
if Env=="TestMaster" :
  if inDB=="\GISNet1" : inDBConn = "N:\SDEConn\TestMaster\Z_TestGISWSL@Net1Master.sde"
  if inDB=="\GISNet2" : inDBConn = "N:\SDEConn\TestMaster\Z_TestGISWSL@Net2Master.sde"
  if inDB=="\GISBase" : inDBConn = "N:\SDEConn\TestMaster\Z_TestGISWSL@BaseMaster.sde"
  if inDB=="\GISStaging" : inDBConn = "N:\SDEConn\TestMaster\Z_TestGISWSL@StagingMaster.sde"
if Env=="TestReplica" :
  if inDB=="\GISNet1" : inDBConn = "N:\SDEConn\TestReplica\Z_TestGISWSL@Net1Replica.sde"
  if inDB=="\GISNet2" : inDBConn = "N:\SDEConn\TestReplica\Z_TestGISWSL@Net2Replica.sde"
  if inDB=="\GISBase" : inDBConn = "N:\SDEConn\TestReplica\Z_TestGISWSL@BaseReplica.sde"
#Development============================================================================

if Env=="DevNew" :
  if inDB=="\GISNet1" : inDBConn = "N:\SDEConn\DevNew\GISWSL\Z_DevGISWSL@Net1.sde"
  if inDB=="\GISNet2" : inDBConn = "N:\SDEConn\DevNew\GISWSL\Z_DevGISWSL@Net2.sde"
  if inDB=="\GISBase" : inDBConn = "N:\SDEConn\DevNew\GISWSL\Z_DevGISWSL@Base.sde"



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

    print "Using " + inDBConnOwn
    print "Register As Versioned in " + Env + " for " + inDB
    for inDataset in inDatasets:
        print ""
        print "Register As Versioned started for " + inDataset
        arcpy.RegisterAsVersioned_management(inDataset, "NO_EDITS_TO_BASE")
        ##arcpy.UnregisterAsVersioned_management(datasetName, "NO_KEEP_EDIT", "COMPRESS_DEFAULT")
        print "Register As Versioned started for " + inDataset


           
except Exception, err:
    print err
    
#display complete
filename = __file__
fo.write (filename + " Completed\n")
fo.write("\n")
# Close opend file
fo.close()

print "Register As Versioned completed for all datasets"
