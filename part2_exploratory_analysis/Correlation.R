PoldataSPIndustries$YrStDis <- paste(PoldataSPIndustries$YEAR,PoldataSPIndustries$STATE,PoldataSPIndustries$DISTRICT,sep="-")

RaceTotals <- aggregate(PoldataSPIndustries$AMOUNT ~ PoldataSPIndustries$YEAR + PoldataSPIndustries$STATE + 
                PoldataSPIndustries$DISTRICT, data=PoldataSPIndustries, sum)

names(RaceTotals) <- c("Year","State","District","Total")
RaceTotals$YrStDis <- paste(RaceTotals$Year,RaceTotals$State,RaceTotals$District,sep="-")

PoldataSPIndustries <- merge(PoldataSPIndustries,RaceTotals[,c("Total","YrStDis")],by="YrStDis")
PoldataSPIndustries$RaceFundPerc <- NULL
i <- 1

for (j in 1:length(PoldataSPIndustries$RaceFundPerc)){
  PoldataSPIndustries$RaceFundPerc[i] <- PoldataSPIndustries$CANDTOTAL[i]/PoldataSPIndustries$Total[i]
  i <- i+1
}

PSPI_numeric = PoldataSPIndustries[,c(4,11,12,13,15,16,24,25)]
cor(na.omit(PSPI_numeric))