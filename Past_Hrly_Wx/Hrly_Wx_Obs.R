library(rgdal)
library(spdep)
library(sp)
library(fields)
library(MBA)
library(dplyr)
library(R.utils)

# reference doc: http://blue.for.msu.edu/lab-notes/NOAA_0.1-1/NOAA-ws-data.pdf

c<-setwd("~/")

file <- "ftp://ftp.ncdc.noaa.gov/pub/data/noaa/isd-history.csv"
options(download.file.method="libcurl")

download.file(file, "~/GitHub/Open_Projects/Past_Hrly_Wx/Data/isd-history.csv",quiet = TRUE)
st <- read.csv("~/GitHub/Open_Projects/Past_Hrly_Wx/Data/isd-history.csv")

points <- read.csv("~/GitHub/EnergyPriceForecastComp/Points.csv")

#st <- st[st$CTRY %in% c("SP", "PO"),]
#for (p in 1:18) {
#  st <- st[st$USAF %in% (points[4,p])]
#}
#st <- st[st$USAF == points[p,4]]
#st$LAT <- st$LAT/1000
#st$LON <- st$LON/1000
#st$ELEV <- st$ELEV/10
st$BEGIN <- as.numeric(substr(st$BEGIN, 1, 4))
st$END <- as.numeric(substr(st$END, 1, 4))

x <- points[[4]]

points.list <- st[st$USAF %in% x,]

points.list <- left_join(points.list,points) %>%
  select(point, USAF, WBAN, STATION.NAME, CTRY, ELEV.M., BEGIN, END)

#& (st$BEGIN <= 2014 & st$END >= 2016 & !is.na(st$BEGIN)), ]
#dim(points.list)

outputs <- as.data.frame(matrix(NA, dim(points.list)[1],2))

names(outputs) <- c("Point","FILE")
for (y in 2014:2016) {
  y.points.list <- points.list[points.list$BEGIN <= y & points.list$END >= y, ]
  for (s in 1:dim(y.points.list)[1]) {
    outputs[s, 2] <- paste(sprintf("%06d", y.points.list[s,
        2]), "-", sprintf("%05d", y.points.list[s,
        3]), "-", y, ".gz", sep = "")
    try(download.file(paste("ftp://ftp.ncdc.noaa.gov/pub/data/noaa/", y, "/", outputs[s,2], sep = ""),
                  paste("~/GitHub/Open_Projects/Past_Hrly_Wx/Data/ES_PT_Wx/", points.list[s,1], "-", outputs[s,2], sep = ""), method = "libcurl"))
  }
}

g <- gunzip("~/GitHub/Open_Projects/Past_Hrly_Wx/Data/ES_PT_Wx/1-080020-99999-2015.gz")
data <- read.table(gzfile(paste(getwd(), "~/GitHub/Open_Projects/Past_Hrly_Wx/Data/ES_PT_Wx/1-080020-99999-2015", sep = ""), open = "rt"), sep = "", header = FALSE, skip =1, colClasses = classes)
