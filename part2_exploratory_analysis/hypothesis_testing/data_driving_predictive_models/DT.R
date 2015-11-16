#code citation: https://www.youtube.com/watch?v=GOJN9SKl_OE
#code citation: https://cran.r-project.org/web/packages/ISLR/ISLR.pdf

library(ISLR)
library(tree)
#load the dataset
dataset = read.csv("PoldataSPIndustriesStockData no outliers.csv")
dataset = dataset[order(dataset$INDRANK, decreasing = T),]
dataset = dataset[!duplicated(dataset[,c("YEAR", "STATE", "DISTRICT", "CANDIDATE")]),]
"
#bin the data
binOfIndustryPercent = 1/6
binOfCandTotal = max(dataset$CANDTOTAL)/10
binOfAmount = max(dataset$AMOUNT.of.1)/10

x = dataset[, 2]
cut(x, b=6)
industryPercentLevel = cut(x, b=6, labels=c(1:6))
dataset = cbind(dataset, industryPercentLevel)

x = dataset[, 3]
candTotalLevel = cut(x, b=10, labels = c(1:10))
dataset = cbind(dataset, candTotalLevel)

a1 = dataset[, 11]
amount1Level = cut(a1, b=10, labels = c(1:10))
dataset = cbind(dataset, amount1Level)

a2 = dataset[, 11]
amount2Level = cut(a2, b=10, labels = c(1:10))
dataset = cbind(dataset, amount2Level)

a3 = dataset[, 11]
amount3Level = cut(a3, b=10, labels = c(1:10))
dataset = cbind(dataset, amount3Level)

a4 = dataset[, 11]
amount4Level = cut(a4, b=10, labels = c(1:10))
dataset = cbind(dataset, amount4Level)


a5 = dataset[, 11]
amount5Level = cut(a5, b=10, labels = c(1:10))
dataset = cbind(dataset, amount5Level)


dataset = dataset[, c(1,4:10,16:22)]
"
#mons = factor(mons,levels=c("Not for profit","Financials","Consumer Staples","Industrials","Consumer Discretionary","Materials","Utilities","Information Technology","Not publicly traded","Health Care","Telecommunication Services","Energy","Other"),ordered=TRUE)
#take a look at first several rows
head(dataset)
            #range(dataset$attr1)
            
            #append a new column named High
            #High = ifelse(trainset$attr1>6.2,"Yes","No")
            #trainset = data.frame(trainset,High)
            
            #discard one column
            #trainset = trainset[2:30]
            #just keep one column of the table
            #trainset = trainset[2]
            
            #split the data into trainset and testset
            #set seed to make sure next time you run the program, it gives you the same result
#3 folds across - get train data and test data
for(k in 1:3){
  train = sample(1:nrow(dataset),nrow(dataset)*2/3)
  test = -train
  traindata = dataset[train,]
  testdata = dataset[test,]
              #head(trainset)
              #head(testset)
  #build the tree model using the train data
  #we want to predict the attribute class, we use all other attributes to train this model, the dataset we use is traindata
  tree_model = tree(traindata$WINNER~.,traindata[,c("CANDTOTAL", "INCUMBENT", "WINNER", "INDRANK")])
  
  #show the tree structure
  plot(tree_model)
  text(tree_model, pretty = 0)
  
  #check the performance of the model using test data
  tree_predict = predict(tree_model, testdata)
  #using .5 as a standard split
  tree_predict[tree_predict<.5] = 0
  tree_predict[tree_predict>=.5] = 1
  print(paste0("The iteration is:", k))
  print(table(tree_predict, testdata$WINNER))
  print(mean(tree_predict==testdata$WINNER))
  print(var(tree_predict==testdata$WINNER))
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
  
  tree_predict_after_prune = predict(prune_model, testdata)
  tree_predict_after_prune[tree_predict_after_prune<.5] = 0
  tree_predict_after_prune[tree_predict_after_prune>=.5] = 1
  
  
  print(table(tree_predict_after_prune, testdata$WINNER))
  
  library(pROC)
  testTarget = as.numeric(testdata$WINNER)
  result = as.numeric(tree_predict_after_prune)
  myROC = roc(testTarget,result, direction="<", auc=TRUE, ci=TRUE)
  jpeg(paste0("hypothesis_testing/data_driving_predictive_models/DT ROC ", k, ".jpeg", sep = ""))
  plot(myROC)
  dev.off()
  
  print(mean(tree_predict_after_prune == testdata$WINNER))
  print(var(tree_predict==testdata$WINNER))
}
