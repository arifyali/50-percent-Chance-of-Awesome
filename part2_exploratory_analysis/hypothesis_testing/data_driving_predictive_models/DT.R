library(ISLR)
library(tree)
#load the dataset
dataset = read.csv("./breast-cancer.csv")
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
#10 folds across - get train data and test data
set.seed(2)
train = sample(1:nrow(dataset),nrow(dataset)*9/10)
test = -trainset
traindata = dataset[train,]
testdata = dataset[test,]
            #head(trainset)
            #head(testset)
#build the tree model using the train data
#we want to predict the attribute class, we use all other attributes to train this model, the dataset we use is traindata
tree_model = tree(traindata$class~.,traindata)

#show the tree structure
plot(tree_model)
text(tree_model, pretty = 0)

#check the performance of the model using test data
tree_predict = predict(tree_model, testdata, type="class")

table(tree_predict, testdata$class)
mean(tree_predict==testdata$class)
var(tree_predict==testdata$class)
#confint(tree_predict==testdata$class)
#how to get mean, variance, confidence interval???????????

#prune the tree to improve the performance
set.seed(3)
cv_tree = cv.tree(tree_model, FUN = prune.misclass)

#see the cv_tree's attributes
names(cv_tree)

plot(cv_tree$size, cv_tree$dev, type = "b")

#we can see that when size==3, the error is least
prune_model = prune.misclass(tree_model, best = 8)


#show the tree structure after pruning
plot(prune_model)
text(prune_model, pretty = 0)

tree_predict_after_prune = predict(prune_model, testdata, type = "class")

table(tree_predict_after_prune, testdata$class)
mean(tree_predict_after_prune == testdata$class)
var(tree_predict==testdata$class)
