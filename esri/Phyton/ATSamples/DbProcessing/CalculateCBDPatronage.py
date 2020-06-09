#sjCalculateCBDPatronage.py

#Purpose:
#Calculate AT Monthly HOP Patronage by Station in the CBD

#Process:
#1.  Set Environment Settings
#2.  Get the Selected Stops
#3.  Join the Stops with the Patronage Summary
#4.  Export to CSV
#5.  Remove Join
#6.  Cleanup

#Authoring
#Susan Jones
#25 NOvember 2016

#import Modules
import datetime, string, arcpy, os

#banner
begin = datetime.datetime.now()
arcpy.AddMessage(message = "***\nCalculate AT Monthly HOP Summary Usage By District\n\nSusan Jones\n25th November 2016\n***")

#todo: collect And Set Parameters

#get Workspaces and connections
arcpy.AddMessage(message = "\nGet workspaces, connections and data sources")
connGIS = r'\\atalgisau01\Projects\AT16\AT16135\05_Scripts\me@GIS@atalgissdbp01.sde'
connAT = r'\\atalgisau01\Projects\AT16\AT16135\05_Scripts\me@AT@atalgissdbp01.sde'
destFolder = r'\\atalgisau01\PROJECTS\AT16\AT16135\03_Outputs'
stgwsp = r'\\atalgisau01\Projects\AT16\AT16135\ProjectData.gdb'
TimePeriod = arcpy.GetParameterAsText(0)
if TimePeriod == "YYYY/MM":
    tp = str(datetime.datetime.now())
    TimePeriod = tp[0:4] + "/" + tp[5:7]
arcpy.AddMessage(message = TimePeriod)

#data Sources and Results (Hardcoded)
listStops = [1053, 7099, 1094, 7006, 7015, 7016, 7018, 7022, 1338, 1342, 1325, 7026, 7055, 7056, 7058, 7081, 7093, 7018]
PTStations = connAT + os.path.sep + "gisadmin.PT_IVUGTFSStop_DV"
Patronage = connGIS + os.path.sep + "gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes"

#todo: 1. Set Environment Settings
arcpy.AddMessage(message = "\n1. Set Environment Settings")
arcpy.env.overwriteOutput = 1
arcpy.env.workspace = stgwsp
arcpy.env.qualifiedFieldNames = 0
arcpy.SetSeverityLevel(2)

##2. Get the Selected Stops
arcpy.AddMessage(message = "\n2. Get the Selected Stops")
start = datetime.datetime.now()
#get the where clause
selectedStops = "STOPID IN " + str(listStops).replace("]", ")").replace("[", "(")
selectedRange = " TimePeriod >= \'" + TimePeriod + "\' AND " + selectedStops
arcpy.AddMessage(message = selectedRange)
arcpy.MakeFeatureLayer_management(in_features  = PTStations , out_layer = "CBDStops", where_clause = selectedStops)
arcpy.MakeTableView_management(in_table  = Patronage , out_view = "Patronage", where_clause = selectedRange)
end = datetime.datetime.now()
arcpy.AddMessage(message = "elapsed " + str(end - start))

#todo: 3. Join the Stops with the Patronage Summary
arcpy.AddMessage(message = "\n3. Join the Stops with the Patronage Summary")
start = datetime.datetime.now()
arcpy.AddJoin_management(in_layer_or_view = "Patronage", in_field = "StopID", join_table = "CBDStops", join_field = "StopID", join_type = "keep_all")
end = datetime.datetime.now()
arcpy.AddMessage(message = "elapsed " + str(end - start))

#todo: 4. Export to CSV
arcpy.AddMessage(message = "\n4. Export to CSV")
start = datetime.datetime.now()

#prepare file for writing
csvFile = destFolder + os.path.sep + "PT_CBD_Monthly.csv"
if os.path.exists(csvFile):
    os.remove(csvFile)
fs = open(csvFile, "w")
fs.write("StopID,StopName,Longitude,Latitude,TimePeriod,TotalTagOn,TotalPaper,TotalPatronage\n")
recs = arcpy.SearchCursor("Patronage")
for rec in recs:
    #initialise
    totalTagon = 0
    totalPaper = 0
    totalPatronage = 0
    #get stop details
    stopid = str(rec.getValue("AT.gisadmin.PT_IVUGTFSStop_DV.STOPID"))
    stopname = rec.getValue("AT.gisadmin.PT_IVUGTFSStop_DV.STOPNAME")
    stopdesc = rec.getValue("AT.gisadmin.PT_IVUGTFSStop_DV.STOPDESC")
    longitude = str(rec.getValue("AT.gisadmin.PT_IVUGTFSStop_DV.STOPLON"))
    latitude = str(rec.getValue("AT.gisadmin.PT_IVUGTFSStop_DV.STOPLAT"))
    timeperiod = str(rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.TimePeriod"))
    #get patronage details
    if rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.AdultPaper") <> None:
        Adultpaper = rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.AdultPaper")
    else:
        Adultpaper = 0
    if rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.AdultTagOn") <> None:
        Adulttagon = rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.AdultTagOn")
    else:
        Adulttagon = 0
    if rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.AccessiblePaper") <> None:
        Accessiblepaper = rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.AccessiblePaper")
    else:
        Accessiblepaper = 0
    if rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.AccessibleTagOn") <> None:
        Accessibletagon = rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.AccessibleTagOn")
    else:
        Accessibletagon = 0
    if rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.ChildPaper") <> None:
        Childpaper = rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.ChildPaper")
    else:
        Childpaper = 0
    if rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.ChildTagOn") <> None:
        Childtagon = rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.ChildTagOn")
    else:
        Childtagon = 0
    if rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.SecondaryStudentPaper") <> None:
        SecondaryStudentpaper = rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.SecondaryStudentPaper")
    else:
        SecondaryStudentpaper = 0        
    if rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.SecondaryStudentTagOn") <> None:
        SecondaryStudenttagon = rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.SecondaryStudentTagOn")
    else:
        SecondaryStudenttagon = 0
    if rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.TertiaryStudentPaper") <> None:
        TertiaryStudentpaper = rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.TertiaryStudentPaper")
    else:
         TertiaryStudentpaper = 0
    if rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.TertiaryStudentTagOn") <> None:
        TertiaryStudenttagon = rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.TertiaryStudentTagOn")
    else:
        TertiaryStudenttagon = 0
    if rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.SuperGoldPaper") <> None:
        SuperGoldpaper = rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.SuperGoldPaper")
    else:
        SuperGoldpaper = 0
    if rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.SuperGoldTagOn") <> None:
        SuperGoldtagon = rec.getValue("GIS.gisadmin.AT_Operations_PT_Stop_UniqueTransactionsAllModes.SuperGoldTagOn")
    else:
        SuperGoldtagon= 0

    #calculate
    totalTagon = Adulttagon + Accessibletagon + Childtagon + SecondaryStudenttagon + TertiaryStudenttagon + SuperGoldtagon
    totalPaper = Adultpaper + Accessiblepaper + Childpaper + SecondaryStudentpaper + TertiaryStudentpaper + SuperGoldpaper
    totalPatronage = totalTagon + totalPaper
    #arcpy.AddMessage(message = stopname)
    fs.write(stopid+","+stopname+","+longitude+","+latitude+","+timeperiod+","+str(totalTagon)+","+str(totalPaper)+","+str(totalPatronage)+ "\n")
del recs
fs.close()

end = datetime.datetime.now()
arcpy.AddMessage(message = "elapsed " + str(end - start))


#todo: 5. Remove Join
arcpy.AddMessage(message = "\n5. Remove Join")
start = datetime.datetime.now()
arcpy.RemoveJoin_management(in_layer_or_view = "Patronage")
end = datetime.datetime.now()
arcpy.AddMessage(message = "elapsed " + str(end - start))

        
#todo: 6. Cleanup
arcpy.AddMessage(message = "\n6. Cleanup")
start = datetime.datetime.now()
arcpy.Delete_management(in_data = "CBDStops")
arcpy.Delete_management(in_data = "Patronage")
end = datetime.datetime.now()
arcpy.AddMessage(message = "elapsed " + str(end - start))

#todo: Notify
arcpy.AddMessage(message = "\noutput located in " + csvFile)

arcpy.AddMessage(message = '\ncompleted')
arcpy.AddMessage(message = "elapsed " + str(end - begin))
