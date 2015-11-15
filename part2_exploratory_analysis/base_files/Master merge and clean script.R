### Master merge and clean script
#==========Global parameters==========#

#Set Working Directory
setwd("/Users/joshuakaplan/50-percent-Chance-of-Awesome")

#==========Load files to be merged==========#

#Set paths to files
resultsRepo <- "part2_exploratory_analysis/combine_and_clean_FEC_and_NYT_elections_data/" 
openRepo <- "part2_exploratory_analysis/openSecrets/"

#Load files
results <- read.csv(paste0(resultsRepo,"ElectionResults.csv"),
                       stringsAsFactors=FALSE,
                       strip.white=TRUE)
openS <- read.csv(paste0(openRepo,"FundingCongress_cleaned.csv"),
                 stringsAsFactors=FALSE,
                 strip.white=TRUE)

#==========Perform any necessary file manipulations to line up files==========#

#Clean openS:
#Data set names to upper case
names(openS) <- toupper(names(openS)) 

#NAME to CANDIDATE
names(openS)[names(openS)=="NAME"]  <- "CANDIDATE"

#Clean-up DISTRICT
unique(openS$DISTRICT) #Show issue
openS$DISTRICT[substr(openS$DISTRICT,1,1)=="S"] <- "S"
unique(openS$DISTRICT) #Check issue resolved

#Order for convenience in RStudio
openS <- openS[,c(3,1,2,9,8,4,5,7,6)]

#Clean results:
results <- results[,!(names(results) %in% "X")]

#After a first failed merge attempt, learned about "at-large" congressional 
#districts.  These districts are listed as district "0" in the FEC data.
#Proof
for (j in c("AK", "DE", "MT", "ND", "SD", "VT", "WY")) {
  # cat("\n",j,"\n")
  # print(table(results$DISTRICT[results$STATE==j],
  #            results$YEAR[results$STATE==j],
  #            dnn=NULL))
  #Change to 1
  results$DISTRICT[results$STATE==j & results$DISTRICT=="0"] <- "1"
}

#After second attempt, trying to remove periods from names
openS$CANDIDATE <- toupper(gsub("\".*?\"","",openS$CANDIDATE))
openS$CANDIDATE <- toupper(gsub("[^a-zA-Z ]","",openS$CANDIDATE))
results$CANDIDATE <- toupper(gsub("[^a-zA-Z ]","",results$CANDIDATE))
results$CANDIDATE <- toupper(gsub("\".*?\"","",results$CANDIDATE))


#Pull out First and Last Name
tempCandSplit <- strsplit(openS$CANDIDATE," ")
stopifnot(length(tempCandSplit)==length(openS$CANDIDATE))
openS$MID1 = NA
openS$MID2 = NA
openS$MID3 = NA
for (j in 1:length(tempCandSplit)) {
  openS$FIRST[j] = tempCandSplit[[j]][1]
  if(length(tempCandSplit[[j]]==2)) {
    openS$LAST[j] = tempCandSplit[[j]][2]
  }
  if (length(tempCandSplit[[j]])==3){
    if(tempCandSplit[[j]][3]=='JR'|tempCandSplit[[j]][3]=='II'|tempCandSplit[[j]][3]=='III'|tempCandSplit[[j]][3]=='SR') {
      openS$LAST[j] = tempCandSplit[[j]][2]
      openS$MID1[j] = tempCandSplit[[j]][3]
    }
    else {
      openS$LAST[j] = tempCandSplit[[j]][3]
      openS$MID1[j] = tempCandSplit[[j]][2]
    }
  }
  if(length(tempCandSplit[[j]])==4){
    if(tempCandSplit[[j]][4]=='JR'|tempCandSplit[[j]][4]=='II'|tempCandSplit[[j]][4]=='III'|tempCandSplit[[j]][4]=='SR') {
      openS$LAST[j] = tempCandSplit[[j]][3]
      openS$MID1[j] = tempCandSplit[[j]][2]
      openS$MID2[j] = tempCandSplit[[j]][4]
    }
    else {
    openS$LAST[j] = tempCandSplit[[j]][4]
    openS$MID1[j] = tempCandSplit[[j]][2]
    openS$MID2[j] = tempCandSplit[[j]][3]
    }
  }
  if(length(tempCandSplit[[j]])==5){
    if(tempCandSplit[[j]][5]=='JR'|tempCandSplit[[j]][5]=='II'|tempCandSplit[[j]][5]=='III'|tempCandSplit[[j]][5]=='SR') {
      openS$LAST[j] = tempCandSplit[[j]][4]
      openS$MID1[j] = tempCandSplit[[j]][2]
      openS$MID2[j] = tempCandSplit[[j]][3]
      openS$MID3[j] = tempCandSplit[[j]][5]
    }
    else {
      openS$LAST[j] = tempCandSplit[[j]][5]
      openS$MID1[j] = tempCandSplit[[j]][2]
      openS$MID2[j] = tempCandSplit[[j]][3]
      openS$MID3[j] = tempCandSplit[[j]][4]
    }
  }
}

tempCandSplit <- strsplit(results$CANDIDATE," ")
stopifnot(length(tempCandSplit)==length(results$CANDIDATE))
results$MID1 = NA
results$MID2 = NA
results$MID3 = NA
for (j in 1:length(tempCandSplit)) {
  results$FIRST[j] = tempCandSplit[[j]][1]
  if(length(tempCandSplit[[j]])==2){
    results$LAST[j] = tempCandSplit[[j]][2]
  }
  if (length(tempCandSplit[[j]])==3){
    if(tempCandSplit[[j]][3]=='JR'|tempCandSplit[[j]][3]=='II'|tempCandSplit[[j]][3]=='III'|tempCandSplit[[j]][3]=='SR'){
      results$LAST[j] = tempCandSplit[[j]][2]
      results$MID1[j] = tempCandSplit[[j]][3]
    }
    else {
      results$MID1[j] = tempCandSplit[[j]][2]
      results$LAST[j] = tempCandSplit[[j]][3]
    }
  }
  if(length(tempCandSplit[[j]])==4){
    if(tempCandSplit[[j]][4]=='JR'|tempCandSplit[[j]][4]=='II'|tempCandSplit[[j]][4]=='III'|tempCandSplit[[j]][4]=='SR') {
      results$MID1[j] = tempCandSplit[[j]][2]
      results$LAST[j] = tempCandSplit[[j]][3]
      results$MID2[j] = tempCandSplit[[j]][4]
    }
    else {
      results$MID1[j] = tempCandSplit[[j]][2]
      results$MID2[j] = tempCandSplit[[j]][3]
      results$LAST[j] = tempCandSplit[[j]][4]
    }
  }
  if(length(tempCandSplit[[j]])==5){
    if(tempCandSplit[[j]][5]=='JR'|tempCandSplit[[j]][5]=='II'|tempCandSplit[[j]][5]=='III'|tempCandSplit[[j]][5]=='SR') {
      results$LAST[j] = tempCandSplit[[j]][4]
      results$MID1[j] = tempCandSplit[[j]][2]
      results$MID2[j] = tempCandSplit[[j]][3]
      results$MID3[j] = tempCandSplit[[j]][5]
    }
    else {
      results$LAST[j] = tempCandSplit[[j]][5]
      results$MID1[j] = tempCandSplit[[j]][2]
      results$MID2[j] = tempCandSplit[[j]][3]
      results$MID3[j] = tempCandSplit[[j]][4]
    }
  }
}

#==========Merge Files==========#

#FIRST MERGE
#Create variable to denote which dataset observation came from
openS$IN = 1
results$IN = 0
#Merge on Year, State, First name, Last name, District
openResults <- merge(openS,results,by=c("YEAR","STATE","FIRST","LAST","DISTRICT"),all=TRUE)

#Find all records that did not match, use this file to visually compare
no_merge_comp <- openResults[is.na(openResults$IN.y) | is.na(openResults$IN.x),]
#Number of records in the following file is the number of distinct candidates 
#that didn't merge
no_merge <- no_merge_comp[!is.na(no_merge_comp$IN.x),]
#Get records that didn't merge from results file, create new results file to merge on
no_merge_res = no_merge_comp[!is.na(no_merge_comp$IN.y),]
resultsMerge2 = no_merge_res[,c("YEAR","STATE","FIRST","LAST","DISTRICT","CANDIDATE.y","PARTY.y","INCUMBENT","VOTES","PERCENT")]
names(resultsMerge2) = c("YEAR","STATE","FIRST","LAST","DISTRICT","CANDIDATE","PARTY","INCUMBENT","VOTES","PERCENT")
resultsMerge2$IN = 0

#Prepare for another merge by pulling just open secrets data that didn't merge 
#from the previous no merge results
openmerge2 <- no_merge
openmerge2 <- openmerge2[,c("YEAR","STATE","FIRST","LAST","DISTRICT","CANDIDATE.x","PARTY.x","INDUSTRY","AMOUNT","INDUSTRYPERCENT","CANDTOTAL")]
names(openmerge2) <- c("YEAR","STATE","FIRST","LAST","DISTRICT","CANDIDATE","PARTY","INDUSTRY","AMOUNT","INDUSTRYPERCENT","CANDTOTAL")
openmerge2$IN <- 1

#SECOND MERGE - on Year, State, District, Last Name
openResults2 <- merge(openmerge2,resultsMerge2,by=c("YEAR","STATE","DISTRICT","LAST"),all=TRUE)

#Find all records that did not match, use this file to visually compare
no_merge2_comp <- openResults2[is.na(openResults2$IN.y) | is.na(openResults2$IN.x),]
#Number of records in the following file is the number of distinct candidates 
#that didn't merge
no_merge2 <- no_merge2_comp[!is.na(no_merge2_comp$IN.x),]

#Prepare for another merge
openmerge3 = no_merge2
openmerge3 <- openmerge3[,c("YEAR","STATE","FIRST.x","LAST","DISTRICT","CANDIDATE.x","PARTY.x","INDUSTRY","AMOUNT","INDUSTRYPERCENT","CANDTOTAL")]
names(openmerge3) <- c("YEAR","STATE","FIRST","LAST","DISTRICT","CANDIDATE","PARTY","INDUSTRY","AMOUNT","INDUSTRYPERCENT","CANDTOTAL")
openmerge3$IN <- 1
no_merge2_res = no_merge2_comp[!is.na(no_merge2_comp$IN.y),]
resultsMerge3 = no_merge2_res[,c("YEAR","STATE","FIRST.y","LAST","DISTRICT","CANDIDATE.y","PARTY.y","INCUMBENT","VOTES","PERCENT")]
names(resultsMerge3) = c("YEAR","STATE","FIRST","LAST","DISTRICT","CANDIDATE","PARTY","INCUMBENT","VOTES","PERCENT")
resultsMerge3$IN = 0

#THIRD MERGE
#Merge with unmerged observations from FEC file on first name
openResults3 = merge(openmerge3,resultsMerge3,by=c("YEAR","STATE","DISTRICT","FIRST"),all=TRUE)

no_merge3_comp <- openResults3[is.na(openResults3$IN.y) | is.na(openResults3$IN.x),]
no_merge3 <- no_merge3_comp[!is.na(no_merge3_comp$IN.x),]

#merge 10 unmatched candidates by hand - these came about from clerical errors
no_merge3 <- no_merge3[,c("YEAR","STATE","FIRST","LAST.x","DISTRICT","CANDIDATE.x","PARTY.x","INDUSTRY","AMOUNT","INDUSTRYPERCENT","CANDTOTAL")]
names(no_merge3) = c("YEAR","STATE","FIRST","LAST","DISTRICT","CANDIDATE","PARTY","INDUSTRY","AMOUNT","INDUSTRYPERCENT","CANDTOTAL")

# Correct clerical errors
no_merge3$FIRST[10:11] = "KOTOS"
no_merge3$FIRST[12:31] = "JIM"
no_merge3$FIRST[32:33] = "TOM"
no_merge3$FIRST[34] = "DOTTIE"
no_merge3$FIRST[35:37] = "SOLE"
no_merge3$FIRST[217:236] = "W"
no_merge3$FIRST[247:266] = "CHARLES"
no_merge3$FIRST[327:346] = "JIM"
no_merge3$DISTRICT[386:397] = 6
no_merge3$FIRST[404:408] = "MATTHEW"
# make sure kenneth del vecchio doesnt get merged with kenneth kaplan
no_merge3$FIRST[325] = 0
no_merge3$IN=1

#FOURTH MERGE
openResults4 = merge(no_merge3,results,by=c("YEAR","STATE","DISTRICT","FIRST"),all=TRUE)
no_merge4_comp <- openResults4[is.na(openResults4$IN.y) | is.na(openResults4$IN.x),]
no_merge4 <- no_merge4_comp[!is.na(no_merge4_comp$IN.x),]

#Combine merged candidates into one dataframe
#Remove unmerged observations from FEC data
openResults = openResults[openResults$IN.x==1 & openResults$IN.y==0,]
#Remove NAs
z = apply(openResults, 1, function(x) all(is.na(x)))
openResults = openResults[!z,]
openResults = openResults[,c("YEAR","STATE","FIRST","LAST","DISTRICT","CANDIDATE.x","PARTY.x","INDUSTRY","AMOUNT","INDUSTRYPERCENT","CANDTOTAL","INCUMBENT","VOTES","PERCENT")]
names(openResults) = c("YEAR","STATE","FIRST","LAST","DISTRICT","CANDIDATE","PARTY","INDUSTRY","AMOUNT","INDUSTRYPERCENT","CANDTOTAL","INCUMBENT","VOTES","PERCENT")

#same process for other sets of merge results
openResults2 = openResults2[openResults2$IN.x==1 & openResults2$IN.y==0,]
z = apply(openResults2, 1, function(x) all(is.na(x)))
openResults2 = openResults2[!z,]
openResults2 = openResults2[,c("YEAR","STATE","FIRST.x","LAST","DISTRICT","CANDIDATE.x","PARTY.x","INDUSTRY","AMOUNT","INDUSTRYPERCENT","CANDTOTAL","INCUMBENT","VOTES","PERCENT")]
names(openResults2) = c("YEAR","STATE","FIRST","LAST","DISTRICT","CANDIDATE","PARTY","INDUSTRY","AMOUNT","INDUSTRYPERCENT","CANDTOTAL","INCUMBENT","VOTES","PERCENT")
openResults = rbind(openResults2,openResults)

openResults3 = openResults3[openResults3$IN.x==1 & openResults3$IN.y==0,]
z = apply(openResults3, 1, function(x) all(is.na(x)))
openResults3 = openResults3[!z,]
openResults3 = openResults3[,c("YEAR","STATE","FIRST","LAST.x","DISTRICT","CANDIDATE.x","PARTY.x","INDUSTRY","AMOUNT","INDUSTRYPERCENT","CANDTOTAL","INCUMBENT","VOTES","PERCENT")]
names(openResults3) = c("YEAR","STATE","FIRST","LAST","DISTRICT","CANDIDATE","PARTY","INDUSTRY","AMOUNT","INDUSTRYPERCENT","CANDTOTAL","INCUMBENT","VOTES","PERCENT")
openResults = rbind(openResults3,openResults)

openResults4 = openResults4[openResults4$IN.x==1 & openResults4$IN.y==0,]
z = apply(openResults4, 1, function(x) all(is.na(x)))
openResults4 = openResults4[!z,]
openResults4 = openResults4[,c("YEAR","STATE","FIRST","LAST.x","DISTRICT","CANDIDATE.x","PARTY.x","INDUSTRY","AMOUNT","INDUSTRYPERCENT","CANDTOTAL","INCUMBENT","VOTES","PERCENT")]
names(openResults4) = c("YEAR","STATE","FIRST","LAST","DISTRICT","CANDIDATE","PARTY","INDUSTRY","AMOUNT","INDUSTRYPERCENT","CANDTOTAL","INCUMBENT","VOTES","PERCENT")
openResults = rbind(openResults4,openResults)

OpenSecretsFECIndustry = openResults

#Merging industry crosswalk with political data
#Classify industries from OpenSecrets into S&P 500 industries
Industry.Crosswalk = read.csv("part2_exploratory_analysis/Industry Crosswalk.csv")
names(Industry.Crosswalk) = c("INDUSTRY", "PRIMARY.INDUSTRY", "SECONDARY.INDUSTRY1", "SECONDARY.INDUSTRY2", "SECONDARY.INDUSTRY3")
#Merge on OpenSecrets industry name
OpenSecretsFECIndustry = merge(OpenSecretsFECIndustry,Industry.Crosswalk,by="INDUSTRY",all=TRUE)
names(OpenSecretsFECIndustry)[1] = "OPENSECRETS INDUSTRY"
# remove donation amounts <=0; these must be errors
OpenSecretsFECIndustry = OpenSecretsFECIndustry[OpenSecretsFECIndustry$AMOUNT>0,]
# clean up industries
OpenSecretsFECIndustry$PRIMARY.INDUSTRY[OpenSecretsFECIndustry$PRIMARY.INDUSTRY=="not for profit"] = "Not for profit"

#creating new features for Frequent Itemset Analysis 
#save uncombined dataset
write.csv(OpenSecretsFECIndustry,file = "OpenSecretsFECIndustry.csv",row.names=F)

#vectors to iterate over
OpenSecretsFECIndustry$candyearind = paste0(OpenSecretsFECIndustry$CANDIDATE,OpenSecretsFECIndustry$YEAR,OpenSecretsFECIndustry$PRIMARY.INDUSTRY)
candyearind = unique(OpenSecretsFECIndustry$candyearind)
sectors = as.character(unique(OpenSecretsFECIndustry$PRIMARY.INDUSTRY))

#convert factor variables to type character
i <- sapply(OpenSecretsFECIndustry, is.factor)
OpenSecretsFECIndustry[i] <- sapply(OpenSecretsFECIndustry[i], as.character)

#combining opensecrets industries into S&P industries 
#sum contributions over OpenSecrets industries belonging to each S&P Industries
PoldataSPIndustries = data.frame(matrix(rep(NA,ncol(OpenSecretsFECIndustry)),nrow = 1))
for (i in 1:length(candyearind)){
  for (sector in sectors){
    for (year in unique(OpenSecretsFECIndustry$YEAR[OpenSecretsFECIndustry$candyearind==candyearind[i] & OpenSecretsFECIndustry$PRIMARY.INDUSTRY==sector])){
      temp = OpenSecretsFECIndustry[OpenSecretsFECIndustry$candyearind==candyearind[i] & OpenSecretsFECIndustry$YEAR==year & OpenSecretsFECIndustry$PRIMARY.INDUSTRY==sector,]
      newrow = c(temp[1,1:8],sum(temp[,9]),sum(temp[,10]),temp[1,11:length(temp)])
      x[i,] = newrow
    }
  }
}

#name cols in new dataset
names(PoldataSPIndustries) =  names(OpenSecretsFECIndustry)

#save dataset before removing outliers
write.csv(PoldataSPIndustries, file = "PoldataSPIndustries.csv",row.names = F)

# recalculate candidate totals (there was an error in part 1 feature creation; 
# candidates from the same year who had the same name got lumped together)

PoldataSPIndustries$racenameid = paste0(PoldataSPIndustries$YEAR,PoldataSPIndustries$STATE,PoldataSPIndustries$DISTRICT,PoldataSPIndustries$CANDIDATE) 
for(racenameid in unique(PoldataSPIndustries$racenameid)){
  PoldataSPIndustries$CANDTOTAL[PoldataSPIndustries$racenameid==racenameid] = sum(PoldataSPIndustries$AMOUNT[PoldataSPIndustries$racenameid==racenameid])
}

# remove outliers: lower than 1IQR below 25th percentile 
# or higher than 1IQR above 75th percentile
remove_outliers <- function(x, na.rm = TRUE, ...) {
  qnt <- quantile(x, probs=c(.25, .75), na.rm = na.rm, ...)
  H <- 1 * IQR(x, na.rm = na.rm)
  y <- x
  y[x < (qnt[1] - H)] <- NA
  y[x > (qnt[2] + H)] <- NA
  y
}
# removing outliers
PoldataSPIndustries$TEST = remove_outliers(PoldataSPIndustries$CANDTOTAL)
PoldataSPIndustries$TEST1 = remove_outliers(PoldataSPIndustries$VOTES)
PoldataSPIndustries = PoldataSPIndustries[!is.na(PoldataSPIndustries$TEST),]
PoldataSPIndustries = PoldataSPIndustries[!is.na(PoldataSPIndustries$TEST1),]

# bin candidate total contributions and votes into 4 levels
PoldataSPIndustries$CANDTOTALLEVEL = cut(PoldataSPIndustries$CANDTOTAL,4,labels = c("Very Low","Mid-Low","Mid-High","High"))
PoldataSPIndustries$VOTESLEVEL = cut(PoldataSPIndustries$VOTES,4,labels = c("Very Low","Mid-Low","Mid-High","High"))

# create win variable
PoldataSPIndustries$race = paste0(PoldataSPIndustries$YEAR,PoldataSPIndustries$STATE,PoldataSPIndustries$DISTRICT)
race = PoldataSPIndustries$race
PoldataSPIndustries$WINNER=0
PoldataSPIndustries$racenameid = paste0(PoldataSPIndustries$YEAR,PoldataSPIndustries$STATE,PoldataSPIndustries$DISTRICT,PoldataSPIndustries$CANDIDATE) 

# find winner of each race in the dataset 
# (there will be duplicates here because we have one observation per 
# industry for each candidate in each race)
victor = 0
for (i in 1:length(race)){
  temp = PoldataSPIndustries[PoldataSPIndustries$race == race[i],]
  racecandidates = unique(temp$CANDIDATE)
  highvotecount = max(temp$VOTES)
  victor[i] = temp$racenameid[temp$VOTES == highvotecount & temp$race==race[i]][1]
}

# create vector of unique identifiers for each winner/race combination
victors = unique(victor)
for (victor in victors){
  PoldataSPIndustries$WINNER[PoldataSPIndustries$racenameid==victor]=1
}
# remove identifier variables
PoldataSPIndustries = PoldataSPIndustries[,c(1:18,21)]

# rank primary industries by donation amount for each candidate
PoldataSPIndustries$candyear = paste0(PoldataSPIndustries$CANDIDATE,PoldataSPIndustries$YEAR)
candyear = unique(PoldataSPIndustries$candyear)
PoldataSPIndustries$INDRANK = 0

for (candidateyear in candyear){
  temp = PoldataSPIndustries[PoldataSPIndustries$candyear == candidateyear,]
  order = order(temp$AMOUNT,decreasing=T)
  PoldataSPIndustries$INDRANK[PoldataSPIndustries$candyear == candidateyear][order] = c(1:length(PoldataSPIndustries$indrank[PoldataSPIndustries$candyear == candidateyear]))
}

#remove identifier column
PoldataSPIndustries = PoldataSPIndustries[,c(1:(ncol(PoldataSPIndustries)-2),ncol(PoldataSPIndustries))]

#save file, don't overwrite dataset with outliers incase we need it later
write.csv(PoldataSPIndustries, file = "PSPI no outliers.csv",row.names = F)

#### Merge S&P500 data with political data (file with outliers) ####
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

write.csv(mergeddata, "PoldataSPIndustriesStockData.csv",row.names=F)

#### Create a new variable to merge data sets by. We will join Year, State, and District to create a new, unique variable.
setwd("~/Documents/Analytics 501 Fall 2015/50-percent-Chance-of-Awesome/part2_exploratory_analysis")
PoldataSPIndustries <- read.csv("PoldataSPIndustries.csv")

PoldataSPIndustries$YrStDis <- paste(PoldataSPIndustries$YEAR,PoldataSPIndustries$STATE,PoldataSPIndustries$DISTRICT,sep="-")

# Total the entire amount of political funding to all candidates by year, state, and district. This will be used
# to calculate the funding received percentage per candidate in each race.
RaceTotals <- aggregate(PoldataSPIndustries$AMOUNT ~ PoldataSPIndustries$YEAR + PoldataSPIndustries$STATE + 
                          PoldataSPIndustries$DISTRICT, data=PoldataSPIndustries, sum)

# Rename variables and create a new variable that is identical in nature to the one created in PoldataSPIndustries
names(RaceTotals) <- c("Year","State","District","TotalRaceFunds")
RaceTotals$YrStDis <- paste(RaceTotals$Year,RaceTotals$State,RaceTotals$District,sep="-")
RaceTotals <- RaceTotals[,4:5]

# Merge PoldataSPIndustries and RaceTotals
PoldataSPIndustries <- merge(PoldataSPIndustries,RaceTotals[,c("TotalRaceFunds","YrStDis")],by="YrStDis")

PoldataSPIndustries$RaceFundPerc <- PoldataSPIndustries$CANDTOTAL/PoldataSPIndustries$TotalRaceFunds

PSPI_numeric = PoldataSPIndustries[,c(4,11,12,13,15,16,24,25)]
cor(na.omit(PSPI_numeric))
