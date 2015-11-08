##### Merge Contributions by Industry 2012-2014.csv and FundingCongress.csv
setwd("~/Documents/Analytics 501 Fall 2015/50-percent-Chance-of-Awesome/part2_exploratory_analysis/OpenSecrets/")
FundingCongress <- read.csv("FundingCongress.csv")

# this is used to index where the party symbol is in the candidate column
# Used this stackoverflow link to figure out how to select the last occurrence and '(' and ')'
# http://stackoverflow.com/questions/5214677/r-find-the-last-dot-in-a-string

Party_index_start = sapply(regexpr("\\([^\\(]*$", FundingCongress$Candidate), function(x){x[1]})+1
Party_index_end = sapply(regexpr("\\)[^\\)]*$", FundingCongress$Candidate), function(x){x[1]})-1
FundingCongress$Party = substr(FundingCongress$Candidate,Party_index_start, Party_index_end)

# Removes the Party symbol from candidate
FundingCongress$Name = substr(FundingCongress$Candidate, 1, Party_index_start-3)

names(FundingCongress)

# Checking the number os unique instances in each data frame column
mapply(function(x){length(unique(x))}, FundingCongress)

# We are a democracy, but let's be honest, it's near impossible for non democractic
# or Republican parties to get elected. It's better to list them as independent. 
# I looked at all non D or R parties and changed them to independent.
unique(FundingCongress$Party)

FundingCongress$Party[(FundingCongress$Party == "3")|(FundingCongress$Party == "L")|(FundingCongress$Party == "U")] = "I"

# Some districts are senate ones and some are House of Rep, so I'm indexing them
senate_index= grep('s', FundingCongress$District)

# remove the s and leading zeros
FundingCongress$District = as.character(as.numeric(gsub("[^0-9]","",FundingCongress$District)))

# places a capital S for the senate seats.
FundingCongress$District[senate_index] = paste0("S", FundingCongress$District[senate_index])

# State Abveviations should be capitalized for merging issues
FundingCongress$State = toupper(FundingCongress$State)

# checking to make sure duplicated rows are gone overall
FundingCongress = FundingCongress[!duplicated(FundingCongress),]

# Candidates with no industry funding don't help us, so they sounds be around.
FundingCongress = FundingCongress[complete.cases(FundingCongress),]

# since we seperated Name and Party, the candidate column isn't needed.
write.csv(FundingCongress[, -c(1,5)], "FundingCongress_cleaned.csv", row.names = F)
