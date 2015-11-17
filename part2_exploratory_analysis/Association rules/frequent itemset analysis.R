### Creating new features in election data for frequent itemset analysis
install.packages("arules")
library(arules)

# frequent itemset analysis
# load in dataset without outliers
PoldataSPIndustries <- read.csv("~/50-percent-Chance-of-Awesome/part2_exploratory_analysis/PSPI no outliers.csv")


#
PoldataSPIndustries$VOTEPERCENTLEVEL = cut(PoldataSPIndustries$PERCENT,4,labels = c("Very Low","Mid-Low","Mid-High","High"))

# convert dataset to type factor
for (i in 1:ncol(PoldataSPIndustries)){
  PoldataSPIndustries[,i] = as.factor(PoldataSPIndustries[,i])
}

# select subset of dataset to be used in FIA
FIAsubset = PoldataSPIndustries[,c(2,3,8,12,15,19,22,24:25)]

# run association rule mining with Apriori algorithm
rules= apriori(FIAsubset,parameter = list(maxlen=20, supp=0.4, conf=0.2))
write(rules,file = "apriorirules.4.2.csv",sep = ",",quote=TRUE)
rules= apriori(FIAsubset,parameter = list(maxlen=20, supp=0.2, conf=0.2))
write(rules,file = "apriorirules.2.2.csv",sep = ",",quote = TRUE)
rules = apriori(FIAsubset,parameter = list(maxlen = 20,supp=.05,conf = 0.2))
write(rules,file = "apriorirules.05.2.csv",sep = ",",quote = TRUE)

# run association rule mining with Eclat algorithm
rules= eclat(FIAsubset,parameter = list(maxlen=20, supp=0.4))
write(rules,file = "eclatrules.4.csv",sep = ",",quote=TRUE)
rules= eclat(FIAsubset,parameter = list(maxlen=20, supp=0.2))
write(rules,file = "eclatrules.2.csv",sep = ",",quote = TRUE)
rules = eclat(FIAsubset,parameter = list(maxlen = 20,supp=.05))
write(rules,file = "eclatrules.05.csv",sep = ",",quote = TRUE)



