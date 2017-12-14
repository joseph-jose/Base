######################################################################
#                   ArcGIS Log Format/Export                         #
#                                                                    #
#   Author: Alan Scandrett, for Watercare Services Limited.          #
#   Last Edit:  dd/mm/yy                                             #
#                                                                    #
######################################################################
import re; #import regex for string manipulation
import datetime; #alter default date format
def parser():
    try:
        with open("ArcGIS_GPP.log", "r") as input_f: #Open log file (same directory as .py file)
             with open('results.csv', 'wb') as output_f: #Create file/open if exists (same directory as .py file)
                print("File is Open")
                output_f.write("Date,Time,Software,Action,Version,ID,Denial Message\n") #Insert Headers
                print("Output File Created")
                date = "not_provided" #Account for missing TIMESTAMP field data
                print("Processing Data...")
                for line in input_f: #for each line the document
                    if "TIMESTAMP" in line: #Block locates and records the TIMESTAMP
                        array = line.split(" ");
                        date = array[-1].strip()
                        date = datetime.datetime.strptime(date, '%m/%d/%Y').strftime('%d/%m/%y') #change from US date to normal date

                    if (" OUT:" in line or "IN:" in line or "UNSUPPORTED:" in line or "DENIED:" in line): #Locates connections
                        array = line.split(" ");
                        outputitem="";
                        if array[0] == "":
                                del array[0]
                        
                        if "UNSUPPORTED:" in array: #Slices through string to format data if field is of UNSUPPORTED:
                            new_array = array[:4]
                            new_array.append(array[8])
                            joined = ' '.join(array[10:])
                            new_array.append((joined.partition('(')[-1].rpartition('(')[0])+',\n')
                            array = new_array


                            
                        if "DENIED:" in array: #Same as above, but for DENIED:
                            new_array = array[:5]
                            joined = ' '.join(array[5:])
                            new_array.append((joined.partition('(')[-1].rpartition('(')[0])+',\n')
                            array = new_array
                            
                        for item in array: #Formats each line into comma seperated value (.CSV) format
                            if outputitem != "" and item != "":
                                outputitem = outputitem + ",";
                            if item != "":
                                outputitem = outputitem + item;
                        outputitem =  date + ',' + outputitem;
                        output_f.write(outputitem);
                        
        print('END'); #Completion
    except Exception, e:
        print('Failed to complete exception encountered: '+ str(e))
        print('Please ensure that the file name input is "ArcGIS_GPP.log"')
        raw_input()
        

parser(); #Runs the function upon opening the file



#Log File Formatting
# Time, Software Label, "TIMESTAMP", 10/8/2015  || TIMESTAMP
# Time, Software Label, Action, Software Version, ID        || Standard Input
# Time, Software Label, Action, "Tracking", (...), ID, (...)    || UNSUPPORTED
# Time, Software Label, "DENIED", Software Version, ID,  "(Licensed number of users already reached. (-4,342))" || DENIED
