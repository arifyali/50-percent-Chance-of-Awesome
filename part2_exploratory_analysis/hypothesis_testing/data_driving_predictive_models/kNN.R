library(class)

#load the dataset
dataset = read.csv("./breast-cancer.csv")
#attach(Smarket)

#standardize data
std_data = scale(dataset[,c(2:30)])

#10-folds-accross
set.seed(2)
train = sample(1:nrow(dataset),nrow(dataset)*9/10)
test = -train
traindata = std_data[train,]
testdata = std_data[test,]
#cl_train = std_data[train,]
