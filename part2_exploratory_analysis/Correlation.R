ProjData <- read.csv("C:/Users/Ahn/Desktop/50-percent-Chance-of-Awesome/part2_exploratory_analysis/PoldataSPIndustriesStockData no outliers.csv", stringsAsFactors=FALSE)

# For correlation variables, include PERCENT, RaceFundPerc, and YrPercentChange
ProjCorrData = ProjData[,c(14,21,29)]
cor(na.omit(ProjCorrData))