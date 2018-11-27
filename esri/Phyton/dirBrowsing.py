import os
sRootFolder = r"D:\FME_Working_AFC"
#for dirpath, dirs, files in os.walk("."):	 
for dirpath, dirs, files in os.walk(sRootFolder):	 
	path = dirpath.split('/')
#	print '|', (len(path))*'***DIR***', '[',os.path.basename(dirpath),']'
	for f in files:
#		print '|', len(path)*'---', f
#		print '|'
#		relDir = os.path.relpath(dirpath, sRootFolder)
		relFile = os.path.join(dirpath, f)
		statinfo = os.stat(relFile)
#		print statinfo.st_size
#		print relDir
		print relFile  ,   statinfo.st_size
