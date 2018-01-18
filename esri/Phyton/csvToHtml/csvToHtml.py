import csv
csvf = 'F:/Library2/GISDocs/GISWebPage/DEV/scratch/layerlist/NetviewLayerChange.csv'
boilerplateTop = """
<html>
<head>
  <title>Layer List Key Word Search</title>
  <link rel="shortcut icon" href="img/favicon.ico"/>
  <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">  
  <link rel="stylesheet" type="text/css" href="vendor/font-awesome-4.7.0/css/font-awesome.min.css">
  <link rel="stylesheet" type="text/css" href="vendor/datatables/datatables.min.css">
  <link rel="stylesheet" type="text/css" href="css/lyrlststyle.css">
  <link rel="stylesheet" type="text/css" href="css/style.css">
  <script type="text/javascript" src="vendor/datatables/jquery-1.12.4.js"></script>
  <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script type="text/javascript" src="vendor/datatables/datatables.min.js"></script>
  <script type="text/javascript" src="js/layerlist.js"></script>
</head>
<body>
<!-- navigation bar -->
<div id="nav"></div>
<!-- container -->
<div id="conTab" class="container">
    <h2 class="mt-5 text-center">Layer List Key Word Search</h2>
    <hr>
    <p>Type in a Keyword, the results will show which viewers will contain the information you require</a></p>
    <!-- row -->
    <div class="row">
    <div class="panel panel-primary filterable">
      <div class="panel-heading">
      </div>
      </div>
      <table id="myTable">
        <thead>
          <tr class="header">
            <th width="200px">Key Word</th>
            <th>Group Layer</th>
            <th>Layer Name</th>
            <th><a href="https://wsldctpgweb.water.internal/netview/nvg/" target="_blank">Netview</a></th>
            <th><a href="https://wsldctpgweb.water.internal/netview/nvr/" target="_blank">Netview for Retail</a></th>
            <th><a href="https://wsldctpgweb.water.internal/netview/nvsd/" target="_blank">Netview for Service Delivery</a></th>
            <th><a href="https://wsldctpgweb.water.internal/netview/nvms/" target="_blank">Netview for MSN</th>
            <th><a href="https://wsldctpgweb.water.internal/netview/nvpd/" target="_blank">Netview for Planning and Developments</a></th>
            <th><a href="https://wsldctpgweb.water.internal/netview/nvp/" target="_blank">Netview for Property</a></th>
            <th><a href="https://wsldctpgweb.water.internal/portal/apps/webappviewer/index.html?id=f93b4d67516341f884e1aca60db03619" target="_blank">Local Network Performance</th>
            <th><a href="https://wsldctpgweb.water.internal/portal/apps/webappviewer/index.html?id=1f1667525996463fa303ceb55ec0dab8" target="_blank">Population Projection</a></th>
            <th><a href="https://wsldctpgweb.water.internal/portal/apps/webappviewer/index.html?id=6a365aa2c7634e819ce988991e5d5096" target="_blank">Auckland Council Unitary Plan</a></th>
            <th><a href="https://wsldctpgweb.water.internal/portal/apps/webappviewer/index.html?id=83deb599dddd46b3833cab771d12a7c3" target="_blank">Geological Map of New Zealand</a></th>
            <th><a href="https://wsldctpgweb.water.internal/portal/apps/webappviewer/index.html?id=e13cc281d3084305a3a51df44980f1ba" target="_blank">Historical Aerial Photography</th>
          </tr>
        </thead>
"""  
boilerplateBot = """

      </table>
    </div>
    <!-- row -->
</div>
<!-- container -->
<!-- footer -->
<div id="footer"></div>
</body>
</html>
"""
     
with open(csvf, 'r') as csvfile:
  reader = csv.reader(csvfile, delimiter=',', quotechar='|')
  csvfile.readline()
  f_html = open('Layerlist.html','w') 
  f_html.write(boilerplateTop)
  
  #data rows
  f_html.write('        <tbody>\n')
  for row in reader:
    f_html.write('          <tr>\n')
    for i in row:
      #find FALSE input "cross" icon into <td>
      if "FALSE" in i:
        print "crossy road"
        f_html.write(str('            <td><i id="cross" class="fa fa-times fa-2x" aria-hidden="true"></i></td>\n'))
      #find TRUE input "tick" icon into <td>
      elif "TRUE" in i:
        print "ticky"
        f_html.write(str('            <td><i id="tick" class="fa fa-check fa-2x" aria-hidden="true"></i></td>\n'))
      else:
        #print the text into td
        print "neither"
        f_html.write(str('            <td>' + i + '</td>\n'))
    f_html.write('          </tr>\n')
  f_html.write('        </tbody>\n')

  f_html.write(boilerplateBot)
  f_html.close()


  






