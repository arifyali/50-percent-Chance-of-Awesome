library(class)

#load the dataset
dataset = read.csv("./kNNData.csv")

normalize<-function(x){
  return ((x-min(x))/(max(x)-min(x)))
}

normalize(c(1,2,3,4,5))
str(dataset)
normalizedDataset = as.data.frame(lapply(dataset[,c(1:4,6:15)], normalize))
str(normalizedDataset)
summary(normalizedDataset)

preprocDataset = cbind(dataset[,1], normalizedDataset)

#10-folds-accross
train = sample(1:nrow(dataset),nrow(dataset)*9/10)
test = -train
traindataset = dataset[train,]
testdataset = dataset[test,]

#10-folds-accross
#train = sample(1:nrow(normalizedDataset),nrow(normalizedDataset)*9/10)
#test = -train
traindata = traindataset[,c(1:4,6:15)]
testdata = testdataset[,c(1:4,6:15)]
trainTarget = traindataset[, 5]
testTarget = testdataset[, 5]

#choose sqrt(569) as the k
sqrt(569)
result = knn(train = traindata, test = testdata, cl = trainTarget, k = 24)

table(testTarget, result)
mean(testTarget==result)
var(testTarget==result)
