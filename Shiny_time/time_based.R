#load("processed_requests2.RData")

library(ggplot2)
library(dplyr)
library(lubridate)
library(viridis)

request1 = request_data %>%
  select(-(ActionTaken), -(Owner), -(MobileOS), 
         -(Anonymous), -(AssignTo), -(AddressVerified), 
         -(ApproximateAddress), -(Address:Suffix), 
         -(Latitude:PolicePrecinct)) %>%
  filter(CreatedDate > ymd_hms("2015-11-16 23:59:59")) %>%
  mutate(day_created = day(CreatedDate))

request1$weekday_created = factor(request1$weekday_created,
                                  levels = 
                                    levels(request1$weekday_created)[c(2:7,1)])

request1$duration_hrs = round((request1$UpdatedDate - request1$CreatedDate)/3600, 
                              digits = 2)

# There are a lot of 0s in duration. What does this mean? 
# updated right when request created
# should we exclude 0s 


# Duration summary - by Request Type   

duration_summary = request1 %>%
  filter(duration_hrs > 0) %>%
  group_by(RequestType) %>%
  summarise(mean = mean(duration_hrs), 
            max = max(duration_hrs),
            min = min(duration_hrs))
# Duration have negative numbers 
# filtering out 0s leads to different ordering 
ggplot(duration_summary, aes(x = reorder(RequestType, -mean), y = mean)) +
  geom_bar(stat = "identity",
           fill = "paleturquoise3") +
  ylab("Avg. Processing Time") +
  xlab("Request Type") +
  ggtitle("Processing time of different request types") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))



# Breakdown by Month   

ggplot(request1, aes(x = factor(month_created))) +
  geom_bar(fill = "paleturquoise3") +
  ylab("Number of Requests") +
  xlab("Month of the year") +
  ggtitle("Requests by Month") +
  theme_classic()
# Summer months have the most requests, 
# winter months have the least requests


# By Week 

ggplot(request1, aes(x = weekday_created)) +
  geom_bar(fill = "paleturquoise3") +
  ylab("Number of Requests") +
  xlab("") +
  ggtitle("Requests by Week") +
  theme_classic()
# Weekdays have far more requests than weekends -- 
#is this due to no service on weekends? 
# Do they have people answering calls on weekends


# By Day of the month

#ggplot(request1, aes(x = factor(day_created))) +
#  geom_bar(fill = "paleturquoise3") +
#  ylab("Number of Requests") +
#  xlab("Day of the month") +
#  ggtitle("Requests by Day") +
#  theme_classic()
# Days at the begining of the month have more requests 
# than days at the end of the month


# Heatmap: Weekday and Time of the day

request2 = request1 %>%
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
  ggtitle("Requests by Weekday and Time of the day")
# Most requests come in from 8am to 5pm, 
# whihc is probably working time of the government employees. 
# The rest might be self service/ self report


# Request Source by time of the day   
request3 = request1 %>%
  group_by(RequestSource, hour_created) %>%
  summarise(count = n())

ggplot(request3, aes(x = RequestSource, 
                          y = factor(hour_created), 
                          fill = count)) +
  geom_tile() +
  scale_fill_gradient(low = "mistyrose", high = "deeppink3", 
                      breaks = NULL, labels = NULL) +
  theme_classic() +
  ylab("Time of the Day") +
  xlab("") +
  ggtitle("Source of Request and Time of the day") +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))


# Request Type by time of the day 

levels(request1$RequestType)

request4 = request1 %>%
  group_by(RequestType, hour_created) %>%
  summarise(count = n())

ggplot(request4, aes(x = RequestType, 
                     y = factor(hour_created), 
                     fill = count)) +
  geom_tile() +
  scale_fill_gradient(low = "mistyrose", high = "deeppink3", 
                      breaks = NULL, labels = NULL) +
  theme_classic() +
  ylab("Time of the Day") +
  xlab("") +
  ggtitle("Type of Request and Time of the day") +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))
# Bulky Item, Graffiti Removal are most frequent 



# Request Source by month   

request5 = request1 %>%
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
  theme(axis.text.x = element_text(angle = 30, hjust = 1))


# Request Type by month   

request6 = request1 %>%
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
  ggtitle("Type of Request and Month of the Year") +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))



# Request Source by weekday   

request7 = request1 %>%
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
  ggtitle("Source of Request and Weekday") +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))



# Request Type by Weekday   

request8 = request1 %>%
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
  ggtitle("Type of Request and Weekday") +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))



# Calls

request9 = request1 %>%
  filter(RequestSource == "Call") %>%
  group_by(RequestSource, month_created)

# Calls by month
ggplot(request9, aes(x = factor(month_created))) +
  geom_bar(fill = "paleturquoise3") +
  ylab("Number of Requests") +
  xlab("Month of the year") +
  ggtitle("Calls distribution by Month") +
  theme_classic()

# Calls by weekday
ggplot(request9, aes(x = weekday_created)) +
  geom_bar(fill = "paleturquoise3") +
  ylab("Number of Requests") +
  xlab("") +
  ggtitle("Calls distribution by weekday") +
  theme_classic()

# Calls by hour
ggplot(request9, aes(x = factor(hour_created))) +
  geom_bar(fill = "paleturquoise3") +
  ylab("Number of Requests") +
  xlab("Hour of the day") +
  ggtitle("Calls distribution by hour of the day") +
  theme_classic()


# Bulky Item & graffiti removal  
request10 = request1 %>%
  filter(RequestType %in% c("Bulky Items", "Graffiti Removal")) 

# by month
ggplot(request10, aes(x = factor(month_created), fill = RequestType)) +
  geom_bar(position = position_dodge(), alpha = 0.6) +
  ylab("Number of Requests") +
  xlab("Month of the year") +
  ggtitle("Request Type distribution by Month") +
  theme_classic()

# by weekday
ggplot(request10, aes(x = weekday_created, fill = RequestType)) +
  geom_bar(position = position_dodge(), alpha = 0.6) +
  ylab("Number of Requests") +
  xlab("") +
  ggtitle("Request Type distribution by weekday") +
  theme_classic()



# Dead Animal removal by month
request11 = request1 %>%
  filter(RequestType == "Dead Animal Removal")

ggplot(request11, aes(x = factor(month_created))) +
  geom_bar(position = position_dodge(), fill = "lightblue") +
  ylab("Number of Requests") +
  xlab("Month of the year") +
  ggtitle("Dead Animal Removal requests by Month") +
  theme_classic()

## Chun

request12 = request_data%>%
  group_by(RequestSource, RequestType)%>%
  summarise(Count=n())

ggplot(request12,aes(x=RequestSource, y=RequestType, fill=Count))+
  geom_tile()+
  scale_fill_gradient(low = "mistyrose", high = "deeppink3") +
  theme_classic() +
  ylab("") +
  xlab("") +
  ggtitle("Requests by Source and Type") +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))
