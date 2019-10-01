from arcgis.gis import GIS
gis = GIS(profile="your_enterprise_profile")


#---------------------------------------


#import modules
from arcgis.gis import *
from IPython.display import display

#declare a connection to your portal
gis = GIS("https://atalgispsu01.aucklandtransport.govt.nz:7443/arcgis/", "JejyJose1@TRANSPORT", "Transport14")
print("Successfully logged in as: " + gis.properties.user.username)

#search for items without passing in string values to the query or type parameters
items = gis.content.search('', '', max_items = 30)
for item in items:
  display(item)