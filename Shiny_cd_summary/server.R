
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

social_types = c("Median_Age", "Median_Household_Income")

server <- function(input, output) {
    
    rv = reactiveValues(cd = c("city of LA"), 
                        req_type = "Metal/Household Appliances",
                        social_type = "Median_Household_Income")
    
    # if we click the buttom
    observeEvent(input$button_cd, {
        rv$cd = input$CD
    })

    observeEvent(input$button_req, {
        rv$req_type = input$request_type
        rv$social_type = input$social_type
    })
            
     output$plot_income <- renderPlotly(
         ggplotly(income_plot(rv$cd))
     )
    
    output$plot_unemployment <- renderPlotly(
        ggplotly(employment_plot(rv$cd))
    )
    
    output$cd_summary <- renderTable(cd_key_stats(CD_summary, cd = rv$cd), 
                                 align = "c", rownames = TRUE, colnames = TRUE)
    
#     output$table2 <- renderTable(cd_top_requests(request_data, cd = rv$cd), 
#                                  align = "c", rownames = TRUE, colnames = TRUE)
    
    
    output$wc <- renderPlot({
        set.seed(152)
        wordcloud(words = type_summary$RequestType, type_summary$count,
                  colors = type_summary$colorlist, ordered.colors = TRUE,
                  rot.per = 0.5)}
    )
    
    output$type_summary <- renderTable(type_summary_table(), 
                                       align = "c", rownames = TRUE, colnames = TRUE)
    
    output$req_summary <- renderPlot(request_social_plot(rv$req_type, rv$social_type))
}