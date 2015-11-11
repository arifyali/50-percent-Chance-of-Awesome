
library(e1071)

#load the dataset
dataset = read.csv("./breast-cancer.csv")
#attach(Smarket)

#10-folds-accross
set.seed(100)
train = sample(1:nrow(dataset),nrow(dataset)*9/10)
test = -train
traindata = dataset[train,]
testdata = dataset[test,]

#traindata$class is the label. 
nb = naiveBayes(traindata$class~., data=traindata)

#use naive bayes to do prediction
pred = predict(nb, testdata,type =c("class"))

#show the result
table(pred, testdata$class)

#the performance
mean(pred==testdata$class)
var(pred==testdata$class)
