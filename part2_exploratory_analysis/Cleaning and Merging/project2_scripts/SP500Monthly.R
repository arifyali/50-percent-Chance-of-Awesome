# Remove duplicate data for "MMM" from Part 2 data frame
SP500HistoricalDataPart2 <- SP500HistoricalDataPart2[2968:686993,]

# Combine select variables of Part 1 and Part 2 data frames to create master data frame
SP500data <- rbind(SP500HistoricalDataPart1[,c(2,8,9,10)],SP500HistoricalDataPart2[,c(2,8,9,10)])

# Convert 'Date' to Date data type
SP500data$Date <- as.Date(SP500data$Date)

# Check frequency of each date
DateFreq <- as.data.frame(table(SP500data$Date)) 
# Frequency jumps from 6 to 81 to 438 and maxes out at 492

# Remove all dates with less than 82 occurences due to unknown reasons for data on non-trading dates
SP500data <- SP500data[!table(SP500data$Date)[as.character(SP500data$Date)]<82,]

# Create a vector of each last date of each month of each year
AllDates <- SP500data$Date
day <- format(AllDates,format="%d")
MonthYr <- format(AllDates,format="%Y-%m")
LastDay <- tapply(day,MonthYr, max)
MonthClose <- as.Date(paste(row.names(LastDay),LastDay,sep="-"))

# Subset data frame to only include the last day of each month
# Remove October 2015 since only partial month
SP500Monthly <- SP500data[SP500data$Date %in% MonthClose[1:141],]

# Sort data by Date and Ticker
SP500Monthly <- SP500Monthly[order(SP500Monthly[,3],SP500Monthly[,1]),]

# Create a new variable, PercentChange, which measures the percentage change 
# of the adjusted close price of a stock from the previous month
SP500Monthly$PercentChange <- NA
i <- 1

while (i < length(SP500Monthly$Date)){
        if (SP500Monthly$ticker[i] == SP500Monthly$ticker[i+1]){
                SP500Monthly$PercentChange[i+1] <- (SP500Monthly$Adjusted.Close[i+1]-SP500Monthly$Adjusted.Close[i])/SP500Monthly$Adjusted.Close[i]
                i <- i+1
        } else {
                i <- i+1
        }
}
