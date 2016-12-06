library(dplyr)
library(plotly)
library(wordcloud)
library(lubridate)

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
    
    colnames(summary) = c("Request Type", "Requests counts", "Update efficiency")
    summary
}

################## request_social_plot #####################
request_social_plot <- function(req_type) {
    selected = zip_merged %>%
        filter(RequestType == req_type)
    
    ggplot(selected, aes(x = log(`Median.Income`),
                         y = req_prop)) +
        geom_point() +
        geom_smooth(method = "lm") +
        ggtitle(paste(req_type, "Requests Proportion v.s. Median Income"),
                subtitle = paste("correlation:", 
                                 round(cor(log(selected$`Median.Income`), selected$req_prop),2)
                                 )) +
        ylab("Regional Request Proportion") +
        theme(plot.title = element_text(hjust = 0.5))
}


## efficiency analysis
### compare department efficiency and request source - dep_source

dep_eff<- request_data %>%
    mutate(update_time = UpdatedDate - CreatedDate) %>%
    group_by(Owner, RequestSource) %>%
    summarise(avg_update = mean(update_time)) %>%
    filter(!avg_update == 0)

dep_eff$avg_update = as.numeric(dep_eff$avg_update)
dep_eff$avg_update = dep_eff$avg_update/6400
round(dep_eff$avg_update,2)

ggplot(dep_eff, aes(x = Owner, y = RequestSource, fill = avg_update)) +
    geom_tile() +
    scale_fill_gradient(low = "white", high = "darkred") +
    ggtitle("Service response time across department and request source") +
    xlab("Department assigned") +
    ylab("Source of Request") +
    theme(axis.text.x = element_text(angle = 30, hjust = 1)) +
    guides(fill=guide_legend(title="Average response(hours)"))



### type resolution efficiency divided by department - dep_type

type_eff <- request_data %>%
    mutate(update_time = UpdatedDate - CreatedDate) %>%
    group_by(Owner,RequestType) %>%
    summarise(avg_update = mean(update_time)) %>%
    filter(!avg_update == 0)

type_eff$avg_update = as.numeric(type_eff$avg_update)
type_eff$avg_update = type_eff$avg_update/6400
round(type_eff$avg_update,2)

ggplot(type_eff, aes(x = RequestType, y = avg_update,color = Owner)) +
    geom_point(size = 5) +
    theme(axis.text.x = element_text(angle = 30, hjust = 1)) +
    ggtitle("Service response time across department and request type") +
    xlab("Service Request Type") +
    ylab("Average response(hours)") +
    theme(axis.text.x = element_text(angle = 30, hjust = 1)) +
    guides(fill=guide_legend(title="Department")) 

### department efficiency in different cd - dep_cd

cd_eff <- request_data %>%
    mutate(update_time = UpdatedDate - CreatedDate) %>%
    group_by(Owner,CD) %>%
    summarise(avg_update = mean(update_time)) %>%
    filter(!avg_update == 0) %>%
    filter(!is.na(CD))

cd_eff$avg_update = as.numeric(cd_eff$avg_update)
cd_eff$avg_update = cd_eff$avg_update/6400
round(cd_eff$avg_update,2)

ggplot(cd_eff, aes(x = factor(CD), y = avg_update,color = Owner)) +
    geom_point(size = 5) +
    ggtitle("Resolution Efficiency Across Council Districts and Department") +
    xlab("Council Districts") +
    ylab("Average updated time(hours)") +
    guides(fill = guide_legend(title = "Department"))