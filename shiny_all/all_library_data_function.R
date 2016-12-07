## interactive map
library(leaflet)
library(ggplot2)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

## convert shp
library(rgdal)
library(rgeos)
# library(raster)
library(splancs)
library(sp)
library(maptools)

## Others
library(lubridate)
library(viridis)
library(wordcloud)

## load everything
load("all_shiny_data.RData")
load("all_function.RData")
