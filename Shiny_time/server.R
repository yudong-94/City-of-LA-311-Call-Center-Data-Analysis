library(shiny)
source("time_based.R")

server <- function(input, output) {
  
  # button
  observeEvent(input$duration, {
    output$plot <- renderPlot(duration_summary_plot(), height = 400, width = 600)
  }) 
  
  observeEvent(input$bymonth, {
    output$plot <- renderPlot(by_month_plot(), height = 400, width = 600)
  }) 
  
  observeEvent(input$byweek, {
    output$plot <- renderPlot(by_weekday_plot(), height = 400, width = 600)
  })

  observeEvent(input$weekday_hour, {
    output$plot <- renderPlot(weekday_hour_heatmap(), height = 400, width = 600)
  })
  
  observeEvent(input$source_month, {
    output$plot <- renderPlot(source_month_heatmap(), height = 400, width = 600)
  })
  
  observeEvent(input$source_weekday, {
    output$plot <- renderPlot(source_weekday_heatmap(), height = 400, width = 600)
  })
  
  observeEvent(input$type_month, {
    output$plot <- renderPlot(type_month_heatmap(), height = 400, width = 600)
  })
  
  observeEvent(input$type_weekday, {
    output$plot <- renderPlot(type_weekday_heatmap(), height = 400, width = 600)
  })
  
  observeEvent(input$calls_month, {
    output$plot <- renderPlot(call_month_plot(), height = 400, width = 600)
  })
  
  observeEvent(input$calls_hour, {
    output$plot <- renderPlot(call_hour_plot(), height = 400, width = 600)
  })
  
}

