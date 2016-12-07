library(ggplot2)
library(dplyr)
library(lubridate)
load("processed_requests2.RData")
request_data$duration_hrs = round((request_data$UpdatedDate - request_data$CreatedDate)/3600, 
                                  digits = 2)
source=request_data%>%
  group_by(RequestSource)%>%
  summarise(count=n())%>%
  arrange(-count)

ggplot(source,aes(x=reorder(RequestSource,-count),y=count))+geom_bar(stat="identity",fill = "paleturquoise3")+
  theme(axis.text.x = element_text(angle = 30, hjust = 1))+
  xlab("")+
  ylab("")+
  ggtitle("Request per source")+
  geom_text(aes(label = count), vjust = -1,size=2.5)

request12=request_data%>%
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

request13=request_data%>%
  group_by(RequestSource)%>%
  summarise(mean=round(mean(duration_hrs),2))
ggplot(request13,aes(x=reorder(RequestSource,-mean),y=mean))+
  geom_bar(stat="identity",fill = "paleturquoise3")+
  ggtitle("Request Efficiency by Request Source") +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))+
  xlab("Reqeust Source")+
  ylab("Average Duration")+
  geom_text(aes(label = mean), vjust = -1,size=2.5)