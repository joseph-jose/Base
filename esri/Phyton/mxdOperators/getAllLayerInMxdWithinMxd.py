mxd = arcpy.mapping.MapDocument("CURRENT")
df = arcpy.mapping.ListDataFrames(mxd, '')[0]
for lyr in arcpy.mapping.ListLayers(mxd, '', df):
    print lyr.name
    print lyr.dataSource
    print lyr.definitionQuery
