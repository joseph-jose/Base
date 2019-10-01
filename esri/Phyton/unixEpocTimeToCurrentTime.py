def unixDateToCurrentDate(inEsriSec):
    #timestamp = 1541966901002L
    delta = datetime.timedelta(seconds=inEsriSec/1000)
    unixStart = datetime.date(1970, 1, 1)
    return(unixStart + delta)