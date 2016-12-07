# library(shiny)
# library(ggplot2)
# library(plotly)
# library(lubridate)
# library(dplyr)
# library(viridis)
# library(wordcloud)

# load("data_for_shiny.RData")

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

    rv = reactiveValues(cd = c("city of LA"), 
                        req_type = "Metal/Household Appliances",
                        social_type = "Median_Household_Income")
    
    # if we click the buttom
    observeEvent(input$button_cd, {
        rv$cd = input$CD
    })
    
    observeEvent(input$button_req, {
        rv$req_type = input$request_type
        rv$social_type = input$social_type
    })
    
    observeEvent(input$dep_source, {
        output$plot <- renderPlot({
            p <- ggplot(dep_eff, aes(x = Owner, y = RequestSource, fill = avg_update)) +
                geom_tile() +
                scale_fill_gradient(low = "white", high = "darkred") +
                ggtitle("Service response time across department and request source") +
                xlab("Department assigned") +
                ylab("Source of Request") +
                theme(axis.text.x = element_text(angle = 30, hjust = 1)) +
                guides(fill=guide_legend(title="Average response(hours)"))
            print(p)
        }, height = 400, width = 600)
    })     
    
    observeEvent(input$dep_cd, {
        output$plot <- renderPlot({
            p <- ggplot(cd_eff, aes(x = factor(CD), y = avg_update,color = Owner)) +
                geom_point(size = 5) +
                ggtitle("Resolution Efficiency Across Council Districts and Department") +
                xlab("Council Districts") +
                ylab("Average updated time(hours)") +
                guides(fill = guide_legend(title = "Department"))
            print(p)
        }, height = 400, width = 600)
    })     
    
    observeEvent(input$dep_type, {
        output$plot <- renderPlot({
            p <- ggplot(type_eff, aes(x = RequestType, y = avg_update,color = Owner)) +
                geom_point(size = 5) +
                theme(axis.text.x = element_text(angle = 30, hjust = 1)) +
                ggtitle("Service response time across department and request type") +
                xlab("Service Request Type") +
                ylab("Average response(hours)") +
                theme(axis.text.x = element_text(angle = 30, hjust = 1)) +
                guides(fill=guide_legend(title="Department"))
            print(p)
        }, height = 400, width = 600)
    })     
    
    output$plot_income <- renderPlotly(
        ggplotly(income_plot(rv$cd))
    )
    
    output$plot_unemployment <- renderPlotly(
        ggplotly(employment_plot(rv$cd))
    )
    
    output$cd_summary <- renderTable(cd_key_stats(CD_summary, cd = rv$cd), 
                                     align = "c", rownames = TRUE, colnames = TRUE)
    
    #     output$table2 <- renderTable(cd_top_requests(request_data, cd = rv$cd), 
    #                                  align = "c", rownames = TRUE, colnames = TRUE)
    
    
    output$wc <- renderPlot({
        set.seed(152)
        wordcloud(words = type_summary$RequestType, type_summary$count,
                  colors = type_summary$colorlist, ordered.colors = TRUE,
                  rot.per = 0.5)}
    )
    
    output$type_summary <- renderTable(type_summary_table(), 
                                       align = "c", rownames = TRUE, colnames = TRUE)
    
    output$req_summary <- renderPlot(request_social_plot(rv$req_type, rv$social_type))
    
    
    observeEvent(input$dep_source, {
        output$dep_plot <- renderPlot(
            def_eff_plot(), height = 400, width = 600)
    })     
    
    observeEvent(input$dep_cd, {
        output$dep_plot <- renderPlot(
            cd_eff_plot(), height = 400, width = 600)
    })     
    
    observeEvent(input$dep_type, {
        output$dep_plot <- renderPlot(
            type_eff_plot(), height = 400, width = 600)
    })     
    
        
}

