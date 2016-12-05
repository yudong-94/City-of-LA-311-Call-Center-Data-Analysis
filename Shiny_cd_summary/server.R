
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
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

    
    output$table1 <- renderTable(cd_key_stats(CD_summary, cd = rv$cd), 
                                 align = "c", rownames = TRUE, colnames = TRUE)
    
    output$table2 <- renderTable(cd_top_requests(request_data, cd = rv$cd), 
                                 align = "c", rownames = TRUE, colnames = TRUE)
    
}