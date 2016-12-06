
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
ui <- fluidPage(
  tabPanel("Request Source Analysis",
           
           column(3,
                  actionButton(inputId = "source_count",
                               label = "Requests by Source")),
           
           column(3,
                  actionButton(inputId = "source_type_count",
                               label = "Requests by Source and Type")),
           
           column(3,
                  actionButton(inputId = "source_eff",
                               label = "Efficiency by Source")),
           
           plotOutput("plot")
  )
  
  
)
  
