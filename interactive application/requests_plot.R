library(choroplethrZip)
library(dplyr)
library(ggmap)

 load("all_data_for_shiny.RData")

# # using spark  (cmd+shift+c to uncomment the whole paragraph)
# 
# library(sparklyr)
# library(dplyr)
# 
# sc <- spark_connect(master = "local")
# 
# requests_data = copy_to(dest = sc, df = sampled_data, name = "requests", overwrite = TRUE)
# 
# zip_plot_customized_spark = function(data, type) {
#     requests_zip_filtered = data %>%
#         filter(RequestType == type) %>%
#         group_by(ZipCode) %>%
#         filter(!ZipCode %in% c("0", "", "9008")) %>%
#         summarise(value = n())
#     
#     mydata <- requests_zip_filtered %>%
#         collect
#     
#     colnames(mydata) = c("region", "value") 
#     zip_vec = unique(mydata$region)
#     
#     zip_choropleth(mydata, 
#                    zip_zoom = zip_vec, 
#                    title="Requests number by zipcode",
#                    legend="Requests numbers")
# }
# 
# # zip_plot_customized_spark(requests_data, "Bulky Items")


zip_plot_customized = function(data, type, time_start, time_end) {
    requests_zip_filtered = data %>%
        filter(RequestType %in% type,
               time_start < CreatedDate, 
               time_end > CreatedDate) %>%
        group_by(ZipCode) %>%
        filter(!ZipCode %in% c("0", "", "9008")) %>%
        summarise(value = n())

    colnames(requests_zip_filtered) = c("region", "value") 
    zip_vec = unique(requests_zip_filtered$region)
    
    zip_choropleth(requests_zip_filtered, 
                   zip_zoom = zip_vec, 
                   title="Requests number by zipcode",
                   legend="Requests numbers") +
        scale_fill_brewer(name="Requests", palette="OrRd", drop=FALSE)
}

# zip_plot_customized(request_data, "Bulky Items", "2015-12-01", "2016-03-01")

top_zip_list <- function(data, type, time_start, time_end) {
    requests_zip_filtered = data %>%
        filter(RequestType %in% type,
               time_start < CreatedDate, 
               time_end > CreatedDate) %>%
        group_by(ZipCode) %>%
        filter(!ZipCode %in% c("0", "", "9008")) %>%
        summarise(requests = n()) %>%
        arrange(-requests)
    
    colnames(requests_zip_filtered) = c("Zip Code", "Number of Requests") 
    
    return(as.data.frame(requests_zip_filtered))
}

# top_zip_list(request_data, "Bulky Items", "2015-12-01", "2016-03-01")

# # a inaccurate way to get the zip from Lon and Lat
# location_to_zip <- function(Lon, Lat) {
#     if (is.numeric(Lon)) {
#         res = revgeocode(as.numeric(c(Lon, Lat)), output = "more")
#         res$postal_code
#     }
# }
