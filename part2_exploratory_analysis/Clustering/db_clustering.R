library(dbscan)
dataset = read.csv("./breast-cancer.csv")
dataset = dataset[2:15]
eps = 0.5
MinPts = 5
db = dbscan(dataset, eps=.4, minPts=3)
db
summary(db)
plot(dataset, col=db$cluster+1L)
