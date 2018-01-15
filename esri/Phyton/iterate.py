import arcpy
from arcpy import da
import os

inTable = arcpy.GetParameterAsText(0)
fileLocation = arcpy.GetParameterAsText(1)

with da.SearchCursor(inTable, ['DATA', 'ATT_NAME', 'REL_GLOBALID']) as cursor:
    for item in cursor:
        attachment = item[0]
        filenum = str(item[2]) + "_"
        filename = filenum + str(item[1])
        open(fileLocation + os.sep + filename, 'wb').write(attachment.tobytes())
        #del item
        #del filenum
        #del filename
        #del attachment