library(shiny)

ui <- navbarPage(
    
    "Requesting Analysis",
    
    fluid = TRUE, 
    
    tabPanel("Time-based Requests Type Analysis",
             
             sidebarPanel(
                 
                 actionButton(inputId = "duration",
                              label = "Avg. Processing Time", width = 200),
                 
                 br(),
                 
                 actionButton(inputId = "bymonth",
                              label = "Requests by Month", width = 200),
                 
                 br(),
                 
                 actionButton(inputId = "byweek",
                              label = "Requests by Weekday", width = 200),
                 
                 br(),
                 
                 actionButton(inputId = "weekday_hour",
                              label = "Weekday and Hour", width = 200),
                 
                 br(),
                 
                 actionButton(inputId = "type_month",
                              label = "Request Type by Month", width = 200),
                 
                 br(),
                 
                 actionButton(inputId = "type_weekday",
                              label = "Request Type by Weekday", width = 200)
                
           ),
           
           mainPanel(
               plotOutput("plot")
               )
    ),
    
    tabPanel("Time-based Requests Source Analysis",

             sidebarPanel(
                 
                 actionButton(inputId = "source_count",
                              label = "Requests by Source", width = 200),
                 
                 br(),
                 
                 actionButton(inputId = "source_type_count",
                              label = "Requests by Source and Type", width = 200),
                 
                 br(),
                 
                 actionButton(inputId = "source_eff",
                              label = "Efficiency by Source", width = 200),
                 
                 br(),
                 
                 actionButton(inputId = "source_month",
                              label = "Request Source by Month", width = 200),
                 
                 br(),
                 
                 actionButton(inputId = "source_weekday",
                              label = "Request Source by Weekday", width = 200),
                 
                 br(),
                 
                 actionButton(inputId = "calls_month",
                              label = "Calls by Month", width = 200),
                 
                 br(),
                 
                 actionButton(inputId = "calls_hour",
                              label = "Calls by Hour", width = 200)
             ),
             
             mainPanel(
                 plotOutput("plot2")
             )
    )
              
)
