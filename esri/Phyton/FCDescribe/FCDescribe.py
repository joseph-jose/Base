import arcpy
import os
import datetime

#FCs = arcpy.GetParameterAsText(0)
#FCs = r'\\atalnapn02\vol_cifs_t2_user_data$\AC_FGDBs\Publication20180826.gdb'
FCs = r'c:\Joseph\temp\Multiline\MultiLine.gdb'

#arcpy.env.workspace = FCs

desc = arcpy.Describe(FCs)



print(datetime.datetime.now())

# Print some Describe Object properties
#
if hasattr(desc, "name"):
    print "Name:        " + desc.name
if hasattr(desc, "dataType"):
    print "DataType:    " + desc.dataType
if hasattr(desc, "catalogPath"):
    print "CatalogPath: " + desc.catalogPath

# Examine children and print their name and dataType
#
print "Children:"
for child in desc.children:
    print "\t%s = %s" % (child.name, child.dataType)
    
print(datetime.datetime.now())
    
   
