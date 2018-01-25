# BulkUpdateTool.py
# Description:
# Author: Mahesh Patel

# import system modules 
import arcpy, os, sys, time, datetime, glob
from arcpy import env

# Set environment settings
env.workspace = r'G:\System\Geodatabase\DBConnections\Dev\GISWSL'
env.overwriteOutput = True
ws = env.workspace

# Start the clock 
start = datetime.datetime.now()
print 'Start time: ', start.replace(microsecond=0)
startTime = time.clock()

# Set the local variables
scriptPath = sys.argv[0]
try:
    sdeGDB = sys.argv[1]
    tblGDB = sys.argv[2]
    modifyFlds = sys.argv[3]
except:
    sdeGDB = os.path.join(ws, 'Z_DevNew@Net1GISWSL.sde')
    tblGDB = r'G:\Working\Mahesh\BulkUpdateTool\BulkUpdate.gdb'
    modifyFlds = ['UNITTYPE', 'GRP', 'MODIFYREF']

    
parentVersion = 'sde.DEFAULT'
versionName = 'MP'
joinFld = 'GIS_ID'
allFlds = [joinFld] + modifyFlds

env.workspace = tblGDB
tblList = [tbl for tbl in arcpy.ListTables()]
wcList = [('*.' + tbl) for tbl in arcpy.ListTables()]
print wcList

env.workspace = sdeGDB
for version in arcpy.da.ListVersions(sdeGDB):
    print version.name
##    if versionName in version.name:
##        arcpy.DeleteVersion_management(sdeGDB, version.name)
##arcpy.CreateVersion_management(\
##    sdeGDB, parentVersion, versionName, 'PUBLIC')

for wc in wcList:
    for sdeDS in arcpy.ListDatasets('', 'Feature'):
        for sdeFC in arcpy.ListFeatureClasses(wc, 'All', sdeDS):
            joinTbl = os.path.join(tblGDB, wc.split('.')[1])
            print sdeFC, joinTbl
            sdeFClyr = joinTbl + '_lyr'
            arcpy.MakeFeatureLayer_management(sdeFC, sdeFClyr)
            arcpy.ChangeVersion_management(\
                sdeFClyr, 'TRANSACTIONAL', 'GISWSL.' + versionName)
            print 'Version changed'
            edit = arcpy.da.Editor(sdeGDB)
            edit.startEditing(with_undo=False, multiuser_mode=True)
            print 'Start editing'
            edit.startOperation()
            print 'Start operation'
            arcpy.AddJoin_management(\
                sdeFClyr, joinFld, joinTbl, joinFld, 'KEEP_COMMON')
            arcpy.SelectLayerByAttribute_management(\
                sdeFClyr, 'NEW_SELECTION')
            arcpy.RemoveJoin_management(sdeFClyr)
            print 'Apply cursors...'
            with arcpy.da.SearchCursor(joinTbl, allFlds) as cursorA:
                print 'Applying cursorA'
                for rowA in cursorA:
                    with arcpy.da.UpdateCursor(sdeFClyr, allFlds)\
                         as cursorB:
                        print 'Applying cursorB'
                        for rowB in cursorB:
                            if rowB[0] == rowA[0]:
                                for i in range(1, len(allFlds)):
                                    rowB[i] = rowA[i]
                                    cursorB.updateRow(rowB)
                                    print rowB[i], 'updated to', rowA[i]
                                    del  rowA,cursorA,rowB,cursorB           
            edit.stopOperation()
            print 'Stop operation'
            edit.stopEditing(save_changes=True)
                             
##except arcpy.ExecuteError:
##    print 'Geoprocessing tool error occurred'
##    msgs = arcpy.GetMessages(2)
##    arcpy.AddError(msgs)
##    print msgs


stop = datetime.datetime.now()
print 'Finish time: ', stop.replace(microsecond=0)



