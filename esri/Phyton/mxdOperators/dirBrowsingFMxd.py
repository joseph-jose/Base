import os
sRootFolder = r"\\atalgisau01\ADMIN\Portal\MXD\PreProd"
#sRootFolder = r"D:\FME_Working_AFC"
#for dirpath, dirs, files in os.walk("."):
sPyRunCmd = r""
for dirpath, dirs, files in os.walk(sRootFolder):	 
        path = dirpath.split('/')
        print '|', (len(path))*'***DIR*** : ', '[',os.path.basename(dirpath),']'
        for f in files:                
                filename, fileExt = os.path.splitext(f)
                try:
                        if fileExt == '.mxd':
                                relFile = os.path.join(dirpath, f)
                                statinfo = os.stat(relFile)
                                sPyRunCmd = r"python.exe C:\Joseph\Python\mxdOperators/getAllLayerInMxdOutsideMxd.py " + relFile
                                print sPyRunCmd
#                                print relFile + " : " + str(statinfo.st_size)
                                os.system(sPyRunCmd)
                except:
                        print "No server listed for layer: {0}"
