
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

request_types = c("Bulky Items", "Dead Animal Removal", "Graffiti Removal",
                  "Electronic Waste", "Illegal Dumping Pickup", "Other",
                  "Metal/Household Appliances", "Homeless Encampment",
                  "Single Streetlight Issue", 
                 "Multiple Streetlight Issue", "Feedback", "Report Water Waste")

ui <- fluidPage(
    
    titlePanel("City of LA Requesting Data Analysis"),
    
    hr(),
    
    fluidRow(
        column(3, 
            dateRangeInput("daterange", "Time Period:",
                           start  = "2015-08-01",
                           end    = "2016-11-30",
                           min    = "2015-08-01",
                           max    = "2016-11-30",
                           format = "mm/dd/yy",
                           separator = " - "),

            selectInput(inputId = "types", 
                        label = "Request Types", 
                        choices = request_types, multiple = TRUE, selectize = TRUE),
            
            actionButton(inputId = "button",
                         label = "Submit")),
        
        column(8, 
        plotOutput(outputId = "plot", click = "plot_click")),
        
        hr(),

        dataTableOutput(outputId = "top_zip")
        
        
        # verbatimTextOutput("info")
    )
)