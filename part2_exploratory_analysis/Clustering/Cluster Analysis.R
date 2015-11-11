#### Cluster Analysis
setwd("~/Documents/Analytics 501 Fall 2015/50-percent-Chance-of-Awesome/part2_exploratory_analysis/")
political_data= read.csv("OpenSecretsFECmerged.csv")
### May change  what political data is later


#political_data = political_data[political_data$Party!="I",]
political_data$PARTY = as.character(political_data$PARTY)

political_data$PARTY[political_data$PARTY=="R"] = -1
political_data$PARTY[political_data$PARTY=="D"] = 1
political_data$PARTY[political_data$PARTY=="I"] = 0
political_data$PARTY = as.numeric(political_data$PARTY)
numeric_characters = (mapply(is.numeric, political_data))

numeric_political_data = political_data[, numeric_characters]
numeric_political_data = numeric_political_data[complete.cases(numeric_political_data),]
numeric_political_data_subset = numeric_political_data[sample(nrow(numeric_political_data), 10000),]                    
### Hierarchical clustering ###

Political_hclustering = hclust(dist(numeric_political_data_subset))

png("Clustering/hcluster.png", width = 755, height = 1200)
plot(Political_hclustering)
dev.off()

### K-means ###

# Number of Political Centers. I'm confident that 3 is the best number because only three political
# categories to worry about.
library(cluster)
political_centers = kmeans(numeric_political_data, 3)

political_data_with_clusters = cbind(numeric_political_data, cluster = political_centers$cluster)

png("Clustering/kmeans political centers.png")
clusplot(political_data_with_clusters, political_data_with_clusters$cluster, 
         color = T, shade = T, labels = 2, lines = 0)
dev.off()



Industrial_centers = kmeans(numeric_political_data, length(unique(political_data$INDUSTRY)))

Industrial_data_with_clusters = cbind(numeric_political_data, cluster = Industrial_centers$cluster)

png(paste("Clustering/kmeans", length(unique(political_data$INDUSTRY)), "Industry centers.png"))
clusplot(Industrial_data_with_clusters, Industrial_data_with_clusters$cluster, 
         color = T, shade = T, labels = 2, lines = 0)
dev.off()
