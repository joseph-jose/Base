#smjProcessSpreadsheets.py

#Purpose:
#Append a excel spreadsheets into a summary csv

#DATA Sources and Destinations
#Source \\atalgisau01\PROJECTS\AT16\AT16135\03_Outputs\AT_Operations_PT_Stop_UniqueTransactionsAllModes
#Destination \\atalgisau01\PROJECTS\AT16\AT16135\03_Outputs\AT_Operations_PT_Stop_UniqueTransactionsAllModes\ATHOP_Monthly.csv

#import Modules
import string, arcpy, os

#banner
print '***\nCREATE AT Monthly Summary\n***\n'


#set Parameters
arcpy.AddMessage(message = "\n1. Set Parameters")
wsp = r'\\atalgisau01\PROJECTS\AT16\AT16135\03_Outputs\AT_Operations_PT_Stop_UniqueTransactionsAllModes'
arcpy.env.workspace = wsp
arcpy.env.overwriteOutput = 1

#Create Summary ATHOP_Monthly.csv File
arcpy.AddMessage(message = "\n2. Create Summary ATHOP_Monthly.csv File")
if os.path.exists(wsp + os.path.sep + "ATHOP_Monthly.csv"):
    os.remove(wsp + os.path.sep + "ATHOP_Monthly.csv")
wFs = open(wsp + os.path.sep + "ATHOP_Monthly.csv", 'w')
wFs.write("DISTRICT,TimePeriod,TotalTagOn,TotalPaper,SUM_Total,ATHOP_Penetration\n")

#Process Excel files
arcpy.AddMessage(message = "\n3. Process Excel files")
fieldList = ["DISTRICT", "TotalTagOn", "TotalPaper", "SUM_Total", "ATHOP_Pene"]
fs = os.listdir(wsp)
for f in fs:

    #cycle Excel Sheets
    if f.find('AT_Monthly') > -1:

        #create in_memory table
        TimePeriod = f.replace("AT_Monthly_", "").replace(".xls", "").replace("_", "_")
        arcpy.AddMessage(message = "Prccessing " + TimePeriod)
        arcpy.ExcelToTable_conversion(Input_Excel_File = f, Output_Table = "in_memory\\TEST")
        recs = arcpy.da.SearchCursor(in_table = "in_memory\\TEST", field_names = fieldList)

        #print rows
        for rec in recs:
##            if rec[0] in ["East", "Central", "North", "West", "South"]:
            wFs.write(rec[0] + "," + TimePeriod + "," + str(rec[1]) + "," + str(rec[2]) + "," + str(rec[3]) + "," + str(rec[4]) + "\n")
        

#Cleanup
arcpy.AddMessage(message = "\n4. Cleanup")
del recs
arcpy.Delete_management(in_data = "in_memory\\TEST")
wFs.close()

#completed
arcpy.AddMessage(message = "\ncompleted")

