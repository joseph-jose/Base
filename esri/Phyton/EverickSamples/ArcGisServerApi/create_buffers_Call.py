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
    if (item.properties.name == 'Scar_TreesBuffer'):
        template_hostedFeature = item
        print('Assigned item')
    print(item.properties.name)

if (1==0):
    fLyr = existing_Contend_Item.layers[0]
    fset = fLyr.query()
    template_hostedFeature = deepcopy(fset.features[0])
    fLyr.manager.truncate()
    flayer_rows = fset.sdf

#access the first layer in points_item
#points_layer1 = points_item.layers[0]
points_layer1 = existing_Contend_Item.layers[0]

#print(points_layer1)

# get the newly buffered item
points_buffer = use_proximity.create_buffers(points_layer1,
                                             distances = [25],
                                             units = 'Meters',
                                             output_name = 'BufferAreas')

new_buffered_points_item = gis.content.get(points_buffer.id)
new_fLyr = new_buffered_points_item.layers[0]
new_fset = new_fLyr.query()
new_fset_features = new_fLyr.query().features
new_flayer_rows = new_fset.sdf

print("AfterExit")

for index, row in new_flayer_rows.iterrows():
    #new_feature = deepcopy(template_hostedFeature)
    #input_geometry = new_fset_features[index].geometry
    #output_geometry = geometry.project(geometries = [input_geometry],
    #                                   in_sr = 3857, 
    #                                   out_sr = 3857,
    #                                   gis = gis)

    # assign the updated values
    # update these based on your dataset
    #new_feature.geometry = output_geometry[0]
    #new_feature.attributes['OBJECTID'] = row['OBJECTID']
    print (row['OBJECTID'])

quit()



features_to_be_added = []

for index, row in new_flayer_rows.iterrows():
    new_feature = deepcopy(template_hostedFeature)
    input_geometry = new_fset_features[index].geometry
    output_geometry = geometry.project(geometries = [input_geometry],
                                       in_sr = 3857, 
                                       out_sr = 3857,
                                       gis = gis)

    # assign the updated values
    # update these based on your dataset
    new_feature.geometry = output_geometry[0]
    new_feature.attributes['OBJECTID'] = row['OBJECTID']
    new_feature.attributes['Region'] = row['Region']
    new_feature.attributes['Project Code'] = row['Project Code']
    new_feature.attributes['ID_Tag'] = row['ID_Tag']
    new_feature.attributes['Tree_Type'] = row['Tree_Type']
    new_feature.attributes['Tree_Status'] = row['Tree_Status']
    new_feature.attributes['Management outcome'] = row['Management outcome'] 
    
    features_to_be_added.append(new_feature)

existing_Contend_Item_Layers[0].edit_features(adds = features_to_be_added) 
print("The existing buffer feature layer is updated with new buffered features!")
