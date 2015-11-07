##### Merge Contributions by Industry 2012-2014.csv and FundingCongress.csv
setwd("~/Documents/Analytics 501 Fall 2015/50-percent-Chance-of-Awesome/part2_exploratory_analysis/")
Contributions_by_Industry_2012_2014 <- read.csv("Contributions by Industry 2012-2014.csv")
FundingCongress <- read.csv("FundingCongress.csv")

# Removes the Party symbol from candidate
FundingCongress$Name = gsub("\\((.*)", "",  FundingCongress$Candidate)
# Remove the last space after the last name 
FundingCongress$Name = substr(FundingCongress$Name, 1, nchar(FundingCongress$Name)-1)

##this is used to index where the party symbol is in the candidate column
Party_index = sapply(gregexpr("\\((.*)", FundingCongress$Candidate), function(x){x[1]})

FundingCongress$Party = substr(FundingCongress$Candidate,Party_index+1,Party_index+1)

# Changed name, so that rbind would not be confused.
colnames(FundingCongress)[7] = "Total"
colnames(FundingCongress)[4] = "Cycle"

names(Contributions_by_Industry_2012_2014)
# Unique ids needs to be created in order to apply the which function later in the process (not in the mood
# to build a SQL engine in R for only stacking because that's more useful for Merging)
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

write.csv(combined_open_secrets, "combined_open_secrets.csv")
