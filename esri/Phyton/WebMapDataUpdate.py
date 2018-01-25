# WebMapDataUpdate.py
# Description:
# Author: Mahesh Patel

# import system modules 
import arcpy, os, sys, time, datetime, glob
from arcpy import env

# Set environment settings
env.workspace = r"G:\Config\SDEProd"
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
        sdeGDB = sys.argv[1]
        hostFolder = sys.argv[2]
        stgTables = sys.argv[3]# Multivalue inputs ';'-delimited
        logFile = sys.argv[4]
    except:
        sdeGDB = os.path.join(ws, "Replica\ProdOS@Net2Replica.sde")
        hostFolder = r"F:\Data\LocalNetworkPerformance"
        stgTables = glob.glob(os.path.join(\
            hostFolder, "BusinessObjectsTables\*.xlsx"))
        logFile = os.path.join(hostFolder,
                               "LocalNetworkPerformanceLog.txt")

    hostGDB = os.path.join(hostFolder,
                           "LocalNetworkPerformance_Test.gdb")
    userFolder = os.path.expanduser('~')
    arcpy.CreateFileGDB_management(userFolder, "Temp_ToDelete")
    stgGDB = os.path.join(userFolder, "Temp_ToDelete.gdb")

    # Open log file for writing
    lf = open(logFile,"w")
    lf.write("="*46 + "\n")
    lf.write("LNP Web Map Features Update Log "
             + str(datetime.date.today()) + "\n")
    lf.write("="*46 + "\n"*2)
    lf.write("Start time: " + str(start.replace(microsecond=0)) +\
             "\n"*2)
    # Set other required parameters
    spatialRef = "2193"
    hostFC1 = os.path.join(hostGDB, "AGOL\O_SRequest")
    hostFC2 = os.path.join(hostGDB, "AGOL\O_WorkOrder")
    addrFC = os.path.join(sdeGDB, "GISNet2.GISWSL.Other2",
                         "GISNet2.GISWSL.O_Addrkey")
    pipeFC1 = os.path.join(sdeGDB, "GISNet2.GISWSL.WastewaterL",
                         "GISNet2.GISWSL.WWL_Pipe")
    pipeFC2 = os.path.join(sdeGDB, "GISNet2.GISWSL.WaterL",
                         "GISNet2.GISWSL.WL_Pipe")
    hostFC1name = os.path.basename(hostFC1)
    hostFC2name = os.path.basename(hostFC2)
    fld1 = "SUBTYPE"
    fld2 = "ADDRKEY"
    fld3 = "COMPKEY"
    joinFld1 = fld2
    joinFld2 = fld3
    fldList = ["NZTM_E", "NZTM_N"]
    tmpLyr = "tmpLyr"
    fld4 = "DATASOURCE"
    fld4_val ='"' + 'HA' +\
              str(datetime.date.today()).replace('-','') + '"'

    # Write initial feature counts to log file
    lf.write("-"*46 + "\n")
    lf.write("Initial feature count:" + "\n")
    lf.write("O_SRequest: " +\
             str(arcpy.GetCount_management(hostFC1)) + "\n")
    lf.write("O_WorkOrder: " +\
             str(arcpy.GetCount_management(hostFC2)) + "\n")
    lf.write("-"*46 + "\n"*2)

    # Empty host feature classes to prepare for new data
    arcpy.DeleteFeatures_management(hostFC1)
    arcpy.DeleteFeatures_management(hostFC2)

    lf.write("O_SRequest subtypes:" + "\n" + "\t" +\
             "1 = Fault Service Request" + "\n" + "\t" +\
             "2 = Unplanned Water Interruption" + "\n" + "\t" +\
             "3 = Sewer Break or Choke" + "\n" + "\t" +\
             "4 = Dry Weather Overflow" + "\n"*2)
    lf.write("O_WorkOrder subtypes:" + "\n" + "\t" +\
             "1 = Sewermain Blockage" + "\n" + "\t" +\
             "2 = Watermain Break" + "\n"*2)


    # Loop through input staging tables
    for stgTable in stgTables: # Applies when run via script toolbar
##    for stgTable in stgTables.split(';'): # When run via toolbox
        xlsx_name = os.path.split(stgTable)[-1].split(".")[0] + "_tmp"
        print xlsx_name
        # Create GDB table
        tmp_tbl = os.path.join(stgGDB, xlsx_name)
        arcpy.ExcelToTable_conversion(stgTable, tmp_tbl)
        tblrecordsCount = arcpy.GetCount_management(tmp_tbl)
        print str(tblrecordsCount) + " records in " + xlsx_name
        lf.write("\n" + str(tblrecordsCount) + " records in " +\
                 os.path.split(stgTable)[-1].split(".")[0] + "\n")
        # Create and populate datasource field
        arcpy.AddField_management(tmp_tbl, fld4, "TEXT","",
                                  "","", 20)
        arcpy.CalculateField_management(tmp_tbl, fld4,
                                        fld4_val, "PYTHON_9.3")        
        # Create and populate numeric fields for subtype & address key
        for f in arcpy.ListFields(tmp_tbl):
            if f.name.find("SUBTYPE_tmp")!=-1:
                arcpy.AddField_management(tmp_tbl, fld1 , "SHORT")
                arcpy.CalculateField_management(tmp_tbl, fld1,
                                                '!SUBTYPE_tmp!',
                                                "PYTHON_9.3")
            else:
                pass

        # Generate new features and append to host feature classes
        for f in arcpy.ListFields(tmp_tbl):
            # Point feature class load
            if f.name.find(joinFld1) != -1:
                arcpy.JoinField_management(tmp_tbl, joinFld1, addrFC,
                                            joinFld1, fldList)
                x = [f.name for f in arcpy.ListFields(tmp_tbl,
                                                      "*NZTM_E")][0]
                y = [f.name for f in arcpy.ListFields(tmp_tbl,
                                                      "*NZTM_N")][0]

                # Create a log file variable
                subtypes = [row[0] for row in\
                          arcpy.da.SearchCursor(tmp_tbl, fld1)]
                subtypeSet = set(subtypes)
                for uniqueSubtype in sorted(subtypeSet):
                    subtype = str(uniqueSubtype)

                # Create spatial features
                arcpy.MakeXYEventLayer_management(tmp_tbl, x, y,
                                                  tmpLyr, spatialRef)
                result = arcpy.GetCount_management(tmp_tbl)
                fCount = int(result.getOutput(0))
                arcpy.AddMessage("Appending {0} SUBTYPE {1} features"\
                                 " to {2}".format(str(fCount), subtype,
                                                  hostFC1name))                                                  
                arcpy.Append_management(tmpLyr, hostFC1, "NO_TEST")
                
                print str(fCount) + " 'SUBTYPE "  + subtype +\
                      "' features appended to " + hostFC1name + "."
                lf.write(str(fCount) + " 'SUBTYPE "  + subtype +\
                         "' features appended to " + hostFC1name +\
                         "." + "\n")                    
                
            # Line feature class load
            elif f.name.find(joinFld2) != -1:
                 
                expr1 = "SUBTYPE = 1"
                expr2 = "SUBTYPE = 2"
                wwtmp_tbl = os.path.join(stgGDB, "wwtmp_tbl")
                wstmp_tbl = os.path.join(stgGDB, "wstmp_tbl")
                arcpy.TableSelect_analysis(tmp_tbl, wwtmp_tbl, expr1)
                arcpy.TableSelect_analysis(tmp_tbl, wstmp_tbl, expr2)
                tblflds = ["WKORDERS", fld1, fld4]
                visFlds = ["COMPKEY", "STATUS", "MATERIAL",
                           "INSTALLED", "NOM_DIA_MM"]
                pipeFCdict = {pipeFC1:wwtmp_tbl, pipeFC2:wstmp_tbl}
                pipeFClyr_a = "pipeFClyr_a"
                pipeFClyr_b = "pipeFClyr_b"
                pipeFCtmplyr = "pipeFCtmplyr"
                pipeFCtmp = os.path.join(stgGDB, "pipeFCtmp")

                for i in range(len(pipeFCdict)):
                    pipeFC = pipeFCdict.items()[i][0]
                    pipeTbl = pipeFCdict.items()[i][1]
                    #print arcpy.Describe(pipeFC).dataType
                    arcpy.MakeFeatureLayer_management(pipeFC,
                                                      pipeFClyr_a)
                    desc = arcpy.Describe(pipeFClyr_a)
                    if desc.dataType == "FeatureLayer":
                            # Create a fieldinfo object to keep
                            # selected (i.e., visible) fields only
                            field_info = desc.fieldInfo
                            for index in range(0, field_info.count):
                                # Hide unwanted fields
                                if field_info.getfieldname(index)\
                                   not in visFlds:
                                    field_info.setVisible(index,
                                                          "HIDDEN")
                    # Create layer with selected fields only
                    arcpy.MakeFeatureLayer_management(pipeFClyr_a,
                                                      pipeFClyr_b, "",
                                                      "", field_info)
                    # Create temp. feature class, otherwise ALL fields
                    # are retained for some reason
                    arcpy.CopyFeatures_management(pipeFClyr_b,
                                                  pipeFCtmp)
                    arcpy.MakeFeatureLayer_management(pipeFCtmp,
                                                      pipeFCtmplyr)
                    
                    arcpy.AddJoin_management(pipeFCtmplyr, joinFld2,
                                             pipeTbl, joinFld2,
                                             "KEEP_COMMON")
                    arcpy.SelectLayerByAttribute_management(\
                        pipeFCtmplyr, "NEW_SELECTION")
                    arcpy.RemoveJoin_management(pipeFCtmplyr)
                    arcpy.JoinField_management(pipeFCtmplyr, joinFld2,
                                               pipeTbl, joinFld2,
                                               tblflds)
                    result = arcpy.GetCount_management(pipeFCtmplyr)
                    fCount = int(result.getOutput(0))
                    if str(fCount) != '0':
                        pass
                    else:
                        print str(fCount) + " 'SUBTYPE "  + str(i+1) +\
                              "' features to append. Investigate."
                        lf.write(str(fCount) + " 'SUBTYPE " + str(i+1)\
                                 + "' features to append. Investigate."\
                                 + "\n")
                    arcpy.AddMessage("Appending {0} SUBTYPE {1}"\
                                     " features to {2}".format(\
                                         str(fCount), str(i+1),
                                                  hostFC2name))                      
                    arcpy.Append_management(pipeFCtmplyr, hostFC2,
                                            "NO_TEST")
                    print str(fCount) + " 'SUBTYPE "  + str(i+1) +\
                          "' features appended to " + hostFC2name + "."
                    lf.write(str(fCount) + " 'SUBTYPE "  + str(i+1) +\
                             "' features appended to " + hostFC2name +\
                             "." + "\n")
  

    # Write final feature counts to log file
    lf.write("\n" + "-"*46 + "\n")
    lf.write("Final feature count:" + "\n")
    lf.write("O_SRequest: " + str(arcpy.GetCount_management(hostFC1))\
             + "\n")
    lf.write("O_WorkOrder: " + str(arcpy.GetCount_management(hostFC2))\
             + "\n")
    lf.write("-"*46 + "\n"*2)

##    # Delete staging GDB
##    arcpy.Delete_management(stgGDB)
                            
except arcpy.ExecuteError:
    print "Geoprocessing tool error occurred"
    msgs = arcpy.GetMessages(2)
    arcpy.AddError(msgs)
    print msgs
    lf.write(msgs + "\n")


stop = datetime.datetime.now()
print "Finish time: ", stop.replace(microsecond=0)
lf.write("\n"*2 + "Finish time: " + str(stop.replace(microsecond=0)))
lf.close()


