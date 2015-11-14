SP500Monthly <- read.csv("C:/Users/Ahn/Desktop/50-percent-Chance-of-Awesome/part2_exploratory_analysis/SP500Monthly.csv", stringsAsFactors=FALSE)

closedates <- c("2004-12-31","2006-12-29","2008-12-31","2010-12-31","2012-12-31","2014-12-31")
SP500Yearly <- SP500Monthly[SP500Monthly$Date %in% closedates,]

# All the stock tickers with adjusted close values at the end of each congressional term
End2004 <- SP500Yearly$ticker[SP500Yearly$Date=="2004-12-31"]
End2006 <- SP500Yearly$ticker[SP500Yearly$Date=="2006-12-29"]
End2008 <- SP500Yearly$ticker[SP500Yearly$Date=="2008-12-31"]
End2010 <- SP500Yearly$ticker[SP500Yearly$Date=="2010-12-31"]
End2012 <- SP500Yearly$ticker[SP500Yearly$Date=="2012-12-31"]
End2014 <- SP500Yearly$ticker[SP500Yearly$Date=="2014-12-31"]

# All stock tickers appearing at the beginning and end of each congressional term
Tickers0506 <- Reduce(intersect, list(End2004,End2006))
Tickers0708 <- Reduce(intersect, list(End2006,End2008))
Tickers0910 <- Reduce(intersect, list(End2008,End2010))
Tickers1112 <- Reduce(intersect, list(End2010,End2012))
Tickers1314 <- Reduce(intersect, list(End2012,End2014))

# Create separate industry stock value totals for each congressional term
# where the stock tickers appeared at the beginning and end of the term
SectorValues0506a <- aggregate(SP500Yearly$Adjusted.Close[SP500Yearly$Date=="2004-12-31" & SP500Yearly$ticker %in% Tickers0506] 
                               ~ SP500Yearly$Sector[SP500Yearly$Date=="2004-12-31" & SP500Yearly$ticker %in% Tickers0506],data=SP500Yearly,sum)
SectorValues0506a$Group <- "Values0506a"
SectorValues0506b <- aggregate(SP500Yearly$Adjusted.Close[SP500Yearly$Date=="2006-12-29" & SP500Yearly$ticker %in% Tickers0506] 
                               ~ SP500Yearly$Sector[SP500Yearly$Date=="2006-12-29" & SP500Yearly$ticker %in% Tickers0506],data=SP500Yearly,sum)
SectorValues0506b$Group <- "Values0506b"

SectorValues0708a <- aggregate(SP500Yearly$Adjusted.Close[SP500Yearly$Date=="2006-12-29" & SP500Yearly$ticker %in% Tickers0708] 
                               ~ SP500Yearly$Sector[SP500Yearly$Date=="2006-12-29" & SP500Yearly$ticker %in% Tickers0708],data=SP500Yearly,sum)
SectorValues0708a$Group <- "Values0708a"
SectorValues0708b <- aggregate(SP500Yearly$Adjusted.Close[SP500Yearly$Date=="2008-12-31" & SP500Yearly$ticker %in% Tickers0708] 
                               ~ SP500Yearly$Sector[SP500Yearly$Date=="2008-12-31" & SP500Yearly$ticker %in% Tickers0708],data=SP500Yearly,sum)
SectorValues0708b$Group <- "Values0708b"

SectorValues0910a <- aggregate(SP500Yearly$Adjusted.Close[SP500Yearly$Date=="2008-12-31" & SP500Yearly$ticker %in% Tickers0910] 
                               ~ SP500Yearly$Sector[SP500Yearly$Date=="2008-12-31" & SP500Yearly$ticker %in% Tickers0910],data=SP500Yearly,sum)
SectorValues0910a$Group <- "Values0910a"
SectorValues0910b <- aggregate(SP500Yearly$Adjusted.Close[SP500Yearly$Date=="2010-12-31" & SP500Yearly$ticker %in% Tickers0910] 
                               ~ SP500Yearly$Sector[SP500Yearly$Date=="2010-12-31" & SP500Yearly$ticker %in% Tickers0910],data=SP500Yearly,sum)
SectorValues0910b$Group <- "Values0910b"

SectorValues1112a <- aggregate(SP500Yearly$Adjusted.Close[SP500Yearly$Date=="2010-12-31" & SP500Yearly$ticker %in% Tickers1112] 
                               ~ SP500Yearly$Sector[SP500Yearly$Date=="2010-12-31" & SP500Yearly$ticker %in% Tickers1112],data=SP500Yearly,sum)
SectorValues1112a$Group <- "Values1112a"
SectorValues1112b <- aggregate(SP500Yearly$Adjusted.Close[SP500Yearly$Date=="2012-12-31" & SP500Yearly$ticker %in% Tickers1112] 
                               ~ SP500Yearly$Sector[SP500Yearly$Date=="2012-12-31" & SP500Yearly$ticker %in% Tickers1112],data=SP500Yearly,sum)
SectorValues1112b$Group <- "Values1112b"

SectorValues1314a <- aggregate(SP500Yearly$Adjusted.Close[SP500Yearly$Date=="2012-12-31" & SP500Yearly$ticker %in% Tickers1314] 
                               ~ SP500Yearly$Sector[SP500Yearly$Date=="2012-12-31" & SP500Yearly$ticker %in% Tickers1314],data=SP500Yearly,sum)
SectorValues1314a$Group <- "Values1314a"
SectorValues1314b <- aggregate(SP500Yearly$Adjusted.Close[SP500Yearly$Date=="2014-12-31" & SP500Yearly$ticker %in% Tickers1314] 
                               ~ SP500Yearly$Sector[SP500Yearly$Date=="2014-12-31" & SP500Yearly$ticker %in% Tickers1314],data=SP500Yearly,sum)
SectorValues1314b$Group <- "Values1314b"

names(SectorValues0506a) <- c("Sector","AdjClose","Group")
names(SectorValues0506b) <- c("Sector","AdjClose","Group")
names(SectorValues0708a) <- c("Sector","AdjClose","Group")
names(SectorValues0708b) <- c("Sector","AdjClose","Group")
names(SectorValues0910a) <- c("Sector","AdjClose","Group")
names(SectorValues0910b) <- c("Sector","AdjClose","Group")
names(SectorValues1112a) <- c("Sector","AdjClose","Group")
names(SectorValues1112b) <- c("Sector","AdjClose","Group")
names(SectorValues1314a) <- c("Sector","AdjClose","Group")
names(SectorValues1314b) <- c("Sector","AdjClose","Group")

SectorValues <- rbind(SectorValues0506a,SectorValues0506b,SectorValues0708a,SectorValues0708b,SectorValues0910a,
                      SectorValues0910b,SectorValues1112a,SectorValues1112b,SectorValues1314a,SectorValues1314b)

# Sort data by Date and Ticker
SectorValues <- SectorValues[order(SectorValues[,1],SectorValues[,3]),]

# Create a new variable, YrPercentChange, which measures the annual percentage change 
# of the total adjusted close price of an industry from the previous year
SectorValues$YrPercentChange <- NA
i <- 1

while (i < length(SectorValues$Group)){
        if (SectorValues$Sector[i] == SectorValues$Sector[i+1]){
                SectorValues$YrPercentChange[i+1] <- (SectorValues$AdjClose[i+1]-SectorValues$AdjClose[i])/SectorValues$AdjClose[i]
                i <- i+1
        } else {
                i <- i+1
        }
}
SectorValues$YrPercentChange <- SectorValues$YrPercentChange * 100
SecYearlyChange <- SectorValues[grepl("b",SectorValues$Group),]

write.csv(SecYearlyChange, file="IndustryChangeByTerm.csv")
