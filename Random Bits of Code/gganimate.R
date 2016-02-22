library(GEOmap)
library(rNOMADS)
library(fields)
library(rvest)
library(xml2)
#Get latest GFS model

options(noaakey = "gOTjkNrzDlVAafWzJyICPLKaWmwXpMoL")

model.urls <- GetDODSDates("gfs")
latest.model <- tail(model.urls$url, 1)
model.runs <- GetDODSModelRuns(latest.model)
latest.model.run <- tail(model.runs$latest.model.run, 1)
#Get data
time <- c(0,0) #Analysis model
lon <- c(0, 719) #All 720 longitude pointsth
lat <- c(0, 360) #All 361 latitude points


library(devtools)
install_github("robjhyndman/MEFM-package") 

install.packages("rNOMADS", repos="http://R-Forge.R-project.org")

library(rNOMADS)


archived.model.list <- NOMADSArchiveList("grib")


abbrev <- "gfs"
urls.out <- GetDODSDates(abbrev)

#______________________________________________________________

devtools::install_github("dgrtwo/gganimate")
devtools::install_github('thomasp85/ggforce')
install.packages('tweenr')

if (!require(devtools)) {
  install.packages("devtools")
}
devtools::install_github("thomasp85/tweenr")

install.packages('gganimate')
install.packages('ggforce')
library(ggplot2)
library(gganimate)
library(tweenr)

# Making up data
t <- data.frame(x=0, y=0, colour = 'forestgreen', size=1, alpha = 1, 
                stringsAsFactors = FALSE)
t <- t[rep(1, 12),]
t$alpha[2:12] <- 0
t2 <- t
t2$y <- 1
t2$colour <- 'firebrick'
t3 <- t2
t3$x <- 1
t3$colour <- 'steelblue'
t4 <- t3
t4$y <- 0
t4$colour <- 'goldenrod'
t5 <- t4
c <- ggforce::radial_trans(c(1,1), c(1, 12))$transform(rep(1, 12), 1:12)
t5$x <- (c$x + 1) / 2
t5$y <- (c$y + 1) / 2
t5$alpha <- 1
t5$size <- 0.5
t6 <- t5
t6 <- rbind(t5[12,], t5[1:11, ])
t6$colour <- 'firebrick'
t7 <- rbind(t6[12,], t6[1:11, ])
t7$colour <- 'steelblue'
t8 <- t7
t8$x <- 0.5
t8$y <- 0.5
t8$size <- 2
t9 <- t
ts <- list(t, t2, t3, t4, t5, t6, t7, t8, t9)

tweenlogo <- data.frame(x=0.5, y=0.5, label = 'tweenr', stringsAsFactors = F)
tweenlogo <- tweenlogo[rep(1, 60),]
tweenlogo$.frame <- 316:375

# Using tweenr
tf <- tween_states(ts, tweenlength = 2, statelength = 1, 
                   ease = c('cubic-in-out', 'elastic-out', 'bounce-out', 
                            'cubic-out', 'sine-in-out', 'sine-in-out', 
                            'circular-in', 'back-out'), 
                   nframes = 375)

# Animate with gganimate
p <- ggplot(data=tf, aes(x=x, y=y)) + 
  geom_text(aes(label = label, frame = .frame), data=tweenlogo, size = 13) + 
  geom_point(aes(frame = .frame, size=size, alpha = alpha, colour = colour)) + 
  scale_colour_identity() + 
  scale_alpha(range = c(0, 1), guide = 'none') +
  scale_size(range = c(4, 60), guide = 'none') + 
  expand_limits(x=c(-0.36, 1.36), y=c(-0.36, 1.36)) + 
  theme_bw()
animation::ani.options(interval = 1/15)
gg_animate(p, title_frame = F, ani.width = 400, 
           ani.height = 400)

library(gapminder)


p <- ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, color = continent, frame = year)) +
  geom_point() +
  scale_x_log10()
gg_animate(p)

Sys.which2 <- function(cmd) {
  stopifnot(length(cmd) == 1)
  if (.Platform$OS.type == "windows") {
    suppressWarnings({
      pathname <- shell(sprintf("where %s 2> NUL", cmd), intern=TRUE)[1]
    })
    if (!is.na(pathname)) return(setNames(pathname, cmd))
  }
  Sys.which(cmd)
}

## Trying out Sys.which & Sys.which2 on my Windows box gives the following:
Sys.which("convert")
#                              convert 
# "C:\\Windows\\system32\\convert.exe" 
Sys.which2("convert")
#                                                 convert 
# "C:\\Program Files\\ImageMagick-6.8.8-Q16\\convert.exe" 
