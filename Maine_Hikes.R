library(rgdal)
library(sp)
library(lubridate)
library(ggplot2)
library(leaflet)
GPX_file <- "C:/Users/John/OneDrive/Maine_2016/GPS_Tracks/Acadia_2016/Current.gpx"
wp1 <- readOGR(GPX_file, layer = "track_points", verbose=FALSE) 

head(wp1[,c('ele', 'time')])

hike.dists <- spDists(wp1, segments=TRUE)
sum(hike.dists) * 0.621371 # km to miles

wp1$time <- with_tz(ymd_hms(wp1$time),"America/New_York")

p <- ggplot(as.data.frame(wp1), # convert to regular dataframe
            aes(x=time, y=ele))
p + geom_point() + labs(x='Hiking time', y='Elevations (meters)')


track <- readOGR(GPX_file, layer = "tracks", verbose = FALSE)
leaflet() %>% addTiles() %>% addPolylines(data=track)


m <- leaflet() %>%
  
  # Add tiles
  addProviderTiles("Thunderforest.Landscape", group = "Topographical") %>%
  addProviderTiles("OpenStreetMap.Mapnik", group = "Road map") %>%
  addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
  
  addLegend(position = 'bottomright',opacity = 0.4, 
            colors = 'blue', 
            labels = 'Gimillan-Grausson',
            title = 'City Hikes, Pittsburgh') %>%
  
  # Layers control
  addLayersControl(position = 'bottomright',
                   baseGroups = c("Topographical", "Road map", "Satellite"),
                   overlayGroups = c("Hiking routes", "Photo markers"),
                   options = layersControlOptions(collapsed = FALSE)) %>%
  
  addPolylines(data=track, color='blue', group='Hiking routes') 
m

exif_datetime <- function(path) {
  # read out the picture-taken datetime for a file using exiftool
  
  exif_cmd <- 'exiftool -T -r -DateTimeOriginal '  
  cmd <- paste(exif_cmd, '"', path, '"', sep='')
  exif_timestamp <- system(cmd, intern = TRUE) # execute exiftool-command
  
  exif_timestamp
}

wpd <- as.data.frame(wp1)

photoIcon <- makeIcon(
  iconAnchorX = 12, iconAnchorY = 12, # center middle of icon on track,
  # instead of top corner  
  iconUrl = "https://www.mapbox.com/maki/renders/camera-12@2x.png"
)

hike_photos <- generatePhotoMarkers(
  photo_dir = '/Users/cmohan/Dropbox/hike_photos/',
  waypoints = wp1,
  base_url = '/Users/cmohan/Dropbox/hike_photos/',
  time_offset = 5260) 

m <- addMarkers(hike_photos, lng=hike_photos$longitude, lat=hike_photos$latitude ,  
                popup=hike_photos$popup_html, # use the timestamp as popup-content 
                icon = "https://www.mapbox.com/maki/renders/camera-12@2x.png", # function providing custom marker-icons
                group='Photo markers')
m


