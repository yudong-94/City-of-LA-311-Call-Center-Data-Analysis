library(plotly)
library(choroplethrZip)

# load("/Users/hzdy1994/Desktop/DSO545/Final project/data_for_shiny.RData")

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


zip_plot_customized = function(data, type) {
    if (type == "") {
        requests_zip_filtered = data %>%
            group_by(ZipCode) %>%
            filter(!ZipCode %in% c("0", "", "9008")) %>%
            summarise(value = n())
    } else {
        requests_zip_filtered = data %>%
            filter(RequestType == type) %>%
            group_by(ZipCode) %>%
            filter(!ZipCode %in% c("0", "", "9008")) %>%
            summarise(value = n())
    }

    colnames(requests_zip_filtered) = c("region", "value") 
    zip_vec = unique(requests_zip_filtered$region)
    
    zip_choropleth(requests_zip_filtered, 
                   zip_zoom = zip_vec, 
                   title="Requests number by zipcode",
                   legend="Requests numbers")
}


