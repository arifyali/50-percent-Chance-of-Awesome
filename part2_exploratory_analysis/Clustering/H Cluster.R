## Heiarchical Cluster ##
# I'm going to compare outliers vs non-outliers in H Cluster
# For H-clusters, I decided not to look at the stock data 
# I also decided not to cluster based on any of the percentages
setwd("~/Documents/Analytics 501 Fall 2015/50-percent-Chance-of-Awesome/part2_exploratory_analysis/")
political_data= read.csv("PSPI no outliers.csv")
political_data_with_outliers = read.csv("PoldataSPIndustries.csv")

political_data = political_data[order(political_data$INDRANK, decreasing = T), ]

### Hierarchical clustering ###
for(i in c(2004, 2006, 2008, 2010, 2012, 2014)){
  
  numeric_political_data = political_data[!duplicated(political_data[,c("CANDIDATE", "PARTY")]) & political_data$YEAR==i, 
                                          c("CANDIDATE","CANDTOTAL", "VOTES","INDRANK")]
  numeric_political_data = numeric_political_data[complete.cases(numeric_political_data),]
  print(nrow(numeric_political_data))
  #numeric_political_data = political_data[, numeric_characters]
  numeric_political_data = numeric_political_data[complete.cases(numeric_political_data),]
  numeric_political_data = numeric_political_data[sample(nrow(numeric_political_data), 50), ]


  Political_hclustering = hclust(dist(numeric_political_data))
  
  numeric_political_data_outlier = political_data_with_outliers[!duplicated(political_data_with_outliers[,c("CANDIDATE", "PARTY")]) 
                                                                & political_data_with_outliers$YEAR==i, 
                                          c("CANDIDATE","CANDTOTAL", "VOTES","indrank")]
  numeric_political_data_outlier = numeric_political_data_outlier[complete.cases(numeric_political_data_outlier),]
  print(nrow(numeric_political_data_outlier))
  #numeric_political_data = political_data[, numeric_characters]
  numeric_political_data_outlier = numeric_political_data_outlier[complete.cases(numeric_political_data_outlier),]
  numeric_political_data_outlier = numeric_political_data_outlier[sample(nrow(numeric_political_data_outlier), 50), ]
  
  numeric_political_data_outlier_cluster = hclust(dist(numeric_political_data_outlier))

  png(paste("Clustering/hcluster_", i, ".png", sep = ""), width = 902, height = 700)
  par(mfrow=c(1,2))
  plot(Political_hclustering, labels = numeric_political_data$CANDIDATE, main = "No Outliers", cex = 0.5)
  plot(numeric_political_data_outlier_cluster, labels = numeric_political_data_outlier$CANDIDATE, main = "With Outliers", cex = 0.5)
  dev.off()
}


