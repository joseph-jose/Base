# CreateLayersFromTable.py
# Description:


# import system modules 
import arcpy, os, sys, time, datetime, glob
from arcpy import env
from xlrd import open_workbook

# Set environment settings
env.overwriteOutput = True

try:
    # Start the clock 
    start = datetime.datetime.now()
    print 'Start time: ', start.replace(microsecond=0)
    startTime = time.clock()
   
    # Set the local variables
    scriptPath = sys.argv[0]
    try:
        tmpDir = os.path.expanduser('~')
        hostDir = sys.argv[1]
        sdeDir = sys.argv[2]
        
    except:
        tmpDir = os.path.expanduser('~')
        hostDir = r'G:\Working\Mahesh\LayerCreationTest'
        sdeDir = r'G:\Config\SDEProd'

    if len(glob.glob(os.path.join(hostDir, '*.xlsx'))) != 0:
        hostTbl = glob.glob(os.path.join(hostDir, '*.xlsx'))[0]
    else:
        hostTbl = glob.glob(os.path.join(hostDir, '*.xls'))[0]
    tmpGDB = os.path.join(tmpDir, 'Temp.gdb')
    sdeWorkspace = os.path.join(\
        sdeDir, 'Master\ProdOS@Net1Master.sde')
    sdeTbl = os.path.join(\
        sdeDir, 'Replica',
        'ProdOS@Net1Replica.sde\GISNet1.GISWSL.WA_Netview_View')
    if not arcpy.Exists(tmpGDB):
        arcpy.CreateFileGDB_management(tmpDir, 'Temp.gdb')
    else:
        pass
    wb = open_workbook(hostTbl); sheet = wb.sheet_by_index(0)
    sdeFld = 'FCLASS'; joinFld = sheet.cell(0,0).value
    print os.path.basename(hostTbl)
    arcpy.AddMessage( 'Opening spreadsheet {0} for processing'\
                     .format(os.path.basename(hostTbl)))    
    sdeTblName = os.path.basename(sdeTbl).split('.')[-1]
    arcpy.CopyRows_management(sdeTbl, 'in_memory\Temp')
    hostTbltmp = arcpy.ExcelToTable_conversion(\
        hostTbl, os.path.join(tmpGDB, sheet.name), sheet.name)
              
    # Exports first sheet by default unless otherwise stated
    arcpy.JoinField_management(\
        hostTbltmp, joinFld, 'in_memory\Temp', joinFld, sdeFld)
    arcpy.Delete_management('in_memory')
    with arcpy.da.UpdateCursor(hostTbltmp, sdeFld) as cursor:
        for row in cursor:
            if row[0] == '' or row[0] == None:
                cursor.deleteRow()
    vals = [row[0] for row in arcpy.da.SearchCursor(hostTbltmp, sdeFld)]
    fcNames = [v for v in set(vals)]
    arcpy.AddField_management(hostTbltmp, 'X', 'DOUBLE')
    arcpy.AddField_management(hostTbltmp, 'Y', 'DOUBLE')
    
    arcpy.env.workspace = sdeWorkspace
    for fcName in fcNames:
        sql = sdeFld + " = " + "'" + str(fcName) + "'"
        print sql
        fcWc = '*.' + str(fcName); tblView = fcName; sdeFClyr = 'in_memory\sdeFClyr'
        arcpy.MakeTableView_management(hostTbltmp, tblView, sql)
        for sdeDS in arcpy.ListDatasets('', 'Feature'):
            for sdeFC in arcpy.ListFeatureClasses(fcWc, '', sdeDS):
                print sdeFC 
                arcpy.MakeFeatureLayer_management(sdeFC, sdeFClyr)
                arcpy.AddJoin_management(\
                    sdeFClyr, joinFld, tblView, joinFld, 'KEEP_COMMON')
                arcpy.SelectLayerByAttribute_management(\
                    sdeFClyr, 'NEW_SELECTION')
                arcpy.RemoveJoin_management(sdeFClyr)
                xyFC = os.path.join(tmpGDB, fcName)
                if arcpy.Describe(sdeFC).shapeType != 'Point':
                    arcpy.FeatureClassToFeatureClass_conversion(\
                        sdeFClyr, tmpGDB, fcName)                    
                    arcpy.AddGeometryAttributes_management(\
                        xyFC, 'CENTROID_INSIDE') # This tool obviates
                    # need for arcinfo license. Doesn't seem to work
                    # with a feature layer.
                else:
                    arcpy.FeatureClassToFeatureClass_conversion(\
                        sdeFClyr, tmpGDB, fcName)
                    arcpy.AddXY_management(xyFC) #see line 81                                
                xFld = [f.name for f in arcpy.ListFields(xyFC, '*_X')][0]
                yFld = [f.name for f in arcpy.ListFields(xyFC, '*_Y')][0]
                print xFld, yFld
                xCalc = '!' + fcName + '.' + xFld + '!'
                yCalc = '!' + fcName + '.' + yFld + '!'
                print xCalc; print yCalc
                arcpy.AddMessage(\
                    'Getting coordinates of {0} features'.format(fcName))  
                arcpy.AddJoin_management(\
                    tblView, joinFld, xyFC, joinFld, 'KEEP_COMMON')
                arcpy.CalculateField_management(\
                    tblView, 'X', xCalc, 'PYTHON_9.3')
                arcpy.CalculateField_management(\
                    tblView, 'Y', yCalc, 'PYTHON_9.3')
                arcpy.RemoveJoin_management(tblView)
                arcpy.Delete_management(xyFC)
    arcpy.MakeXYEventLayer_management(\
        hostTbltmp, 'X', 'Y', 'xyLyr', '2193')        
    arcpy.CopyFeatures_management(\
        'xyLyr', os.path.join(hostDir, 'LayerXY'))
    print 'XY layer created'
    arcpy.AddMessage('Layer has been sucessfully created. Lucky me.')
    #arcpy.Delete_management(tmpGDB)
except arcpy.ExecuteError:
    print 'Geoprocessing tool error occurred'
    msgs = arcpy.GetMessages(2)
    arcpy.AddError(msgs)
    print msgs


stop = datetime.datetime.now()
print 'Finish time: ', stop.replace(microsecond=0)

