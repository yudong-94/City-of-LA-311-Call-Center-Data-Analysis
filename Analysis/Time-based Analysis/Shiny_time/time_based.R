# load("processed_requests2.RData")
# load("data for shiny.RData")

library(ggplot2)
library(dplyr)
library(lubridate)
library(viridis)

# request_subset = request_data %>%
#   select(-(ActionTaken), -(Owner), -(MobileOS), 
#          -(Anonymous), -(AssignTo), -(AddressVerified), 
#          -(ApproximateAddress), -(Address:Suffix), 
#          -(Latitude:PolicePrecinct)) %>%
#   filter(CreatedDate > ymd_hms("2015-11-16 23:59:59")) %>%
#   mutate(day_created = day(CreatedDate))
# 
# request_subset$weekday_created = factor(request_subset$weekday_created,
#                                   levels = 
#                                     levels(request_subset$weekday_created)[c(2:7,1)])
# 
# request_subset$duration_hrs = round((request_subset$UpdatedDate - request_subset$CreatedDate)/3600, 
#                               digits = 2)

# There are a lot of 0s in duration. What does this mean? 
# updated right when request created
# should we exclude 0s 


# Duration summary - by Request Type   

duration_summary_plot <- function() {
    duration_summary = request_subset %>%
        filter(duration_hrs > 0) %>%
        group_by(RequestType) %>%
        summarise(mean = mean(duration_hrs), 
                  max = max(duration_hrs),
                  min = min(duration_hrs))
    ggplot(duration_summary, aes(x = reorder(RequestType, -mean), y = mean)) +
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
}


# Breakdown by Month   

by_month_plot <- function() {
    ggplot(request_subset, aes(x = factor(month_created))) +
        geom_bar(fill = "paleturquoise3") +
        ylab("Number of Requests") +
        xlab("Month of the year") +
        ggtitle("Total Requests by Month") +
        theme_classic() +
        theme(axis.text.x = element_text(size = 16),
              axis.text.y = element_text(size = 16),
              axis.title = element_text(size=16),
              title = element_text(size=16, face='bold'))
}
# Summer months have the most requests, 
# winter months have the least requests


# By Week 

by_weekday_plot <- function() {
    ggplot(request_subset, aes(x = weekday_created)) +
        geom_bar(fill = "paleturquoise3") +
        ylab("Number of Requests") +
        xlab("") +
        ggtitle("Total Requests by Weekday") +
        theme_classic() +
        theme(axis.text.x = element_text(size = 16),
              axis.text.y = element_text(size = 16),
              axis.title = element_text(size=16),
              title = element_text(size=16, face='bold'))
}

# Weekdays have far more requests than weekends -- 
#is this due to no service on weekends? 
# Do they have people answering calls on weekends


# By Day of the month

#ggplot(request_subset, aes(x = factor(day_created))) +
#  geom_bar(fill = "paleturquoise3") +
#  ylab("Number of Requests") +
#  xlab("Day of the month") +
#  ggtitle("Requests by Day") +
#  theme_classic()
# Days at the begining of the month have more requests 
# than days at the end of the month


# Heatmap: Weekday and Time of the day

weekday_hour_heatmap <- function() {
    request2 = request_subset %>%
        group_by(weekday_created, hour_created) %>%
        summarise(count = n())
    ggplot(request2, aes(x = weekday_created, 
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
}

# Most requests come in from 8am to 5pm, 
# whihc is probably working time of the government employees. 
# The rest might be self service/ self report
 
 
# # Request Source by time of the day   
# request3 = request_subset %>%
#   group_by(RequestSource, hour_created) %>%
#   summarise(count = n())
# 
# ggplot(request3, aes(x = RequestSource, 
#                           y = factor(hour_created), 
#                           fill = count)) +
#   geom_tile() +
#   scale_fill_gradient(low = "mistyrose", high = "deeppink3", 
#                       breaks = NULL, labels = NULL) +
#   theme_classic() +
#   ylab("Time of the Day") +
#   xlab("") +
#   ggtitle("Source of Request and Time of the day") +
#   theme(axis.text.x = element_text(angle = 30, hjust = 1))
# 
# 
# # Request Type by time of the day 
# 
# levels(request_subset$RequestType)
# 
# request4 = request_subset %>%
#   group_by(RequestType, hour_created) %>%
#   summarise(count = n())
# 
# ggplot(request4, aes(x = RequestType, 
#                      y = factor(hour_created), 
#                      fill = count)) +
#   geom_tile() +
#   scale_fill_gradient(low = "mistyrose", high = "deeppink3", 
#                       breaks = NULL, labels = NULL) +
#   theme_classic() +
#   ylab("Time of the Day") +
#   xlab("") +
#   ggtitle("Type of Request and Time of the day") +
#   theme(axis.text.x = element_text(angle = 30, hjust = 1))
# # Bulky Item, Graffiti Removal are most frequent 


# Request sources
source_count <- function() {
  source_data =request_subset%>%
    group_by(RequestSource)%>%
    summarise(count=n())%>%
    arrange(-count)
  
  ggplot(source_data,aes(x=reorder(RequestSource,-count),y=count))+
    geom_bar(stat="identity",fill = "paleturquoise3")+
    xlab("")+
    ylab("")+
    ggtitle("Request per source")+
    geom_text(aes(label = count), vjust = -1,size=2.5)+ 
    theme_classic()+
    theme(axis.text.x = element_text(angle = 30, hjust = 1))
}


# Source and type

source_type_count <- function() {
  request12=request_subset%>%
    group_by(RequestSource,RequestType)%>%
    summarise(Count=n())
  
  ggplot(request12,aes(x=RequestSource,y=RequestType,fill=Count))+
    geom_tile()+
    scale_fill_gradient(low = "mistyrose", high = "deeppink3") +
    theme_classic() +
    ylab("") +
    xlab("") +
    ggtitle("Requests by Source and Type") +
    theme(axis.text.x = element_text(angle = 30, hjust = 1))
}

# Request sources efficiency

source_eff <- function() {
  request13=request_subset%>%
    group_by(RequestSource)%>%
    summarise(mean=round(mean(duration_hrs),2))
  
  ggplot(request13,aes(x=reorder(RequestSource,-mean),y=mean))+
    geom_bar(stat="identity",fill = "paleturquoise3")+
    ggtitle("Request Efficiency by Request Source") +
    xlab("Reqeust Source")+
    ylab("Average Duration")+
    geom_text(aes(label = mean), vjust = -1,size=2.5)+
    theme_classic()+
    theme(axis.text.x = element_text(angle = 30, hjust = 1))
}

# Request Source by month   

source_month_heatmap <- function() {
    request5 = request_subset %>%
        group_by(RequestSource, month_created) %>%
        summarise(count = n())
    ggplot(request5, aes(x = RequestSource, 
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
}

# # Request Type by month   
# 
# request6 = request_subset %>%
#   group_by(RequestType, month_created) %>%
#   summarise(count = n())
# 
# ggplot(request6, aes(x = RequestType, 
#                      y = factor(month_created), 
#                      fill = count)) +
#   geom_tile() +
#   scale_fill_gradient(low = "mistyrose", high = "deeppink3", 
#                       breaks = NULL, labels = NULL) +
#   theme_classic() +
#   ylab("Month of the Year") +
#   xlab("") +
#   ggtitle("Type of Request and Month of the Year") +
#   theme(axis.text.x = element_text(angle = 30, hjust = 1))



# Request Source by weekday   

source_weekday_heatmap <- function() {
    request7 = request_subset %>%
        group_by(RequestSource, weekday_created) %>%
        summarise(count = n())
    
    ggplot(request7, aes(x = RequestSource, 
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
}


# Request Type by Month

type_month_heatmap <- function() {
    request6 = request_subset %>%
        group_by(RequestType, month_created) %>%
        summarise(count = n())
    
    ggplot(request6, aes(x = RequestType, 
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
}


# Request Type by Weekday   

type_weekday_heatmap <- function() {
    request8 = request_subset %>%
        group_by(RequestType, weekday_created) %>%
        summarise(count = n())
    
    ggplot(request8, aes(x = RequestType, 
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
}


# Calls

call_month_plot <- function() {
    request_call = request_subset %>%
        filter(RequestSource == "Call") %>%
        group_by(RequestSource, month_created)
    
    ggplot(request_call, aes(x = factor(month_created))) +
        geom_bar(fill = "paleturquoise3") +
        ylab("Number of Requests") +
        xlab("Month of the year") +
        ggtitle("Calls distribution by Month") +
        theme_classic() +
        theme(axis.text.x = element_text(size = 16),
              axis.text.y = element_text(size = 16),
              axis.title = element_text(size=16),
              title = element_text(size=16, face='bold'))
}

call_hour_plot <- function() {
    request_call = request_subset %>%
        filter(RequestSource == "Call") %>%
        group_by(RequestSource, month_created)
    
    ggplot(request_call, aes(x = factor(hour_created))) +
        geom_bar(fill = "paleturquoise3") +
        ylab("Number of Requests") +
        xlab("Hour of the day") +
        ggtitle("Calls distribution by hour of the day") +
        theme_classic() +
        theme(axis.text.x = element_text(size = 16),
              axis.text.y = element_text(size = 16),
              axis.title = element_text(size=16),
              title = element_text(size=16, face='bold'))
}

# # Calls by weekday
# ggplot(request_call, aes(x = weekday_created)) +
#   geom_bar(fill = "paleturquoise3") +
#   ylab("Number of Requests") +
#   xlab("") +
#   ggtitle("Calls distribution by weekday") +
#   theme_classic()
# 
# # Bulky Item & graffiti removal  
# request10 = request_subset %>%
#   filter(RequestType %in% c("Bulky Items", "Graffiti Removal")) 
# 
# # by month
# ggplot(request10, aes(x = factor(month_created), fill = RequestType)) +
#   geom_bar(position = position_dodge(), alpha = 0.6) +
#   ylab("Number of Requests") +
#   xlab("Month of the year") +
#   ggtitle("Request Type distribution by Month") +
#   theme_classic()
# 
# # by weekday
# ggplot(request10, aes(x = weekday_created, fill = RequestType)) +
#   geom_bar(position = position_dodge(), alpha = 0.6) +
#   ylab("Number of Requests") +
#   xlab("") +
#   ggtitle("Request Type distribution by weekday") +
#   theme_classic()
# 
# 
# 
# # Dead Animal removal by month
# request_subset1 = request_subset %>%
#   filter(RequestType == "Dead Animal Removal")
# 
# ggplot(request_subset1, aes(x = factor(month_created))) +
#   geom_bar(position = position_dodge(), fill = "lightblue") +
#   ylab("Number of Requests") +
#   xlab("Month of the year") +
#   ggtitle("Dead Animal Removal requests by Month") +
#   theme_classic()
# 
# ## Chun
# 
# request_subset2 = request_data%>%
#   group_by(RequestSource, RequestType)%>%
#   summarise(Count=n())
# 
# ggplot(request_subset2,aes(x=RequestSource, y=RequestType, fill=Count))+
#   geom_tile()+
#   scale_fill_gradient(low = "mistyrose", high = "deeppink3") +
#   theme_classic() +
#   ylab("") +
#   xlab("") +
#   ggtitle("Requests by Source and Type") +
#   theme(axis.text.x = element_text(angle = 30, hjust = 1))
