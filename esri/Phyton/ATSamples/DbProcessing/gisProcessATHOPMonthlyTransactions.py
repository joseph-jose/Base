#gisProcessATHOPMonthlyTransactions.py


#Purpose: Generate the AT Public HOP monthly extracts by the 5th day of every month for the previous Month.

#This works wraps the fme workbenches developed by Stuart Pidgeon into a single unit.

#Dependancies
#   \\atalgisap01\Projects\PT\HOPMonthlySummary\Scripts\FME\HOPHeatMaps1_DW_DataExtract.fmw
#   \\atalgisap01\Projects\PT\HOPMonthlySummary\Scripts\FME\HOPHeatMaps3_CreateStationPoints.fmw
#   \\atalgisap01\Projects\PT\HOPMonthlySummary\Scripts\FME\HOPHeatMaps2_PivotTables.fmw
#   \\atalgisap01\Projects\PT\HOPMonthlySummary\Scripts\FME\HOPHeatMaps4_SummariseByCAU.fmw
#   \\atalgisap01\Projects\PT\HOPMonthlySummary\Scripts\FME\HOPHeatMaps5_SummariseByGrid.fmw



#Authored By: Susan Jones
#Created: 7 July 2016

#todo: Process AT HOP Monthly Patronage Statistics

#import Modules
import arcpy, string, os
import datetime

#measure Start Time
beginProcess = datetime.datetime.now()

#banner
print "***\nProcess AT HOP Monthly Transactions\n***"
print "Start time " + str(beginProcess)

#todo: set Parameters
fme = r"d:\apps\FME\fme.exe"
#gdb = r"\\atalgisap01\Projects\PT\HOPMonthlySummary\Data\NonSDEDataSource.gdb"
gdb = r"\\Atalgisau01\projects\AT14\AT14043\Data\NonSDEDataSource.gdb"
sde = r"\\atalgisap01\Projects\SDEConnections\gisadmin@GIS@atalgissdbp01.sde"
arcpy.env.workspace = gdb
arcpy.env.overwriteOutput = 1


#todo: varTimePeriod
varTimePeriod = str(datetime.datetime.now() - datetime.timedelta(hours = (24*30)))
varTimePeriod = varTimePeriod[0:4] + "/" +  varTimePeriod[5:7]
#varTimePeriod = "2016/09" #todo: adhoc Data range

fld = "TimePeriod"
strWhere = fld + " = \'" + varTimePeriod + "\' OR " + fld + "  Is NULL"
print "\n" + strWhere


#todo: Preliminary. Initialise the tables in the GDB
print "\ntodo: Preliminary. Initialise the tables in the GDB"


#define table to be updated in ArcSDE Database
tables = []

tables.append("AT_Operations_PT_PostCode_HOPRegistrations")
tables.append("AT_Operations_PT_Stop_DistinctHOPCardAllModes")
tables.append("AT_Operations_PT_Stop_DistinctHOPCardBus")
tables.append("AT_Operations_PT_Stop_DistinctHOPCardBusTrain")
tables.append("AT_Operations_PT_Stop_StoredValueTopup")
tables.append("AT_Operations_PT_Stop_UniqueTransactionsAllModes")
tables.append("AT_Operations_PT_Stop_UniqueTransactionsBus")
tables.append("AT_Operations_PT_Stop_UniqueTransactionsBusTrain")

tables.append("AT_Operations_PT_CAU_UniqueTransactionsBusTrain")
tables.append("AT_Operations_PT_CAU_UniqueTransactionsBus")
tables.append("AT_Operations_PT_CAU_UniqueTransactionsAllModes")


tables.append("AT_Operations_PT_Grid_UniqueTransactionsBus")
tables.append("AT_Operations_PT_Grid_UniqueTransactionsBusTrain")
tables.append("AT_Operations_PT_Grid_UniqueTransactionsAllModes")

tables.append("AT_Operations_PT_Grid_DistinctHOPCardBus")
tables.append("AT_Operations_PT_Grid_DistinctHOPCardBusTrain")
tables.append("AT_Operations_PT_Grid_DistinctHOPCardAllModes")


#cycle through all the GDB tables and truncate the current varTimePeriod
for table in tables:

    #truncate Table for the current Time Period
    start = datetime.datetime.now()
    #source SDE Tables
    GDBTable = gdb + os.path.sep + table
    try:
        arcpy.MakeTableView_management(in_table = GDBTable, out_view = "GDBTable", where_clause = strWhere)
        arcpy.DeleteRows_management(in_rows = "GDBTable")
    except:
        arcpy.MakeFeatureLayer_management(in_table = GDBTable, out_view = "GDBTable", where_clause = strWhere)
        arcpy.DeleteFeatures_management(in_features = "GDBTable")
    end = datetime.datetime.now()
    print table + " loaded in " + str(end - start) + " seconds (" + str(arcpy.GetCount_management("GDBTable")) + ")"


#todo: 1. PT HOP: Create EDW Data Extract
print "\ntodo: 1. PT HOP: Create EDW Data Extract"
start = datetime.datetime.now()
package = "\"\\\\atalgisap01\\Projects\\PT\\HOPMonthlySummary\\Scripts\\FME\\HOPHeatMaps1_DW_DataExtract.fmw\""
cmd = fme + " " + package + " --varTimePeriod " + varTimePeriod
print cmd
os.system(cmd)
end = datetime.datetime.now()
print 'elapsed ' + str(end - start)


#todo: 2. PT HOP: Create Station Points
print "\ntodo: 2. PT HOP: Create Station Points"
start = datetime.datetime.now()
package = "\"\\\\atalgisap01\\Projects\\PT\\HOPMonthlySummary\\Scripts\\FME\\HOPHeatMaps3_CreateStationPoints.fmw\""
cmd = fme + " " + package
print cmd
os.system(cmd)
end = datetime.datetime.now()
print 'elapsed ' + str(end - start)


#todo: 3. PT HOP: Create Pivot Tables
print "\ntodo: 3. PT HOP: Create Pivot Tables"
start = datetime.datetime.now()
package = "\"\\\\atalgisap01\\Projects\\PT\\HOPMonthlySummary\\Scripts\\FME\\HOPHeatMaps2_PivotTables.fmw\""
cmd = fme + " " + package
print cmd
os.system(cmd)
end = datetime.datetime.now()
print 'elapsed ' + str(end - start)


#todo: 4. PT HOP: Summarise by Census Area Unit
print "\ntodo: 4. PT HOP: Summarise by Census Area Unit"
start = datetime.datetime.now()
package = "\"\\\\atalgisap01\\Projects\\PT\\HOPMonthlySummary\\Scripts\\FME\\HOPHeatMaps4_SummariseByCAU.fmw\""
cmd = fme + " " + package + " --varTimePeriod " + varTimePeriod
print cmd
os.system(cmd)
end = datetime.datetime.now()
print 'elapsed ' + str(end - start)


#todo: 5. PT HOP: Summarise by Grid
print "\ntodo: 5. PT HOP: Summarise by Grid"
start = datetime.datetime.now()
package = "\"\\\\atalgisap01\\Projects\\PT\\HOPMonthlySummary\\Scripts\\FME\\HOPHeatMaps5_SummariseByGrid.fmw\""
cmd = fme + " " + package + " --varTimePeriod " + varTimePeriod
print cmd
os.system(cmd)
end = datetime.datetime.now()
print 'elapsed ' + str(end - start)


#todo: 6. Load the PT HOP Tables in ArcSDE
print "\ntodo: 6. Load the PT HOP Tables in ArcSDE"

#define table to be updated in ArcSDE Database
tables = []
tables.append("AT_Operations_PT_PostCode_HOPRegistrations")
tables.append("AT_Operations_PT_Stop_UniqueTransactionsBus")
tables.append("AT_Operations_PT_Stop_UniqueTransactionsAllModes")
tables.append("AT_Operations_PT_Stop_StoredValueTopup")
tables.append("AT_Operations_PT_Stop_DistinctHOPCardBus")
tables.append("AT_Operations_PT_Stop_DistinctHOPCardAllModes")
tables.append("AT_Operations_PT_Grid_UniqueTransactionsBus")
tables.append("AT_Operations_PT_Grid_UniqueTransactionsAllModes")
tables.append("AT_Operations_PT_Grid_DistinctHOPCardAllModes")
tables.append("AT_Operations_PT_Grid_DistinctHOPCardBus")
tables.append("AT_Operations_PT_Grid_DistinctHOPCardAllModes")
tables.append("AT_Operations_PT_CAU_UniqueTransactionsBusTrain")
tables.append("AT_Operations_PT_CAU_UniqueTransactionsBus")
tables.append("AT_Operations_PT_CAU_UniqueTransactionsAllModes")

#cycle through all the tables refreshing the ArcSDE datasource
print "\n" + strWhere
for table in tables:

    try:
        start = datetime.datetime.now()
        #source SDE Tables
        SDETable = sde + os.path.sep + "GIS.GISADMIN." + table
        arcpy.MakeTableView_management(in_table = SDETable, out_view = "SDETable", where_clause = strWhere)
        #todo: delete Features
        arcpy.DeleteRows_management(in_rows = "SDETable")
        #todo: append Features
        arcpy.MakeTableView_management(in_table = table, out_view = "GDBTable", where_clause = strWhere)
        arcpy.Append_management(inputs = "GDBTable", target = "SDETable", schema_type = "TEST")
        end = datetime.datetime.now()
        print table + " loaded in " + str(end - start) + " seconds (" + str(arcpy.GetCount_management("GDBTable")) + ")"
        #cleanup in_memory tables
        arcpy.Delete_management("GDBTable")
        arcpy.Delete_management("SDETable")

    except:
        print "cannot process " + table


#measure End Time
endProcess = datetime.datetime.now()
print "End time " + str(endProcess)

print "\nprocess completed in " + str(endProcess - beginProcess) + "\n"

print "\n***\ncompleted"
