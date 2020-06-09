#gisCalculateTotalUsage.py

#Purpose:
#Calculate AT Monthly HOP Usage.

#Process:
#1.  Set Environment Settings
#2.  field Management
#3.  fetch the featureclasses
#4.  process Featureclasses
#5.  Notify the feature class processing
#6.  Add Join
#7.  join the Districts with the Patronage Summary
#8.  generate The Summary Statistics
#9.  Remove Join
#10. export To Excel Spreadsheet
#11. cleanup

#Authoring
#Susan Jones
#5 October 2016

#import Modules
import datetime, string, arcpy, os

#banner
begin = datetime.datetime.now()
print("***\nCalculate AT Monthly HOP Summary Usage By District\n\nSusan Jones\n5 October 2016\n***")

#todo: collect And Set Parameters

#get Workspaces and connections
print("\nGet workspaces, connections and data sources")
connGIS = r'\\atalgisau01\Projects\AT16\AT16135\05_Scripts\me@GIS@atalgissdbp01.sde'
connAT = r'\\atalgisau01\Projects\AT16\AT16135\05_Scripts\me@AT@atalgissdbp01.sde'
destFolder = r'\\atalgisap01\Projects\PT\HOPMonthlySummary\Output\HOP_Monthly_Summary'
wsp = r'\\atalgisap01\Projects\PT\HOPMonthlySummary\Data\NonSDEDataSource.gdb'
stgwsp = r'\\atalgisap01\Projects\PT\HOPMonthlySummary\Data\ProjectData.gdb'

dt = str(datetime.datetime.now()- datetime.timedelta(days = 30))
lstDt = string.split(dt, "-")
TimePeriod = lstDt[0] + "/" + lstDt[1]
print(TimePeriod)

#data Sources and Results (Hardcoded)
listDistrict = ['West', 'East', 'South', 'North', 'Central']
HOPRegionalClassification = r'\\atalgisau01\Projects\AT16\AT16135\ProjectData.gdb\HOP_District'
PTStations = connAT + os.path.sep + "gisadmin.PT_IVUGTFSStop_DV"
PTMonthlyStats = '\\\\atalgisau01\\Projects\\AT16\\AT16135\\ProjectData.gdb\\PT_Monthly_Statistics'
fc = connGIS + os.path.sep + "gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes"

#Set Environment Settings
print("\n1. Set Environment Settings")
arcpy.env.overwriteOutput = 1
arcpy.env.workspace = stgwsp
arcpy.env.qualifiedFieldNames = 0
arcpy.SetSeverityLevel(2)

#todo: create a Feature Layer for Districts
start = datetime.datetime.now()
print("\n2. create a Feature Layer for Districts")
if arcpy.Exists("Districts"):
    arcpy.Delete_management("Districts")
arcpy.MakeFeatureLayer_management(in_features = HOPRegionalClassification, out_layer = "mmHOPRegionalClassification")
arcpy.MakeFeatureLayer_management(in_features = PTStations, out_layer = "mmPTStations")
arcpy.Identity_analysis(in_features = "mmPTStations", identity_features = "mmHOPRegionalClassification", out_feature_class = stgwsp + "\\Districts")
arcpy.MakeFeatureLayer_management(in_features = stgwsp + "\\Districts", out_layer = "mmDistricts")
arcpy.AddIndex_management(in_table = "mmDistricts", fields = "StopId", index_name = "StopIdIdx")
end = datetime.datetime.now()
print("elapsed " + str(end - start))

#list Fields
deleteFields = ["FID_PT_IVUGTFSStop_DV"]
deleteFields.append("PARENTSTATION")
deleteFields.append("PARENTSTATION")
deleteFields.append("MODE")
deleteFields.append("CREATEBY")
deleteFields.append("CREATEDATE")
deleteFields.append("MODIFYBY")
deleteFields.append("MODIFYDATE")
deleteFields.append("FID_HOP_District")
deleteFields.append("STOPCODE")
deleteFields.append("STOPNAME")
deleteFields.append("STOPDESC")
deleteFields.append("LOCATIONTYPE")

#todo: field Management
start = datetime.datetime.now()
print("\n3. field Management")
fields = arcpy.ListFields("mmDistricts")
for field in fields:
    #remove field
    if field.name in deleteFields:
        arcpy.DeleteField_management(in_table = "mmDistricts", drop_field = field.name)
end = datetime.datetime.now()
print("elapsed " + str(end - start))

#todo: process Featureclasses
print('\n4. process Featureclasses')

#todo; Notify the feature class processing
start = datetime.datetime.now()
print("\n5. Processing " + fc + "")
sqlQuery = "TimePeriod = \'" + TimePeriod + "\'"
arcpy.MakeTableView_management(in_table = fc, out_view = "mmOPS", where_clause = sqlQuery)
end = datetime.datetime.now()
print("elapsed " + str(end - start))

#notify Number of Stops
print("\nStops To Process: " + str(arcpy.GetCount_management("mmOPS")))

#todo: add Spatial Join
start = datetime.datetime.now()
print("\n6. add Spatial Join")
arcpy.AddJoin_management(in_layer_or_view = "mmDistricts", in_field = "stopID", join_table = "mmOPS", join_field = "stopID", join_type = "keep_common") #stopID, stopID
end = datetime.datetime.now()
print("elapsed " + str(end - start))

#copy the Joined Dataset
start = datetime.datetime.now()
print("\n7. join the Districts with the Patronage Summary")
if arcpy.Exists(dataset = stgwsp + "\\Districts_join"):
    arcpy.Delete_management(in_data = stgwsp + "\\Districts_join")
arcpy.FeatureClassToFeatureClass_conversion(in_features = "mmDistricts", out_path = stgwsp, out_name = "Districts_join")

#make an Update Cursor for Null Values
recs = arcpy.UpdateCursor(dataset = stgwsp + "\\Districts_join")
for rec in recs:
    if rec.AdultPaper == None: rec.AdultPaper = 0
    if rec.AdultTagOn == None: rec.AdultTagOn = 0
    if rec.AccessiblePaper == None: rec.AccessiblePaper = 0
    if rec.AccessibleTagOn == None: rec.AccessibleTagOn = 0
    if rec.ChildPaper == None: rec.ChildPaper = 0
    if rec.ChildTagOn == None: rec.ChildTagOn = 0
    if rec.SecondaryStudentPaper == None: rec.SecondaryStudentPaper = 0
    if rec.SecondaryStudentTagOn == None: rec.SecondaryStudentTagOn = 0
    if rec.TertiaryStudentPaper == None: rec.TertiaryStudentPaper = 0
    if rec.TertiaryStudentTagOn == None: rec.TertiaryStudentTagOn = 0
    if rec.SuperGoldPaper == None: rec.SuperGoldPaper = 0
    if rec.SuperGoldTagOn == None: rec.SuperGoldTagOn = 0
    recs.updateRow(rec)
del recs
arcpy.MakeFeatureLayer_management(in_features = stgwsp + "\\Districts_join", out_layer = "mmDistricts_join")


#remove null Districts
#listDistrict = ['West', 'East', 'South', 'North', 'Central']
recs = arcpy.UpdateCursor(dataset = "mmDistricts_join")
for rec in recs:
    #remove Extract District
    if not rec.DISTRICT in listDistrict:
        recs.deleteRow(rec)
del recs
end = datetime.datetime.now()
print("elapsed " + str(end - start))


#todo: generate The Summary Statistics
start = datetime.datetime.now()
print("\n8. todo: generate The Summary Statistics")
valueTable = []
valueTable.append(["Total", "SUM"])
valueTable.append(["AdultPaper", "SUM"])
valueTable.append(["AdultTagOn", "SUM"])
valueTable.append(["AccessiblePaper", "SUM"])
valueTable.append(["AccessibleTagOn", "SUM"])
valueTable.append(["ChildPaper", "SUM"])
valueTable.append(["ChildTagOn", "SUM"])
valueTable.append(["SecondaryStudentPaper", "SUM"])
valueTable.append(["SecondaryStudentTagOn", "SUM"])
valueTable.append(["TertiaryStudentPaper", "SUM"])
valueTable.append(["TertiaryStudentTagOn", "SUM"])
valueTable.append(["SuperGoldPaper", "SUM"])
valueTable.append(["SuperGoldTagOn", "SUM"])        
arcpy.Statistics_analysis(in_table = "mmDistricts_join", out_table = PTMonthlyStats, statistics_fields = valueTable, case_field = "DISTRICT")
end = datetime.datetime.now()
print("elapsed " + str(end - start))

#todo: calculate total Tag On and Paper Ticket Per Zone
start = datetime.datetime.now()
print("\n9. calculate total Tag Ons and Paper Ticket Per Zone")
arcpy.AddField_management(in_table = PTMonthlyStats, field_name = "TotalTagOn", field_type = "DOUBLE")
arcpy.AddField_management(in_table = PTMonthlyStats, field_name = "TotalPaper", field_type = "DOUBLE")
arcpy.AddField_management(in_table = PTMonthlyStats, field_name = "ATHOP_Penetration", field_type = "DOUBLE")
arcpy.DeleteField_management(in_table = PTMonthlyStats, drop_field = ["FREQUENCY"])

#generate Zonal Summary
print("\ngenerate Zonal Summary")
TotalTagOn = 0
TotalPaper = 0
recs = arcpy.UpdateCursor(dataset = PTMonthlyStats)   
#todo: calculate Summary Variables
for rec in recs:
    #initialise
    TotalTagOn = 0
    TotalPaper = 0
    #tag ons
    TotalTagOn = rec.SUM_AdultTagOn + rec.SUM_AccessibleTagOn + rec.SUM_ChildTagOn + rec.SUM_SecondaryStudentTagOn + rec.SUM_TertiaryStudentTagOn + rec.SUM_SuperGoldTagOn
    rec.TotalTagOn = TotalTagOn
    #paper
    TotalPaper = rec.SUM_AdultPaper + rec.SUM_ChildPaper + rec.SUM_SecondaryStudentPaper + rec.SUM_TertiaryStudentPaper + rec.SUM_SuperGoldPaper
    rec.TotalPaper = TotalPaper
    #total patronage
    rec.SUM_Total = rec.TotalTagOn + rec.TotalPaper
    #ATHOP pentetration
    rec.ATHOP_Penetration = rec.TotalTagOn / rec.SUM_Total
    #update the row
    recs.updateRow(rec)
del recs

end = datetime.datetime.now()
print("elapsed " + str(end - start))


#remove Join
start = datetime.datetime.now()
print("\n10. todo: Remove Join")
arcpy.RemoveJoin_management(in_layer_or_view = "mmDistricts")
end = datetime.datetime.now()
print("elapsed " + str(end - start))


#export To Excel Spreadsheet
start = datetime.datetime.now()
print("\n11. todo: export To Excel Spreadsheet")
xlsFile = destFolder + os.path.sep + "AT_Monthly_" + str(TimePeriod.replace("/", "_")) + ".xls"
if os.path.exists(xlsFile):
    os.remove(xlsFile)
arcpy.TableToExcel_conversion (Input_Table = PTMonthlyStats, Output_Excel_File = xlsFile)
end = datetime.datetime.now()
print("elapsed " + str(end - start))      
        
#todo: cleanup
start = datetime.datetime.now()
print("\n12. todo: cleanup")
arcpy.Delete_management(in_data = "mmHOPRegionalClassification")
arcpy.Delete_management(in_data = "mmPTStations")
arcpy.Delete_management(in_data = "mmDistricts")
arcpy.Delete_management(in_data = "mmDistricts_join")
arcpy.Delete_management(in_data = "mmOPS")
##arcpy.Delete_management(in_data = "Districts")
##arcpy.Delete_management(in_data = PTMonthlyStats)
end = datetime.datetime.now()
print("elapsed " + str(end - start))

print('\ncompleted')
print("elapsed " + str(end - begin))
