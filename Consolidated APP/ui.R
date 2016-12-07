library(shiny)

request_types = c("Bulky Items", "Dead Animal Removal", "Graffiti Removal",
                  "Electronic Waste", "Illegal Dumping Pickup", "Other",
                  "Metal/Household Appliances", "Homeless Encampment",
                  "Single Streetlight Issue", 
                  "Multiple Streetlight Issue", "Feedback", "Report Water Waste")

CD_lists = c(as.character(1:15), "city of LA")

social_types = c("Median_Age", "Median_Household_Income")

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
    ),
    
    tabPanel("Regional Requests Social Analysis",
             
             
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
                         tableOutput('cd_summary'))
                     #                      hr(),
                     #                      tableOutput('table2'))
                 )
             ),
             
             hr(),
             
             fluidRow(
                 column(6,
                        plotlyOutput(outputId = "plot_income")),
                 column(6,
                        plotlyOutput(outputId = "plot_unemployment")))
    ),
    
    tabPanel("Requests Type Social Analysis",
             
             sidebarPanel(
                 selectInput(inputId = "request_type", 
                             label = "Request Type: ", 
                             choices = request_types, 
                             multiple = FALSE, selectize = TRUE,
                             selected = "Metal/Household Appliances"),
                 
                 selectInput(inputId = "social_type", 
                             label = "Social Characteristics: ", 
                             choices = social_types, 
                             multiple = FALSE, selectize = TRUE,
                             selected = "Median_Household_Income"),
                 
                 actionButton(inputId = "button_req",
                              label = "Submit"),
                 
                 width = 4),
             
             mainPanel(
                 fluidRow(
                     plotOutput(outputId = 'req_summary')))
             
    ),
    
    tabPanel("Requests Type Efficiency Analysis",
             
             fluidRow(
                 column(6,
                        tableOutput(outputId = "type_summary")
                 ),
                 
                 column(4,
                        plotOutput(outputId = "wc")))
             
    ),
    
    tabPanel("Department Efficiency Analysis",
             
             column(3,
                    actionButton(inputId = "dep_source",
                                 label = "Department and request source")),
             
             column(3,
                    actionButton(inputId = "dep_type",
                                 label = "Department and request type")),
             
             column(3,
                    actionButton(inputId = "dep_cd",
                                 label = "Department and Council Districts")),
             
             plotOutput("dep_plot")
    )
    
    
)
