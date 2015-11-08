##### Merge Contributions by Industry 2012-2014.csv and FundingCongress.csv
setwd("~/Documents/Analytics 501 Fall 2015/50-percent-Chance-of-Awesome/part2_exploratory_analysis/OpenSecrets/")
Contributions_by_Industry_2012_2014 <- read.csv("Contributions by Industry 2012-2014.csv")
FundingCongress <- read.csv("FundingCongress.csv")



# this is used to index where the party symbol is in the candidate column
# Used this stackoverflow link to figure out how to select the last occurrence and '(' and ')'
# http://stackoverflow.com/questions/5214677/r-find-the-last-dot-in-a-string

Party_index_start = sapply(regexpr("\\([^\\(]*$", FundingCongress$Candidate), function(x){x[1]})+1
Party_index_end = sapply(regexpr("\\)[^\\)]*$", FundingCongress$Candidate), function(x){x[1]})-1
FundingCongress$Party = substr(FundingCongress$Candidate,Party_index_start, Party_index_end)

# Removes the Party symbol from candidate
FundingCongress$Name = substr(FundingCongress$Candidate, 1, Party_index_start-3)

# Changed name, so that rbind would not be confused.
colnames(FundingCongress)[7] = "Total"
colnames(FundingCongress)[4] = "Cycle"

names(Contributions_by_Industry_2012_2014)
# Unique ids needs to be created in order to apply the which function later in the process (not in the mood
# to build a SQL engine in R for only stacking because that's more useful for Merging)
# The ids are based on industry, cycle (year), party, and name. The idea is to avoid duplications
Contributions_by_Industry_2012_2014$unique_id_1 =paste0(Contributions_by_Industry_2012_2014$Name, 
                                  Contributions_by_Industry_2012_2014$Cycle, 
                                  Contributions_by_Industry_2012_2014$Party,
                                  Contributions_by_Industry_2012_2014$Industry)

names(FundingCongress)
FundingCongress$unique_id =paste0(FundingCongress$Name, 
                                  FundingCongress$Cycle, 
                                  FundingCongress$Party, 
                                  FundingCongress$Industry)

# subsetting only the columns that exist in both with remain
aa = Contributions_by_Industry_2012_2014[,
                                    which(names(Contributions_by_Industry_2012_2014) 
                                          %in% names(FundingCongress))]

# any data captured by Contributions_by_Industry_2012_2014 should not reappear so those rows are removed.
ab = FundingCongress[-which(FundingCongress$unique_id %in% Contributions_by_Industry_2012_2014$unique_id_1), 
                     which(names(FundingCongress) 
                             %in% names(Contributions_by_Industry_2012_2014))]


combined_open_secrets = rbind(aa, ab)
combined_open_secrets = combined_open_secrets[,-1]

mapply(unique,
       combined_open_secrets[combined_open_secrets$Industry ==
                               unique(combined_open_secrets$Industry)[89], 
                             -1])

# There were blank industries, it didn't make sense to keep them

write.csv(combined_open_secrets[combined_open_secrets$Industry !=
unique(combined_open_secrets$Industry)[89], 
], "combined_open_secrets.csv")
