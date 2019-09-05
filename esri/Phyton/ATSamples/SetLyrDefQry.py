#-------------------------------------------------------------------------------
# Name:        This Script updates the mothly HOP Patronage maps by changing date fields and definition queries.
#                Must be run after the data soruce has been updated through FME
# Purpose:
#
# Author:      DanielNu1
#
# Created:     22/03/2016
# Copyright:   (c) DanielNu1 2016
# Licence:     <your licence>
#-------------------------------------------------------------------------------

import arcpy, datetime, os
arcpy.env.overwriteOutput = True



'''Local Variables'''
MonthCode = raw_input('Enter year/month to create data def query. Eg "2016/02": \n' )
Month = raw_input('Type date range for maps to be used in map title e.g. "1 February - 29 February 2016":')
Workspace = r"\\atalgisap01\Projects\PT\HOPMonthlySummary\Maps\TemplateMXDs" # path to MXD templates - do not modify

ProjectFolder = raw_input("Enter (Copy/Paste) the directory to save PDF maps and MXDs. Note MUST be local drive:\n") # path must be in local drive due to write issues

#Dictionary of MXD name as key and Def Query Layer and Def Query text as values
MXD_Properties = {'PT_BusTrain_AdultPaperTicket_ByCAU_000000': ('% of Adult Paper Tickets by CAU', 'GIS.GISADMIN.AT_Operations_PT_CAU_UniqueTransactionsBusTrain.AU2014_NAME NOT LIKE \'%Inlet%\' AND GIS.GISADMIN.AT_Operations_PT_CAU_UniqueTransactionsBusTrain.AdultPaper_Sum > 0 AND GIS.GISADMIN.AT_Operations_PT_CAU_UniqueTransactionsBusTrain.TimePeriod = \'0000/00\''),
                    'PT_BusTrain_ChildPaperTicket_ByCAU_000000':('% of Child Paper Tickets by CAU', 'GIS.GISADMIN.AT_Operations_PT_CAU_UniqueTransactionsBusTrain.AU2014_NAME NOT LIKE \'%Inlet%\' AND GIS.GISADMIN.AT_Operations_PT_CAU_UniqueTransactionsBusTrain.ChildPaper_Sum > 0 AND GIS.GISADMIN.AT_Operations_PT_CAU_UniqueTransactionsBusTrain.TimePeriod = \'0000/00\''),
##                    'BusTrain_SuperGoldPaperTicket_ByCAU_000000': ('% of SuperGold Paper Tickets by CAU', 'AT_Operations_PT_CAU_UniqueTransactionsBusTrain.AU2014_NAME NOT LIKE \'%Inlet%\' AND AT_Operations_PT_CAU_UniqueTransactionsBusTrain.AdultPaper_Sum > 100 AND AT_Operations_PT_CAU_UniqueTransactionsBusTrain.TimePeriod = \'0000/00\''),
##                    'HOPCount_AllModes_Regional_000000' : ('Transactions per 2km Grid', 'GIS.GISADMIN.AT_Operations_PT_Grid_DistinctHOPCardAllModes.TimePeriod = \'0000/00\' AND GIS.GISADMIN.AT_Operations_PT_Grid_DistinctHOPCardAllModes.TagOn_sum >0'),
##                    'HOPCount_BusStops_Regional_000000' : ('Transactions per 2km Grid', 'GIS.GISADMIN.AT_Operations_PT_Grid_DistinctHOPCardBus.TimePeriod = \'0000/00\' AND GIS.GISADMIN.AT_Operations_PT_Grid_DistinctHOPCardBus.TagOn_sum >0'),
                    'PT_PostCodeBoundaries_CAUDeprivation_000000' : ('Registered AT HOP Cards', 'AT_Operations_PT_PostCode_HOPRegistrations.CustomerCount >0 AND AT_Operations_PT_PostCode_HOPRegistrations.TimePeriod = \'0000/00\'')
                  }

print "Exporting montly HOP patronage maps for date range {0}...\n".format(Month)

print "Project workspace: {0}...\n".format(ProjectFolder)
arcpy.env.workspace = Workspace
mxdList = arcpy.ListFiles("*.mxd")
for mapdoc in mxdList:
    filePath = os.path.join(Workspace, mapdoc)
    mxd = arcpy.mapping.MapDocument(filePath)
    print "Opening {0} document...\n".format(mapdoc.split('.')[0])
    for lyr in arcpy.mapping.ListLayers(mxd):
        LyrName = mapdoc.split(".")[0]

        if lyr.name == MXD_Properties.get(LyrName)[0]:
            lyr.definitionQuery = MXD_Properties.get(LyrName)[1].replace("0000/00", MonthCode)
            fcount = int(arcpy.GetCount_management(lyr).getOutput(0))
            print "Feature Count: {0}".format(fcount)
            if fcount == 0:

                print lyr.name + " has no records"
        else:
            continue
##
    for elm in arcpy.mapping.ListLayoutElements(mxd, "TEXT_ELEMENT"):
        if elm.text == "Date Range":
            elm.text = Month
##
    print "Verifying workspaces ...\n"
    if not os.path.exists(ProjectFolder + '\\' + '03_Outputs' + "\\" + MonthCode.replace("/","")):
        os.makedirs(ProjectFolder + '\\' + '03_Outputs' + "\\" + MonthCode.replace("/",""))

    if not os.path.exists(ProjectFolder + '\\' + '04_Workspaces' + "\\" + MonthCode.replace("/","")):
        os.makedirs(ProjectFolder + '\\' + '04_Workspaces' + "\\" + MonthCode.replace("/",""))

    print "Exporting {0} to PDF...\n".format(LyrName.replace("000000", MonthCode.replace("/","")))
    arcpy.mapping.ExportToPDF(mxd, ProjectFolder + '\\' + '03_Outputs' + "\\" + MonthCode.replace("/","") + "\\" + LyrName.replace("000000", MonthCode.replace("/","")) + ".pdf")

    print "Copying {0} map document to new workspace...\n".format(LyrName.replace("000000", MonthCode.replace("/","")))
    mxd.saveACopy(ProjectFolder + '\\' + '04_Workspaces' + "\\" + MonthCode.replace("/","") + "\\" + mapdoc.replace("000000", MonthCode.replace("/","")), '10.3')


    del mxd
    os.system("TASKKILL /F /IM ArcMap.exe")

    print "{0} PDF sucessfully exported\n...".format(LyrName.replace("000000", MonthCode.replace("/","")))
    print "--------------------------------------------------------------"

    '''-------------------------- Map Export Complete ---------------------------'''

print "\nMaps successfully exported"

