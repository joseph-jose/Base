# CreateAndLoadFeaturesFromStagingTable.py
# Description:

def position_bfprev():
    # Set local variables
    stgFC = create_tmp_bfprev()
    bfFC = stgFC
    print bfFC
    arcpy.env.workspace = outWorkspace
    arcpy.env.overwriteOutput = True
    # Link temp. b/flow prev's to meters (via addr. key) to get a more
    # accurate position based on location description field
    joinField1 = "COMPKEY"
    joinField2 = "ADDRKEY"
    mtrFCLyr = "mtrFCLyr"
    mtrFCName = os.path.basename(mtrFC).split('.', 2)[2]
    mtrFCtmp = os.path.join(outWorkspace, mtrFCName + "_BF_Compare_tmp")
    print mtrFCtmp
    arcpy.MakeFeatureLayer_management(mtrFC, mtrFCLyr)
    arcpy.AddJoin_management(mtrFCLyr, joinField2, bfFC, joinField2,
                             "KEEP_COMMON")
    arcpy.SelectLayerByAttribute_management(mtrFCLyr, "NEW_SELECTION")
    print str(arcpy.GetCount_management(mtrFCLyr))
    arcpy.CopyFeatures_management(mtrFCLyr, mtrFCtmp)
    print "Temp. feature class created."

    # Tag features where meter no. is cited in b/f location description
    fld1 = "OBJECTID"
    fld2 = [f.name for f in arcpy.ListFields(mtrFCtmp,
                                             "*Meter_UNITID")][0]
    fld3 = [f.name for f in arcpy.ListFields(mtrFCtmp,
                                             "*tmp_ADDRQUAL")][0]
    fld4 = "MTR_MATCH"
    arcpy.AddField_management(mtrFCtmp, fld4, "TEXT", "", "", 1)
    print fld2, fld3
    with arcpy.da.UpdateCursor(mtrFCtmp, [fld1, fld2, fld3, fld4])\
         as cursor1:
        for row in cursor1:
            if row[2] is None:
                pass
            elif row[2].find(row[1]) != -1:
                row[3] = "Y"
                cursor1.updateRow(row)
            elif row[2].find(row[1].split((row[1])[0],1)[1]) != -1:
                row[3] = "Y"
                cursor1.updateRow(row)
            else:
    ##            cursor1.deleteRow()
                row[3] = "N"
                cursor1.updateRow(row)


    # Determine where meter sits and add a comment
    fld5 = "GIS_COMM"
    arcpy.AddField_management(mtrFCtmp, fld5, "TEXT", "", "", 20)
    mtrFCtmpLyr = "mtrFCtmpLyr"
    arcpy.MakeFeatureLayer_management(mtrFCtmp, mtrFCtmpLyr)

    # Create list of temporary positioned feature classes
    mtrPosFC_list = []
    # ... meters connected to service lines
    expr4 = "SUBTYPE = 2"
    srvlineFC = os.path.join(outWorkspace, "ServiceLines_tmp")
    arcpy.Select_analysis(pipeFC, srvlineFC, expr4)
    arcpy.SelectLayerByLocation_management(mtrFCtmpLyr,
                                           "WITHIN_A_DISTANCE",
                                           srvlineFC, "0.1 Meters",
                                           "NEW_SELECTION")

    print str(arcpy.GetCount_management(mtrFCtmpLyr)) +\
          " staging feature(s) on s/line"
    # Proceed only if number of features on s/l is not zero ...
    if str(arcpy.GetCount_management(mtrFCtmpLyr)) == '0': # 0 is
        # boolean, hence convert to string to avoid erroneous process
        pass
    else:
        with arcpy.da.UpdateCursor(mtrFCtmpLyr, fld5) as cursor3:
            for row in cursor3:
                row[0] = "Service line"
                cursor3.updateRow(row)

        # Create s/line buffers, extend s/l to buffer, get XY of end pt
        srvlineFCLyr = "srvlineFCLyr"

        arcpy.MakeFeatureLayer_management(srvlineFC, srvlineFCLyr)
        arcpy.SelectLayerByLocation_management(srvlineFCLyr,
                                               "WITHIN_A_DISTANCE",
                                               mtrFCtmpLyr,
                                               "0.1 Meters",
                                               "NEW_SELECTION")
        print str(arcpy.GetCount_management(srvlineFCLyr)) + " s/lines"
        srvlineFCtmp = os.path.join(outWorkspace, "srvlineFCtmp")
        arcpy.CopyFeatures_management(srvlineFCLyr, srvlineFCtmp)
        srvlineFCtmpLyr = "srvlineFCtmpLyr"
        arcpy.MakeFeatureLayer_management(srvlineFCtmp, srvlineFCtmpLyr)
        print str(arcpy.GetCount_management(srvlineFCtmpLyr)) +\
              " s/line feature(s)"
        slbuffTmp = os.path.join(outWorkspace, "slbufftmp")
        arcpy.Buffer_analysis(srvlineFCtmpLyr, slbuffTmp, "2 Meters")
        slbufflineTmp = os.path.join(outWorkspace, "slbufflinetmp")
        arcpy.PolygonToLine_management(slbuffTmp, slbufflineTmp)

        srvlineFCtmp2 = os.path.join(outWorkspace, "srvlineFCtmp2")
        arcpy.Merge_management([slbufflineTmp, srvlineFCtmpLyr],
                               srvlineFCtmp2)
        srvlineFCtmp2Lyr = "srvlineFCtmp2Lyr"
        arcpy.MakeFeatureLayer_management(srvlineFCtmp2,
                                          srvlineFCtmp2Lyr)
        arcpy.ExtendLine_edit(srvlineFCtmp2Lyr, "2 Meters", "FEATURE")
        print str(arcpy.GetCount_management(srvlineFCtmp2Lyr)) +\
        " s/line features"
        slbufflineTmp_endpt = os.path.join(outWorkspace,
            "slbufflinetmp_endpt")
        arcpy.FeatureVerticesToPoints_management(srvlineFCtmp2Lyr,
                                                 slbufflineTmp_endpt,
                                                 "END")
        print str(arcpy.GetCount_management(srvlineFCtmp2Lyr)) +\
              " s/line feature(s)"
        arcpy.Near_analysis(mtrFCtmpLyr, slbufflineTmp_endpt, "",
                            "LOCATION")
        print str(arcpy.GetCount_management(mtrFCtmpLyr)) +\
              " s/lines NEAR"
        mtrFCtmp_sl = os.path.join(outWorkspace, "mtrFCtmp_sl")
        arcpy.CopyFeatures_management(mtrFCtmpLyr, mtrFCtmp_sl)
        mtrPosFC_list.append(mtrFCtmp_sl)

    # ... meters sitting on parcel boundaries
    expr5 = fld5 + ' IS NULL'
    print expr5
    arcpy.SelectLayerByAttribute_management(mtrFCtmpLyr,
                                            "NEW_SELECTION", expr5)
    print str(arcpy.GetCount_management(mtrFCtmpLyr)) +\
          " staging feature(s) not on s/line"
    arcpy.SelectLayerByLocation_management(mtrFCtmpLyr,
                                           "WITHIN_A_DISTANCE",
                                           pclbdyFC, "0.1 Meters",
                                           "SUBSET_SELECTION")
    print str(arcpy.GetCount_management(mtrFCtmpLyr)) +\
          " staging feature(s) on pcl bdy"
    # Proceed only if number of features on bdy is not zero ...
    if str(arcpy.GetCount_management(mtrFCtmpLyr)) == '0':
        pass
    else:
        with arcpy.da.UpdateCursor(mtrFCtmpLyr, fld5) as cursor2:
            for row in cursor2:
                row[0] = "Parcel boundary"
                cursor2.updateRow(row)
        print str(arcpy.GetCount_management(mtrFCtmpLyr)) +\
              " staging feature(s) on pcl bdy"
        # Create internal buffers in parcels containing backflow prev.
        pclLyr = "pclLyr"
        pclbdyLyr = "pclbdyLyr"
        addrFCLyr = "addrFCLyr"
        fld6 = [f.name for f in arcpy.ListFields(mtrFCtmp,
                                                 "*tmp_ADDRKEY")][0]
        buffTmp = os.path.join(outWorkspace, "bufftmp")
        arcpy.MakeFeatureLayer_management(pclFC, pclLyr)
        arcpy.MakeFeatureLayer_management(pclbdyFC, pclbdyLyr)
        arcpy.MakeFeatureLayer_management(addrFC, addrFCLyr)
        arcpy.AddJoin_management(addrFCLyr, joinField2, mtrFCtmpLyr,
                                 fld6, "KEEP_COMMON")
        arcpy.SelectLayerByAttribute_management(addrFCLyr,
                                                "NEW_SELECTION")
        arcpy.SelectLayerByLocation_management(pclLyr, "INTERSECT",
                                               addrFCLyr)
        arcpy.Buffer_analysis(pclLyr, buffTmp, "-2 Meters")
        print "Internal buffer polygons created"
        arcpy.Near_analysis(mtrFCtmpLyr, buffTmp, "", "LOCATION")
        mtrFCtmp_bdy = os.path.join(outWorkspace, "mtrFCtmp_bdy")
        arcpy.CopyFeatures_management(mtrFCtmpLyr, mtrFCtmp_bdy)
        mtrPosFC_list.append(mtrFCtmp_bdy)

    # ... meters isolated from any other feature class
    arcpy.SelectLayerByAttribute_management(mtrFCtmpLyr,
                                            "NEW_SELECTION", expr5)
    print str(arcpy.GetCount_management(mtrFCtmpLyr)) +\
          " staging feature(s) isolated"
    # Proceed only if number of isolated features is not zero ...
    if str(arcpy.GetCount_management(mtrFCtmpLyr)) == '0':
        pass
    else:
        with arcpy.da.UpdateCursor(mtrFCtmpLyr, fld5) as cursor3:
            for row in cursor3:
                row[0] = "Isolated point"
                cursor3.updateRow(row)
        print str(arcpy.GetCount_management(mtrFCtmpLyr)) +\
              " staging feature(s) isolated"
        mtrFCtmp_isol = os.path.join(outWorkspace, "mtrFCtmp_isol")
        arcpy.CopyFeatures_management(mtrFCtmpLyr, mtrFCtmp_isol)
        mtrPosFC_list.append(mtrFCtmp_isol)


    mtrFCtmp2 = os.path.join(outWorkspace, mtrFCName +\
                             "_BF_Compare_tmp2")

    arcpy.Merge_management(mtrPosFC_list, mtrFCtmp2)
        
       
    print "Fields updated"

    # Append x,y and meter match fields to temp. backflow prev.s
    stgBFtmp = os.path.join(outWorkspace, "BackFlow_STGtmp")
    joinField3 = [f.name for f in arcpy.ListFields(mtrFCtmp2,
                                                   "*tmp_COMPKEY")][0]
    x = [f.name for f in arcpy.ListFields(mtrFCtmp2, "*_X")][0]
    y = [f.name for f in arcpy.ListFields(mtrFCtmp2, "*_Y")][0]
    mtrFCtmp3 = os.path.join(outWorkspace, mtrFCName +\
                             "_BF_Compare_tmp3")
    expr6 = fld4 + " = 'Y'"
    arcpy.Select_analysis(mtrFCtmp2, mtrFCtmp3, expr6)
    arcpy.JoinField_management(bfFC, joinField1, mtrFCtmp3, joinField3,
                                [fld4, fld5, x, y])
    arcpy.MakeFeatureLayer_management(bfFC, "bfFC_lyr")
    arcpy.SelectLayerByAttribute_management("bfFC_lyr", "NEW_SELECTION")
    arcpy.CopyFeatures_management("bfFC_lyr", stgBFtmp)

    # Place b/f prev. without a meter match on parcel buffer
    ##arcpy.MakeFeatureLayer_management(stgBFtmp, "stgBFtmp_lyr")
    ##arcpy.SelectLayerByAttribute_management("stgBFtmp_lyr",
    ##                                         "NEW_SELECTION", expr5)
    ##arcpy.AddJoin_management("stgBFtmp_lyr", joinField1, mtrFCtmp_bdy,
    ##                         joinField3)

    arcpy.JoinField_management(stgBFtmp, joinField1, mtrFCtmp_bdy,
                               joinField3, [x, y])
    arcpy.MakeFeatureLayer_management(stgBFtmp, "stgBFtmp_lyr")
    arcpy.SelectLayerByAttribute_management("stgBFtmp_lyr",
                                            "NEW_SELECTION", expr5)
    x1 = [f.name for f in arcpy.ListFields(stgBFtmp, "*_X_1")][0]
    y1 = [f.name for f in arcpy.ListFields(stgBFtmp, "*_Y_1")][0]
    with arcpy.da.UpdateCursor("stgBFtmp_lyr", ["NEAR_X", "NEAR_Y",
                                                x1, y1])\
         as cursor4:
        for row in cursor4:
            row[0] = row[2]
            row[1] = row[3]
            cursor4.updateRow(row)
    arcpy.SelectLayerByAttribute_management("stgBFtmp_lyr",
                                            "CLEAR_SELECTION")
    arcpy.DeleteField_management(stgBFtmp, [x1, y1])


    # Place remaining b/f of unknown location on road bdy point
    ##expr7 = fld5 + " = 'N' AND " + fld4 + " IN " +\
    ##        "('Service line', 'Isolated point')"
    fld6 = "NEAR_X"
    expr7 = fld6 + " IS NULL OR " + fld6 + " = -1"
    arcpy.MakeFeatureLayer_management(stgBFtmp, "stgBFtmp_lyr")
    arcpy.SelectLayerByAttribute_management("stgBFtmp_lyr",
                                            "NEW_SELECTION", expr7)
    arcpy.CalculateField_management("stgBFtmp_lyr", x,
                                    "!SHAPE.CENTROID.X!", "PYTHON_9.3")
    arcpy.CalculateField_management("stgBFtmp_lyr", y,
                                    "!SHAPE.CENTROID.Y!", "PYTHON_9.3")
    arcpy.SelectLayerByAttribute_management("stgBFtmp_lyr",
                                            "CLEAR_SELECTION")
    arcpy.CopyRows_management("stgBFtmp_lyr", os.path.join(outWorkspace,
                                                      "tmpXYtbl"))
    print str(arcpy.GetCount_management("tmpXYtbl"))
    spatialRef = "2193"
    tmpLyr2 = "tmpLyr2"
    arcpy.MakeXYEventLayer_management("tmpXYtbl", x, y, tmpLyr2,
                                      spatialRef)
    stgBF = os.path.join(outWorkspace, "BackFlow_STG")
    arcpy.CopyFeatures_management(tmpLyr2, stgBF)
    arcpy.Delete_management("tmpXYtbl")
    tmpFCs = arcpy.ListFeatureClasses("*tmp*")
    for tmpFC in tmpFCs:
        arcpy.Delete_management(tmpFC)
    print "Staging backflow preventer feature class created"
    arcpy.AddMessage("{} backflow preventers created"\
                     .format(str(arcpy.GetCount_management(stgBF))))
    lf.write(str(arcpy.GetCount_management(stgBF)) +\
             " backflow preventers loaded into SDE" + "\n")

def create_tmp_bfprev():
    lf.write("="*46 + "\n")
    lf.write("Backflow Features Log File "
             + str(datetime.date.today()) + "\n")
    lf.write("="*46 + "\n"*2)
    lf.write("Start time: "
             + str(start.replace(microsecond=0)) + "\n"*2) 

    # Create names for staging data
    tblName = os.path.basename(stgTable).split("_")[1]
    print "Table name: ", tblName
    fcName = (os.path.basename(hostFC)).split(".")[2]
    print "Feature class name: ", fcName
 
    # Create new table from Hansen table to generate OIDs, which are
    # required to execute a join
    stgTblOID = os.path.join(outWorkspace, tblName)
    arcpy.CopyRows_management(stgTable, stgTblOID)

    # Set parameters for first join
    tblView = "tbl_view"
    joinField1 = "COMPKEY"
    # Set expression to determine unmatched records when stg table is
    # joined to feature class in SDE ProdMaster
    expr1 = fcName + ".OBJECTID IS NULL"
    # Set expression to select valid records
    expr2 = "SERVSTAT = 'IN' AND LOC <> 'BINT'"
    arcpy.MakeTableView_management(stgTblOID, tblView, expr2)

    # Set parameters for second join
    joinField2 = "ADDRKEY"
    fieldList = ["NZTM_E", "NZTM_N"]
    # Create temp. feature class of backflow preventers only
    expr3 = "SUBTYPE IN (5,6)"
    hostFCtmp = os.path.join(outWorkspace, fcName)
    arcpy.Select_analysis(hostFC, hostFCtmp, expr3)
    
    # Find unmatched records and create table of new records  
    print "Determine whether records in staging table are new..."
    arcpy.AddMessage("Determining unmatched records ...")
    arcpy.AddJoin_management(tblView, joinField1, hostFCtmp,
                             joinField1)
    arcpy.SelectLayerByAttribute_management(tblView,
                                            "NEW_SELECTION", expr1)
    arcpy.RemoveJoin_management(tblView)
    print arcpy.GetCount_management(tblView), " valid new records"
    lf.write(str(arcpy.GetCount_management(tblView)) +\
             " valid new records" + "\n")
    arcpy.JoinField_management(tblView, joinField2, addrbdyFC,
                                joinField2, fieldList)
    stgTblXY = os.path.join(outWorkspace, tblName + "XY")
    arcpy.CopyRows_management(tblView, stgTblXY)
    arcpy.Delete_management(stgTblOID)
    arcpy.Delete_management(hostFCtmp)

    # Create a staging feature class
    spatialRef = "2193"
    x = fieldList[0]
    y = fieldList[1]
    tmpLyr = "tmpLyr"
    stgFC = os.path.join(outWorkspace, tblName + "_tmp")
    arcpy.MakeXYEventLayer_management(stgTblXY, x, y, tmpLyr,
                                      spatialRef)
    arcpy.CopyFeatures_management(tmpLyr, stgFC)
    arcpy.Delete_management(stgTblXY)
    print "Temp. backflows created"
    lf.write(str(arcpy.GetCount_management(stgFC)) +\
             " temp. backflow preventers created" + "\n")

    # Add additional mandatory fields
    arcpy.AddMessage("Populating mandatory fields ...")

    # Create a dictionary of additional required text fields
    # with field names, field length, & field value
    # NOTE: correct string format is "'string'"
    txtFlds = {"ACCURACY-20":"'appr'", "PROCESS-15":"'Backflow Prev'",
               "GRP-15":"'Backflow'", "AMS-10":"'Hansen'",
               "MODIFYREF-20":"'New'", "DATASOURCE-20":""}
    datasource_val ='"' + 'HA' +\
                     str(datetime.date.today()).replace('-','') + '"'
    for i in range(len(txtFlds)):
        fld_nm = txtFlds.keys()[i].split('-')[0]
        fld_len = txtFlds.keys()[i].split('-')[1]
        fld_val = txtFlds.values()[i]
        arcpy.AddField_management(stgFC, fld_nm, "TEXT",
                              "", "", fld_len)
        if fld_nm != 'DATASOURCE':
            arcpy.CalculateField_management(stgFC, fld_nm, fld_val,
                                        "PYTHON_9.3")
        else:
            arcpy.CalculateField_management(stgFC,
                                            fld_nm, datasource_val,
                                            "PYTHON_9.3")

    # Create and populate additional required numeric fields
    numFld1 = 'COMPTYPE'
    numFld2 = 'ROTATION'
    numFld3 = 'SUBTYPE'
    arcpy.AddField_management(stgFC, numFld1, "LONG", 10)
    arcpy.AddField_management(stgFC, numFld2, "DOUBLE", 8, 2)
    arcpy.AddField_management(stgFC, numFld3, "SHORT", 5)
    arcpy.CalculateField_management(stgFC, numFld1, "38")
    arcpy.CalculateField_management(stgFC, numFld2, "0")
    # Determine and populate correct sub type
    # Get date field
    dateFld = [f.name for f in arcpy.ListFields(stgFC,"", "Date")][0]
    present = datetime.datetime.today() # Format is date and time
    # as are values in the date field
    with arcpy.da.UpdateCursor(stgFC, [dateFld, numFld3]) as cursor:
        for row in cursor:
            if (present + timedelta(days=-365)) < row[0]:
                row[1] = 5
            else:
                row[1] = 6
            cursor.updateRow(row)
    print "Backflow preventer fields populated"
    arcpy.AddMessage("All backflow preventer fields now populated.")
    return stgFC

#===============================main================================== 

# import system modules 
import arcpy, os, sys, time, datetime
from arcpy import env
from datetime import timedelta

# Set environment settings
env.workspace = r"G:\Config\SDEProd"
env.overwriteOutput = True
ws = env.workspace

if __name__ == "__main__":

    try:
        # Start the clock 
        start = datetime.datetime.now()
        print "Start time: ", start.replace(microsecond=0)
        startTime = time.clock()

        # Set the global variables
        scriptPath = sys.argv[0]
        try:
            hostFC = sys.argv[1]
            stgTable = sys.argv[2]
            logFile = sys.argv[3]
        except:
            hostFC = os.path.join(
                ws, "Master\ProdOS@Net2Master.sde",
                "GISNet2.GISWSL.WaterL\GISNet2.GISWSL.WL_Fitting")
            stgTable = os.path.join(
                ws, "Replica\ProdDB@HansenReporting.sde",
                "HansenReporting.dbo.uvw_BackFlow")
            logFile = os.path.join(os.path.dirname(scriptPath),
                                   "GPMessages_BackflowLoad.txt")
        addrFC = os.path.join(
            ws, "Replica\ProdOS@Net2Replica.sde",
            "GISNet2.GISWSL.Other2\GISNet2.GISWSL.O_Addrkey")
        addrbdyFC = os.path.join(
                ws, "Replica\ProdOS@Net2Replica.sde",
                "GISNet2.GISWSL.Other2\GISNet2.GISWSL.O_AddrkeyRoadBdy")
        pclFC = os.path.join(
                ws, "Master\ProdOS@BaseMaster.sde",
                "GISBase.GISWSL.LandbaseCRS\GISBase.GISWSL.LC_Parcel")
        mtrFC = os.path.join(
                ws, "Replica\ProdOS@Net2Replica.sde",
                "GISNet2.GISWSL.WaterL\GISNet2.GISWSL.WL_Meter")
        pclbdyFC = os.path.join(
            "G:\Config\SDEProd", "Master\ProdOS@BaseMaster.sde",
            "GISBase.GISWSL.LandbaseCRS",
            "GISBase.GISWSL.LC_ParcelBoundary")
        pipeFC = os.path.join(
            "G:\Config\SDEProd", "Replica\ProdOS@Net2Replica.sde",
            "GISNet2.GISWSL.WaterL\GISNet2.GISWSL.WL_Pipe")
        # Set temporary workspace
        print "Script home: ", scriptPath
        #os.chdir(os.path.expanduser('~'))
        print "Current working directory: ", os.getcwd()
        userName = os.path.split(os.path.expanduser('~'))[1]
        print "User name: ", userName
        outWorkspace = os.path.join(r"\\wsldctvdfs1\users$", userName,
                                    r"Documents\ArcGIS\Default.gdb")
        print "Temp. workspace: ", outWorkspace
        # Open log file for writing
        lf = open(logFile, "w")

        # Run program
        position_bfprev()

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

