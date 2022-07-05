# script to create buffers from points in another layer
print("Entering")
from arcgis.gis import GIS
from arcgis.features import use_proximity
from arcgis.geometry import Point
from arcgis.geometry import Envelope
from arcgis.geometry import Geometry
from arcgis.geometry import Polygon
from copy import deepcopy

print("Connected")

#point_str = "{'x': 622400, 'y': 8605354, 'spatialReference': {'wkid': 28354, 'latestWkid': 28354}}"
#pt = Point({"x" : -118.15, "y" : 33.80, "spatialReference" : {"wkid" : 4326}})
point_str = "{\"x\" : 589521.0816, \"y\" : 8627265.153, \"spatialReference\" : {\"wkid\" : 28354, \"latestWkid\": 28354}}"
curr_Point = Point(point_str)
print (curr_Point.is_valid)
print (curr_Point.type)
print(curr_Point.x)
print(curr_Point.y)


print(curr_Point.spatialReference['latestWkid'])
#quit()

print("Area 1")

curr_Coord_xMin = curr_Point.x - 100
curr_Coord_xMax = curr_Point.x + 100
curr_Coord_yMin = curr_Point.y - 100
curr_Coord_yMax = curr_Point.y + 100
geom_Str = Geometry({
     'rings' : [[[-97.06138,32.837],[-97.06133,32.836],[-97.06124,32.834],[-97.06127,32.832],
               [-97.06138,32.837]],[[-97.06326,32.759],[-97.06298,32.755],[-97.06153,32.749],
               [-97.06326,32.759]]],
     'spatialReference' : {'wkid' : 4326}
     })

print(geom_Str)
curr_Polygon = Geometry(geom_Str)
print(curr_Polygon)
print (curr_Polygon.type)
print (isinstance(curr_Polygon, Polygon))




print("Area 2")

geom_Str = Geometry({
     'rings' : [
         [
            [-97.06326,32.759],[-97.06298,32.755],
            [-97.06153,32.749],[-97.06326,32.759]
                                    ]],
     'spatialReference' : {'wkid' : 4326}
     })


print(geom_Str)
curr_Polygon = Geometry(geom_Str)
print(curr_Polygon)
print (curr_Polygon.type)
print (isinstance(curr_Polygon, Polygon))


#589421.0816	8627165.153
#589421.0816	8627365.153
#589621.0816	8627365.153
#589621.0816	8627165.153
print("Area 3")

geom_Str = Geometry({
     'rings' : [[
                 [589421.0816, 8627165.153],[589421.0816,8627365.153],
                 [589621.0816, 8627365.153],[589621.0816, 8627165.153]
                 ]],
     'spatialReference' : {'wkid' : 28354}
     })

print(geom_Str)
curr_Polygon = Geometry(geom_Str)
print(curr_Polygon)
print (curr_Polygon.type)
print (isinstance(curr_Polygon, Polygon))
#quit()

print("Area 4")

#\"spatialReference\" : {\"wkid\" : 28354, \"latestWkid\": 28354}
#geom_Str = "{{\"rings\" : [[[{0},{1}],[{2},{3}],[{4},{5}],[{6},{7}]]],\"spatialReference\" : {8}}}"
geom_Str = "{{\"rings\" : [[[{0},{1}],[{2},{3}],[{4},{5}],[{6},{7}]]],\"spatialReference\" : {8}}}"
geom_Str = geom_Str.format(curr_Coord_xMin, curr_Coord_yMin,
                           curr_Coord_xMin, curr_Coord_yMax,
                           curr_Coord_xMax, curr_Coord_yMax,
                           curr_Coord_xMax, curr_Coord_yMin, str(curr_Point.spatialReference))
print(geom_Str)
curr_Polygon = Geometry(geom_Str)
print(curr_Polygon)
print (curr_Polygon.type)
print (isinstance(curr_Polygon, Polygon))
