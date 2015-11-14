#==========Global parameters==========#

#Assign the root to the folder containing our repo.
#If you do that, the rest of the program should run successfully.
root <- paste0("H:/Hotchkiss Hive Mind/John/Documents/Schoolwork/Georgetown/",
               "ANLY-501/50-percent-Chance-of-Awesome/")




#==========Gather and stack the FEC data==========#

#Path to the FEC data
cleanFECRepo <- "part2_exploratory_analysis/clean_data/clean/"

FECYears <- c(2004, 2006, 2008, 2010, 2012) #Create a list of years for looping
for (i in FECYears) {
  cat("Loading FEC",i,"data.","\n") #For log/debug
  
  #Create the year-specific FEC data set.
  currYrData <- read.csv(paste0(root,cleanFECRepo,i,".csv"),
                         stringsAsFactors=FALSE,
                         strip.white=TRUE)
  
  #Verify year is not missing and has the expected value.
  stopifnot(unique(currYrData$YEAR)==i)
  
  #Construct stacked data set.
  if (i==FECYears[1]) { #If first year, generate new data frame
    FECAllYears <- currYrData
  } else { #If not the first year, append to data frame
    FECAllYears <- rbind(FECAllYears,currYrData)
  }
}
print("FEC Data Stacked") #For log/debug


#==========Start cleaning stacked data==========#

#Rename some columns
names(FECAllYears)[names(FECAllYears)=="STATE.ABBREVIATION"]  <- "STATE"
names(FECAllYears)[names(FECAllYears)=="GENERAL"]             <- "VOTES"
names(FECAllYears)[names(FECAllYears)=="GENERAL.."]           <- "PERCENT"
names(FECAllYears)[names(FECAllYears)=="INCUMBENT.INDICATOR"] <- "INCUMBENT"

#Change INCUMBENT to be numeric
FECAllYears$INCUMBENT[FECAllYears$INCUMBENT=="TRUE" | 
                        FECAllYears$INCUMBENT=="True"] <- "1"
FECAllYears$INCUMBENT[FECAllYears$INCUMBENT=="FALSE" | 
                        FECAllYears$INCUMBENT=="False"] <- "0"
FECAllYears$INCUMBENT <- as.numeric(FECAllYears$INCUMBENT)

#Drop variables that we aren't going to use for cleaning or analysis or merging
FECAllYears <- FECAllYears[,!(names(FECAllYears) %in% c("PRIMARY","PRIMARY..",
                                                        "RUNOFF","RUNOFF.."))]

#Drop candidates that did not make it to the General Election
FECAllYears <- FECAllYears[!(is.na(FECAllYears$VOTES) & is.na(FECAllYears$PERCENT)),]

#Check for candidates missing percentage
FECAllYears[is.na(FECAllYears$PERCENT),]
#Note that candidates with 0 for votes and NA for percent are candidates that 
#ran unopposed in this data set.
#See 2004congresults.xls, cell P3615=P3625, which is clearly an error.
#Mr. Said never made it out of the primaries, so he will be dropped.
FECAllYears <- FECAllYears[FECAllYears$KEY!="WA|S|Mohammad H.|Said|2004",]
#See results10.xls, cell P3615=P3625, which is clearly an error.
#Ms. Peckinpaugh seems to have legitimate information and the percentage is 
#missing.  Using P951/P959 to replace it.
FECAllYears$PERCENT[FECAllYears$KEY=="CT|2|Janet|Peckinpaugh|2010"] <- 
  round(95671/246809,digits=4)
FECAllYears[is.na(FECAllYears$PERCENT),] #Verify the cases were handled.

#Check for candidates missing votes
FECAllYears[is.na(FECAllYears$VOTES),]

#Now change all "unopposed" to having NA for votes so that it matches the NYT data set.
FECAllYears$VOTES[FECAllYears$VOTES==0 & is.na(FECAllYears$PERCENT)] <- NA
FECAllYears[is.na(FECAllYears$VOTES),] #Check

#Remove unwanted election information (information from non-states)
FECAllYears <- FECAllYears[!(FECAllYears$STATE %in% c("AS", "DC", 
                                                      "GU", "PR", 
                                                      "VI", "MP")),]
#Make sure there are 50 states after removal of the above elements.
stopifnot(length(unique(FECAllYears$STATE))==50)

#Check assumption that there are no duplicates by state-year-district-first.name-last.name
dups <- FECAllYears[duplicated(FECAllYears[,c("STATE","DISTRICT","FIRST.NAME","LAST.NAME","YEAR")]),]
stopifnot(nrow(dups)==0)

#Remove unneeded information from the DISTRICT variable
unique(FECAllYears$DISTRICT)
#Drop people running for an unexpired term (indicated as such or with asterisk in DISTRICT)
FECAllYears <- FECAllYears[substr(FECAllYears$DISTRICT,
                                  nchar(FECAllYears$DISTRICT)-13,
                                  nchar(FECAllYears$DISTRICT))!="UNEXPIRED TERM",]
FECAllYears <- FECAllYears[substr(FECAllYears$DISTRICT,3,3)!="*",]
FECAllYears$DISTRICT[substr(FECAllYears$DISTRICT,1,1)=="S"] <- "S"
FECAllYears$DISTRICT[substr(FECAllYears$DISTRICT,1,1)!="S"] <- 
  as.character(as.numeric(
    substr(FECAllYears$DISTRICT[substr(FECAllYears$DISTRICT,1,1)!="S"],1,2)))
unique(FECAllYears$DISTRICT) #Verify DISTRICT is as expected now.

#Check assumption that there are no duplicates by state-year-district-first.name-last.name
dups <- FECAllYears[duplicated(FECAllYears[,c("STATE","DISTRICT","FIRST.NAME","LAST.NAME","YEAR")]),]
stopifnot(nrow(dups)==0)

#Get a variable called CANDIDATE that contains the full name to merge with the 
#NYTimes Data.
FECAllYears$CANDIDATE <- paste(FECAllYears$FIRST.NAME,FECAllYears$LAST.NAME)




#==========Import party affiliation crosswalk to clean PARTY variable==========#

#Path to party affiliation crosswalk
partyAffiliationRepo <- "part2_exploratory_analysis/combine_and_clean_FEC_and_NYT_elections_data/"

#Pull in crosswalk
partyXwalk <- read.csv(paste0(root,partyAffiliationRepo,
                              "party affiliation.csv"),
                       stringsAsFactors=FALSE,
                       strip.white=TRUE)

#Clean up the PARTY variable.  Binning to R, D, and I.
#Binned based on minimal ideological research
D = partyXwalk$Party.Label[partyXwalk$Class=='D']
R = partyXwalk$Party.Label[partyXwalk$Class=='R']
I = partyXwalk$Party.Label[partyXwalk$Class=='I']

#Apply Xwalk to the FEC Data
FECAllYears$PARTY[FECAllYears$PARTY %in% D] <- "D"
FECAllYears$PARTY[FECAllYears$PARTY %in% R] <- "R"
FECAllYears$PARTY[FECAllYears$PARTY %in% I] <- "I"
unique(FECAllYears$PARTY) #Check Recode





#==========Shape the FEC Data for Merger==========#

#Remove remaining columns that will not be used in the analysis or merging
FECAllYears <- FECAllYears[,!(names(FECAllYears) %in% c("FEC.ID",
                                                        "FIRST.NAME",
                                                        "LAST.NAME",
                                                        "KEY"))]

#Order in final data set order
FECAllYears <- FECAllYears[c(5,1,2,8,4,3,6,7)]




#==========Load and Stack NYTimes Data==========#

#Path to NYTimes Data
cleanNYTimesRepo <- "part1_scrape_data/"

#Load data
NYTElectionsRaw <- read.csv(paste0(root,cleanNYTimesRepo,
                                   "NYTimes2014elections.csv"),
                            stringsAsFactors=FALSE,
                            strip.white=TRUE)

#Reshape the NYT data to be long
for (i in 1:12) {
  #Get just one candidate's information
  currCandData <- 
         NYTElectionsRaw[,c("State",               "CongressionalMembership",
                            paste0("Candidate",i), paste0("PartyAffiliation",i),
                            paste0("Votes",i),     paste0("VotePercent",i)
                            )
                         ]
  #Rename Variables to generic forms
  names(currCandData) <- c("STATE",     "DISTRICT",
                           "CANDIDATE", "PARTY",
                           "VOTES",     "PERCENT")
  #Construct stacked data set.
  if (i==1) { #If first year, generate new data frame
    NYTElectionLong <- currCandData
  } else { #If not the first year, append to data frame
    NYTElectionLong <- rbind(NYTElectionLong,currCandData)
  }
}




#==========Clean NYTimes Data==========#

#Transform state names into abbreviations
#Declare matched lists of states and abbreviations 
#(taken from original scraping code)
stateNameList = c("alabama",        "alaska",        "arizona",
                  "arkansas",       "california",    "colorado",
                  "connecticut",    "delaware",      "florida",
                  "georgia",        "hawaii",        "idaho",
                  "illinois",       "indiana",       "iowa",
                  "kansas",         "kentucky",      "louisiana",
                  "maine",          "maryland",      "massachusetts",
                  "michigan",       "minnesota",     "mississippi",
                  "missouri",       "montana",       "nebraska",
                  "nevada",         "new-hampshire", "new-jersey",
                  "new-mexico",     "new-york",      "north-carolina",
                  "north-dakota",   "ohio",          "oklahoma",
                  "oregon",         "pennsylvania",  "rhode-island",
                  "south-carolina", "south-dakota",  "tennessee",
                  "texas",          "utah",          "vermont",
                  "virginia",       "washington",    "west-virginia",
                  "wisconsin",      "wyoming")

stateAbbrevList = c("al", "ak", "az", "ar", "ca", "co", "ct", "de", "fl",
                    "ga", "hi", "id", "il" ,"in", "ia", "ks", "ky", "la",
                    "me", "md", "ma", "mi", "mn", "ms", "mo", "mt", "ne",
                    "nv", "nh", "nj", "nm", "ny", "nc", "nd", "oh", "ok",
                    "or", "pa", "ri", "sc", "sd", "tn", "tx", "ut", "vt",
                    "va", "wa", "wv", "wi", "wy")

#Make abbreviations upper case to match FEC data
stateAbbrevList <- toupper(stateAbbrevList)

#Make replacements
for (i in 1:length(stateNameList)) {
  NYTElectionLong$STATE[NYTElectionLong$STATE==stateNameList[i]] <- 
    stateAbbrevList[i]
}

#Remove empty candidate rows
NYTElectionLong <- NYTElectionLong[NYTElectionLong$CANDIDATE!="",]

#Recode PARTY
NYTElectionLong$PARTY[NYTElectionLong$PARTY=="RepublicanRep."] <- "R"
NYTElectionLong$PARTY[NYTElectionLong$PARTY=="DemocratDem."]   <- "D"
NYTElectionLong$PARTY[NYTElectionLong$PARTY=="Other"]          <- "I"
unique(NYTElectionLong$PARTY) #Check Recode
#Note that "" belongs to "Uncontested" candidate
stopifnot(NYTElectionLong$CANDIDATE[NYTElectionLong$PARTY==""]=="Uncontested")

#Handle missing VOTES/PERCENT
#Verify that anyone missing votes is also missing percentage
stopifnot(sum(is.na(NYTElectionLong$PERCENT))==
            sum(is.na(NYTElectionLong$VOTES)))
#Print offending cases
NYTElectionLong[is.na(NYTElectionLong$PERCENT),]
#Check that all offending cases are uncontested elections
stopifnot(
  sum(NYTElectionLong$CANDIDATE[is.na(NYTElectionLong$PERCENT)]=="Uncontested")==
    (sum(is.na(NYTElectionLong$PERCENT))/2))
#Drop all "Uncontested"
NYTElectionLong <- NYTElectionLong[NYTElectionLong$CANDIDATE!="Uncontested",]

#Make VOTES numeric
#NOTE: If VOTES is missing it is because the runner was Uncontested.
NYTElectionLong$VOTES <- as.numeric(gsub(",","",NYTElectionLong$VOTES))

#Change PERCENT to match format in FEC Data
#NOTE: If PERCENT is missing it is because the runner was Uncontested.
NYTElectionLong$PERCENT <- as.numeric(gsub("%","",NYTElectionLong$PERCENT))/100

#Add year variable
NYTElectionLong$YEAR <- 2014

#Make DISTRICT match FEC
NYTElectionLong$DISTRICT <- gsub("House District ","",NYTElectionLong$DISTRICT)
NYTElectionLong$DISTRICT <- gsub("Senate","S",NYTElectionLong$DISTRICT)
NYTElectionLong$DISTRICT <- gsub(" Special","",NYTElectionLong$DISTRICT)

#Create Incumbent variable
NYTElectionLong$INCUMBENT <- as.numeric(substr(NYTElectionLong$CANDIDATE,
                                        nchar(NYTElectionLong$CANDIDATE),
                                        nchar(NYTElectionLong$CANDIDATE))=="*")

#Remove asterisks identifying incumbents from candidate names
NYTElectionLong$CANDIDATE <- gsub("[*]","",NYTElectionLong$CANDIDATE)

#Order in final data set order
NYTElectionLong <- NYTElectionLong[c(7,1,2,3,4,8,5,6)]




#==========Stack NYT and FEC Data - Save Master Data Set==========#

#Verify that the column names are the same and in the same order
stopifnot(names(FECAllYears)==names(NYTElectionLong))

#Stack the data
ElectionResults <- rbind(NYTElectionLong,FECAllYears)

#Output Location
OutputRepo <- "part2_exploratory_analysis/combine_and_clean_FEC_and_NYT_elections_data/"

#Output Data Set
write.csv(ElectionResults,paste0(root,OutputRepo,"ElectionResults.csv"))



