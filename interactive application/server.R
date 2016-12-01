
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
source("requests_plot.R")



server <- function(input, output) {
    
    rv = reactiveValues(type = "", time_start = "", )
    
    # if we click the buttom
    observeEvent(input$button, {
        rv$data = "Bulky Items"
    }) 
    
    output$plot <- renderPlot(zip_plot_customized(sampled_data, rv$data))
    
    output$click_info <- renderPrint({
        cat("input$plot_click:\n")
        str(input$plot_click)
    })
}