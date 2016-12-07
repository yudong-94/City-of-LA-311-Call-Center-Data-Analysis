#### This script is used to plot the two auxiliary bar charts

## Barchart 1
top10_cd_barchart = function(request_types, metric){
  cd_top10 = request_duration %>%
    filter(RequestType %in% request_types) %>%
    group_by(CD) %>%
    summarise(count = n(), duration = sum(Duration)/n())
  
  cd_top10 = cd_top10[order(cd_top10[[metric]],decreasing=T),][1:10,]
  cd_top10$CD = as.factor(cd_top10$CD)
  
  ggplot(data = cd_top10, aes(x=reorder(CD,-eval(parse(text=metric))), y=eval(parse(text=metric)), fill='darkred')) +
    geom_bar(stat='identity') +
    # geom_hline(aes(yintercept = mean(eval(parse(text=metric))))) +
    guides(fill=F) +
    xlab('Top 10 Council District') +
    ylab(metric) +
    theme_bw() + 
    theme(panel.border = element_blank(), panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
}

## Barchart 2
top10_nc_barchart = function(request_types, metric){
  nc_top10 = request_duration %>%
    filter(RequestType %in% request_types & !is.na(NC)) %>%
    group_by(NC) %>%
    summarise(count = n(), duration = sum(Duration)/n())
  nc_top10 = nc_top10[order(nc_top10[[metric]],decreasing=T),][1:10,]
  nc_top10$NC = as.factor(nc_top10$NC)
  
  ggplot(data = nc_top10, aes(x=reorder(NC,-eval(parse(text=metric))), y=eval(parse(text=metric)), fill='darkred')) +
    geom_bar(stat='identity') +
    # geom_hline(aes(yintercept = mean(eval(parse(text=metric))))) +
    guides(fill=F) +
    xlab('Top 10 Neighborhood Council Code') +    
    ylab(metric) +
    theme_bw() + 
    theme(panel.border = element_blank(), panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
}
