#### Merge industry and election data ####
setwd("~/Documents/Analytics 501 Fall 2015/50-percent-Chance-of-Awesome/part2_exploratory_analysis")
PoldataSPIndustries <- read.csv("PoldataSPIndustries.csv")
IndustryStockData <- read.csv("IndustryChangeByTerm.csv")

NotSP500Industrydonors = data.frame("X" = rep(NA, times = 15),
  "Sector" = rep(c("Not for profit", "", "Not publicly traded")
                                           , each = 5))
NotSP500Industrydonors$AdjClose = NA

NotSP500Industrydonors$Group = rep(c("Values0506b", "Values0708b",
                                               "Values0910b", "Values1112b",
                                               "Values1314b"), each = 3)
NotSP500Industrydonors$YrPercentChange = NA

IndustryStockData = rbind(IndustryStockData, NotSP500Industrydonors)
IndustryStockData$RelYear = as.character(IndustryStockData$Group)

IndustryStockData$RelYear[IndustryStockData$Group == "Values0506b"] = 2004
IndustryStockData$RelYear[IndustryStockData$Group == "Values0708b"] = 2006
IndustryStockData$RelYear[IndustryStockData$Group == "Values0910b"] = 2008
IndustryStockData$RelYear[IndustryStockData$Group == "Values1112b"] = 2010
IndustryStockData$RelYear[IndustryStockData$Group == "Values1314b"] = 2012

library(RSQLite)
m = dbDriver("SQLite")
tfile = tempfile()
con=dbConnect(m, dbname = tfile)

dbWriteTable(con, "PoldataSPIndustries", PoldataSPIndustries)
dbWriteTable(con, "IndustryStockData", IndustryStockData)

mergeddata = dbGetQuery(con, "SELECT * FROM  PoldataSPIndustries, IndustryStockData 
                              WHERE PoldataSPIndustries.'PRIMARY.INDUSTRY' = IndustryStockData.SECTOR
                              AND PoldataSPIndustries.YEAR = IndustryStockData.RELYEAR;")

write.csv(mergeddata, "PoldataSPIndustriesStockData.csv")
