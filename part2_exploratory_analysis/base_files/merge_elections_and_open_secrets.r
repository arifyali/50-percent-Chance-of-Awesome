
#==========Global parameters==========#

#You must have the following library to run this program.
#This library allows the use of SQL commands within R.
library(RSQLite)

#Set Working Directory
setwd(paste0("H:/Hotchkiss Hive Mind/John/Documents/Schoolwork/Georgetown/",
             "ANLY-501/50-percent-Chance-of-Awesome/"))




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
  cat("\n",j,"\n")
  print(table(results$DISTRICT[results$STATE==j],
              results$YEAR[results$STATE==j],
              dnn=NULL))
  #Change to 1
  results$DISTRICT[results$STATE==j & results$DISTRICT=="0"] <- "1"
}

#After second attempt, trying to remove periods from names
openS$CANDIDATE <- toupper(gsub("\".*?\"","",openS$CANDIDATE))
results$CANDIDATE <- toupper(gsub("\".*?\"","",results$CANDIDATE))
openS$CANDIDATE <- toupper(gsub("[^a-zA-Z ]","",openS$CANDIDATE))
results$CANDIDATE <- toupper(gsub("[^a-zA-Z ]","",results$CANDIDATE))

#Pull out First and Last Name
tempCandSplit <- strsplit(openS$CANDIDATE," ")
stopifnot(length(tempCandSplit)==length(openS$CANDIDATE))
for (j in 1:length(tempCandSplit)) {
  openS$FIRST[j] <- tempCandSplit[[j]][1]
  openS$LAST[j] <- tempCandSplit[[j]][min(3,length(tempCandSplit[[j]]))]
}

tempCandSplit <- strsplit(results$CANDIDATE," ")
stopifnot(length(tempCandSplit)==length(results$CANDIDATE))
for (j in 1:length(tempCandSplit)) {
  results$FIRST[j] <- tempCandSplit[[j]][1]
  results$LAST[j] <- tempCandSplit[[j]][min(3,length(tempCandSplit[[j]]))]
}




#==========Merge Files==========#

#Attempt 1:
openResults <- merge(openS,results,by=c("YEAR","STATE","FIRST","LAST"),all.x=TRUE)
no_merge <- openResults[is.na(openResults$VOTES),]

#Attempt: THIS DOES NOT GIVE THE FINAL DATA SET.  CAN SIMPLY BE USED TO TRY TO 
#TEST MERGES
#Get just open secrets subset of data
openMergeVars <- openS[,c("YEAR","STATE","FIRST","LAST","DISTRICT","CANDIDATE")]
openMergeVars$IN <- 1 #Variable for tracking merge results easily
#dedup this to remove industry info we don't care about while learning the merge
openMergeVars <- openMergeVars[!duplicated(openMergeVars),] 

#Do the same steps to the election results
resultsMergeVars <- results[,c("YEAR","STATE","FIRST","LAST","DISTRICT","CANDIDATE")]
resultsMergeVars$IN <- 0
resultsMergeVars <- resultsMergeVars[!duplicated(resultsMergeVars),]

#FIRST MERGE
openResults <- merge(openMergeVars,resultsMergeVars,by=c("YEAR","STATE","FIRST","LAST","DISTRICT"),all=TRUE)
#Find all records that did not match, use this file to visually compare
no_merge_comp <- openResults[is.na(openResults$IN.y) | is.na(openResults$IN.x),]
#Number of records in the following file is the number of distinct candidates 
#that didn't merge
no_merge <- no_merge_comp[!is.na(no_merge_comp$IN.x),]

#Prepare for another merge by pulling just open secrets data that didn't merge 
#from the previous no merge results
openmerge2 <- no_merge
names(openmerge2) <- c("YEAR","STATE","FIRST","LAST","DISTRICT","CANDIDATE")
openmerge2 <- openmerge2[,c("YEAR","STATE","FIRST","LAST","DISTRICT","CANDIDATE")]
openmerge2$IN <- 1

#SECOND MERGE
openResults2 <- merge(openmerge2,resultsMergeVars,by=c("YEAR","STATE","DISTRICT","LAST"),all=TRUE)
#Find all records that did not match, use this file to visually compare
no_merge2_comp <- openResults2[is.na(openResults2$IN.y) | is.na(openResults2$IN.x),]
#Number of records in the following file is the number of distinct candidates 
#that didn't merge
no_merge2 <- no_merge2_comp[!is.na(no_merge2_comp$IN.x),]
