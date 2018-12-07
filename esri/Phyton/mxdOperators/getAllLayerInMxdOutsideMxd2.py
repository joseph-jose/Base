import arcpy
import os


def FindConnPropTbl(mxd_source):
    mxd = arcpy.mapping.MapDocument(mxd_source)
    for df in arcpy.mapping.ListDataFrames(mxd):
        tableList = arcpy.mapping.ListTableViews(mxd, "", df)
        for table in tableList:
            dsource = str(table.dataSource)
            fnd = dsource.find('.sde')
            sub_str = dsource[:fnd +4]
            desc = arcpy.Describe(sub_str)
            cp = desc.connectionProperties
            try:
                print "Table:{0},Server: {1}".format(table.name,cp.server)
            except:
                print "No server listed for table: {0}".format(table.name)
            try:
                print "Table:{0},Database: {1}".format(table.name,cp.database)
            except:
                print "No database listed for table: {0}".format(table.name)
            del table,dsource,fnd,cp,sub_str,desc
    del mxd,df,tableList


def FindConnPropFc(mxd_source):
    mxd = arcpy.mapping.MapDocument(mxd_source)
    for df in arcpy.mapping.ListDataFrames(mxd):
        layerList = arcpy.mapping.ListLayers(mxd, "", df)
        for layer in layerList:
            dsource = str(layer.dataSource)
            fnd = dsource.find('.sde')
            sub_str = dsource[:fnd +4]
            desc = arcpy.Describe(sub_str)
            cp = desc.connectionProperties
            try:
                print "Layer:{0},Server: {1}".format(layer.name,cp.server)
            except:
                print "No server listed for layer: {0}".format(layer.name)
            try:
                print "Layer:{0},Database: {1}".format(layer.name,cp.database)
            except:
                print "No database listed for layer {0}".format(layer.name)
            del layer,dsource,fnd,cp,sub_str,desc
    del mxd,df,layerList


if __name__=="__main__":
    mxd = arcpy.mapping.MapDocument(r"\\atalgisau01\ADMIN\Portal\MXD\PreProd\Assets\AS_ITSAssets_MS_PIDS_CCTV.mxd")
#    FindConnPropTbl(mxd)
    FindConnPropFc(mxd)    
