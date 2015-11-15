#### Merge industry and election data ####
setwd("~/Documents/Analytics 501 Fall 2015/50-percent-Chance-of-Awesome/part2_exploratory_analysis")
PoldataSPIndustries <- read.csv("PoldataSPIndustries.csv")
IndustryStockData <- read.csv("IndustryChangeByTerm.csv")

# The groups are specific to certain years for candidates, so years needed to be assigned in order for
# the merge between Political Data to occur.
IndustryStockData$RelYear = as.character(IndustryStockData$Group)

# Done by subsetting each group and attaching the right year
IndustryStockData$RelYear[IndustryStockData$Group == "Values0506b"] = 2004
IndustryStockData$RelYear[IndustryStockData$Group == "Values0708b"] = 2006
IndustryStockData$RelYear[IndustryStockData$Group == "Values0910b"] = 2008
IndustryStockData$RelYear[IndustryStockData$Group == "Values1112b"] = 2010
IndustryStockData$RelYear[IndustryStockData$Group == "Values1314b"] = 2012


# Setting up RSQLite Engine within R. I (Arif) have used this synthax for many projects, so I guess I would
# cite myself
library(RSQLite)
m = dbDriver("SQLite")
tfile = tempfile()
con=dbConnect(m, dbname = tfile)

dbWriteTable(con, "PoldataSPIndustries", PoldataSPIndustries)
dbWriteTable(con, "IndustryStockData", IndustryStockData)

# Adding the year makes sense down here. Since RSQLite doesn't allow joins, I have to use the where clause

mergeddata = dbGetQuery(con, "SELECT * FROM  PoldataSPIndustries, IndustryStockData 
                              WHERE PoldataSPIndustries.'PRIMARY.INDUSTRY' = IndustryStockData.SECTOR
                              AND PoldataSPIndustries.YEAR = IndustryStockData.RELYEAR;")

write.csv(mergeddata, "PoldataSPIndustriesStockData.csv")
