
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
source("requests_plot.R")

request_types = c("Bulky Items", "Dead Animal Removal", "Graffiti Removal",
                  "Electronic Waste", "Illegal Dumping Pickup", "Other",
                  "Metal/Household Appliances", "Homeless Encampment",
                  "Single Streetlight Issue", 
                  "Multiple Streetlight Issue", "Feedback", "Report Water Waste")

server <- function(input, output) {
    
    rv = reactiveValues(type = request_types, time_start = "2015-08-01", time_end = "2016-11-30")
    
    # if we click the buttom
    observeEvent(input$button, {
        rv$type = input$types
        rv$time_start = as.POSIXct(input$daterange[1])
        rv$time_end = as.POSIXct(input$daterange[2])
    }) 
    
    output$plot <- renderPlot(zip_plot_customized(
        sampled_data, rv$type, rv$time_start, rv$time_end))
    
    output$click_info <- renderPrint({
        cat("input$plot_click:\n")
        str(input$plot_click)
    })
}