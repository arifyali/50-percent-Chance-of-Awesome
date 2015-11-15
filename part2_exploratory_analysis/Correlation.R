# Create a new variable to merge data sets by. We will join Year, State, and District to create a new, unique variable.
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
PoldataSPIndustries$RaceFundPerc <- NULL
i <- 1

for (j in 1:length(PoldataSPIndustries$RaceFundPerc)){
  PoldataSPIndustries$RaceFundPerc[i] <- PoldataSPIndustries$CANDTOTAL[i]/PoldataSPIndustries$TotalRaceFunds[i]
  i <- i+1
}

PSPI_numeric = PoldataSPIndustries[,c(4,11,12,13,15,16,24,25)]
cor(na.omit(PSPI_numeric))