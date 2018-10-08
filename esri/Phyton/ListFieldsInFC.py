import arcpy

#FCs = arcpy.GetParameterAsText(0)
#FC = r"AT.GISADMIN.PJ_AucklandRegion_NZFS_SubSuburbs_TE"
#arcpy.env.workspace = "C:\Joseph\Task\REQ43327\Data\TASK43327\ProjectData.gdb"

FC = r"AT.GISADMIN.PJ_AucklandRegion_NZFS_SubSuburbs_TE"
arcpy.env.workspace = r"C:\Users\jejyjose1\AppData\Roaming\ESRI\Desktop10.5\ArcCatalog\PROD atalgissdbp01.AT.sde"

fields = arcpy.ListFields(FC)
for field in fields:
    print("{0},{1},{2}".format(field.name, field.type, field.length))
    print("------------")
