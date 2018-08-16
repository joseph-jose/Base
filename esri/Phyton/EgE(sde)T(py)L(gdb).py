#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      TasBarsd1
#
# Created:     09/05/2017
# Copyright:   (c) TasBarsd1 2017
# Licence:     <your licence>
#-------------------------------------------------------------------------------


# SNITCH - Calculate Speed difference between two months
# based on accumulated Snitch monthly data.
# A requirement requested by Anita Lin.
#
# Author: CP
# Owned by: AT
# Date last modified: 9/08/2017

'''Import libraries'''
import arcpy
import os

'''Function for creating lookup table for IDs and geometries'''
def LookUpSegmentID(routes):

    return {i[0]:i[1] for i in arcpy.da.SearchCursor(routes, ['ID', 'SHAPE@'])}

'''Function to calculate speed difference between two months'''
def PopulateDiffTable(ids, input_table, diff_table, current_month, previous_month):

    tableExtract = {}

    dataList = [i for i in arcpy.da.SearchCursor(input_table
                , ['ID', 'MONTH', 'MEDIANKMH', 'DIRECTION', 'CATEGORY', 'LOSPERCENT']
                , where_clause="MONTH in ('{0}','{1}')".format(current_month, previous_month))]


    ic = arcpy.da.InsertCursor(diff_table, ['ID'
                                            , 'CATEGORY'
                                            , 'DIFFMONTH'
                                            , 'DIFFSPEED'
                                            , 'DIFFPERSPEED'
                                            , 'DIRECTION'
                                            , 'SHAPE@'
                                            , 'CLASS'
                                            , 'CLASSPER'
                                            , 'CLOS'
                                            , 'PLOS'])

    for i in ids:
        inTab_am_in = {j[1]:[j[2],j[-1]] for j in dataList if j[0]==i and j[4]=='AM' and j[3]=='In'}
        inTab_am_out = {j[1]:[j[2],j[-1]]for j in dataList if j[0]==i and j[4]=='AM' and j[3]=='Out'}
        inTab_pm_in = {j[1]:[j[2],j[-1]] for j in dataList if j[0]==i and j[4]=='PM' and j[3]=='In'}
        inTab_pm_out = {j[1]:[j[2],j[-1]]for j in dataList if j[0]==i and j[4]=='PM' and j[3]=='Out'}

        tableExtract[i] = {'am_in':inTab_am_in
                            , 'am_out':inTab_am_out
                            , 'pm_in':inTab_pm_in
                            , 'pm_out':inTab_pm_out}

    for i in ids:
        print i
        timeperiod = {'am_in': ['AM', 'In']
                    , 'am_out': ['AM', 'Out']
                    , 'pm_in': ['PM', 'In']
                    , 'pm_out': ['PM', 'Out']}

        route_extract = tableExtract[i]

        for tp in timeperiod:
            tp_extract = route_extract[tp]
            if len(tp_extract) == 2:
                current_speed = tp_extract[current_month][0]
                previous_speed = tp_extract[previous_month][0]
                current_los = tp_extract[current_month][1]
                previous_los = tp_extract[previous_month][1]
                if current_speed != None:
                    if previous_speed != None:
                        delta_speed = current_speed-previous_speed
                        if previous_speed != 0:
                            delta_speed_per = delta_speed/previous_speed
                            ic.insertRow([i
                                        , timeperiod[tp][0]
                                        , current_month+'-'+previous_month
                                        , delta_speed
                                        , delta_speed_per
                                        , timeperiod[tp][1]
                                        , ids[i]
                                        , GetSpeedClassRange(delta_speed)
                                        , GetSpeedClassPerRange(delta_speed_per)
                                        , current_los
                                        , previous_los])
                        else:
                            ic.insertRow([i
                                        , timeperiod[tp][0]
                                        , current_month+'-'+previous_month
                                        , delta_speed
                                        , None
                                        , timeperiod[tp][1]
                                        , ids[i]
                                        , GetSpeedClassRange(delta_speed)
                                        , None
                                        , current_los
                                        , previous_los])
                    else:
                        print 'No speed values for segement {0}'.format(i)
                else:
                    print 'No speed values for segement {0}'.format(i)

    del ic

    print '\nProcess done.'

'''Funciton for generating Speed Difference class value'''
def GetSpeedClassRange(value):
    if value <= -20:
        return 'Worse 20+'
    elif -20 < value <= -5:
        return 'Worse 5-20'
    elif -5 < value <= 5:
        return '+-5'
    elif 5 < value <= 20:
        return 'Improve 5-20'
    elif value > 20:
        return 'Improve 20+'

'''Funciton for generating Speed Difference % class value'''
def GetSpeedClassPerRange(value):
    if value <= -0.3:
        return 'Worse 30%+'
    elif -0.3 < value <= -0.1:
        return 'Worse 10-30%'
    elif -0.1 < value <= 0.1:
        return '+-10%'
    elif 0.1 < value <= 0.3:
        return 'Improve 10-30%'
    elif value > 0.3:
        return 'Improve 30%+'


if __name__ == '__main__':

    '''User Input'''
    current_month = '2018/06' #arcpy.GetParameterAsText(0)
    previous_month = '2017/06' #arcpy.GetParameterAsText(1)

    '''Data Inputs'''
    input_segments = r'Database Connections\EXT_Prod.sde\EXT.GISADMIN.Snitch_RouteSegment_XR'
    input_table = r'Database Connections\EXT_Prod.sde\EXT.GISADMIN.Snitch_AttributeDataMonthly_XR'
    diff_table = r'\\atalgisau01\PROJECTS\AT18\Snitch_Monthly_Process\ProjectData.gdb\Speed_Diff_June2017_June2018'

    ' Get Id & Shape from EXT.GISADMIN.Snitch_RouteSegment_XR
    routeIDs = LookUpSegmentID(input_segments)

    print 'Calculating difference values...\n'

    PopulateDiffTable(routeIDs, input_table, diff_table, current_month, previous_month)
