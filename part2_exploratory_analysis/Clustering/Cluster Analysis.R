#### Cluster Analysis
setwd("~/Documents/Analytics 501 Fall 2015/50-percent-Chance-of-Awesome/part2_exploratory_analysis/")
political_data= read.csv("PoldataSPIndustries.csv")
### May change  what political data is later

political_data = political_data[order(political_data$indrank, decreasing = T), ]

### Hierarchical clustering ###
for(i in c(2004, 2006, 2008, 2010, 2012, 2014)){
  
  numeric_political_data = political_data[!duplicated(political_data[,c("CANDIDATE", "PARTY")]) & political_data$YEAR==i, 
                                          c("CANDIDATE","CANDTOTAL", "VOTES","indrank")]
  numeric_political_data = numeric_political_data[complete.cases(numeric_political_data),]
  print(nrow(numeric_political_data))
  #numeric_political_data = political_data[, numeric_characters]
  numeric_political_data = numeric_political_data[complete.cases(numeric_political_data),]
  numeric_political_data = numeric_political_data[sample(nrow(numeric_political_data), 50), ]


  Political_hclustering = hclust(dist(numeric_political_data))

  png(paste("Clustering/hcluster_", i, ".png", sep = ""), width = 755, height = 1200)
  plot(Political_hclustering, labels = numeric_political_data$CANDIDATE)
  dev.off()
}

### K-means ###
numeric_variables = (mapply(is.numeric, political_data))
numeric_political_data = political_data[!duplicated(political_data[, c("DISTRICT", "CANDIDATE", "YEAR")]), numeric_variables]

numeric_political_data = numeric_political_data[complete.cases(numeric_political_data),c("CANDTOTAL", "VOTES", "indrank")]


#### Check difference in winner/loser and incumbent/challenger


library(cluster)
political_centers = kmeans(numeric_political_data, 2)

political_data_with_clusters = cbind(numeric_political_data, cluster = political_centers$cluster)

png("Clustering/kmeans political centers or incumbents vs challengers.png")
clusplot(political_data_with_clusters, political_data_with_clusters$cluster, 
         color = T, shade = T, labels = 2, lines = 0)
dev.off()


political_centers = kmeans(numeric_political_data, 4)

political_data_with_clusters = cbind(numeric_political_data, cluster = political_centers$cluster)

png("Clustering/kmeans political centers with incumbents vs challengers.png")
clusplot(political_data_with_clusters, political_data_with_clusters$cluster, 
         color = T, shade = T, labels = 2, lines = 0)
dev.off()
