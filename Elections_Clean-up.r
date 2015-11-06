#==========Global parameters==========#

#Assign the root to the folder containing our repo.
#If you do that, the rest of the program should run successfully.
root <- paste0("H:/Hotchkiss Hive Mind/John/Documents/Schoolwork/Georgetown/",
               "ANLY-501/50-percent-Chance-of-Awesome/")

#NOTE TO PROGRAMMER: You must have the "reshape2" package installed to 
#successfully run this program.
library(reshape2)




#==========Gather and stack the FEC data==========#

#Path to the FEC data
cleanFECRepo <- "part2_exploratory_analysis/clean_data/clean/"

FECYears <- c(2004, 2006, 2008, 2010, 2012) #Create a list of years for looping
for (i in FECYears) {
  cat("Loading FEC",i,"data.","\n") #For log/debug
  
  #Create the year-specific FEC data set.
  currYrData <- read.csv(paste0(root,cleanFECRepo,i,".csv"),
                         stringsAsFactors=FALSE.
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

#Drop variables that we aren't going to use
FECAllYears <- FECAllYears[,!(names(FECAllYears) %in% c("PRIMARY","PRIMARY..",
                                                        "RUNOFF","RUNOFF.."))]

#Drop candidates that did not make it to the General Election
FECAllYears <- FECAllYears[!(is.na(FECAllYears$VOTES) & is.na(FECAllYears$PERCENT)),]

#Check for candidates missing percentage
print(FECAllYears[is.na(FECAllYears$PERCENT),])
#See 2004congresults.xls, cell P3615=P3625, which is clearly an error.
#Mr. Said never made it out of the primaries, so he will be dropped.
FECAllYears <- FECAllYears[FECAllYears$KEY!="WA|S|Mohammad H.|Said|2004",]
#See results10.xls, cell P3615=P3625, which is clearly an error.
#Ms. Peckinpaugh seems to have legitimate information and the percentage is 
#missing.  Using P951/P959 to replace it.
FECAllYears$PERCENT[FECAllYears$KEY=="CT|2|Janet|Peckinpaugh|2010"] <- 
  round(95671/246809,digits=4)
print(FECAllYears[is.na(FECAllYears$PERCENT),]) #Verify the cases were handled.

#Check for candidates missing votes
print(FECAllYears[is.na(FECAllYears$VOTES),])

#Remove unwanted election information (information from non-states)
FECAllYears <- FECAllYears[!(FECAllYears$STATE %in% c("AS", "DC", 
                                                      "GU", "PR", 
                                                      "VI", "MP")),]
#Make sure there are 50 states after removal of the above elements.
stopifnot(length(unique(FECAllYears$STATE))==50)

#Get a variable called CANDIDATE that contains the full name to merge with the 
#NYTimes Data.
FECAllYears$CANDIDATE <- paste(FECAllYears$FIRST.NAME,FECAllYears$LAST.NAME)

#Remove Data that will not be used





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
print(unique(NYTElectionLong$PARTY)) #Check Recode

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

#Create Incumbent variable
NYTElectionLong$INCUMBENT <- as.numeric(substr(NYTElectionLong$CANDIDATE,
                                        nchar(NYTElectionLong$CANDIDATE),
                                        nchar(NYTElectionLong$CANDIDATE))=="*")

#Remove asterisks identifying incumbents from candidate names
NYTElectionLong$CANDIDATE <- gsub("[*]","",NYTElectionLong$CANDIDATE)



