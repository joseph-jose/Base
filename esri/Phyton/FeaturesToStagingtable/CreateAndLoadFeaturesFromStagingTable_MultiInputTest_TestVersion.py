# CreateAndLoadFeaturesFromStagingTable_MultiInputTest_TestVersion.py
# Description:
# Author: Mahesh Patel

# import system modules 
import arcpy, os, sys, time, datetime
from arcpy import env

# Set environment settings
env.workspace = r"G:\Config\SDETest"
env.overwriteOutput = True
ws = env.workspace

try:
    # Start the clock 
    start = datetime.datetime.now()
    print "Start time: ", start.replace(microsecond=0)

    startTime = time.clock()

   
    # Set the local variables
    scriptPath = sys.argv[0]
    try:
        stgTables = sys.argv[1] # Multivalue inputs are semicolon delimited
        hostGDB1 = sys.argv[2] # Select host GDB instead of host fc
        hostGDB2 = sys.argv[3] 
        logFile = sys.argv[4]
    except:
        hostGDB1 = os.path.join(ws, "Master\TestOS@Net1Master.sde")
        hostGDB2 = os.path.join(ws, "Master\TestOS@Net2Master.sde")
        hostGDB3 = os.path.join(ws, "Master\Z_TestGISWSL@ExternalMaster.sde")
        stgGDB1 = os.path.join(ws, "Replica\TestDB@AdminReplica.sde")
        stgGDB2 = os.path.join(ws, "Master\Z_TestGISWSL@ExternalMaster.sde")
        stgTables = [os.path.join(stgGDB1,
                                  "GISAdmin.GISWSL.W_METER_STG"),
                     os.path.join(stgGDB1,
                                  "GISAdmin.GISWSL.O_CONNECTION_STG"),
                     os.path.join(stgGDB2,
                                  "GISExternal.GISWSL.DA_KEYCUSTOMER_STG")]
        logFile = os.path.join(os.path.dirname(scriptPath),
                               "GPMessages_TestLoad.txt")
        print logFile

    # Open log file for writing
    lf = open(logFile,"w")
    lf.write("="*46 + "\n")
    lf.write("New Address-Based Features Log File "
             + str(datetime.date.today()) + "\n")
    lf.write("="*46 + "\n"*2)
    lf.write("Start time: " + str(start.replace(microsecond=0)) + "\n"*2) 

    # Loop through input staging tables
    for stgTable in stgTables: # This applies when run via script toolbar
##    for stgTable in stgTables.split(';'): # This applies when run via tbx

        print stgTable
        arcpy.AddMessage("Staging Table:{0}".format(stgTable))

        # Check input table is correct data type
        try:
            if arcpy.Describe(stgTable).dataType == "Table":
                pass
            else:
                print "Error"
        except arcpy.ExecuteError:
            print(arcpy.GetMessages(2))
            print "ERROR: incorrect data type. 'Standalone' table is required"
            lf.write (
                "ERROR: incorrect data type. 'Standalone' table is required"
                      + "\n")

        # Set temporary workspace
        print "Script home: ", scriptPath
        os.chdir(os.path.expanduser('~'))
        print "Current working directory: ", os.getcwd()
        userName = os.path.split(os.path.expanduser('~'))[1]
        print "User name: ", userName
        outWorkspace = os.path.join(r"\\wsldctvdfs1\users$",userName,
                                    r"Documents\ArcGIS\Default.gdb")
        print "Temp. workspace: ",outWorkspace

        # Set join parameters
        tblName =((os.path.basename(stgTable)).split(".")[2]).rsplit("_",1)[0]
        print tblName

        if tblName=='W_METER':
            hostFC = os.path.join(
                hostGDB1, "GISNet1.GISWSL.Water\GISNet1.GISWSL.W_Meter")
        elif tblName=='O_CONNECTION':
            hostFC = os.path.join(
                hostGDB2, "GISNet2.GISWSL.Other2\GISNet2.GISWSL.O_Connection")
        elif tblName=='DA_KEYCUSTOMER':
            hostFC = os.path.join(
                hostGDB3,
                "GISExternal.GISWSL.DCAGOLWSL\GISExternal.GISWSL.DA_KeyCustomer")            
        
        fcName = (os.path.basename(hostFC)).split(".")[2]
        print fcName.upper()
        if tblName==fcName.upper():
            print "Yes"
            tempLayer = tblName
            print tempLayer
            savedLayer = os.path.join(r"\\wsldctvdfs1\users$", userName,
                                      r"Documents\ArcGIS", tempLayer + ".lyr")
            print savedLayer
            x_coords = "NZTM_E"
            y_coords = "NZTM_N"
            expr1 = "GISNet1.GISWSL." + fcName + ".OBJECTID IS NULL"
            expr2 = "GISNet2.GISWSL." + fcName + ".OBJECTID IS NULL"
            expr3 = "GISExternal.GISWSL." + fcName + ".OBJECTID IS NULL"
            

        # Set fc-specific parameters for join and subsequent creation of new fc
            if tblName == "DA_KEYCUSTOMER":
                inField = "ACCNUM"
                joinField = "ACCNUM"
                whereClause = ""
                expression = expr3
                print expression
            elif tblName == "W_METER":
                inField = "COMPKEY"
                joinField = "COMPKEY"
                whereClause = "STATE = 'ToLoad'"
                expression = expr1
                print expression                
            elif tblName == "O_CONNECTION":
                inField = "ACCTNOPFIX"
                joinField = "ACCTNOPFIX"
                whereClause = "STATE = 'ToLoad'"
                expression = expr2
                print expression                

        # Set the spatial reference
        spatialRef = "2193"#r"Coordinate Systems\Favorites\
                           #NZGD 2000 New Zealand Transverse Mercator.prj"


        # Make the XY event layer...
        arcpy.MakeXYEventLayer_management(stgTable, x_coords, y_coords,
                                          tempLayer, spatialRef)

        # Print the total rows
        print "Number of records in ", tblName, " staging table: ",\
              arcpy.GetCount_management(tempLayer)
        lf.write("Number of records in " + tblName + " staging table: " +
                 str(arcpy.GetCount_management(tempLayer)) + "\n")


        # Save to a layer file
        arcpy.SaveToLayerFile_management(tempLayer, savedLayer)

        
        # Join tables, find unmatched records and create FC of new records
        print "Determine whether records in staging table are new..."
        arcpy.AddMessage("Comparing {0}_STG to {1}".format(tblName, fcName))
        arcpy.AddJoin_management(tempLayer, inField, hostFC, joinField)
        arcpy.SelectLayerByAttribute_management(tempLayer, "NEW_SELECTION",
                                                expression)
        arcpy.RemoveJoin_management(tempLayer)
        newFCName = "New" + fcName.split("_")[1]
        print newFCName
        fcToAppend = arcpy.FeatureClassToFeatureClass_conversion(
            tempLayer, outWorkspace, newFCName, whereClause)
        nonmatchCount = int(arcpy.GetCount_management(fcToAppend).getOutput(0))
        lf.write("There are " + str(nonmatchCount)+
                 " valid non-matching records." + "\n")
        if nonmatchCount > 0:
            print "Number of ", fcName.split("_")[1]," features to load is: ",\
                  nonmatchCount
            lf.write("Number of " + fcName.split("_")[1] +
                     " features to load is: " + str(nonmatchCount) + "\n")
        else:
            print "There are no new records."

        # Confirm number of new features to append is correct
        try:
            tempLayer2 = newFCName + "_layer"
            print tempLayer2
            arcpy.MakeFeatureLayer_management(fcToAppend, tempLayer2)
            savedLayer2 = os.path.join(r"\\wsldctvdfs1\users$",userName,
                                       r"Documents\ArcGIS",tempLayer2 + ".lyr")
            print savedLayer2
            arcpy.SaveToLayerFile_management(tempLayer2, savedLayer2)
            arcpy.AddJoin_management(tempLayer2, inField, hostFC, joinField)
            arcpy.SelectLayerByAttribute_management(tempLayer2,
                                                    "NEW_SELECTION", expression)
            arcpy.RemoveJoin_management(tempLayer2)
            result = arcpy.GetCount_management(tempLayer2)
            checkCount = int(result.getOutput(0))
            lf.write(str(checkCount) + " features have been created." + "\n")
            if checkCount == nonmatchCount:
                print checkCount, " features to load confirmed."
                lf.write(str(checkCount) + " features to load confirmed."\
                         + "\n")
                
                # Populate remaining mandatory fields
                try:
                    print fcToAppend

                    if newFCName == "NewMeter":
                        print "Pass"
                        # Populate mandatory fields
                        arcpy.AddMessage("Populating mandatory fields ...")
                        try:
                            fld1 = "COMPTYPE"
                            fld2 = "SUBTYPE"
                            fld3 = "ACCURACY"
                            fld4 = "ROTATION"
                            fld5 = "SERVICE"
                            fld6 = "UNITTYPE"
                            fld7 = "GRP"
                            fld8 = "AMS"
                            fld9 = "PROCESS"
                            fld10 = "TYPE"
                            fld11 = "GIS_ID"

                            # Add new fields first
                            arcpy.AddField_management(fcToAppend, fld7, "TEXT",
                                                      "", "", 15)
                            arcpy.AddField_management(fcToAppend, fld8, "TEXT",
                                                      "", "", 10)
                            arcpy.AddField_management(fcToAppend, fld9, "TEXT",
                                                      "", "", 15)
                            arcpy.AddField_management(fcToAppend, fld10, "TEXT",
                                                      "", "", 10)
                            arcpy.AddField_management(fcToAppend, fld11, "LONG")
                            
                            arcpy.CalculateField_management(fcToAppend, fld1,
                                                            "42")
                            arcpy.CalculateField_management(fcToAppend, fld2,
                                                            "12")
                            arcpy.CalculateField_management(fcToAppend, fld3,
                                                            "'appr'",
                                                            "PYTHON_9.3")
                            #NOTE: correct string format is "'string'"
                            arcpy.CalculateField_management(fcToAppend, fld4,
                                                            "0")
                            arcpy.CalculateField_management(fcToAppend, fld5,
                                                            "'Local'",
                                                            "PYTHON_9.3")                                                            
                            arcpy.CalculateField_management(fcToAppend, fld7,
                                                            "'Customer'",
                                                            "PYTHON_9.3")
                            arcpy.CalculateField_management(fcToAppend, fld8,
                                                            "'Hansen'",
                                                            "PYTHON_9.3")
                            arcpy.CalculateField_management(fcToAppend, fld11,
                                                            "0")                            
                            # Create dictionary for UNITTYPE domain
                            utyp_dict = {'MTCOMB':'Combo',
                                            'FM':'Flow',
                                            'MTIMP':'Imperial',
                                            'MTMAST':'Master',
                                            'MTNOPT':'Non Potable',
                                            'MTRAIN':'Rain',
                                            'MTSERV':'Service',
                                            'MTSHRE':'Shared',
                                            'MTSTD':'Standard',
                                            'MTDEDT':'Deduction',
                                            'REMOTE':'Remote'}
                            # Populate 'SERVICE' field
                            with arcpy.da.UpdateCursor(fcToAppend,
                                                       [fld6, fld10, fld9])\
                                                       as cursor:
                                for row in cursor:
                                    # Update "TYPE" field
                                    if row[0] == 'MTNOPT':
                                        row[1] = 'NONPOT'
                                    else:
                                        row[1] = 'POT'
                                    cursor.updateRow(row)
                                    # Update "PROCESS" field
                                    for i in range(len(utyp_dict)):
                                        if row[0] == utyp_dict.items()[i][0]:
                                            row[2] = utyp_dict.items()[i][1]
                                            cursor.updateRow(row)
                            print "Meter fields populated"
                        except arcpy.ExecuteError:
                            print arcpy.GetMessages()
                    else:
                        print "No fields populated"
                                
                except arcpy.ExecuteError:
                    print arcpy.GetMessages()
                    
                # Append new features to existing SDE dataset
                arcpy.AddMessage("Loading new features into SDE ...")
                try:
                    arcpy.Append_management(fcToAppend, hostFC, "NO_TEST")
                    print "Appending ", str(checkCount), " new features to the ",\
                          fcName, " feature class..."
                    print checkCount," features successfully loaded into SDE."
                    lf.write(str(checkCount) + " features successfully loaded into "
                             + fcName + "\n"*2)
                except arcpy.ExecuteError:
                    print arcpy.GetMessages()
                
            else:
                print "ERROR occurred: Number of non-matching records differs"\
                      "from check count. No features have been appended."
                lf.write("There is a discrepancy between initial number to"\
                         " load and confirmed number to load - investigate!"\
                         + "\n")

        except Exception as e:
            print "There is a discrepancy - investigate!"
            print e.message
            lf.write(e.message + "\n")
            lf.write("There is a discrepancy between initial number to load and " \
                     "confirmed number to load - investigate!" + "\n"*2)

 
except arcpy.ExecuteError:
    print "Geoprocessing tool error occurred"
    msgs = arcpy.GetMessages(2)
    arcpy.AddError(msgs)
    print msgs
    lf.write(msgs + "\n")


stop = datetime.datetime.now()
print "Finish time: ", stop.replace(microsecond=0)
lf.write("Finish time: " + str(stop.replace(microsecond=0)))
lf.close()


