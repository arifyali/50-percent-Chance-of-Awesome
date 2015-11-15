# For K-means, I decided not to look at the stock data 
# I also decided not to cluster based on any of the percentages
setwd("~/Documents/Analytics 501 Fall 2015/50-percent-Chance-of-Awesome/part2_exploratory_analysis/")
political_data= read.csv("PSPI no outliers.csv")
political_data = political_data[order(political_data$INDRANK, decreasing = T),]

# Focusing on the no outlier dataset first

### K-means ###
numeric_political_data = political_data[!duplicated(political_data[, c("DISTRICT", "CANDIDATE", "YEAR")]), ]

numeric_political_data = numeric_political_data[complete.cases(numeric_political_data),c("CANDTOTAL", "VOTES", "INDRANK")]


#### Check difference in winner/loser and incumbent/challenger


library(cluster)
political_centers = kmeans(numeric_political_data, 2)

political_data_with_clusters = cbind(numeric_political_data, cluster = political_centers$cluster)

png("Clustering/kmeans political centers or incumbents vs challengers.png")
clusplot(political_data_with_clusters, political_data_with_clusters$cluster, 
         color = T, shade = T, labels = 2, lines = 0)
dev.off()

# I picked a center of four by thinking of all combinations 
political_centers = kmeans(numeric_political_data, 4)

political_data_with_clusters = cbind(numeric_political_data, cluster = political_centers$cluster)

png("Clustering/kmeans political centers with incumbents vs challengers and winners vs losers.png")
clusplot(political_data_with_clusters, political_data_with_clusters$cluster, 
         color = T, shade = T, labels = 2, lines = 0)
dev.off()