library(dplyr)

################## cd_top_requests #####################
cd_top_requests <- function(data, cd) {
    summary = data %>%
        filter(CD %in% cd) %>%
        group_by(RequestType) %>%
        summarise(count = n()) %>%
        arrange(-count) %>%
        top_n(3)
    colnames(summary) = c("Top Requests Type", "Requests counts")
    summary
}


################## cd_key_stats #####################
cd_key_stats <- function(data, cd) {
    stats = t(filter(data, `Council District` %in% cd))
    cd_names = stats[1,]
    stats = as.data.frame(stats[2:nrow(stats),])
    colnames(stats) = cd_names
    stats
}
