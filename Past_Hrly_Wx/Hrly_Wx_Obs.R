library(rgdal)
library(spdep)
library(sp)
library(fields)
library(MBA)

# reference doc: http://blue.for.msu.edu/lab-notes/NOAA_0.1-1/NOAA-ws-data.pdf

c<-setwd("~/")

file <- "ftp://ftp.ncdc.noaa.gov/pub/data/noaa/isd-history.csv"
options(download.file.method="libcurl")

download.file(file, "~/GitHub/Open_Projects/Past_Hrly_Wx/Data/isd-history.csv",quiet = TRUE)
st <- read.csv("~/GitHub/Open_Projects/Past_Hrly_Wx/Data/isd-history.csv")

points <- read.csv("~/GitHub/EnergyPriceForecastComp/Points.csv")

#st <- st[st$CTRY %in% c("SP", "PO"),]
for (p in 1:18) {
  st <- st[st$USAF %in% (points[4,p])]
}
#st <- st[st$USAF == points[p,4]]
#st$LAT <- st$LAT/1000
#st$LON <- st$LON/1000
#st$ELEV <- st$ELEV/10
st$BEGIN <- as.numeric(substr(st$BEGIN, 1, 4))
st$END <- as.numeric(substr(st$END, 1, 4))


sp.list <- st[st$USAF %in% c("80020", "85670") & (st$BEGIN <= 2014 & st$END >= 2016 & !is.na(st$BEGIN)), ]
dim(pa.list)

outputs <- as.data.frame(matrix(NA, dim(sp.list)[1],2))

names(outputs) <- c("Point","FILE")
for (y in 2014:2016) {
  y.sp.list <- sp.list[sp.list$BEGIN <= y & sp.list$END >= y, ]
  for (s in 1:dim(y.sp.list)[1]) {
    outputs[s, 2] <- paste(sprintf("%06d", y.sp.list[s,
        1]), "-", sprintf("%05d", y.sp.list[s,
        2]), "-", y, ".gz", sep = "")
    try(download.file(paste("ftp://ftp.ncdc.noaa.gov/pub/data/noaa/", y, "/", outputs[s,2], sep = ""),
                  paste("~/GitHub/Open_Projects/Past_Hrly_Wx/Data/", outputs[s,2], sep = ""), method = "libcurl"))
  }
}
head(pa.list)
head(outputs)

dir.create(paste(getwd(),"/GitHub/Open_Projects/Past_Hrly_Wx/Data/ES_PT",sep = ""))
untar(paste(getwd(), "/GitHub/Open_Projects/Past_Hrly_Wx/Data/",))

g <- gunzip("~/GitHub/Open_Projects/Past_Hrly_Wx/Data/080020-99999-2014.gz")
