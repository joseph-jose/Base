# Name: ExtractDataFromGDB.py
# Description: Extract data from gdb (incl. sde) feature classes and
#              export to dbf files.


# Import system modules
import arcpy, os, sys, time, datetime
from arcpy import env

start = datetime.datetime.now()
print 'Start time: ', start.replace(microsecond=0)
startTime = time.clock()
dateToday = str(datetime.date.today()).replace('-','')

# Set sde workspace
env.overwriteOutput = True
env.workspace = r'G:\Config\SDEProd\Replica'

# Set temp. workspace
tempGDB = r'C:\Z_Mahesh\TempProjectsFolder\PR16057.gdb'

# Set other parameters
wldcrds = [['*Valve','*Hydrant','*Manhole'],
           ['*PumpStn','*TPlant','*Reservoir'],['*Source'],
           ['*Pipe']]
flds = [[], ['FAC_CODE','FAC_DESC'],  ['FAC_CODE','FAC_DESC'],
        ['PROCESS', 'GRP', 'UNITTYPE', 'TYPE', 'MATERIAL',
         'INSTALLED', 'NOM_DIA_MM', 'POSITION',
         'SHAPE.STLength()', 'SHAPE_Length']] # Note: first length
         # field occurs in SDE, second in FileGDB.

# Set query clauses               
sql1 = """STATUS = 'BUILT' AND OWNER = 'WSL'""" 
sql2 = """STATUS = 'IN' AND OWNER = 'WSL'"""
sql3 = sql1 + """ AND TYPE = 'R'"""
sql4 = sql1 + """ AND TYPE = 'T'"""
sql5 = sql2 + """ AND SERVICE = 'NONPOT'"""
sql6 = sql2 + """ AND SERVICE = 'POT'"""
sql7 = sql5 + """ AND SUBTYPE <> 2"""
sql8 = sql6 + """ AND SUBTYPE <> 2"""
sql9 = sql2 + """ AND SUBTYPE <> 2"""
sql10 = """STATUS = 'BUILT'"""


# List all file geodatabases in the sde workspace
workspaces = arcpy.ListWorkspaces('*Net*','SDE')
for ws in workspaces:
    #print ws
    # Create child workspaces
    env.workspace = ws #NOTE: order of equality important here
    datasets = list(set(arcpy.ListDatasets('*water*', 'Feature')) -
                    set(arcpy.ListDatasets('*waterN', 'Feature')) -
                    set(arcpy.ListDatasets('*water', 'Feature')))
    for dataset in datasets:
        #print '\t', dataset
        # Get a list of feature classes
        for i in range(len(wldcrds)):
            for wldcrd in wldcrds[i]:
                fcList = arcpy.ListFeatureClasses(\
                    wldcrd, 'All', dataset)
                for fc in fcList:
                    fcLyr = 'fcLyr'
                    fcName = fc.split('.')[2]
                    #print '\t'*2, fcName

                    # Create a fieldinfo object
                    fieldinfo = arcpy.FieldInfo()
                    # List subset of fields in each feature class
                    fcFlds = [f.name for f in arcpy.ListFields(fc)]
                    for f.name in fcFlds:
                        fldName = f.name
                        if fldName in flds[i]:
                            #print '\t'*3, fldName
                            fieldinfo.addField(\
                                fldName, fldName, 'VISIBLE', '')
                        else:
                            fieldinfo.addField(\
                                fldName, fldName, 'HIDDEN', '')
                    # Create table view name
                    outView = fcName + '_tblvw'
                    tblPath = os.path.join(\
                        tempGDB, fcName + '_' + dateToday)
                    #print tblPath

##                    # 1. Selected feature counts.
##                    if  i == 0:
##                        if fcName.find('T_') != -1:
##                            arcpy.MakeFeatureLayer_management(\
##                                fc, fcLyr, sql1)
##                        if fcName.find('WWL_') != -1:
##                            arcpy.MakeFeatureLayer_management(\
##                                fc, fcLyr, sql2)                        
##                        elif fcName.find('WL_') != -1 and\
##                             fcName.find('WWL_') == -1:
##                            arcpy.MakeFeatureLayer_management(\
##                                fc, fcLyr, sql6)                        
##                            
##                        result = arcpy.GetCount_management(fcLyr)
##                        fCount = int(result.getOutput(0))
##                        print '\t'*2, fcName, '\t', fCount
##
##
##                    # 2. Selected facilities and their names.
##                    if i == 1 or i == 2:
##                        # Create table for each feature class
##                        if fcName.find('T_') != -1 and i == 1:
##                            arcpy.MakeTableView_management(\
##                                fc, outView, sql1, tempGDB, fieldinfo)
##                        elif fcName.find('T_') != -1 and i == 2:
##                            arcpy.MakeTableView_management(\
##                                fc, outView, sql10, tempGDB, fieldinfo)                            
##                        elif fcName.find('L_') != -1:
##                            arcpy.MakeTableView_management(\
##                                fc, outView, sql2, tempGDB, fieldinfo)                 
##                        arcpy.CopyRows_management(outView, tblPath)                        

                    # 3. Selected attribute summary statistics.
                    if  i == 3:
                        if fcName.find('L_') != -1:
                            sdeFCtmp = os.path.join(\
                                tempGDB, fcName + '_tmp')
                            arcpy.Copy_management(fc, sdeFCtmp)                        
                        # Loop through fields to summarize on.
                        for j in range(4,7):
                            freqFld = flds[i][j]
                            freqFldnm = flds[i][j].lower()
                            sumFld1 = flds[i][8]
                            sumFld2 = flds[i][9]
                            freqFldlist = [flds[i][0], flds[i][1],
                                           flds[i][7]]
                            # Place this clause PRIOR to following one
                            # else point of difference in sql
                            # statements will disappear.
                            if fcName.find('WT_') != -1 and\
                               fcName.find('WWT_') == -1:
                                arcpy.MakeFeatureLayer_management(\
                                    fc, fcLyr, sql4)
                                arcpy.Frequency_analysis(\
                                    fcLyr, tblPath + '_' + freqFldnm,
                                    freqFld, sumFld1)
                                arcpy.Frequency_analysis(\
                                    fcLyr, tblPath + '_assettype',
                                    freqFldlist, sumFld1)                                
                            elif fcName.find('WT_') != -1 and\
                               fcName.find('WWT_') == -1:
                                arcpy.MakeFeatureLayer_management(\
                                    fc, fcLyr, sql3)
                                arcpy.Frequency_analysis(\
                                    fcLyr, tblPath + 'R_' + freqFldnm,
                                    freqFld, sumFld1)
                                arcpy.Frequency_analysis(\
                                    fcLyr, tblPath + 'R_assettype',
                                    freqFldlist, sumFld1)                                 
                            elif fcName.find('WWT_') != -1:
                                arcpy.MakeFeatureLayer_management(\
                                    fc, fcLyr, sql1)
                                arcpy.Frequency_analysis(\
                                    fcLyr, tblPath + '_' + freqFldnm,
                                    freqFld, sumFld1)
                                arcpy.Frequency_analysis(\
                                    fcLyr, tblPath + '_assettype',
                                    freqFldlist, sumFld1)                                 
                            # See preceding note.
                            elif fcName.find('WL_') != -1 and\
                                 fcName.find('WWL_') == -1:
                                arcpy.MakeFeatureLayer_management(\
                                    sdeFCtmp, fcLyr, sql8)
                                arcpy.Frequency_analysis(\
                                    fcLyr, tblPath + '_' + freqFldnm,
                                    freqFld, sumFld2)
                                arcpy.Frequency_analysis(\
                                    fcLyr, tblPath + '_assettype',
                                    freqFldlist, sumFld2)                                
                            elif fcName.find('WL_') != -1 and\
                                 fcName.find('WWL_') == -1:
                                arcpy.MakeFeatureLayer_management(\
                                    sdeFCtmp, fcLyr, sql7)
                                arcpy.Frequency_analysis(\
                                    fcLyr, tblPath + 'NP_' + freqFldnm,
                                    freqFld, sumFld2)
                                arcpy.Frequency_analysis(\
                                    fcLyr, tblPath + 'NP_assettype',
                                    freqFldlist, sumFld2)                                 
                            elif fcName.find('WWL_') != -1:
                                arcpy.MakeFeatureLayer_management(\
                                    sdeFCtmp, fcLyr, sql9)
                                arcpy.Frequency_analysis(\
                                    fcLyr, tblPath + '_' + freqFldnm,
                                    freqFld, sumFld2)
                                arcpy.Frequency_analysis(\
                                    fcLyr, tblPath + '_assettype',
                                    freqFldlist, sumFld2)                                 
                            print fcName


stop = datetime.datetime.now()
stopTime = time.clock()
print 'Finish time: ', stop.replace(microsecond=0)
print 'Elapsed time: ', round(float(stopTime - startTime)/60, 2), 'min.'
              




        


    






