library(class)

#load the dataset
dataset = read.csv("./breast-cancer.csv")
#attach(Smarket)



#preproces: normalize the attributes
normalize<-function(x){
  return ((x-min(x))/(max(x)-min(x)))
}
normalize(c(1,2,3,4,5))
str(dataset)
normalizedDataset = as.data.frame(lapply(dataset[,c(2:30)], normalize))
str(normalizedDataset)
summary(normalizedDataset)

preprocDataset = cbind(dataset[,1], normalizedDataset)

#10-folds-accross
set.seed(100)
train = sample(1:nrow(dataset),nrow(dataset)*9/10)
test = -train
traindataset = dataset[train,]
testdataset = dataset[test,]

#10-folds-accross
set.seed(2)
#train = sample(1:nrow(normalizedDataset),nrow(normalizedDataset)*9/10)
#test = -train
traindata = traindataset[,2:30]
testdata = testdataset[,2:30]
trainTarget = traindataset[, 1]
testTarget = testdataset[, 1]

#choose sqrt(569) as the k
sqrt(569)
result = knn(train = traindata, test = testdata, cl = trainTarget, k = 24)

table(testTarget, result)
mean(testTarget==result)
var(testTarget==result)
