library(dbscan)
setwd("Documents/Analytics 501 Fall 2015/50-percent-Chance-of-Awesome/part2_exploratory_analysis/")
dataset = read.csv("PoldataSPIndustriesStockData.csv")
dataset = dataset[, mapply(is.numeric, dataset)]
dataset = dataset[complete.cases(dataset),]
dataset = dataset[sample(nrow(dataset), 5000), c("INDUSTRYPERCENT", "PERCENT", "YrPercentChange", "WINNER", "INCUMBENT")]

db = dbscan(dataset, eps=.4, minPts=5)
db
summary(db)
png("Clustering/db scan cluster.png")
plot(dataset, col=db$cluster+1L)
dev.off()