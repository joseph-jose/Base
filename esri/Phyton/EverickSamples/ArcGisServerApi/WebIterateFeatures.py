# script to create buffers from points in another layer
print("Entering")
from arcgis.gis import GIS
from arcgis.features import use_proximity
from arcgis.geometry import Point
from copy import deepcopy
gis = GIS("https://everick-heritage.maps.arcgis.com/home/content.html?view=table&sortOrder=desc&sortField=modified&folder=Joseph.Jose_Everick&start=1&num=20#content", "Joseph.Jose_Everick", "j0s3pH2o22!")

print("Connected")

# get the buffered feature layer
existing_Contend_Item = gis.content.get("eba7f6a8b51d4615ab386d43580d82b2")
existing_Contend_Item_Layers = existing_Contend_Item.layers

for item in existing_Contend_Item.layers:
    #print(item)
    #print(item.properties.name)
    if (item.properties.name == 'Scar_Trees2'):
        Lyrpoint_ScarTree = item
        #print('Assigned itemScar_Trees2')
    if (item.properties.name == 'Scar_TreesBuffer'):
        LyrPoly_ScarTreeBuffer = item
        #print('Assigned itemScar_TreesBuffer')
    if (item.properties.name == 'Scar_Trees2Copy'):
        Lyrpoint_ScarTreeCopy = item
        #print('Assigned itemScar_Trees2Copy')

#access the first layer in points_item
points_layer1 = existing_Contend_Item.layers[0]
new_fset = points_layer1.query()
new_fset_features = points_layer1.query().features
new_flayer_rows = new_fset.sdf

points_layer1 = Lyrpoint_ScarTree
new_fset = points_layer1.query()
new_fset_features = points_layer1.query().features
new_flayer_rows = new_fset.sdf



features_to_be_added = []

print('Printing Lyrpoint_ScarTree')
for f in new_fset_features:
    original_feature = f
    #print(str(original_feature))
    print(original_feature.attributes['GlobalID'])
    print(original_feature.geometry)

    curr_Point = Point(original_feature.geometry)
    print(curr_Point.x)
    curr_Coord_xMin = curr_Point.x - 100
    curr_Coord_xMax = curr_Point.x + 100
    curr_Coord_yMin = curr_Point.y - 100
    curr_Coord_yMax = curr_Point.y + 100

    geom_Str = "\{\"rings\" : [[{0},{1}],[{2},{3}],[(4},{5}],[{6},{7}]],\"spatialReference\" : {8}\}"
    geom_Str = geom_Str.format(curr_Coord_xMin, curr_Coord_xMax,
                    curr_Coord_xMin, curr_Coord_yMax,
                    curr_Coord_xMax, curr_Coord_yMax,
                    curr_Coord_xMin, curr_Coord_yMin, curr_Point.spatialReference)
    print(geom_Str)

    print(curr_Point.spatialReference)
    #print(original_feature.geometry[1:10])

    orig_geometry = original_feature.geometry
    print('Another\n')
