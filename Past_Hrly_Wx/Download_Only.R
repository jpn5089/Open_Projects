

download.file('ftp://ftp.ncdc.noaa.gov/pub/data/noaa/2016/994340-99999-2016.gz',
              "C:/Users/jnicola/Desktop/R/test.gz")
library(httr)
r<-GET('ftp://ftp.ncdc.noaa.gov/pub/data/noaa/2016/994340-99999-2016.gz',timeout(100))
t<-readLines('ftp://ftp.ncdc.noaa.gov/pub/data/noaa/2016/994340-99999-2016.gz')
