
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(plotly)
source("cd_summary_support.R")

request_types = c("Bulky Items", "Dead Animal Removal", "Graffiti Removal",
                  "Electronic Waste", "Illegal Dumping Pickup", "Other",
                  "Metal/Household Appliances", "Homeless Encampment",
                  "Single Streetlight Issue", 
                  "Multiple Streetlight Issue", "Feedback", "Report Water Waste")

server <- function(input, output) {
    
    rv = reactiveValues(cd = c("city of LA"))
    
    # if we click the buttom
    observeEvent(input$button_cd, {
        rv$cd = input$CD
    }) 
    
     output$plot_income <- renderPlotly(
         ggplotly(income_plot(rv$cd))
     )
    
    output$plot_unemployment <- renderPlotly(
        ggplotly(employment_plot(rv$cd))
    )
    
    output$table1 <- renderTable(cd_key_stats(CD_summary, cd = rv$cd), 
                                 align = "c", rownames = TRUE, colnames = TRUE)
    
#     output$table2 <- renderTable(cd_top_requests(request_data, cd = rv$cd), 
#                                  align = "c", rownames = TRUE, colnames = TRUE)
    
    
    output$wc <- renderPlot({
        set.seed(152)
        wordcloud(words = type_summary$RequestType, type_summary$count,
                  colors = type_summary$colorlist, ordered.colors = TRUE,
                  rot.per = 0.5)}
    )
}