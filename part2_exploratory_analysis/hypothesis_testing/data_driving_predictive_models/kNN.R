#code citation: https://www.youtube.com/watch?v=GtgJEVxl7DY
#code citation: https://www.youtube.com/watch?v=DkLNb0CXw84
#code citation: https://cran.r-project.org/web/packages/class/class.pdf
library(class)

#load the dataset
dataset = read.csv("PoldataSPIndustriesStockData no outliers.csv")
dataset = dataset[order(dataset$INDRANK, decreasing = T),]
dataset = dataset[!duplicated(dataset[,c("YEAR", "STATE", "DISTRICT", "CANDIDATE")]),]

dataset = dataset[, mapply(is.numeric, dataset)]

dataset = dataset[, -c(2,3, 12,13,14,15,10,9,7)]

#10-folds-accross
#for(k in 1:20){
for(i in 1:3){
train = sample(1:nrow(dataset),nrow(dataset)*2/3)
test = -train
traindataset = dataset[train,]
testdataset = dataset[test,]



trainTarget = traindataset[, 5]
testTarget = testdataset[, 5]

# Determined k should be 17 after benchmarking K values between 1 and 20
pred = knn(train = traindataset[,-5], test = testdataset[,-5], cl = trainTarget, k = 17)

confmatrix = table(pred, testTarget)
print("confusion matrix",quote = FALSE)
print(confmatrix)

library(pROC)
testTarget = as.numeric(testTarget)
result = as.numeric(result)-1
myROC = roc(testTarget,result, direction="<", auc=TRUE, ci=TRUE)
jpeg(paste0("hypothesis_testing/data_driving_predictive_models/KNN ROC validation ", i, ".jpeg", sep=""))
plot(myROC)
dev.off()
precision = confmatrix[2,2]/sum(confmatrix[2,2],confmatrix[1,2])
Recall = confmatrix[2,2]/sum(confmatrix[2,2],confmatrix[2,1])
print(paste0("accuracy: ", mean(pred==testdata$WINNER)),quote = FALSE)
print(paste0("precision: ", precision),quote = FALSE)
print(paste0("Recall: ", Recall),quote = FALSE)
print(paste0("F-measure: ", 2*precision*Recall/(precision+Recall)),quote = FALSE)

}
