
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(dplyr)
library(ggplot2)
source("source.R")

shiny=function(input, output) {
  
  observeEvent(input$source_count, {
    output$plot <- renderPlot({
      p <- ggplot(source,aes(x=reorder(RequestSource,-count),y=count))+
        geom_bar(stat="identity",fill = "paleturquoise3")+
        xlab("")+
        ylab("")+
        ggtitle("Request per source")+
        geom_text(aes(label = count), vjust = -1,size=2.5)+ 
        theme_classic()+
        theme(axis.text.x = element_text(angle = 30, hjust = 1))
      print(p)
    }, height = 400, width = 600)
  })     
  
  observeEvent(input$source_type_count, {
    output$plot <- renderPlot({
      p <- ggplot(request12,aes(x=RequestSource,y=RequestType,fill=Count))+
        geom_tile()+
        scale_fill_gradient(low = "mistyrose", high = "deeppink3") +
        theme_classic() +
        ylab("") +
        xlab("") +
        ggtitle("Requests by Source and Type") +
        theme(axis.text.x = element_text(angle = 30, hjust = 1))
      print(p)
    }, height = 400, width = 600)
  })     
  
  observeEvent(input$source_eff, {
    output$plot <- renderPlot({
      p <-ggplot(request13,aes(x=reorder(RequestSource,-mean),y=mean))+
        geom_bar(stat="identity",fill = "paleturquoise3")+
        ggtitle("Request Efficiency by Request Source") +
        xlab("Reqeust Source")+
        ylab("Average Duration")+
        geom_text(aes(label = mean), vjust = -1,size=2.5)+
        theme_classic()+
        theme(axis.text.x = element_text(angle = 30, hjust = 1))
      print(p)
    }, height = 400, width = 600)
  })     
  
   
}