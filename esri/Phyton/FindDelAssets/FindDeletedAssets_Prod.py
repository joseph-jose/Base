# Import system modules
import arcpy, os, sys, time, datetime, shutil, glob
from datetime import timedelta

# Set workspace
start = datetime.datetime.now()
print 'Start time: ', start.replace(microsecond=0)
startTime = time.clock()
arcpy.env.overwriteOutput = True
dateToday = datetime.date.today()
dateYesterday = dateToday + datetime.timedelta(hours=-24)

def initialize_staging_gdb():
    tmpGDB = os.path.join(tmpDir, os.path.basename(archDir) + '.gdb')
    print tmpGDB
    if arcpy.Exists(tmpGDB):
        print 'Temp gdb exists'
    else:
        arcpy.CreateFileGDB_management(\
            tmpDir, os.path.basename(archDir))
        print 'New temp gdb created'
    arcpy.env.workspace = tmpGDB
    if len(arcpy.ListFeatureClasses()) > 0:
        for tmpFC in arcpy.ListFeatureClasses():
            if tmpFC.split('_')[2] != str(dateToday).replace('-',''):
                print 'A', tmpFC.rsplit('_', 1)[0],\
                      'feature class older than today exists'
                pass
            else:
                print 'Re-run program tomorrow'
                sys.exit()
    elif len(arcpy.ListFeatureClasses()) == 0:
        print 'Temp gdb empty. Run refresh_staging_data()'
    archGDB = os.path.join(archDir, 'Archive.gdb')
    if arcpy.Exists(archGDB):
        arcpy.Delete_management(archGDB)
    arcpy.Copy_management(tmpGDB, archGDB)
    print 'Previous feature classes archived'
    return tmpGDB


def determine_mismatches():
    tmpGDB = initialize_staging_gdb()
    arcpy.env.workspace = tmpGDB
    searchDB = os.path.join(\
        adminDir, 'MovedFeatures\MovedFeatures.gdb')
    delAssetsDB = os.path.join(\
        adminDir, 'Logs\FindDeletedAssets\DeletedAssets.gdb')
    flds = ['GIS_ID', 'EQUIP_ID', 'COMPKEY', 'SUBTYPE']

    lfName_all = 'DeletedAssetsLog_*'
    lf_list = glob.glob(os.path.join(stgDir, lfName_all))
    for lf_old in lf_list:
        if not lf_old.find(lfName) != -1:
            shutil.move(lf_old, archDir)
    lf = open(logFile, 'w')
    lf.write('='*70 + '\n')
    lf.write('Deleted Assets Log File ' + str(dateToday) + '\n')
    lf.write('='*70 + '\n'*2)
    lf.write(\
        'Start time: ' + str(start.replace(microsecond=0)) + '\n'*2)
    lf.write('-'*70 + '\n')
    lf.write('Deleted features:' + '\n')
    lf.write('='*70 + '\n'*2)
    lf.write('{0:<15}{1:>10}{2:>10}{3:>10}{4:>23}'.format(\
        '', '-'*6, '-'*8, '-'*7, '-'*20) + '\n')
    lf.write('{0:<15}{1:>10}{2:>10}{3:>10}{4:>16}'.format(\
        '', flds[0], flds[1], flds[2], flds[3]) + '\n')
    lf.write('{0:<15}{1:>10}{2:>10}{3:>10}{4:>23}'.format(\
        '', '-'*6, '-'*8, '-'*7, '-'*20) + '\n')
    try:
        wildCard1 = '*_' + str(dateToday).replace('-','')
        for stgFC in list(set(arcpy.ListFeatureClasses())\
                          - set(arcpy.ListFeatureClasses(wildCard1))):
            print 'Staging FC:', stgFC
            searchDict = {}
            inFld = 'GlobalID'
            joinFld = inFld
            sql1 = '.OBJECTID IS NULL'            
            stgFCname = str(stgFC).rsplit('_',1)[0]
            stgFClyr = 'stgFClyr'
            arcpy.env.workspace = tmpGDB 
            arcpy.MakeFeatureLayer_management(stgFC, stgFClyr)
            wildCard2 = '*.' + stgFCname
            arcpy.env.workspace = sdeWorkspace
            for sdeWS in arcpy.ListWorkspaces('*Net1*', 'SDE'):
                arcpy.env.workspace = sdeWS
                for sdeDS in arcpy.ListDatasets('*water', 'Feature'):
                    for sdeFC in arcpy.ListFeatureClasses(wildCard2,
                                                       'All', sdeDS):
                        print 'SDE FC:', sdeFC

                        sdeFCtmp = os.path.join(tmpGDB, stgFCname +\
                                                 '_tmp')
                        arcpy.Copy_management(sdeFC, sdeFCtmp)
                        searchDict[sdeFCtmp] = sdeDS
            sql = os.path.basename(sdeFCtmp) + sql1
            arcpy.AddJoin_management(\
                stgFClyr, inFld, sdeFCtmp, joinFld)
            arcpy.SelectLayerByAttribute_management(\
                stgFClyr, 'NEW_SELECTION', sql)
            arcpy.RemoveJoin_management(stgFClyr)
            arcpy.Delete_management(sdeFCtmp)
            result = arcpy.GetCount_management(stgFClyr)
            jcount = int(result.getOutput(0))
            print 'Unmatched records: ', jcount
            desc = arcpy.Describe(stgFClyr)
            lyrShapeType = desc.featureClass.shapeType            
            delAssetFC = lyrShapeType + 'Features'
            print delAssetFC
            if jcount > 0:
                stypes = arcpy.da.ListSubtypes(stgFClyr)
                stype_desc = {k:v['Name'] for k, v in\
                              stypes.iteritems()}
                with arcpy.da.SearchCursor(stgFClyr, flds) as cursor:
                    for row in cursor:
                        print stgFCname, row[0], row[1], row[2],\
                              stype_desc[row[3]]
                        qry = flds[0] + ' = ' + str(row[0])
                        print qry
                        searchDS = searchDict[sdeFCtmp].split('.')[2]
                        arcpy.env.workspace = searchDB
                        arcpy.env.overwriteOutput = True
                        searchFC = os.path.join(\
                            searchDB, searchDS, stgFCname)
                        searchFClyr = 'searchFClyr'
                        arcpy.MakeFeatureLayer_management(\
                            searchFC, searchFClyr)
                        arcpy.SelectLayerByAttribute_management(\
                            searchFClyr, 'NEW_SELECTION', qry)
                        sres = arcpy.GetCount_management(searchFClyr)
                        scount = int(sres.getOutput(0))
                        print os.path.basename(searchFC),\
                              'GIS_ID match',  scount
                        if scount > 0:
                            print 'Found in search database:', scount
                            print '\n'
                            pass
                        else:
                            try:
                                arcpy.SelectLayerByAttribute_management(\
                                    stgFClyr, 'NEW_SELECTION', qry)
                                arcpy.Append_management(\
                                    stgFClyr, os.path.join(\
                                        delAssetsDB, delAssetFC),
                                    'NO_TEST')
                                lf.write(\
                                    '{0:<15}{1:>10}{2:>10}{3:>10}{4:>23}'
                                    .format(\
                                        os.path.basename(stgFCname),
                                        row[0], row[1], row[2],
                                        stype_desc[row[3]]))
                                lf.write('\n')                                
                                print 'Feature(s) added to Deleted Assets'
                                print '\n'
                            except arcpy.ExecuteError:
                                print arcpy.GetMessages()
                                print 'Append failed miserably' + '\n'
    except arcpy.ExecuteError:
        print arcpy.GetMessages()
    lf.close()

def refresh_staging_data():
    lf = open(logFile, 'a')
    tmpGDB = os.path.join(tmpDir, os.path.basename(archDir) + '.gdb')
    arcpy.env.workspace = tmpGDB
    for fc in arcpy.ListFeatureClasses():
        arcpy.Delete_management(fc)
    arcpy.env.workspace = sdeWorkspace
    for sdeWS in arcpy.ListWorkspaces('*Net1*', 'SDE'):
        arcpy.env.workspace = sdeWS
        for sdeDS in arcpy.ListDatasets('*water', 'Feature'):
            print sdeDS
            sdeFCs = list(\
                set(arcpy.ListFeatureClasses('*Pipe', 'All', sdeDS))|
                set(arcpy.ListFeatureClasses('*Manhole', 'All', sdeDS))|
                set(arcpy.ListFeatureClasses('*Fitting', 'All', sdeDS))|
                set(arcpy.ListFeatureClasses('*Hydrant', 'All', sdeDS))|
                set(arcpy.ListFeatureClasses('*PumpStn', 'All', sdeDS))|
                set(arcpy.ListFeatureClasses('*Structure', 'All', sdeDS))|
                set(arcpy.ListFeatureClasses('*Reservoir', 'All', sdeDS))|
                set(arcpy.ListFeatureClasses('*TPlant', 'All', sdeDS))|
                set(arcpy.ListFeatureClasses('*Valve', 'All', sdeDS)))
            for sdeFC in sdeFCs:
                print '\t', sdeFC
                assetFCname = sdeFC.split('.')[2] + '_' +\
                             str(dateToday).replace('-','')
                stgFC = os.path.join(tmpGDB, assetFCname)
                arcpy.Copy_management(sdeFC, stgFC)
                print assetFCname + ' feature class created'
    stop = datetime.datetime.now()
    lf.write('\n'*2 + '*'*70 + '\n')
    lf.write(\
        'Log file completed: ' +\
        str(datetime.datetime.now().replace(microsecond=0)) +\
        '\n' + '*'*70)
    lf.close()
                   
#-----------------------------------%----------------------------------        

if __name__ == '__main__':
##    try:
    # Get the tool parameter values
    lfName = 'DeletedAssetsLog_' + str(dateToday).replace('-','')\
             + '.txt'    
    try:
        sdeWorkspace = sys.argv[1]
        adminDir = sys.argv[2]
        tmpDir = sys.argv[3]

    except:
        sdeWorkspace = r'G:\Config\SDEProd\Master'
        adminDir = r'G:\Admin'
        tmpDir = r'C:\\'
        stgDir = os.path.join(adminDir, 'Logs\FindDeletedAssets')
        archDir = os.path.join(stgDir, 'Archive')
        logFile = os.path.join(stgDir, lfName)


    determine_mismatches()
    refresh_staging_data()


stop = datetime.datetime.now()
print "Finish time: ", stop.replace(microsecond=0)



   



