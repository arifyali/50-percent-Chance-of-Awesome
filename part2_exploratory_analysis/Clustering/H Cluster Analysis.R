#### Cluster Analysis
setwd("~/Documents/Analytics 501 Fall 2015/50-percent-Chance-of-Awesome/part2_exploratory_analysis/")
political_data= read.csv("OpenSecrets/FundingCongress_cleaned.csv")
### May change  what political data is later


political_data = political_data[political_data$Party!="I",]
political_data$Party = as.character(political_data$Party)

# If party is numerical post merge then eliminate this
political_data$Party[political_data$Party=="R"] = 1
political_data$Party[political_data$Party=="D"] = 0

political_data$Party = as.numeric(political_data$Party)
numeric_characters = (mapply(is.numeric, political_data))

numeric_political_data = political_data[sample(nrow(political_data), 10000), numeric_characters]
numeric_political_data = numeric_political_data[complete.cases(numeric_political_data),]
                      
Political_hclustering = hclust(dist(numeric_political_data))


png("Clustering/hcluster.png", width = 755, height = 1200)
plot(Political_hclustering)
dev.off()