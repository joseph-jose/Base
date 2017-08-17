# Name: Clean Domains
# Description: Remove unattached domains in the database


# Import system modules
import arcpy


# Set Server Enviromnent
#Env="ProdMaster"
#Env="ProdReplica"
Env="TestMaster"
#Env="TestReplica"
#Env="NewDev"


# Set Database
#inDB="\GISNet1"
#inDB="\GISNet2"
#inDB="\GISBase"
#inDB="\GISExternal"
inDB="\GISStaging"

##inDBConn="\\wsldctvgpw\AGSData\FGDBBaseMly\BaseM.gdb"
##
##inDBConn="\\wsldctvgpw\AGSData\FGDBBaseWly\BaseW.gdb"
##
##inDBConn="\\wsldctvgpw\AGSData\FGDBBaseQly\BaseQ.gdb"
##
##inDBConn="\\wsldctvgpw\AGSData\FGDBBaseYly\Base.gdb"


#Production=============================================================================
if Env=="ProdMaster" :
  if inDB=="\GISNet1" : inDBConn = "N:\SDEConn\Prod\Master\Z_ProdGISWSL@Net1Master.sde"
  if inDB=="\GISNet2" : inDBConn = "N:\SDEConn\Prod\Master\Z_ProdGISWSL@Net2Master.sde"
  if inDB=="\GISBase" : inDBConn = "N:\SDEConn\Prod\Master\Z_ProdGISWSL@BaseMaster.sde"
  if inDB=="\GISExternal" : inDBConn = "N:\SDEConn\Prod\Master\Z_ProdGISWSL@BaseMaster.sde"
  if inDB=="\GISStaging" : inDBConn = "N:\SDEConn\Prod\Master\Z_ProdGISWSL@StagingMaster.sde"
if Env=="ProdReplica" :
  if inDB=="\GISNet1" : inDBConn = "N:\SDEConn\Prod\Replica\Z_ProdGISWSL@Net1Replica.sde"
  if inDB=="\GISNet2" : inDBConn = "N:\SDEConn\Prod\Replica\Z_ProdGISWSL@Net2Replica.sde"
  if inDB=="\GISBase" : inDBConn = "N:\SDEConn\Prod\Replica\Z_ProdGISWSL@BaseReplica.sde"
#Test      =============================================================================
if Env=="TestMaster" :
  if inDB=="\GISNet1" : inDBConn = "N:\SDEConn\Test\Master\Z_TestGISWSL@Net1Master.sde"
  if inDB=="\GISNet2" : inDBConn = "N:\SDEConn\Test\Master\Z_TestGISWSL@Net2Master.sde"
  if inDB=="\GISBase" : inDBConn = "N:\SDEConn\Test\Master\Z_TestGISWSL@BaseMaster.sde"
  if inDB=="\GISStaging" : inDBConn = "N:\SDEConn\Test\Master\Z_TestGISWSL@StagingMaster.sde"
if Env=="TestReplica" :
  if inDB=="\GISNet1" : inDBConn = "N:\SDEConn\Test\Replica\Z_TestGISWSL@Net1Replica.sde"
  if inDB=="\GISNet2" : inDBConn = "N:\SDEConn\Test\Replica\Z_TestGISWSL@Net2Replica.sde"
  if inDB=="\GISBase" : inDBConn = "N:\SDEConn\Test\Replica\Z_TestGISWSL@BaseReplica.sde"
#Development============================================================================
if Env=="DevGDW" :
  if inDB=="\GISNet1" : inDBConn = "N:\SDEConn\DevGDW\Z_GDWGISWSL@Net1.sde"
  if inDB=="\GISNet2" : inDBConn = "N:\SDEConn\DevGDW\Z_GDWGISWSL@Net2.sde"
  if inDB=="\GISBase" : inDBConn = "N:\SDEConn\DevGDW\Z_GDWGISWSL@Base.sde"
if Env=="DevGDE" :
  if inDB=="\GISNet1" : inDBConn = "N:\SDEConn\DevGDE\Z_GDEGISWSL@Net1.sde"
  if inDB=="\GISNet2" : inDBConn = "N:\SDEConn\DevGDE\Z_GDEGISWSL@Net2.sde"
  if inDB=="\GISBase" : inDBConn = "N:\SDEConn\DevGDE\Z_GDEGISWSL@Base.sde"


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

# Get domains that are assigned to a field  
domains_used = []  
for dirpath, dirnames, filenames in arcpy.da.Walk(inDB, datatype=["FeatureClass", "Table"]):  
    for filename in filenames:  
        print "Checking {}".format(os.path.join(dirpath, filename))  
        try:  
            ## Check for normal field domains  
            for field in arcpy.ListFields(os.path.join(dirpath, filename)):
                if field.domain:  
                    domains_used.append(field.domain)  
            ## Check for domains used in a subtype field  
            subtypes = arcpy.da.ListSubtypes(os.path.join(dirpath, filename))  
            for stcode, stdict in subtypes.iteritems():  
                if stdict["SubtypeField"] != u'':  
                    for field, fieldvals in stdict["FieldValues"].iteritems():  
                        if not fieldvals[1] is None:  
                            domains_used.append(fieldvals[1].name)  
        except Exception, err:  
            print "Error:", err  
  
# Get domains that exist in the geodatabase  
domains_existing = [dom.name for dom in arcpy.da.ListDomains(inDBConn)]  
  
# Find existing domains that are not assigned to a field  
domains_unused = set(domains_existing) ^ set(domains_used)  
print "{} unused domains in {}".format(len(domains_unused), inDBConn)  
for domain in domains_unused:  
    arcpy.DeleteDomain_management(inDBConn, domain)  
    print "{} deleted".format(domain)


 
#display complete
filename = __file__
fo.write (filename + " Completed\n")
fo.write("\n")
# Close opend file
fo.close()

print "All unused domains deleted from Database"
