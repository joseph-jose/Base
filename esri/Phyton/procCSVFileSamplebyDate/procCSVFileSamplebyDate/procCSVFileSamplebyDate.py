import numpy as np, pandas; #import NumPy and CSV reader


def csv_analysis():
    df = pandas.read_csv('results.csv', delimiter=',', names = list(range(0,7))) #check integrity of error solving
    new_header = df.iloc[0] #grab the first row for the header
    df = df[1:] #take the data less the header row
    df.columns = new_header #set the header row as the df header

    #JJ - bulk processing
    df['Date']= pandas.to_datetime(df['Date'], dayfirst=True, errors='coerce') #Format to date type.
    df.set_index(df["Date"],inplace=True) # Change default index to pandas.DateTimeIndex
    """Descriptive Statistics"""
    #Columns (7)
        #   Date, Time, Software, Action, Version, ID, Denial Message
        #   'not_provided' or '10/09/2015', '15:51:53', '(ARCGIS)', 'OUT:', 'Editor', 'pshih@SGH227R9P9', 'Checkout exceeds MAX specified in options file. '

    #DENIED users per week
    denied = df.loc[df ['Action'] =='DENIED:', 'Action'].resample('W').count()#Counting weekly Denials

    print(denied)

    """Writing Statistics [EXCLUDED - WIP - ]"""

    vheader = ["Date", "DENIED USERS"]

    #JJ- not working here - column headers not popping out
    denied.to_csv('statistics.csv', header = 'Date COUNT')
    #denied.to_csv('statistics.csv')
    print("Statistics File Created")

csv_analysis(); #Run csv analysis