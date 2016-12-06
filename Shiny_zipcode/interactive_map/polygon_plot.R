#### This script is used to cover the map with the CD polygons

library(rgdal)
library(sp)
library(maptools)

load('request_duration.RData')
load('cd_summary.RData')

polygon_plot = function(request_types, metric){
  
  ## load shp file and transform to (lng,lat) data
  map = readOGR("./CnclDist_July2012/CnclDist_July2012.shp")
  cd = spTransform(map, CRS("+proj=longlat +datum=WGS84"))
  
  ## filter the request data
  request_cd = request_duration %>%
    filter(RequestType %in% request_types) %>%
    group_by(CD) %>%
    summarise('Requests Counts' = n(), 'Average Update Duration' = sum(Duration)/n())
  request_cd$CD = as.factor(request_cd$CD)
  
  ## combine request data and new information
  data = left_join(cd_summary, request_cd, by=c('Council District'='CD'))
  data = data %>%
    mutate(requests_per_1000_residents = `Requests Counts`/`Population(000s)`) %>%
    rename(id=`Council District`, population=`Population(000s)`,
           income=`Median Household Income($000s)`, unemployment=`Unemployment Rate`,
           count=`Requests Counts`, duration=`Average Update Duration`)
  
  ## combine the joined request dataset to spatial dataset
  ggcd<-fortify(cd, region = "DISTRICT")
  ggcd<-left_join(ggcd, data, by=c("id"))
  ggcd$id = as.factor(ggcd$id)
  polyFunc<-function(groupname, dat){
    poly<-filter(dat, id==groupname) %>%
      dplyr::select(long, lat)
    return(Polygons(list(Polygon(poly)), groupname))
  }
  
  ## generate the spatial data frame
  cds <- distinct(ggcd, id, population, income, unemployment, count, duration, requests_per_1000_residents)
  cdname <- cds$id
  polygons<-lapply(cdname, function(x) polyFunc(x, dat=ggcd))
  sp.polygon<-SpatialPolygons(polygons)
  df.polygon<-SpatialPolygonsDataFrame(sp.polygon,
                                       data=data.frame(row.names=cdname, cds))
  
  ## set polygon color
  pal <- colorNumeric(
    palette = "YlGnBu",
    domain = df.polygon[[metric]]
  )
  
  ## build the map
  map1<-leaflet() %>%
    addProviderTiles("CartoDB.Positron") %>%
    addPolygons(data = df.polygon,
                fillColor = ~pal(eval(parse(text=metric))), # let string recognized as variable
                color = "#b2aeae", # need to use hex colors
                fillOpacity = 0.7,
                weight = 0.3,
                smoothFactor = 0.2,
                layerId = ~id) %>%
    addLegend(pal = pal,
              values = df.polygon[[metric]],
              position = "bottomright",
              title = metric) 
  return(map1)
}

############################################################################################
# cd_summary = CD_summary[1:15,] %>%
#   dplyr::select(`Council District`, `Population(000s)`, `Median Household Income($000s)`,
#                 `Unemployment Rate`)

# df.polygon <- df.polygon[order(df.polygon$Requests.Counts),]

# popup <- paste0("GEOID: ", df.polygon$id, "<br>", "Percent of Households above $200k: ", round(df.polygon$percent,2))

# polygon_select('Other','Requests Counts')

# ggplot() +
#   geom_polygon(data = ggcd , aes(x=long, y=lat, group = group, fill=Count), color="grey50") +
#   scale_fill_gradientn(colours = c("red", "white", "cadetblue"),
#                        values = c(1,0.5, .3, .2, .1, 0))


# tmp <- left_join(df.polygon2@data, data, by=c("DISTRICT"="id")) %>%
#   arrange(rec)
# 
# df.polygon2@data=tmp
# 
# pal = colorNumeric(
#   palette='YlGnBu',
#   domain=df.polygon2$Count
# )
# 
# map2=leaflet() %>%
#   addProviderTiles('Requests') %>%
#   addPolygons(data=df.polygon2,
#               fillColor = ~pal(Count),
#               color = '#b2aeae',
#               fillOpacity = 0.7,
#               weight=1,
#               smoothFactor=0.2) %>%
#   addLegend(pal=pal,
#             values=df.polygon2$Count,
#             position='bottomright',
#             title = 'aaaaa',
#             labFormat = labelFormat(suffix="%"))
# map2
