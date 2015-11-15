### This histogram provides a visual representation of the distribution of
### monthly percentage changes of stock prices listed as part of the S&P 500 index.
### The red-shaded bars represent election years, the blue bars are non-election years.

# Split data set by election years and non-election years
SP500Monthly <- read.csv("C:/Users/Ahn/Desktop/50-percent-Chance-of-Awesome/part2_exploratory_analysis/SP500Monthly.csv", stringsAsFactors=FALSE)
Year <- as.numeric(format(as.Date(SP500Monthly$Date),format="%Y"))
OddYears <- SP500Monthly[Year%%2!=0,]
EvenYears <- SP500Monthly[Year%%2==0,]
# Create histograms based on election and non-election years and plot them together
OddHist <- hist(OddYears$PercentChange,breaks=100,plot=F)
EvenHist <- hist(EvenYears$PercentChange,breaks=50,plot=F)
plot(0,0,type="n",xlim=c(-60,60),ylim=c(1,10000),xlab="% Change",ylab="Frequency",main="Monthly Percentage Change Occurences")
plot(OddHist,col="blue",density=20,add=T)
plot(EvenHist,col="red",density=20,angle=135,add=T)
legend("topright",c("Election Year","Non-Election Year"),fill=c("red","blue"),density=20)



### This histogram provides a visual representation of the distribution of industry
### contribution amounts of $10,000 or more. The x-limits are set as [0,300000], but there are
### several outlier contributions up to $1,000,000 that are not shown for readability reasons.
### The red-shaded bars represent Republican donors, the blue bars are Democrat donors.
Donors <- read.csv("C:/Users/Ahn/Desktop/50-percent-Chance-of-Awesome/part2_exploratory_analysis/PoldataSPIndustriesStockData no outliers.csv", stringsAsFactors=FALSE)
Dems <- Donors$AMOUNT[Donors$PARTY=="D"]>=10000
Reps <- Donors$AMOUNT[Donors$PARTY=="R"]>=10000
DemDonors <- hist(Donors$AMOUNT[Dems],breaks=50,plot=F)
RepDonors <- hist(Donors$AMOUNT[Reps],breaks=50,plot=F)
plot(0,0,type="n",xlim=c(0,300000),ylim=c(1,6000),xlab="Contribution Amounts",ylab="Frequency",main="Industry Contribution Amounts to Candidates")
plot(DemDonors,col="blue",density=20,add=T)
plot(RepDonors,col="red",density=20,angle=135,add=T)
legend("topright",c("Democratic Contributions","Republican Contributions"),fill=c("blue","red"),density=20)



### This histogram provides a visual representation of the disparity of industry contribution sizes between
### winning and losing candidates. The green-shaded bars represent winning candidates and the 
### black-shaded bars represent the losing candidates.
### The interquartile range is being used for the purposes of this histogram.
PoldataSPIndustries <- read.csv("C:/Users/Ahn/Desktop/50-percent-Chance-of-Awesome/part2_exploratory_analysis/PoldataSPIndustries.csv", stringsAsFactors=FALSE)
# Find Interquartile Range to use for histogram data. Winners = [25500,157000], Losers = [1500,40500]
summary(PoldataSPIndustries$AMOUNT[PoldataSPIndustries$WINNER==1])
summary(PoldataSPIndustries$AMOUNT[PoldataSPIndustries$WINNER==0])
Winners <- PoldataSPIndustries$AMOUNT[PoldataSPIndustries$WINNER==1 & PoldataSPIndustries$AMOUNT>=25500 & PoldataSPIndustries$AMOUNT<=157000]
Losers <- PoldataSPIndustries$AMOUNT[PoldataSPIndustries$WINNER==0 & PoldataSPIndustries$AMOUNT>=1500 & PoldataSPIndustries$AMOUNT<=40500]
Windata <- hist(Winners,breaks=30,plot = F)
Losedata <- hist(Losers,breaks=10,plot = F)
plot(0,0,type="n",xlim=c(0,160000),ylim=c(0,3000),xlab="Industry Contribution Amounts",ylab="Frequency",main="Industry Contribution Amounts to Candidates (IQR)")
plot(Windata,col="green",density=20,add=T)
plot(Losedata,density=20,angle=135,add=T)
legend("topright",c("Winning Candidates","Losing Candidates"),fill=c("green","black"),density=20)



### This histogram shows the frequency of total contribution amounts to each candidate per
### election, distinguished by winning and losing candidates. The green-shaded bars represent
### winning candidates and the black-shaded bars represent the losing candidates.
### The interquartile range is used for the purposes of this histogram.
PoldataSPIndustries$UniqueCand <- paste(PoldataSPIndustries$YEAR,PoldataSPIndustries$CANDIDATE, sep="-")
WinnersTotal <- aggregate(PoldataSPIndustries$AMOUNT[PoldataSPIndustries$WINNER==1] 
                  ~ PoldataSPIndustries$UniqueCand[PoldataSPIndustries$WINNER==1],data=PoldataSPIndustries,sum)
names(WinnersTotal) <- c("Candidate","Amount")
LosersTotal <- aggregate(PoldataSPIndustries$AMOUNT[PoldataSPIndustries$WINNER==0] 
                  ~ PoldataSPIndustries$UniqueCand[PoldataSPIndustries$WINNER==0],data=PoldataSPIndustries,sum)
names(LosersTotal) <- c("Candidate","Amount")
# Find Interquartile Range to use for histogram data. Winners = [512500,1178000], Losers = [7416,395400]
summary(WinnersTotal$Amount)
summary(LosersTotal$Amount)
WinnersTotal <- WinnersTotal[WinnersTotal$Amount>=512500 & WinnersTotal$Amount<=1178000,]
LosersTotal <- LosersTotal[LosersTotal$Amount>=7416 & LosersTotal$Amount<=395400,]
# Create histograms based on winning and losing candidates and plot them together
WinTotalHist <- hist(WinnersTotal$Amount,breaks=10,plot=F)
LoseTotalHist <- hist(LosersTotal$Amount,breaks=10,plot=F)
plot(0,0,type="n",xlim=c(0,1250000),ylim=c(0,800),xlab="Total Contributions per Candidate",ylab="Frequency",main="Winning v Losing Candidate Total Funds Raised (IQR)")
plot(WinTotalHist,col="green",density=20,add=T)
plot(LoseTotalHist,density=20,angle=135,add=T)
legend("topright",c("Winning Candidates","Losing Candidates"),fill=c("green","black"),density=20)



###
PoldataSPIndustries <- read.csv("C:/Users/Ahn/Desktop/50-percent-Chance-of-Awesome/part2_exploratory_analysis/PoldataSPIndustriesStockData no outliers.csv", stringsAsFactors=FALSE)
# Find Interquartile Range to use for histogram data. Winners = [17610,67320], Losers = [1000,17050]
Winners <- PoldataSPIndustries$RaceFundPerc[PoldataSPIndustries$WINNER==1]
Losers <- PoldataSPIndustries$RaceFundPerc[PoldataSPIndustries$WINNER==0]
Windata <- hist(Winners,breaks=30,plot = F)
Losedata <- hist(Losers,breaks=30,plot = F)
plot(0,0,type="n",xlim=c(0,1),ylim=c(0,5000),xlab="% of Total Race Funds Raised",ylab="Frequency",main="Winning v Losing % of Funds Raised")
plot(Windata,col="green",density=20,add=T)
plot(Losedata,density=20,angle=135,add=T)
legend("topleft",c("Winning Candidates","Losing Candidates"),fill=c("green","black"),density=20)
