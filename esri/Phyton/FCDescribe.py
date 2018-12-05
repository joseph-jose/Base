import arcpy
import os
import datetime

#FCs = arcpy.GetParameterAsText(0)
#FCs = r'\\atalnapn02\vol_cifs_t2_user_data$\AC_FGDBs\Publication20180826.gdb'
#FCs = r'c:\Joseph\temp\Multiline\MultiLine.gdb'

FCs = r"AT.GISADMIN.RD_RAMMCARRWAY_PROPOSEDSPEEDCHANGES_TE"
arcpy.env.workspace = r"C:\Users\jejyjose1\AppData\Roaming\ESRI\Desktop10.5\ArcCatalog\atalgissdbu01.AT.sde"
#FCs = r"AT.GISADMIN.RD_ProposedSpeedChanges_TE"
#arcpy.env.workspace = r"C:\Users\jejyjose1\AppData\Roaming\ESRI\Desktop10.5\ArcCatalog\PROD atalgissdbp01.AT.sde"

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

if desc.hasOID:
    print "OIDFieldName: " + desc.OIDFieldName

for field in desc.fields:
    print "%-22s %s %s" % (field.name, ":", field.type)
    
   
print(datetime.datetime.now())
