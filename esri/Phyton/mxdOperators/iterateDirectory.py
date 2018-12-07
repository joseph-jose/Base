import os

#os.system(r"python.exe C:\Joseph\Python\mxdOperators/getAllLayerInMxdOutsideMxd.py C:\temp\1\FrieghtNetwork.mxd")
strFileName = r"C:/Joseph/ArcMap/"
for file in os.listdir(strFileName):
    if file.endswith(".mxd"):
        #logger.info(file + "...")
        templateMxd = os.path.join(strFileName, file)
        os.system(r"python.exe C:\Joseph\Python\mxdOperators/getAllLayerInMxdOutsideMxd.py " + templateMxd)
        print(templateMxd)
