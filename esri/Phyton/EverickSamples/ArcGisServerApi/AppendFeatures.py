import arcpy
from arcgis.gis import GIS
from arcgis.features import use_proximity
from copy import deepcopy
from arcgis import geometry
from arcgis.geometry import Point
from arcgis.geometry import Geometry

def createBufferFPoint(inGeom):
    curr_Point = Point(inGeom)
 
    curr_Coord_xMin = curr_Point.x - 100 
    curr_Coord_xMax = curr_Point.x + 100 
    curr_Coord_yMin = curr_Point.y - 100 
    curr_Coord_yMax = curr_Point.y + 100

    geom_Polygon = Geometry({
        'rings' : [[
                 [curr_Coord_xMin, curr_Coord_yMin],[curr_Coord_xMin,curr_Coord_yMax],
                 [curr_Coord_xMax, curr_Coord_yMax],[curr_Coord_xMax, curr_Coord_yMin]
                 ]],
         'spatialReference' : {'wkid' : curr_Point.spatialReference['latestWkid']}
    })

    return geom_Polygon

def connRemoteLayers():
    v_crl_Result = False
    gis = GIS("https://everick-heritage.maps.arcgis.com/home/index.html", v_uName, v_uPwd)
    print("AGOL Connected")

    v_crl_existing_Contend_Item = gis.content.get(v_uAgolItem)
    if (v_crl_existing_Contend_Item == None):
        print("AGOL contend not found")
        return [v_crl_Result, None, None]

    for item in v_crl_existing_Contend_Item.layers:
        if (item.properties.name == v_uPointLyrName):
            v_crl_Lyrpoint = item
        if (item.properties.name == v_uPolyLyrName):
            v_crl_LyLyrPolygon = item       
    if (v_crl_Lyrpoint == None):
        print("AGOL Point Feature class not found")
        return [v_crl_Result, None, None]
    if (v_crl_LyLyrPolygon == None):
        print("AGOL Polygon Feature class not found")
        return [v_crl_Result, None, None]
    
    return [True, v_crl_Lyrpoint, v_crl_LyLyrPolygon]


if __name__ == "__main__":
    v_uName = arcpy.GetParameterAsText(0)
    v_uPwd = arcpy.GetParameterAsText(1)
    v_uAgolItem = arcpy.GetParameterAsText(2)
    v_uPointLyrName = arcpy.GetParameterAsText(3)
    v_uPolyLyrName = arcpy.GetParameterAsText(4)

    v_connAGOLItems = connRemoteLayers()
    if (v_connAGOLItems[0] == True):
        print("AGOL Point & Polygon Feature layers  found")
    v_PointLyr = v_connAGOLItems[1] 
    v_PolyLyr = v_connAGOLItems[2] 

    v_PolyLyr.delete_features(where = "OBJECTID > 0")
    v_ToBeAdded_Features = []
    
    v_PointLyr_Features = v_PointLyr.query().features
    print("Collecting features to be converted...")
    for v_CurrFeat in v_PointLyr_Features:
        v_original_feature = v_CurrFeat

        v_new_feature = deepcopy(v_original_feature)
        v_original_geometry = v_original_feature.geometry
    
        v_new_Geometry = createBufferFPoint(v_original_geometry)
        v_new_feature.geometry = v_new_Geometry
        v_new_feature.attributes['OBJECTID'] = v_original_feature.attributes['OBJECTID']
        v_new_feature.attributes['Region'] = v_original_feature.attributes['Region']
        #new_feature.attributes['Project Code'] = original_feature.attributes['Project Code']
        v_new_feature.attributes['ID_Tag'] = v_original_feature.attributes['ID_Tag']
        v_new_feature.attributes['Tree_Type'] = v_original_feature.attributes['Tree_Type']
        v_new_feature.attributes['Tree_Status'] = v_original_feature.attributes['Tree_Status']
        #new_feature.attributes['Management outcome'] = original_feature.attributes['Management outcome']     
        v_ToBeAdded_Features.append(v_new_feature)

    v_PolyLyr.edit_features(adds = v_ToBeAdded_Features) 
    print("The existing point layer is updated with new buffered features!")

