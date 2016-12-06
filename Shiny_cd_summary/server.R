
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(plotly)
source("cd_summary_support.R")

request_types = c("Bulky Items", "Dead Animal Removal", "Graffiti Removal",
                  "Electronic Waste", "Illegal Dumping Pickup", "Other",
                  "Metal/Household Appliances", "Homeless Encampment",
                  "Single Streetlight Issue", 
                  "Multiple Streetlight Issue", "Feedback", "Report Water Waste")

server <- function(input, output) {
    
    rv = reactiveValues(cd = c("city of LA"), req_type = "Graffiti Removal")
    
    # if we click the buttom
    observeEvent(input$button_cd, {
        rv$cd = input$CD
    })

    observeEvent(input$button_req, {
        rv$req_type = input$request_type
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
    
    output$req_summary <- renderPlot(request_social_plot(rv$req_type))
}