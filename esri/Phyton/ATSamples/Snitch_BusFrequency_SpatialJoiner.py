#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      TasBarsd1
#
# Created:     05/10/2018
# Copyright:   (c) TasBarsd1 2018
# Licence:     <your licence>
#-------------------------------------------------------------------------------

##def main():
##    pass
##
##if __name__ == '__main__':
##    main()

# Bus Service Frequency on Snitch LOS (E-F) workflow test
# This workflow is to produce monthly outputs showing the bus service
# frequency for AM and PM peaks overlaying poor level of service Snitch
# Segments (LOS is E-F). Simple looping spatial join script.

import os, arcpy

# Workspace Environment
arcpy.env.workspace = r'\\At3fsp03\gisfs$\ATALGISFSP01\WORK\SUPPORT\AT18\TASK200049148'


# Inputs

snitch_busfreq_left_am = "\\Revised_ProjectData.gdb\\Snitch_AM_BusFreq_Left"
snitch_busfreq_right_am = "\\Revised_ProjectData.gdb\\Snitch_AM_BusFreq_Right"
snitch_busfreq_left_pm = "\\Revised_ProjectData.gdb\\Snitch_PM_BusFreq_Left"
snitch_busfreq_right_pm = "\\Revised_ProjectData.gdb\\Snitch_PM_BusFreq_Right"

# SDE Inputs

snitch_table = r'Database Connections\EXT-PROD atalgissdbp01.sde\EXT.GISADMIN.Snitch_AttributeDataMonthly_XR'
snitch_geometry = r'Database Connections\EXT-PROD atalgissdbp01.sde\EXT.GISADMIN.Snitch_RouteSegment_XR'

# Lists and other variables

_input_list = [snitch_busfreq_left_am, snitch_busfreq_right_am, snitch_busfreq_left_pm, snitch_busfreq_right_pm]

query_layer = "\\FinalOutputs.gdb\\Snitch_Query_layer"

query = "Select SHAPE,EXT.gisadmin.SNITCH_ATTRIBUTEDATAMONTHLY_XR.ID,ROUTEID,ROUTENAME,TOTALRECORDS,USED,USED90,OUTLIERS,EXT.gisadmin.SNITCH_ATTRIBUTEDATAMONTHLY_XR.FROMNAME,EXT.gisadmin.SNITCH_ATTRIBUTEDATAMONTHLY_XR.TONAME,LENGTH,PERCENTILE15TH,MEAN,MEDIAN,MEAN90,PERCENTILE85TH,MEDIANKMH,STANDARDDEVIATION,SPEEDLIMIT,LOSPERCENT,DIRECTION,CATEGORY,MONTH from EXT.gisadmin.SNITCH_ROUTESEGMENT_XR,EXT.gisadmin.SNITCH_ATTRIBUTEDATAMONTHLY_XR where EXT.gisadmin.SNITCH_ROUTESEGMENT_XR.ID=EXT.gisadmin.SNITCH_ATTRIBUTEDATAMONTHLY_XR.ID"

# sr = arcpy.SpatialReference("NZGD_2000_New_Zealand_Transverse_Mercator")

routeIDs = LookUpSegmentID(snitch_geometry)

print "Starting..."

print _input_list

print snitch_table

print snitch_geometry

print query_layer

print query

print "Making query layer hopefully"

# arcpy.MakeQueryLayer_management("Database Connections\EXT-PROD atalgissdbp01.sde", query_layer, query, "OBJECTID", "POLYLINE")


'''Function for creating lookup table for IDs and geometries'''
def LookUpSegmentID(routes):

    return {i[0]:i[1] for i in arcpy.da.SearchCursor(routes, ['ID', 'SHAPE@'])}


print "Did it work?"
