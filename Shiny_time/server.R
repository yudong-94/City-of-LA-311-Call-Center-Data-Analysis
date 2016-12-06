library(shiny)
source("time_based.R")

server <- function(input, output) {
  
  # button
  observeEvent(input$duration, {
    output$plot <- renderPlot({
      p <- ggplot(duration_summary, aes(x = reorder(RequestType, -mean), y = mean)) +
        geom_bar(stat = "identity",
                 fill = "paleturquoise3") +
        ylab("Avg. Processing Time (hrs)") +
        xlab("Request Type") +
        ggtitle("Processing time of different request types") +
        theme_classic() +
        theme(axis.text.x = element_text(angle = 30, hjust = 1, size = 12),
              axis.text.y = element_text(size = 14),
              axis.title = element_text(size=14),
              title = element_text(size=16, face='bold'))
      print(p)
    }, height = 400, width = 600)
  }) 
  
  observeEvent(input$bymonth, {
    output$plot <- renderPlot({
      p <- ggplot(request1, aes(x = factor(month_created))) +
        geom_bar(fill = "paleturquoise3") +
        ylab("Number of Requests") +
        xlab("Month of the year") +
        ggtitle("Total Requests by Month") +
        theme_classic() +
        theme(axis.text.x = element_text(size = 16),
              axis.text.y = element_text(size = 16),
              axis.title = element_text(size=16),
              title = element_text(size=16, face='bold'))
      print(p) 
    }, height = 400, width = 600)
  }) 
  
  observeEvent(input$byweek, {
    output$plot <- renderPlot({
      p <- ggplot(request1, aes(x = weekday_created)) +
        geom_bar(fill = "paleturquoise3") +
        ylab("Number of Requests") +
        xlab("") +
        ggtitle("Total Requests by Weekday") +
        theme_classic() +
        theme(axis.text.x = element_text(size = 16),
              axis.text.y = element_text(size = 16),
              axis.title = element_text(size=16),
              title = element_text(size=16, face='bold'))
      print(p)
    }, height = 400, width = 600)
  })

  observeEvent(input$weekday_hour, {
    output$plot <- renderPlot({
      p <- ggplot(request2, aes(x = weekday_created, 
                                y = factor(hour_created), 
                                fill = count)) +
        geom_tile() +
        scale_fill_gradient(low = "white", high = "deeppink4", 
                            breaks = NULL, labels = NULL) +
        theme_classic() +
        ylab("Time of the Day") +
        xlab("") +
        ggtitle("Total Requests by Weekday and Time of the day") +
        theme(axis.text.x = element_text(size = 16),
              axis.text.y = element_text(size = 16),
              axis.title = element_text(size=16),
              title = element_text(size=16, face='bold'))
      print(p)
    }, height = 400, width = 600)
  })
  
  
  observeEvent(input$source_month, {
    output$plot <- renderPlot({
      p <- ggplot(request5, aes(x = RequestSource, 
                                y = factor(month_created), 
                                fill = count)) +
        geom_tile() +
        scale_fill_gradient(low = "mistyrose", high = "deeppink3", 
                            breaks = NULL, labels = NULL) +
        theme_classic() +
        ylab("Month of the Year") +
        xlab("") +
        ggtitle("Source of Request and Month of the Year") +
        theme(axis.text.x = element_text(angle = 30, hjust = 1, size = 12),
              axis.text.y = element_text(size = 16),
              axis.title = element_text(size=16),
              title = element_text(size=16, face='bold'))
      print(p)
    }, height = 400, width = 600)
  })
  
  observeEvent(input$source_weekday, {
    output$plot <- renderPlot({
      p <- ggplot(request7, aes(x = RequestSource, 
                                y = factor(weekday_created), 
                                fill = count)) +
        geom_tile() +
        scale_fill_gradient(low = "mistyrose", high = "deeppink3", 
                            breaks = NULL, labels = NULL) +
        theme_classic() +
        ylab("") +
        xlab("") +
        ggtitle("Request Source by Weekday") +
        theme(axis.text.x = element_text(angle = 30, hjust = 1, size = 12),
              axis.text.y = element_text(size = 16),
              axis.title = element_text(size=16),
              title = element_text(size=16, face='bold'))
      print(p)
    }, height = 400, width = 600)
  })
  
  observeEvent(input$type_month, {
    output$plot <- renderPlot({
      p <- ggplot(request6, aes(x = RequestType, 
                                y = factor(month_created), 
                                fill = count)) +
        geom_tile() +
        scale_fill_gradient(low = "mistyrose", high = "deeppink3", 
                            breaks = NULL, labels = NULL) +
        theme_classic() +
        ylab("Month of the Year") +
        xlab("") +
        ggtitle("Request Type by Month") +
        theme(axis.text.x = element_text(angle = 30, hjust = 1, size = 12),
              axis.text.y = element_text(size = 16),
              axis.title = element_text(size=16),
              title = element_text(size=16, face='bold'))
      print(p)
    }, height = 400, width = 600)
  })
  
  observeEvent(input$type_weekday, {
    output$plot <- renderPlot({
      p <- ggplot(request8, aes(x = RequestType, 
                                y = factor(weekday_created), 
                                fill = count)) +
        geom_tile() +
        scale_fill_gradient(low = "mistyrose", high = "deeppink3", 
                            breaks = NULL, labels = NULL) +
        theme_classic() +
        ylab("") +
        xlab("") +
        ggtitle("Type of Request by Weekday") +
        theme(axis.text.x = element_text(angle = 30, hjust = 1, size = 12),
              axis.text.y = element_text(size = 16),
              axis.title = element_text(size=16),
              title = element_text(size=16, face='bold'))
      print(p)
    }, height = 400, width = 600)
  })
  
  observeEvent(input$calls_month, {
    output$plot <- renderPlot({
      p <- ggplot(request9, aes(x = factor(month_created))) +
        geom_bar(fill = "paleturquoise3") +
        ylab("Number of Requests") +
        xlab("Month of the year") +
        ggtitle("Calls distribution by Month") +
        theme_classic() +
        theme(axis.text.x = element_text(size = 16),
              axis.text.y = element_text(size = 16),
              axis.title = element_text(size=16),
              title = element_text(size=16, face='bold'))
      print(p)
    }, height = 400, width = 600)
  })
  
  observeEvent(input$calls_hour, {
    output$plot <- renderPlot({
      p <- ggplot(request9, aes(x = factor(hour_created))) +
        geom_bar(fill = "paleturquoise3") +
        ylab("Number of Requests") +
        xlab("Hour of the day") +
        ggtitle("Calls distribution by hour of the day") +
        theme_classic() +
        theme(axis.text.x = element_text(size = 16),
              axis.text.y = element_text(size = 16),
              axis.title = element_text(size=16),
              title = element_text(size=16, face='bold'))
      print(p)
    }, height = 400, width = 600)
  })
  
}

