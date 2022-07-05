# script to create buffers from points in another layer
print("Entering")
from arcgis.gis import GIS
from arcgis.features import use_proximity
from copy import deepcopy
gis = GIS("https://everick-heritage.maps.arcgis.com/home/content.html?view=table&sortOrder=desc&sortField=modified&folder=Joseph.Jose_Everick&start=1&num=20#content", "Joseph.Jose_Everick", "j0s3pH2o22!")

print("Connected")

# get the buffered feature layer
existing_Contend_Item = gis.content.get("eba7f6a8b51d4615ab386d43580d82b2")
existing_Contend_Item_Layers = existing_Contend_Item.layers

#for item in existing_Contend_Item:
#    print(item)
for item in existing_Contend_Item.layers:
    print(item)
    if (item.properties.name == 'Scar_Trees2'):
        Lyrpoint_ScarTree = item
    if (item.properties.name == 'Scar_TreesBuffer'):
        LyrPoly_ScarTreeBuffer = item
        print('Assigned item')
    print(item.properties.name)

#access the first layer in points_item
points_layer1 = existing_Contend_Item.layers[0]
new_fset = points_layer1.query()
new_fset_features = points_layer1.query().features
new_flayer_rows = new_fset.sdf

print('Printing Layers 0')

for index, row in new_flayer_rows.iterrows():
    print (row['OBJECTID'])
    print (row['Region'])
    #print (row['Project Code'])
    print (row['ID_Tag'])
    print (row['Tree_Type'])
    print (row['Tree_Status'])

print('Printing Layers 1')
new_fset = LyrPoly_ScarTreeBuffer.query()
new_fset_features = points_layer1.query().features
new_flayer_rows = new_fset.sdf

for index, row in new_flayer_rows.iterrows():
    print (row['OBJECTID'])
    print (row['Region'])
    #print (row['Project Code'])
    print (row['ID_Tag'])
    print (row['Tree_Type'])
    print (row['Tree_Status'])
