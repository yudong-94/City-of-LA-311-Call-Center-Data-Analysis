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

  observeEvent(input$source_count, {
    output$plot2 <- renderPlot(source_count(), height = 400, width = 600)
  })  

  observeEvent(input$source_type_count, {
    output$plot2 <- renderPlot(source_type_count(), height = 400, width = 600)
  })  
  
  observeEvent(input$source_eff, {
    output$plot2 <- renderPlot(source_eff(), height = 400, width = 600)
  })    
      
  observeEvent(input$source_month, {
    output$plot2 <- renderPlot(source_month_heatmap(), height = 400, width = 600)
  })
  
  observeEvent(input$source_weekday, {
    output$plot2 <- renderPlot(source_weekday_heatmap(), height = 400, width = 600)
  })
  
  observeEvent(input$type_month, {
    output$plot <- renderPlot(type_month_heatmap(), height = 400, width = 600)
  })
  
  observeEvent(input$type_weekday, {
    output$plot <- renderPlot(type_weekday_heatmap(), height = 400, width = 600)
  })
  
  observeEvent(input$calls_month, {
    output$plot2 <- renderPlot(call_month_plot(), height = 400, width = 600)
  })
  
  observeEvent(input$calls_hour, {
    output$plot2 <- renderPlot(call_hour_plot(), height = 400, width = 600)
  })
  
}

