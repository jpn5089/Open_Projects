library(rgdal)
library(spdep)
library(sp)
library(fields)
library(MBA)

# reference doc: http://blue.for.msu.edu/lab-notes/NOAA_0.1-1/NOAA-ws-data.pdf

file <- "ftp://ftp.ncdc.noaa.gov/pub/data/noaa/isd-history.csv"
options(download.file.method="libcurl")

download.file(file, "C:/Users/jnicola/Desktop/isd-history.csv",quiet = TRUE)
st <- read.csv("C:/Users/jnicola/Desktop/R/isd-history.csv")
dim(st)
#st <- st[, -c(1:2,6:8)]
st <- st[st$CTRY == "US",]
st <- st[st$STATE %in% c("PA","VA"),]
#st$LAT <- st$LAT/1000
#st$LON <- st$LON/1000
#st$ELEV <- st$ELEV/10
st$BEGIN <- as.numeric(substr(st$BEGIN, 1, 4))
st$END <- as.numeric(substr(st$END, 1, 4))


pa.list <- st[st$WBAN %in% c("93738", "14736") & (st$BEGIN <= 2000 & st$END >= 2016 & !is.na(st$BEGIN)), ]
dim(pa.list)

outputs <- as.data.frame(matrix(NA, dim(pa.list)[1],2))


names(outputs) <- c("FILE", "STATUS")
for (y in 2000:2016) {
  y.pa.list <- pa.list[pa.list$BEGIN <= y & pa.list$END >= y, ]
  for (s in 1:dim(y.pa.list)[1]) {
    outputs[s, 1] <- paste(sprintf("%06d", y.pa.list[s,
        1]), "-", sprintf("%05d", y.pa.list[s,
        2]), "-", y, ".gz", sep = "")
    try(download.file(paste("ftp://ftp.ncdc.noaa.gov/pub/data/noaa/", y, "/", outputs[s,1], sep = ""),
                  paste("C:/Users/jnicola/Desktop/R/Hrly_Wx/", outputs[s,1], sep = ""), method = "libcurl"))
  }
}
head(pa.list)
head(outputs)

