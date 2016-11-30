library(dplyr)
library(ggplot2)
library(lubridate)
library(stringr)

load("processed1.RData")

request_data$CreatedDate = mdy_hms(request_data$CreatedDate)
request_data$UpdatedDate = mdy_hms(request_data$UpdatedDate)
# since there are lots of observations like xx/xx/xxxx 12:00:00AM which leads to unaccurate time records, remove the hour-minute_seconds part
request_data$ServiceDate = str_replace_all(request_data$ServiceDate, " [0-9]{2}:[0-9]{2}:[0-9]{2} [AP]M", "")
request_data$ServiceDate = mdy(request_data$ServiceDate)
# attention: there are many obviously unreasonable records: many records with service date of 1900/01/01, and some other service dates in 2017 or later
request_data$ClosedDate = mdy_hms(request_data$ClosedDate)


# extract the month, weekday and hour the request created, not updated
request_data$month_created = month(request_data$CreatedDate)
request_data$weekday_created = wday(request_data$CreatedDate, label = TRUE)
request_data$hour_created = hour(request_data$CreatedDate)

# create the response period in hours as the time from created date to closed date
request_data$response_period = round(
    (request_data$ClosedDate - request_data$CreatedDate) / (60 * 60),
    2)

# the percentage of requests without a ClosedDate: 0.546
nrow(filter(request_data, is.na(ClosedDate)))/ nrow(request_data)

