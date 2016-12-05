
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com

library(shiny)

request_types = c("Bulky Items", "Dead Animal Removal", "Graffiti Removal",
                  "Electronic Waste", "Illegal Dumping Pickup", "Other",
                  "Metal/Household Appliances", "Homeless Encampment",
                  "Single Streetlight Issue", 
                 "Multiple Streetlight Issue", "Feedback", "Report Water Waste")

CD_lists = c(as.character(1:15), "city of LA")

ui <- navbarPage(
    
    "Requesting Analysis",
    
    fluid = TRUE, 
    
    tabPanel("Zipcode Level Analysis",

        sidebarLayout(
            sidebarPanel(
                    dateRangeInput("daterange", "Time Period: ",
                                    start  = "2015-08-01",
                                    end    = "2016-11-30",
                                    min    = "2015-08-01",
                                    max    = "2016-11-30",
                                    format = "mm/dd/yy",
                                    separator = " - "),
                
                    selectInput(inputId = "types", 
                                label = "Request Types: ", 
                                choices = request_types, 
                                multiple = TRUE, selectize = TRUE),
                            
                    actionButton(inputId = "button_geo",
                                label = "Submit"),
                    
                    width = 4),
            
                mainPanel(
                    plotOutput(outputId = "plot", click = "plot_click")))),
    
    tabPanel("Council Districts Analysis",
    
        sidebarLayout(
            sidebarPanel(
                selectInput(inputId = "CD", 
                            label = "Council Districts: ", 
                            choices = CD_lists, 
                            multiple = TRUE, selectize = TRUE,
                            selected = "city of LA"),
            
                actionButton(inputId = "button_cd",
                            label = "Submit",
                            style='padding:3px'),
                
                width = 3),
            
            mainPanel(
                fluidRow(
                    tableOutput('table1')),
                hr(),
                    tableOutput('table2')))
    )
    
)