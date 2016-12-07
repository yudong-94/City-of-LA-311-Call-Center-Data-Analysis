
## Choices for drop-downs
vars1 <- c("All Request Types" = 'all',
           "Bulky Items" = "Bulky Items", 
           "Dead Animal Removal" = "Dead Animal Removal", 
           "Graffiti Removal" = "Graffiti Removal",
           "Electronic Waste" = "Electronic Waste", 
           "Illegal Dumping Pickup" = "Illegal Dumping Pickup", 
           "Other" = "Other",
           "Metal/Household Appliances" = "Metal/Household Appliances", 
           "Homeless Encampment" = "Homeless Encampment",
           "Single Streetlight Issue" = "Single Streetlight Issue", 
           "Multiple Streetlight Issue" = "Multiple Streetlight Issue", 
           "Feedback" = "Feedback", 
           "Report Water Waste" = "Report Water Waste")

vars2 <- c('Population(000s)' = 'population',
           'Median Household Income($000s)' = 'income',
           'Unemployment rate(%)' = 'unemployment',
           'Number of requests' = 'count',
           'Number of requests per 1000 residents' = 'requests_per_1000_residents',
           'Average processing duration(mins)' = 'duration')

vars3 <- c('Number of requests' = 'count',
           'Average processing duration(mins)' = 'duration')


## The panel
navbarPage("LA311", id="nav",
           
           tabPanel("Interactive map",
                    div(class="outer",
                        
                        tags$head(
                          # Include our custom CSS
                          includeCSS("styles.css"),
                          includeScript("gomap.js")
                        ),
                        
                        leafletOutput("map", width="100%", height="100%"),

                        
                        # Shiny versions prior to 0.11 should use class="modal" instead.
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                      width = 330, height = "auto",
                                      
                                      h2("Requests explorer"),
                                      
                                      selectInput("type", "Request type", vars1, multiple = T, selectize = T),
                                      selectInput('polygon', 'Background color', vars2, selected = 'count'),
                                      selectInput('metric', 'Metric', vars3, selected = 'count'),
                                      actionButton("reset", label = "Reset"),
                                      plotOutput("top10_cd", height = 200),
                                      plotOutput("top10_nc", height = 200)
                        )
                    )
           )
)
