#-----------------------------------
#
# Generate Feature Class and tables
# based on uploaded EOD XML file
#
# Owned by: Auckland Transport
# Author: CP
# Last updated: 4/27/2016
#
# Update 05052016 - Add parameter to specify stopid(s)
# and filter by service pattern(s) of the said stops
#
# Update 23052016 - Added ZOMBIE zone and output report
# for stops with no XY data
#-----------------------------------


import arcpy
import os
from xml.dom import minidom
import datetime
import csv

def CreateDBConnections(workspaceFolder):

    if arcpy.Exists(os.path.join(workspaceFolder, 'EOD.sde')) == False:
        arcpy.CreateDatabaseConnection_management(workspaceFolder
        , 'EOD.sde'
        , 'SQL_SERVER'
        , 'ATALGISSDBU01'
        , 'OPERATING_SYSTEM_AUTH'
        , '#'
        , '#'
        , '#'
        , 'AT')

def GetPoints(rootdomain_object):

    arcpy.AddMessage('Creating Stop geometry dictionary...\n')

    pnt_geo = {}

    sd = rootdomain_object[0].getElementsByTagName('SubDomains')
    domains = sd[0].getElementsByTagName('Domain')

    for domain in domains:
        if domain.getAttribute('Name') in ('Bus + Rail', 'City LINK'):
            pointSet = domain.getElementsByTagName('PointsSet')
            points = pointSet[0].getElementsByTagName('Point')
            for point in points:
                pt_data = point.childNodes
                xy = []
                radius = []
                for ptd in pt_data:
                    if ptd.nodeType != ptd.TEXT_NODE:
                        if ptd.nodeName == 'GPSCircleCenterLong':
                            xy.append(float(ptd.firstChild.data)/100)
                        if ptd.nodeName == 'GPSCircleCenterLat':
                            xy.append(float(ptd.firstChild.data)/100)
                        if ptd.nodeName == 'GPSCircleRadius':
                            radius.append(int(ptd.firstChild.data))
                pt = arcpy.Point(xy[1], xy[0])
                pt_geometry = arcpy.PointGeometry(pt)
                pnt_geo[point.getAttribute('RefNumber')] = [pt_geometry, radius[0]]

    return pnt_geo

def GetZone(rootdomain_object):

    arcpy.AddMessage('Creating Zone table dictionary...\n')

    zone_dic = {}

    zonesSet = rootdomain_object[0].getElementsByTagName('ZonesSet')
    zones = zonesSet[0].getElementsByTagName('Zone')

    for zone in zones:
        zone_points = zone.getElementsByTagName('PointRefNumber')
        zpnt_list = [i.firstChild.data for i in zone_points]
        if len(zpnt_list) > 0:
            zone_dic[zone.getAttribute('ShortName')] = zpnt_list

    return zone_dic

def GetOperator(operatorsset_object):

    arcpy.AddMessage('Creating Operator table dictionary...\n')

    operators_dic = {}

    operators = operatorsset_object[0].getElementsByTagName('Operator')
    for operator in operators:
        operators_dic[operator.getAttribute('RefNumber')] = operator.getAttribute('Name')

    return operators_dic

def GetBusLine(buslinesset_object, operatorsset_object, rootdomain_object, input_fc):

    operator_lookup = GetOperator(operatorsset_object)
    zone_lookup = GetZone(rootdomain_object)
    pointgeo_lookup = GetPoints(rootdomain_object)

    #count = 0
    arcpy.AddMessage('Creating Service pattern point geometries...\n')
    icb = arcpy.da.InsertCursor(input_fc
                                , ['NAME'
                                , 'OPERATORREFNUMBER'
                                , 'PUBLICNUMBER'
                                , 'REFNUMBER'
                                , 'SHORTNAME'
                                , 'SERVICEPATTERNREFNUMBER'
                                , 'ISFARECAPDISCOUNTALLOWED'
                                , 'ISTRANSFERDISCOUNTALLOWED'
                                , 'ISCONCESSIONDISCOUNTALLOWED'
                                , 'POINTREFNUMBER'
                                , 'ZONE'
                                , 'SHAPE@'
                                , 'POINTRADIUS'
                                , 'RADIUSTAG'
                                , 'ENTRYSTAGE'
                                , 'EXITSTAGE'
                                , 'FLOATINGSTAGE'
                                , 'SEQUENCENUM'
                                , 'COLOR'])

    buslines = buslinesset_object[0].getElementsByTagName('BusLine')

    with open(os.path.join(workspaceFolder, 'StopsNoXY.csv'), 'wb') as c:
        writer = csv.writer(c, delimiter=',')
        writer.writerow(['NAME'
                        , 'OPERATORREFNUMBER'
                        , 'PUBLICNUMBER'
                        , 'REFNUMBER'
                        , 'SHORTNAME'
                        , 'SERVICEPATTERNREFNUMBER'
                        , 'ISFARECAPDISCOUNTALLOWED'
                        , 'ISTRANSFERDISCOUNTALLOWED'
                        , 'ISCONCESSIONDISCOUNTALLOWED'
                        , 'POINTREFNUMBER'
                        , 'ZONE'
                        , 'SHAPE@'
                        , 'POINTRADIUS'
                        , 'RADIUSTAG'
                        , 'ENTRYSTAGE'
                        , 'EXITSTAGE'
                        , 'FLOATINGSTAGE'
                        , 'SEQUENCENUM'
                        , 'COLOR'])

        for busline in buslines:
            lsps = busline.getElementsByTagName('LineServicePatternsSet')
            sps = lsps[0].getElementsByTagName('ServicePattern')
            for sp in sps:
                itemList = [busline.getAttribute('Name')
                            , operator_lookup[busline.getAttribute('OperatorRefNumber')]
                            , busline.getAttribute('PublicNumber')
                            , busline.getAttribute('RefNumber')
                            , busline.getAttribute('ShortName')
                            , sp.getAttribute('RefNumber')]

                _sp = sp.childNodes
                for sn in _sp:
                    if sn.nodeType != sn.TEXT_NODE:
                        if sn.nodeName == 'IsFareCapDiscountAllowed':
                            itemList.append(sn.firstChild.data)
                        if sn.nodeName == 'IsTransferAllowed':
                            itemList.append(sn.firstChild.data)
                        if sn.nodeName == 'IsConcessionDiscountAllowed':
                            itemList.append(sn.firstChild.data)

                osop = sp.getElementsByTagName('OrderedPointsOfServicePattern')
                sqn_num = 1
                for op in osop: # get individual ordered points
                    pntList = []
                    _opn = op.childNodes
                    for _on in _opn:
                        if _on.nodeType != _on.TEXT_NODE:
                            if _on.nodeName == 'PointRefNumber':
                                pntList.append(_on.firstChild.data)
                                pnt_zones = []
                                for inzone in zone_lookup.keys():
                                    if _on.firstChild.data in zone_lookup[inzone]:
                                        pnt_zones.append(inzone)
                                if len(pnt_zones) != 0:
                                    outzone = (',').join(set(pnt_zones))
                                else:
                                    outzone = 'ZOM'
                                pntList.append(outzone)
                                if _on.firstChild.data in pointgeo_lookup.keys():
                                    geo = pointgeo_lookup[_on.firstChild.data][0]
                                    rad = pointgeo_lookup[_on.firstChild.data][1]
                                    pntList.append(geo.buffer(rad))
                                    pntList.append(rad)
                                    if int(rad) == 50:
                                        pntList.append('Y')
                                    else:
                                        pntList.append('N')
                                else:
                                    pntList.append(None)
                                    pntList.append(None)
                                    pntList.append(None)
                            else:
                                pntList.append(_on.firstChild.data)
                    if len(pntList) == 8:
                        pass
                    else:
                        pntList.append(0)
                    finalList = itemList+pntList+[sqn_num]
                    if finalList[16] == 0:
                        if finalList[14] == finalList[15]:
                            finalList.append('R')
                        else:
                            finalList.append('Y')
                    else:
                        finalList.append('C')

                    '''Insert records to featureclass'''
                    if finalList[11] != None:
                        #print finalList
                        icb.insertRow(finalList)
                    else:
                        arcpy.AddMessage(finalList)
                        writer.writerow(finalList)

                    #count += 1
                    sqn_num += 1
        #print count

def DetectClashWithinServicePatters(input_a_fc, xml_name):

    arcpy.AddMessage('Detecting clashes between stops...\n')

    overlap_dic = {}

    eod_data = [i for i in arcpy.da.SearchCursor(input_a_fc, ['OID@', 'POINTREFNUMBER', 'SHAPE@', 'SEQUENCENUM'])]

    for eod_row in eod_data:
        if eod_row[0] != eod_data[-1][0]:
            overlap_points = []
            base_index = eod_data.index(eod_row)
            second_seq = eod_data[base_index+1][-1]
            if second_seq != 1:
                second_seq_row = eod_data[base_index+1]
                if eod_row[2].overlaps(second_seq_row[2]):
                    overlap_points.append(str(second_seq_row[1]))
                    base_index += 1
                    third_seq = eod_data[base_index+1][-1]
                    if third_seq != 1:
                        third_seq_row = eod_data[base_index+1]
                        if eod_row[2].overlaps(third_seq_row[2]):
                            overlap_points.append(str(third_seq_row[1]))
                            base_index += 1
                            fourth_seq = eod_data[base_index+1][-1]
                            if fourth_seq != 1:
                                fourth_seq_row = eod_data[base_index+1]
                                if eod_row[2].overlaps(fourth_seq_row[2]):
                                    overlap_points.append(str(fourth_seq_row[1]))
            if len(overlap_points) > 0:
                overlap_dic[eod_row[0]] = 'Y'#(',').join(overlap_points)

    with arcpy.da.UpdateCursor(input_a_fc, ['OID@', 'CLASHSTATUS', 'FILENAME', 'COLOR', 'RADIUSTAG', 'RENDERER']) as uc:
        for row in uc:
            if row[0] in overlap_dic:
                row[1] = overlap_dic[row[0]]
            else:
                row[1] = 'N'
            row[2] = xml_name
            row[-1] = row[3]+row[4]+row[1]
            uc.updateRow(row)

# Function to represent time
def TimeConverter(time_difference):

    '''Convert time difference to float value'''
    time_dbl = float(time_difference)

    '''Run string display conditions'''
    if time_dbl <= 60:
        return [round(time_dbl, 2), 'seconds']
    else:
        time_min = time_dbl/60
        if time_min <= 60:
            return [round(time_min, 2), 'minutes']
        else:
            time_hr = time_min/60
            return [round(time_hr, 2), 'hours']

def GetServicePatternByStopID(selected_stops, infc):

    stops_text = ','.join(selected_stops)

    service_patterns = set([str(i[0]) for i in arcpy.da.SearchCursor(infc
                                                            , ['SERVICEPATTERNREFNUMBER']
                                                            , where_clause="POINTREFNUMBER in ({0})".format(stops_text))])
    return service_patterns

if __name__ == '__main__':

    start_time = time.time()

    '''Inputs'''
    workspaceFolder = arcpy.env.scratchFolder
    workspaceGDB = arcpy.env.scratchGDB
    in_xml = arcpy.GetParameterAsText(0)
    in_stops = arcpy.GetParameterAsText(1)
    '''Create a list from user input of bus stops'''


    # Create SDE connection
    #CreateDBConnections(workspaceFolder)
    #input_area_fc = os.path.join(workspaceFolder, 'EOD.sde\AT.GISADMIN.PT_EODValidationArea_DV')
    #input_location_fc = os.path.join(workspaceFolder, 'EOD.sde\AT.GISADMIN.PT_EODValidationLocation_DV')

    # Clean-up SDE featureclass
   # arcpy.DeleteFeatures_management(input_area_fc)
   # arcpy.DeleteFeatures_management(input_location_fc)

    # Create a staging featureclass in the scratch GDB
    staging_area_fc = 'xml_AREA_geometry'
    staging_location_fc = 'xml_LOCATION_geometry'

    fields = ['NAME'
            , 'OPERATORREFNUMBER'
            , 'PUBLICNUMBER'
            , 'REFNUMBER'
            , 'SHORTNAME'
            , 'SERVICEPATTERNREFNUMBER'
            , 'ISFARECAPDISCOUNTALLOWED'
            , 'ISTRANSFERDISCOUNTALLOWED'
            , 'ISCONCESSIONDISCOUNTALLOWED'
            , 'POINTREFNUMBER'
            , 'ZONE'
            , 'POINTRADIUS'
            , 'ENTRYSTAGE'
            , 'EXITSTAGE'
            , 'FLOATINGSTAGE'
            , 'SEQUENCENUM'
            , 'COLOR'
            , 'CLASHSTATUS'
            , 'FILENAME'
            , 'RADIUSTAG'
            , 'RENDERER']

    fields_cur = ['NAME'#0
            , 'OPERATORREFNUMBER'#1
            , 'PUBLICNUMBER'#2
            , 'REFNUMBER'#3
            , 'SHORTNAME'#4
            , 'SERVICEPATTERNREFNUMBER'#5
            , 'ISFARECAPDISCOUNTALLOWED'#6
            , 'ISTRANSFERDISCOUNTALLOWED'#7
            , 'ISCONCESSIONDISCOUNTALLOWED'#8
            , 'POINTREFNUMBER'#9
            , 'ZONE'#10
            , 'POINTRADIUS'#11
            , 'ENTRYSTAGE'#12
            , 'EXITSTAGE'#13
            , 'FLOATINGSTAGE'#14
            , 'SEQUENCENUM'#15
            , 'COLOR'#16
            , 'CLASHSTATUS'#17
            , 'FILENAME'#18
            , 'SHAPE@'#19
            , 'RADIUSTAG'#20
            , 'RENDERER']#-1

    fields_cur2 = ['NAME'#0
            , 'OPERATORREFNUMBER'#1
            , 'PUBLICNUMBER'#2
            , 'REFNUMBER'#3
            , 'SHORTNAME'#4
            , 'SERVICEPATTERNREFNUMBER'#5
            , 'ISFARECAPDISCOUNTALLOWED'#6
            , 'ISTRANSFERDISCOUNTALLOWED'#7
            , 'ISCONCESSIONDISCOUNTALLOWED'#8
            , 'POINTREFNUMBER'#9
            , 'ZONE'#10
            , 'POINTRADIUS'#11
            , 'ENTRYSTAGE'#12
            , 'EXITSTAGE'#13
            , 'FLOATINGSTAGE'#14
            , 'SEQUENCENUM'#15
            , 'COLOR'#16
            , 'CLASHSTATUS'#17
            , 'FILENAME'#18
            , 'SHAPE@XY'#19
            , 'RADIUSTAG'#20
            , 'RENDERER']#-1

    field_dic = {'NAME': 'TEXT'
                , 'OPERATORREFNUMBER': 'TEXT'
                , 'PUBLICNUMBER': 'TEXT'
                , 'REFNUMBER': 'LONG'
                , 'SHORTNAME': 'TEXT'
                , 'SERVICEPATTERNREFNUMBER': 'LONG'
                , 'ISFARECAPDISCOUNTALLOWED': 'TEXT'
                , 'ISTRANSFERDISCOUNTALLOWED': 'TEXT'
                , 'ISCONCESSIONDISCOUNTALLOWED': 'TEXT'
                , 'POINTREFNUMBER': 'LONG'
                , 'ZONE': 'TEXT'
                , 'POINTRADIUS': 'LONG'
                , 'ENTRYSTAGE': 'LONG'
                , 'EXITSTAGE': 'LONG'
                , 'FLOATINGSTAGE': 'LONG'
                , 'SEQUENCENUM': 'LONG'
                , 'COLOR': 'TEXT'
                , 'CLASHSTATUS': 'TEXT'
                , 'FILENAME': 'TEXT'
                , 'RADIUSTAG': 'TEXT'
                , 'RENDERER': 'TEXT'}

    '''Check if fc_ping file exist'''

    fc_dic = {staging_area_fc:'POLYGON', staging_location_fc:'POINT'}

    for _fc in fc_dic:
        if arcpy.Exists(os.path.join(workspaceGDB, _fc)) == False:
            arcpy.CreateFeatureclass_management(workspaceGDB
                                                , _fc
                                                , fc_dic[_fc]
                                                , '#'
                                                , '#'
                                                , '#'
                                                , arcpy.SpatialReference(2193))

            for _field in field_dic.keys():
                arcpy.AddField_management(os.path.join(workspaceGDB, _fc), _field, field_dic[_field])
        else:
            arcpy.TruncateTable_management(os.path.join(workspaceGDB, _fc))

    # XML Element Mining
    doc = minidom.parse(in_xml)
    od = doc.getElementsByTagName('OperatorsDefinition')
    ost = od[0].getElementsByTagName('OperatorsSet')

    dd = doc.getElementsByTagName('DomainsDefinition')
    rd = dd[0].getElementsByTagName('RootDomain')

    ld = doc.getElementsByTagName('LinesDefinition')
    bls = ld[0].getElementsByTagName('BusLinesSet')

    # Run Generate Busline Function
    GetBusLine(bls, ost, rd, os.path.join(workspaceGDB, staging_area_fc))

    # Generate Radius Clash Tags
    xml_name = os.path.basename(in_xml)
    DetectClashWithinServicePatters(os.path.join(workspaceGDB, staging_area_fc), xml_name)

    # Append new data to SDE Featureclass
    arcpy.AddMessage( 'Updating the SDE Featureclass...')
    print os.path.join(workspaceGDB, staging_area_fc)
    #if not in_stops:
       # ic_area_fc = arcpy.da.InsertCursor(input_area_fc, fields_cur)
       # with arcpy.da.SearchCursor(os.path.join(workspaceGDB, staging_area_fc), fields_cur) as sc_area_fc:
       #     for row in sc_area_fc:
       #         ic_area_fc.insertRow(row)
       # del ic_area_fc

       # ic_location_fc = arcpy.da.InsertCursor(input_location_fc, fields_cur)
       # with arcpy.da.SearchCursor(os.path.join(workspaceGDB, staging_area_fc), fields_cur2) as sc_location_fc:
       #     for row in sc_location_fc:
       #         ic_location_fc.insertRow(row)
       # del ic_location_fc
    #else:
       # selected_stops = in_stops.split(',')
       # sp_selection = GetServicePatternByStopID(selected_stops, os.path.join(workspaceGDB, staging_area_fc))
       # sp_selection_txt = ','.join(sp_selection)

       # ic_area_fc = arcpy.da.InsertCursor(input_area_fc, fields_cur)
       # with arcpy.da.SearchCursor(os.path.join(workspaceGDB, staging_area_fc)
       #                                         , fields_cur
       #                                         , where_clause="SERVICEPATTERNREFNUMBER in ({0})".format(sp_selection_txt)) as sc_area_fc:
       #     for row in sc_area_fc:
       #         ic_area_fc.insertRow(row)
       # del ic_area_fc

       # ic_location_fc = arcpy.da.InsertCursor(input_location_fc, fields_cur)
       # with arcpy.da.SearchCursor(os.path.join(workspaceGDB, staging_area_fc)
       #                             , fields_cur2
       #                             , where_clause="SERVICEPATTERNREFNUMBER in ({0})".format(sp_selection_txt)) as sc_location_fc:
       #     for row in sc_location_fc:
       #         ic_location_fc.insertRow(row)
       # del ic_location_fc

    timedifference = time.time() - start_time

    outReport = os.path.join(workspaceFolder, 'StopsNoXY.csv')
    arcpy.SetParameter(2, outReport)

    arcpy.AddMessage('\nProcess done in {0} {1}\n'.format(str(TimeConverter(timedifference)[0]), TimeConverter(timedifference)[1]))

    del in_xml, doc
    del od, os
    del dd, rd
    del ld, bls



