import os, arcpy  
  
masterPath = r"C:\Joseph\Task\TASK_PreProdRefresh\Processing"  
sites = os.listdir(masterPath)
#newPathSDE = r"C:\Users\jejyjose1\AppData\Roaming\ESRI\Desktop10.6\ArcCatalog\PreProd atalgissdbu02.AT.sde"
newPathSDE = r"C:\Users\jejyjose1\AppData\Roaming\ESRI\Desktop10.6\ArcCatalog\PreProd atalgissdbu02.AC.sde"
#newPathSDE = r"C:\Users\jejyjose1\AppData\Roaming\ESRI\Desktop10.6\ArcCatalog\PreProd atalgissdbu02.EXT.sde"
  
for site in sites:
    if ".mxd" in site or ".MXD" in site: #checks if file is a map document
        
        mxd = arcpy.mapping.MapDocument(masterPath+"\\"+site)  
  #==========  
  #do stuff to MXDs here:  
        for lyr in arcpy.mapping.ListLayers(mxd):  
            if lyr.isFeatureLayer and ".sde" in lyr.dataSource: #'isGroupLayer' must be tested before 'dataSource'
              print "Replacing", '\t', site, '\t', lyr
              lyr.replaceDataSource(newPathSDE, "SDE_WORKSPACE", lyr.datasetName, True)    
  #==========
        mxd.save()
        del mxd  
