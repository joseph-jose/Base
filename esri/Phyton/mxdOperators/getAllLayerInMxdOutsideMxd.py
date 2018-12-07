import arcpy
import os

#strFileName = r"\\atalgisau01\ADMIN\Portal\MXD\PreProd\Assets\AS_ITSAssets_MS_PIDS_CCTV.mxd"
#mxd = arcpy.mapping.MapDocument(strFileName)
strFileName = arcpy.GetParameterAsText(0)
mxd = arcpy.mapping.MapDocument(strFileName)

vSCurrDir = os.path.dirname(os.path.realpath(__file__)) + "\OutFile.txt"
f = open(vSCurrDir, "a+")
f.write(strFileName + "\r\n")

df = arcpy.mapping.ListDataFrames(mxd, '')[0]
for lyr in arcpy.mapping.ListLayers(mxd, '', df):
    str_OutVal = ""
    str_OutVal = lyr.name + " -- "
    if lyr.supports("DATASOURCE"):
        str_OutVal = str_OutVal + lyr.dataSource + " -- "
    else:
        str_OutVal = str_OutVal + "    " + " -- "
    if lyr.supports("DEFINITIONQUERY"):
        str_OutVal = str_OutVal + lyr.definitionQuery + " -- "
    else:
        str_OutVal = str_OutVal + "    " + " -- "
    #str_OutVal = lyr.name + " -- " + lyr.dataSource + " -- " + lyr.definitionQuery
    #print(lyr.name + " -- " + lyr.dataSource + " -- " + lyr.definitionQuery)
    print str_OutVal
    f.write( str_OutVal + "\r\n" )
del mxd

f.close()         
