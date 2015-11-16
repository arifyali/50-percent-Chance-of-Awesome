#code citation: https://www.youtube.com/watch?v=GtgJEVxl7DY
#code citation: https://www.youtube.com/watch?v=DkLNb0CXw84
#code citation: https://cran.r-project.org/web/packages/class/class.pdf
library(class)

#load the dataset
dataset = read.csv("hypothesis_testing/data_driving_predictive_models/kNNData.csv")

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
library(pROC)
testTarget = as.numeric(testTarget)
result = as.numeric(result)
myROC = roc(testTarget,result, direction="<", auc=TRUE, ci=TRUE)
plot(myROC)

mean(testTarget==result)
var(testTarget==result)
