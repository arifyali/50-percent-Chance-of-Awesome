#code citation: https://cran.r-project.org/web/packages/e1071/e1071.pdf
#code citation: https://cran.r-project.org/web/packages/pROC/pROC.pdf

library(e1071)

#load the dataset
dataset = read.csv("PoldataSPIndustriesStockData no outliers.csv")
dataset = dataset[order(dataset$INDRANK, decreasing = T),]
dataset = dataset[!duplicated(dataset[,c("YEAR", "STATE", "DISTRICT", "CANDIDATE")]),]


#bin the data
dataset$WINNER = as.factor(dataset$WINNER)

# x = dataset[, "CANDTOTAL"]
# candTotalLevel = cut(x, b=10, labels = c(1:10))
# dataset = cbind(dataset, candTotalLevel)
# 
# x = dataset[, "INDRANK"]
# INDLevel = cut(x, b=12, labels = c(1:12))
# dataset = cbind(dataset, INDLevel)


dataset = dataset[, c("WINNER", "CANDTOTAL", "INDRANK", "INCUMBENT")]

#dataset = dataset[,c(1,3:15)]
#10-folds-accross
k = 5
for(i in 1:k){
  train = sample(1:nrow(dataset),nrow(dataset)*(k-1)/k)
  test = -train
  traindata = dataset[train,]
  testdata = dataset[test,]
  
  #traindata$WINNER is the label. 
  nb = naiveBayes(traindata$WINNER~., data=traindata)
  
  #use naive bayes to do prediction
  pred = predict(nb, testdata[,-1], type = c("class"))
  
  #show the result
  print("confusion matrix",quote = FALSE)
  confmatrix = table(pred, testdata$WINNER)
  print(confmatrix)
  
  library(pROC)
  testTarget = as.numeric(testdata$WINNER)
  result = as.numeric(pred)
  myROC = roc(testTarget,result, 
              print.auc=TRUE,
              main="Confidence intervals", percent=TRUE,
              ci=TRUE,  auc.polygon=TRUE, grid=TRUE, plot=FALSE)
  jpeg(paste0("hypothesis_testing/data_driving_predictive_models/Naive Bayes ROC validation ", i, ".jpeg", sep=""))
  plot(myROC)
  
  #the performance
  precision = confmatrix[2,2]/sum(confmatrix[2,2],confmatrix[1,2])
  Recall = confmatrix[2,2]/sum(confmatrix[2,2],confmatrix[2,1])
  print(paste0("accuracy: ", mean(pred==testdata$WINNER)),quote = FALSE)
  print(paste0("precision: ", precision),quote = FALSE)
  print(paste0("Recall: ", Recall),quote = FALSE)
  print(paste0("F-measure: ", 2*precision*Recall/(precision+Recall)),quote = FALSE)
}
