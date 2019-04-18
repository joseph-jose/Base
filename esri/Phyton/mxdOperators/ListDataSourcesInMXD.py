import os, arcpy  
  
masterPath = r"C:\Joseph\Task\TASK_PreProdRefresh\Processing"  
sites = os.listdir(masterPath)
  
for site in sites:
    if ".mxd" in site or ".MXD" in site: #checks if file is a map document
        
        mxd = arcpy.mapping.MapDocument(masterPath+"\\"+site)
        #print mxd.tags
        #print mxd.description
  #==========  
  #do stuff to MXDs here:  
        for lyr in arcpy.mapping.ListLayers(mxd):  
            if lyr.isFeatureLayer and ".sde" in lyr.dataSource: #'isGroupLayer' must be tested before 'dataSource'
                if lyr.supports('DATASOURCE') and\
                    lyr.supports('WORKSPACEPATH'):
                        dSource = lyr.dataSource # datasource path
                        wsPath = lyr.workspacePath # database path
                        dSet = lyr.datasetName # feature class name
                        ds = os.path.split(dSource)[0] # dataset path
                        fc = os.path.split(dSource)[1]# same as dSet
                        print '\t', site, '\t', lyr, '\t', wsPath,\
                            '\t', dSet, '\t', ds, '\t', fc                        
  #==========
        del mxd  
