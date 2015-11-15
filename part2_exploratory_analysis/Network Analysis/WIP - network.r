
#library(network)
root <- paste0("H:/Hotchkiss Hive Mind/John/Documents/Schoolwork/Georgetown/",
               "ANLY-501/50-percent-Chance-of-Awesome/")

baseData <- read.csv(paste0(root,
                            "part2_exploratory_analysis/PoldataSPIndustries.csv"))
#Remove column X
stopifnot(names(baseData)[1]=="X")
baseData <- baseData[,-1]
candIndOnly <- baseData[baseData$WINNER==1 & 
                          (baseData$indrank %in% c(1,2,3)) &
                          baseData$DISTRICT=="S",
                        c("CANDIDATE","PRIMARY.INDUSTRY","PARTY")]
testdata <- candIndOnly
#testdata <- testdata[1:2000,]

#Load years into network
#nodeinfo <- testdata[,c("CANDIDATE","PRIMARY.INDUSTRY")]
testnet2012 <- network(testdata[,c("CANDIDATE","PRIMARY.INDUSTRY")],directed=FALSE)
testattr <- get.vertex.attribute(testnet2012,"vertex.names")

industrylist <- as.character(unique(testdata$PRIMARY.INDUSTRY))
testattr[testattr %in% industrylist] <- "7"

partyDemList <- as.character(unique(testdata$CANDIDATE[testdata$PARTY=="D"]))
testattr[testattr %in% partyDemList] <- "4"

partyRepList <- as.character(unique(testdata$CANDIDATE[testdata$PARTY=="R"]))
testattr[testattr %in% partyRepList] <- "2"

partyIndList <- as.character(unique(testdata$CANDIDATE[testdata$PARTY=="I"]))
testattr[testattr %in% partyIndList] <- "3"

testattr <- as.numeric(testattr)
summary(testattr)
set.vertex.attribute(testnet2012,"ind",testattr)


