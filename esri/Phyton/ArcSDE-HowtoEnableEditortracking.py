# Name: Editor tracking enabling
# Description: Enable editor tracking on all dataset feature classes


# Import system modules
import arcpy, os


# Set Server Enviromnent
#Env="ProdMaster"
#Env="ProdReplica"
Env="TestMaster"
#Env="TestReplica"
#Env="DevNew"


# Set Database
inDB="\GISNet1"
#inDB="\GISNet2"
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
    print "Creating Editor tracking in " + Env + " for " + inDB
    for inDataset in inDatasets:
        print ""
        print "Adding Editor tracking to " + inDataset

#Adding Editor tracking to Water==============================================================================
        if inDataset=="Water" :
          inFClasses =  (
                        "\W_Pipe",
                        "\W_Fitting",
                        "\W_Valve",
                        "\W_Meter",
                        "\W_Hydrant",
                        "\W_PumpStn",
                        "\W_Reservoir",
                        "\W_Structure",
                        "\W_TPlant",
                        "\W_Source",
                        "\W_KeyAssetCen",
                        )
          for inFClass in inFClasses:
            print "Adding Editor tracking to " + inFClass
            arcpy.EnableEditorTracking_management(inDBConnOwn +inDataset+ inFClass, "CREATEBY","CREATEDATE", "MODIFYBY", "MODIFYDATE", "NO_ADD_FIELDS", "DATABASE_TIME")
            print "Editor tracking enabled on " + inFClass          

#Adding Editor tracking to Wastewater=========================================================================
        if inDataset=="Wastewater" :
          inFClasses = (
                        "\WW_Pipe",
                        "\WW_Fitting",
                        "\WW_Manhole",
                        "\WW_Structure",
                        "\WW_PumpStn",
                        "\WW_TPlant",
                        "\WW_PipeInspection",
                        "\WW_KeyAssetCen",
                        "\WW_Node"
                        )
          for inFClass in inFClasses:
            print "Adding Editor tracking to " + inFClass
            arcpy.EnableEditorTracking_management(inDBConnOwn +inDataset+ inFClass, "CREATEBY","CREATEDATE", "MODIFYBY", "MODIFYDATE", "NO_ADD_FIELDS", "DATABASE_TIME")
            print "Editor tracking enabled on " + inFClass
            
##Adding Editor tracking to OtherAssets------------------------------------------------------------------------------------------------
        if inDataset=="OtherAsset" :
          inFClasses = (
                        "\OA_ECable",
                        "\OA_EPipe",
                        "\OA_EPoints",
                        "\OA_EStructure",
                        "\OA_ECProtection",
                        "\OA_OLines",
                        "\OA_OPoints",
                        "\OA_OShapes"                        
                        )
          for inFClass in inFClasses:
            print "Adding Editor tracking to " + inFClass
            arcpy.EnableEditorTracking_management(inDBConnOwn +inDataset+ inFClass, "CREATEBY","CREATEDATE", "MODIFYBY", "MODIFYDATE", "NO_ADD_FIELDS", "DATABASE_TIME")
            print "Editor tracking enabled on " + inFClass

##Adding Editor tracking to NonWSL---------------------------------------------------------------------------------------------------
        if inDataset=="NonWSL" :
          inFClasses = (
                        "\NW_Fitting",
                        "\NW_Pipe",
                        "\NW_Structure",                   
                        )
          for inFClass in inFClasses:
            print "Adding Editor tracking to " + inFClass
            arcpy.EnableEditorTracking_management(inDBConnOwn +inDataset+ inFClass, "CREATEBY","CREATEDATE", "MODIFYBY", "MODIFYDATE", "NO_ADD_FIELDS", "DATABASE_TIME")
            print "Editor tracking enabled on " + inFClass
##Enable Editor tracking to DCWebWSL---------------------------------------------------------------------------------------------------
        if inDataset=="DCWebWSL" :
          inFClasses = (
                        "\DW_DevTracker",
                        "\DW_GasAlarm",
                        "\DW_Overflow",
                        "\DW_Tradewaste",
                        "\DW_WorksOver",                  
                        )
          for inFClass in inFClasses:
            print "Enable Editor tracking started " + inFClass
            arcpy.EnableEditorTracking_management(inDBConnOwn +inDataset+ inFClass, "CREATEBY","CREATEDATE", "MODIFYBY", "MODIFYDATE", "NO_ADD_FIELDS", "UTC")
            print "Enable Editor tracking completed " + inFClass
##Enable Editor tracking to Other---------------------------------------------------------------------------------------------------
        if inDataset=="Other" :
          inFClasses = (
                        "\O_Addrkey",
                        "\O_AddrkeyRoadBdy",
                        "\O_Connection",
                        "\O_IGC",
                        )
          for inFClass in inFClasses:
            print "Enable Editor tracking started " + inFClass
            arcpy.EnableEditorTracking_management(inDBConnOwn +inDataset+ inFClass, "CREATEBY","CREATEDATE", "MODIFYBY", "MODIFYDATE", "NO_ADD_FIELDS", "DATABASE_TIME")
            print "Enable Editor tracking completed " + inFClass
##Enable Editor tracking to Property---------------------------------------------------------------------------------------------------
        if inDataset=="Property" :
          inFClasses = (
                        "\P_Designation",
                        "\P_Easement",
                        "\P_Lease",
                        "\P_LegalOther",
                        "\P_Parcel",
                        "\P_Tenant",
                        )
          for inFClass in inFClasses:
            print "Enable Editor tracking started " + inFClass
            arcpy.EnableEditorTracking_management(inDBConnOwn +inDataset+ inFClass, "CREATEBY","CREATEDATE", "MODIFYBY", "MODIFYDATE", "NO_ADD_FIELDS", "DATABASE_TIME")
            print "Enable Editor tracking completed " + inFClass
##Enable Editor tracking to Survey---------------------------------------------------------------------------------------------------
        if inDataset=="Survey" :
          inFClasses = (
                        "\S_GPSPoint",
                        "\S_SurveyPoint",
                        )
          for inFClass in inFClasses:
            print "Enable Editor tracking started " + inFClass
            arcpy.EnableEditorTracking_management(inDBConnOwn +inDataset+ inFClass, "CREATEBY","CREATEDATE", "MODIFYBY", "MODIFYDATE", "NO_ADD_FIELDS", "DATABASE_TIME")
            print "Enable Editor tracking completed " + inFClass
#Enable Editor tracking to Water Net2==============================================================================
        if inDataset=="WaterOther" :
          inFClasses =  (
                        "\W_AreaOfService",
                        "\W_Proposed",
                        "\W_RainGauge",
                        "\W_SourceCatchment",
                        "\W_SupplyZone",
                        )
          for inFClass in inFClasses:
            print "Enable Editor tracking started " + inFClass
            arcpy.EnableEditorTracking_management(inDBConnOwn +inDataset+ inFClass, "CREATEBY","CREATEDATE", "MODIFYBY", "MODIFYDATE", "NO_ADD_FIELDS", "DATABASE_TIME")
            print "Enable Editor tracking completed " + inFClass          

#Enable Editor tracking to Wastewater Net2=========================================================================
        if inDataset=="WastewaterOther" :
          inFClasses = (
                        "\WW_AreaOfService",
                        "\WW_CapacityConstraintArea",
                        "\WW_Catchment",
                        "\WW_DrainageArea",
                        "\WW_NDConsent",
                        "\WW_Proposed",
                        "\WW_SeparationArea",
                        )
          for inFClass in inFClasses:
            print "Enable Editor tracking started " + inFClass
            arcpy.EnableEditorTracking_management(inDBConnOwn +inDataset+ inFClass, "CREATEBY","CREATEDATE", "MODIFYBY", "MODIFYDATE", "NO_ADD_FIELDS", "DATABASE_TIME")
            print "Enable Editor tracking completed " + inFClass

            
except Exception, err:
    print err
    
#display complete
filename = __file__
fo.write (filename + " Completed\n")
fo.write("\n")
# Close opend file
fo.close()

print "Editor tracking enabled on all feature classes completed"
