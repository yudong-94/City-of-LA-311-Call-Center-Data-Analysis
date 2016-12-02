
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

ui <- fluidPage(
    dateRangeInput("daterange", "Time Period:",
                   start  = "2015-08-01",
                   end    = "2016-11-30",
                   min    = "2015-08-01",
                   max    = "2016-11-30",
                   format = "mm/dd/yy",
                   separator = " - "),
    
    actionButton(inputId = "button",
                 label = "Bulky Items"),
    
    plotOutput(outputId = "plot", click = "plot_click")

)