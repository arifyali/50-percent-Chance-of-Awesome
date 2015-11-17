#code citation: https://www.youtube.com/watch?v=GOJN9SKl_OE
#code citation: https://cran.r-project.org/web/packages/ISLR/ISLR.pdf

library(ISLR)
library(tree)
#load the dataset
dataset = read.csv("PoldataSPIndustriesStockData no outliers.csv")
dataset = dataset[order(dataset$INDRANK, decreasing = T),]
dataset = dataset[!duplicated(dataset[,c("YEAR", "STATE", "DISTRICT", "CANDIDATE")]),]
dataset$WINNER = as.factor(dataset$WINNER)
for(k in 1:3){
  train = sample(1:nrow(dataset),nrow(dataset)*2/3)
  test = -train
  traindata = dataset[train,]
  testdata = dataset[test,]
              
  #build the tree model using the train data
  #we want to predict the attribute class, we use all other attributes to train this model, the dataset we use is traindata
  tree_model = tree(traindata$WINNER~.,traindata[,c("CANDTOTAL", "INCUMBENT", "WINNER", "INDRANK")])
  
  
  
  #check the performance of the model using test data
  pred = predict(tree_model, testdata, type = "class")
  #using .5 as a standard split
  print(paste0("accuracy: ", mean(pred==testdata$WINNER)),quote = FALSE)
  
  
  #confint(tree_predict==testdata$class)
  #how to get mean, variance, confidence interval???????????
  
  #prune the tree to improve the performance
  cv_tree = cv.tree(tree_model, FUN = prune.tree)
  
  #see the cv_tree's attributes
  names(cv_tree)
  
  plot(cv_tree$size, cv_tree$dev, type = "b")
  
  #we can see that when size = 3, the error is least
  prune_model = prune.tree(tree_model, best = 3)
  
  
  #show the tree structure after pruning
  jpeg(paste0("hypothesis_testing/data_driving_predictive_models/DT Prune ", k, ".jpeg", sep = ""))
  plot(prune_model)
  text(prune_model, pretty = 0)
  dev.off()
  
  predict_after_prune = predict(prune_model, testdata, type = "class")
  
  
  confmatrix = (table(predict_after_prune, testdata$WINNER))
  print("confusion matrix",quote = FALSE)
  print(confmatrix)
  
  library(pROC)
  testTarget = as.numeric(testdata$WINNER)
  result = as.numeric(predict_after_prune)
  myROC = roc(testTarget,result, direction="<", auc=TRUE, ci=TRUE)
  jpeg(paste0("hypothesis_testing/data_driving_predictive_models/DT ROC ", k, ".jpeg", sep = ""))
  plot(myROC)
  dev.off()
  
  precision = confmatrix[2,2]/sum(confmatrix[2,2],confmatrix[1,2])
  Recall = confmatrix[2,2]/sum(confmatrix[2,2],confmatrix[2,1])
  
  print(paste0("accuracy: ", mean(predict_after_prune==testdata$WINNER)),quote = FALSE)
  print(paste0("precision: ", precision),quote = FALSE)
  print(paste0("Recall: ", Recall),quote = FALSE)
  print(paste0("F-measure: ", 2*precision*Recall/(precision+Recall)),quote = FALSE)
  
}
