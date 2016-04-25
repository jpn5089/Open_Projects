library(dplyr)
library(readr)
library(stringr)
library(lubridate)
library(ggplot2)
library(viridis)
library(scales)
library(rnoaa)
options(noaakey = "gOTjkNrzDlVAafWzJyICPLKaWmwXpMoL")

out <- ncdc(datasetid = "GHCND", stationid = "GHCND:USW00094823", datatypeid = c("TMAX", "TMIN"),
            startdate = "2015-01-01", enddate = "2015-12-31", limit = 1000)

stuff <- out$data %>%
  mutate(date = ymd_hms(gsub("T"," ",date)),
         value = (value/10) ) %>%
  select(date,datatype,value) %>%
  mutate(value = as.numeric(value))%>%
  mutate(month = month(date)) 

write.csv(stuff, "C:/Users/John/Desktop/Pitt.csv")
ready <- read.csv("C:/Users/John/Desktop/PIT.csv") %>%
  mutate(date = as.Date(mdy(date))) %>%
  mutate(month = month(date)) 

temp_labs <- data_frame(x=c(rep(as.Date("2015-04-01"), 2),
                            rep(as.Date("2015-10-01"), 3),
                            rep(as.Date("2015-07-01"), 1)),
                        y=c(rep(seq(0, 80, by=80), 1),
                            rep(seq(0, 80, by=40), 1),
                            32),
                        angle=c(rep(0,5),
                                rep(6)),
                        label=sprintf("%d°F", y))

gg <- ggplot()
gg <- gg + geom_label(data=temp_labs, aes(x=x, y=y, label=label),
                      size=2.5, label.size=0)
gg <- gg + geom_linerange(data=ready,
                          aes(x=date, ymin=TMINF,
                              ymax=TMAXF,
                              color=TMEANF),
                          size=0.75, alpha=1)
gg <- gg + scale_y_continuous(expand=c(0,0), limits=c(-20, 100),
                              breaks=c(seq(-20, 100, by=20),32),
                              labels=c(seq(-20, 100, by=20),32))
gg <- gg + scale_colour_gradient(low = "black", high = "gold")
gg <- gg + scale_x_date(labels = date_format("%b"), breaks = date_breaks("month"))
gg <- gg + labs(x=NULL, y=NULL, title= "2015 Daily Temperatures - Pittsburgh", subtitle=NULL)
gg <- gg + coord_polar()
gg <- gg + theme(panel.grid.major=element_line())
gg <- gg + theme(panel.grid.major.x=element_blank())
gg <- gg + theme(panel.grid.major.y=element_line(color=c(rep("#b2b2b2", 8), "white"), size=0.2))
gg <- gg + theme(panel.grid.minor=element_blank())
gg <- gg + theme(panel.grid.minor.x=element_blank())
gg <- gg + theme(panel.grid.minor.y=element_blank())
gg <- gg + theme(panel.border=element_blank())
gg <- gg + theme(panel.background=element_blank())
gg <- gg + theme(axis.text.x=element_text(color="#b2b2b2",angle=-seq(0, 360, 30)))
gg <- gg + theme(axis.text.y=element_blank())
gg <- gg + theme(axis.ticks.x=element_line(color="#b2b2b2", size=10))
gg <- gg + theme(axis.ticks.y=element_blank())
gg <- gg + theme(legend.position="none")

suppressWarnings(print(gg))

ggsave(gg, file = "C:/Users/John/Desktop/PITtemps.jpeg", width = 7, height = 7)
