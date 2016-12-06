library(dplyr)
library(plotly)
library(wordcloud)

# load("all_data_for_shiny.RData")

################## cd_top_requests #####################
# cd_top_requests <- function(data, cd) {
#     summary = data %>%
#         filter(CD %in% cd) %>%
#         group_by(RequestType) %>%
#         summarise(count = n()) %>%
#         arrange(-count) %>%
#         top_n(3)
#     colnames(summary) = c("Top Requests Type", "Requests counts")
#     summary
# }


################## cd_key_stats #####################
cd_key_stats <- function(data, cd) {
    stats = t(filter(data, `Council District` %in% cd))
    cd_names = stats[1,]
    stats = as.data.frame(stats[2:nrow(stats),])
    colnames(stats) = cd_names
    stats
}


################## income_plots #####################
income_plot <- function(cd) {
    selected = as.data.frame(filter(CD_summary, 
                                    `Council District` %in% cd, 
                                    `Council District` != "city of LA"))
    ggplot(CD_summary[1:15,], aes(x = `Median Household Income($000s)`,
                           y = `Requests per 1000 Residents`)) +
        geom_point(aes(text = paste("Council District: ", `Council District`))) +
        geom_smooth(method = "lm") +
        ylim(0, 500) +
        geom_point(data = selected,
                   aes(x = `Median Household Income($000s)`,
                       y = `Requests per 1000 Residents`),
                   size = 5, color = "red") +
        ggtitle("Requests v.s. Income", 
                subtitle = "Correlation: -0.92") +
        theme(plot.title = element_text(hjust = 0.5)) 
}


################## employment_plots #####################
employment_plot <- function(cd) {
    selected = as.data.frame(filter(CD_summary, 
                                    `Council District` %in% cd, 
                                    `Council District` != "city of LA"))
    ggplot(CD_summary[1:15,], aes(x = `Unemployment Rate`,
                                  y = `Requests per 1000 Residents`)) +
        geom_point(aes(text = paste("Council District: ", `Council District`))) +
        geom_smooth(method = "lm") +
        ylim(0, 500) +
        geom_point(data = selected,
                   aes(x = `Unemployment Rate`,
                       y = `Requests per 1000 Residents`),
                  size = 5, color = "red") +
        ggtitle("Requests v.s. Unemployment Rate", 
                subtitle = "Correlation: 0.76") +
        theme(plot.title = element_text(hjust = 0.5)) 
}


################## type_summary_table #####################
type_summary_table <- function() {
    summary = mutate(type_summary, above = ifelse(overtime == TRUE, "below average", ""))
    summary = summary %>%
        select(RequestType, count, above) %>%
        arrange(-count)
    
    colnames(summary) = c("Request Type", "Requests Counts", "Update Efficiency")
    summary
}

################## request_social_plot #####################
request_social_plot <- function(req_type, social) {
    selected = zip_merged %>%
        filter(RequestType == req_type, Median_Household_Income > 0)
    
    if (social == "Median_Household_Income") {
        ggplot(selected, aes(x = log(Median_Household_Income), y = req_prop)) +
            geom_point() +
            geom_smooth(method = "lm") +
            ggtitle(paste(req_type, "Requests Proportion v.s. Median Household Income"),
                    subtitle = paste("correlation:", 
                                     round(cor(log(selected$Median_Household_Income), selected$req_prop),2)
                                     )) +
            xlab("Log Meidian Household Income") +
            ylab("Regional Request Proportion") +
            theme(plot.title = element_text(hjust = 0.5))
    } else {
        ggplot(selected, aes(x = Median_Age, y = req_prop)) +
            geom_point() +
            geom_smooth(method = "lm") +
            ggtitle(paste(req_type, "Requests Proportion v.s. Median Age"),
                    subtitle = paste("correlation:", 
                                     round(cor(selected$Median_Age, selected$req_prop),2)
                    )) +
            xlab("Median Age") +
            ylab("Regional Request Proportion") +
            theme(plot.title = element_text(hjust = 0.5))        
    }
}

# request_social_plot("Metal/Household Appliances", "Median_Age")
