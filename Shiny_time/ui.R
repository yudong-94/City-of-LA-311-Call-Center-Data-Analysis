library(shiny)

ui <- fluidPage(
  tabsetPanel(
    tabPanel("Time based analysis",
  
  titlePanel("City of LA Requesting Data Analysis - Time Based"),
  
  hr(),
  
  sidebarPanel(

           actionButton(inputId = "duration",
                        label = "Avg. Processing Time"),
           br(),
           actionButton(inputId = "bymonth",
                        label = "Requests by Month"),
           br(),
           actionButton(inputId = "byweek",
                        label = "Requests by Weekday"),
           br(),
           actionButton(inputId = "weekday_hour",
                        label = "Weekday and Hour"),
           br(),
           actionButton(inputId = "source_type",
                        label = "Source and Type"),
           br(),
           actionButton(inputId = "source_month",
                        label = "Request Source by Month"),
           br(),
           actionButton(inputId = "source_weekday",
                        label = "Request Source by Weekday"),
           br(),
           actionButton(inputId = "type_month",
                        label = "Request Type by Month"),
           br(),
           actionButton(inputId = "type_weekday",
                        label = "Request Type by Weekday"),
           br(),
           actionButton(inputId = "calls_month",
                        label = "Calls by Month"),
           br(),
           actionButton(inputId = "calls_hour",
                        label = "Calls by Hour")
           ),


  mainPanel(
           plotOutput("plot")
           )
  )
))

