# script to create buffers from points in another layer
print("Entering")
from arcgis.gis import GIS
from arcgis.features import use_proximity
from copy import deepcopy
from arcgis import geometry
gis = GIS("https://everick-heritage.maps.arcgis.com/home/content.html?view=table&sortOrder=desc&sortField=modified&folder=Joseph.Jose_Everick&start=1&num=20#content", "Joseph.Jose_Everick", "j0s3pH2o22!")

print("Connected")

# get the buffered feature layer
existing_Contend_Item = gis.content.get("eba7f6a8b51d4615ab386d43580d82b2")
existing_Contend_Item_Layers = existing_Contend_Item.layers

#for item in existing_Contend_Item:
#    print(item)
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

Lyrpoint_ScarTreeCopy.delete_features(where = "OBJECTID > 0")

points_layer1 = Lyrpoint_ScarTree
new_fset = points_layer1.query()
new_fset_features = points_layer1.query().features
new_flayer_rows = new_fset.sdf
