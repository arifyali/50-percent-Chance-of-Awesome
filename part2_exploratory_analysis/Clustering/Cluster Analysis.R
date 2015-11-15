#### Cluster Analysis
setwd("~/Documents/Analytics 501 Fall 2015/50-percent-Chance-of-Awesome/part2_exploratory_analysis/")
political_data= read.csv("PoldataSPIndustries.csv")
### May change  what political data is later


#political_data = political_data[political_data$Party!="I",]
political_data$PARTY = as.character(political_data$PARTY)



### Hierarchical clustering ###
for(i in c(2004, 2006, 2008, 2010, 2012, 2014)){
  
  numeric_political_data = political_data[!duplicated(political_data[,c("CANDIDATE", "PARTY")]), 
                                          c("CANDIDATE","CANDTOTAL", "CANDTOTAL", "INCUMBENT", 
                                            "WINNER", "VOTES", "YEAR")]
  numeric_political_data = numeric_political_data[complete.cases(numeric_political_data),]
  
  #numeric_political_data = political_data[, numeric_characters]
  numeric_political_data = numeric_political_data[complete.cases(numeric_political_data),]  
  numeric_political_data_subset = numeric_political_data[numeric_political_data$YEAR==i,]  

  numeric_political_data_subset = numeric_political_data_subset[,]

  Political_hclustering = hclust(dist(numeric_political_data_subset))

  png(paste("Clustering/hcluster_", i, ".png", sep = ""), width = 755, height = 1200)
  plot(Political_hclustering, labels = numeric_political_data_subset$CANDIDATE)
  dev.off()
}

### K-means ###
numeric_variables = (mapply(is.numeric, political_data))
numeric_political_data = political_data[, numeric_variables]

#### Outlier 
remove_outliers <- function(x) {
  qnt <- quantile(x, probs=c(.25, .75), na.rm = T)
  H <- 1.5 * IQR(x, na.rm = T)
  y <- x
  y[x < (qnt[1] - H)] <- NA
  y[x > (qnt[2] + H)] <- NA
  return(y)
}

for(i in 1:ncol(numeric_political_data)){
  numeric_political_data[, i] = remove_outliers(numeric_political_data[, i])
}




numeric_political_data = numeric_political_data[complete.cases(numeric_political_data),-c(1,2,3,12,15)]



# Number of Political Centers. I'm confident that 3 is the best number because only three political
# categories to worry about.

#### Check difference in winner/loser and incumbent/challenger


library(cluster)
political_centers = kmeans(numeric_political_data, 3)

political_data_with_clusters = cbind(numeric_political_data, cluster = political_centers$cluster)

png("Clustering/kmeans political centers.png")
clusplot(political_data_with_clusters, political_data_with_clusters$cluster, 
         color = T, shade = T, labels = 2, lines = 0)
dev.off()


political_centers = kmeans(numeric_political_data, 2)

political_data_with_clusters = cbind(numeric_political_data, cluster = political_centers$cluster)

png("Clustering/kmeans political centers without Independents.png")
clusplot(political_data_with_clusters, political_data_with_clusters$cluster, 
         color = T, shade = T, labels = 2, lines = 0)
dev.off()


Industrial_centers = kmeans(numeric_political_data, length(unique(political_data$INDUSTRY)))

Industrial_data_with_clusters = cbind(numeric_political_data, cluster = Industrial_centers$cluster)

png(paste("Clustering/kmeans", length(unique(political_data$INDUSTRY)), "Industry centers.png"))
clusplot(Industrial_data_with_clusters, Industrial_data_with_clusters$cluster, 
         color = T, shade = T, labels = 2, lines = 0)
dev.off()
