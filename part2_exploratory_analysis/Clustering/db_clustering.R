library(dbscan)
dataset = read.csv("PoldataSPIndustriesStockData.csv")
dataset = dataset[, mapply(is.numeric, dataset)]
dataset = dataset[complete.cases(dataset),]
dataset = dataset[sample(nrow(dataset), 5000), c("INDUSTRYPERCENT", "PERCENT", "YrPercentChange")]

db = dbscan(dataset, eps=.4, minPts=5)
db
summary(db)
plot(dataset, col=db$cluster+1L)

