library(leaflet)
library(ggplot2)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

source('polygon_plot.R')
source('top10_barchart.R')

## Leaflet bindings are a bit slow; for now we'll just sample to compensate
set.seed(100)
request_sample <- sample_n(request_duration,1000)

types <- c("Bulky Items", "Dead Animal Removal", "Graffiti Removal",
           "Electronic Waste", "Illegal Dumping Pickup", "Other",
           "Metal/Household Appliances", "Homeless Encampment",
           "Single Streetlight Issue", 
           "Multiple Streetlight Issue", "Feedback", "Report Water Waste")

function(input, output, session) {
  
########################### Interactive Map ###########################################
  
  #### This observer is used to create the map with Council District polygons 
  observe({
    if (length(input$type)==0 || 'all' %in% input$type) {
      requestBy <- types
    } else {
      requestBy <- input$type
    }
    polyBy <- input$polygon
    # print(str(input$type))
    # Create the polygons
    output$map <- renderLeaflet({
      polygon_plot(requestBy, polyBy) %>%
        # addTiles(
        #   urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        #   attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
        # ) %>%
        setView(lng = -118, lat = 34, zoom = 10)
    })
  })

  ## A reactive expression that returns the set of requests that are in bounds right now
  requestsInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(request_sample[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)

    subset(request_sample,
           Latitude >= latRng[1] & Latitude <= latRng[2] &
             Longitude >= lngRng[1] & Longitude <= lngRng[2])
  })
  
  
  ## reset all the circles
  observeEvent(input$reset, {
    # leafletProxy('map') %>%
    #   clearShapes()
    updateSelectInput(session, 'type', selected = character(0))
    output$top10_cd = renderPlot({})
    output$top10_nc = renderPlot({})
  }) 
  
  #### This observer is responsible for maintaining the circles and legend.
  observe({
    polyBy <- input$polygon
    metricBy <- input$metric
    
    ## select the circle data
    if (length(input$type)==0) {
      output$top10_cd = renderPlot({})
      output$top10_nc = renderPlot({})
    } else if ('all' %in% input$type) {
      requestBy <- types
      circle_data = request_sample
      updateSelectInput(session, 'type', selected = 'all')
    } else {
      requestBy <- input$type
      circle_data = request_sample %>% filter(RequestType %in% requestBy)
    }
    
    ## Color and palette are set by the request types.
    if (length(input$type)==0) {
    } else {
      colorData <- circle_data$RequestType
      pal <- colorFactor(palette = palette(rainbow(12)), 
                         domain=types)
      
      ## Radius are set by duration for the data point divided by max duration multiply 10000
      max_size <- max(request_duration$Duration)
      
      ## Set layerId as SRNumber to ensure all circles shown on the map
      ## Set group to remove all the circles without removing the polygons
      leafletProxy("map", data = circle_data) %>%
        addCircles(~Longitude, ~Latitude, radius=~Duration/max_size*10000, layerId=~SRNumber,
                   stroke=FALSE, fillOpacity=0.6, fillColor=pal(colorData), group='circles') %>%
        addLegend("bottomleft", pal=pal, values=colorData, title='Request type',
                  layerId="colorLegend") 
      
      ## Plot auxiliary bar charts
      output$top10_cd <- renderPlot({
        ## If no requests are in view, don't plot
        if (nrow(requestsInBounds()) == 0)
          return(NULL)
        top10_cd_barchart(requestBy, metricBy)
      })
      
      output$top10_nc <- renderPlot({
        ## If no requests are in view, don't plot
        if (nrow(requestsInBounds()) == 0)
          return(NULL)
        top10_nc_barchart(requestBy, metricBy)
      })
    }
  })
  
  ## Show a popup at the given location
  showRequestPopup <- function(layer, lat, lng) {
    ## show popup for polygon information
    if (!layer %in% request_sample$SRNumber) {
      selectedRequest <- request_duration %>%
        select(CD, RequestType, Duration) %>%
        filter(CD == layer) %>%
        group_by(RequestType) %>%
        summarise(count = n(), avg_duration = sum(Duration)/n())
      countTop3 <- selectedRequest %>%
        arrange(desc(count)) %>%
        slice(1:3)
      durationTop3 <- selectedRequest %>%
        arrange(desc(avg_duration)) %>%
        slice(1:3)
      content <- as.character(tagList(
        sprintf("Council District: %s", layer), tags$br(),
        sprintf('Top3 occurrance request types:\n %s', 
                paste(countTop3$RequestType,collapse = ", ")), tags$br(),
        sprintf('Top3 longest duration request types:\n %s', 
                paste(durationTop3$RequestType,collapse = ", "))
      ))
    } else {
      ## show popup for circle information
      selectedRequest <- request_sample[request_sample$SRNumber == layer,]
      content <- as.character(tagList(
        sprintf("Request type: %s", selectedRequest$RequestType), tags$br(),
        sprintf("Duration: %s", as.integer(selectedRequest$Duration)), tags$br(),
        sprintf("Council district: %s", selectedRequest$CD), tags$br(),
        sprintf("Neighborhood council code: %s", selectedRequest$NC), tags$br(),
        sprintf("Zipcode: %s", selectedRequest$ZipCode)
      ))
    }
    leafletProxy("map") %>% addPopups(lng, lat, content, layerId = layer)
  }
  
  ## When map is clicked, show a popup with city info
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()
    
    isolate({
      showRequestPopup(event$id, event$lat, event$lng)
    })
    
  })
  
}