library(e1071)

#load the dataset
dataset = read.csv("./data.csv")
#attach(Smarket)

#bin the data

x = dataset[, 2]
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

#dataset = dataset[,c(1,3:15)]
#10-folds-accross
train = sample(1:nrow(dataset),nrow(dataset)*9/10)
test = -train
traindata = dataset[train,]
testdata = dataset[test,]

#traindata$WINNER is the label. 
nb = naiveBayes(traindata$WINNER~., data=traindata)

#use naive bayes to do prediction
pred = predict(nb, testdata,type =c("class"))

#show the result
table(pred, testdata$WINNER)
library(pROC)
testTarget = as.numeric(testdata$WINNER)
result = as.numeric(pred)
myROC = roc(testTarget,result, 
            print.auc=TRUE,
            main="Confidence intervals", percent=TRUE,
            ci=TRUE,  auc.polygon=TRUE, grid=TRUE, plot=FALSE)
plot(myROC)

#the performance
mean(pred==testdata$WINNER)
var(pred==testdata$WINNER)
