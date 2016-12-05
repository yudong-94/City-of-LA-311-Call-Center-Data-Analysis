library(dplyr)
library(plotly)
library(wordcloud)

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

