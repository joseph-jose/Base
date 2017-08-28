# Name: Analyze.py
# Description: analyzes and rebuild indexes for all datasets in an enterprise geodatabase
#              for a given user.

# Import system modules
import arcpy, os


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
#inDB="\GISStaging"

###Production=============================================================================
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
fo.write( "Using " + inDBConn + "\n");


# the user in this workspace must be the owner of the data to analyze.
workspace = inDBConn

# set the workspace environment
arcpy.env.workspace = workspace

# NOTE: Analyze Datasets can accept a Python list of datasets.

# Get a list of all the datasets the user has access to.
# First, get all the stand alone tables, feature classes and rasters.
dataList = arcpy.ListTables() + arcpy.ListFeatureClasses() + arcpy.ListRasters()

# Next, for feature datasets get all of the datasets and featureclasses
# from the list and add them to the master list.
for dataset in arcpy.ListDatasets("", "Feature"):
    arcpy.env.workspace = os.path.join(workspace,dataset)
    dataList += arcpy.ListFeatureClasses() + arcpy.ListDatasets()

# reset the workspace
arcpy.env.workspace = workspace

# Get the user name for the workspace
userName = arcpy.Describe(workspace).connectionProperties.user.lower()

# remove any datasets that are not owned by the connected user.
userDataList = [ds for ds in dataList if ds.lower().find(".%s." % userName) > -1]

# Execute analyze datasets
# Note: to use the "SYSTEM" option the workspace user must be an administrator.
arcpy.RebuildIndexes_management(workspace, "SYSTEM", userDataList, "ALL")
print "Rebuild indexes Completed for " + workspace
arcpy.AnalyzeDatasets_management(workspace, "NO_SYSTEM", userDataList, "ANALYZE_BASE","ANALYZE_DELTA","ANALYZE_ARCHIVE")
print "Analyze Completed for "+ workspace
