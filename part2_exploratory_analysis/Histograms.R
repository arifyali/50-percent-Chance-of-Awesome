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



### This histogram provides a visual representation of the distribution of industries
### that appear in the top 10 of each Congress candidates' contributors.
### The red-shaded bars represent Republican donors, the blue bars are Democrat donors.
Donors <- read.csv("C:/Users/Ahn/Desktop/50-percent-Chance-of-Awesome/part2_exploratory_analysis/OpenSecrets/FundingCongress_cleaned.csv", stringsAsFactors=FALSE)
Dems <- Donors$Amount[Donors$Party=="D"]>10000
Reps <- Donors$Amount[Donors$Party=="R"]>10000
DemDonors <- hist(Donors$Amount[Dems],breaks=1000,plot=F)
RepDonors <- hist(Donors$Amount[Reps],breaks=1000,plot=F)
plot(0,0,type="n",xlim=c(0,250000),ylim=c(1,15000),xlab="Contribution Amounts",ylab="Frequency",main="Industry Contribution Amounts to Candidates")
plot(DemDonors,col="blue",density=20,add=T)
plot(RepDonors,col="red",density=20,angle=135,add=T)
legend("topright",c("Democratic Contributions","Republican Contributions"),fill=c("blue","red"),density=20)



### This histogram shows the frequency of the number of candidates each unique industry
### appears in the top 10 of political contributions.
IndContrib <- as.data.frame(table(Donors$Industry))
hist(IndContrib$Freq,breaks=30,xlim=c(0,5000),ylim=c(0,25),xlab="# of Candidates Supported by each Industry",
        main = "Frequency of # of Candidates Each Industry Contributes To")



### This histogram provides a visual representation of the disparity of industry contribution sizes between
### winning and losing candidates
PoldataSPIndustries <- read.csv("C:/Users/Ahn/Desktop/50-percent-Chance-of-Awesome/part2_exploratory_analysis/PoldataSPIndustries.csv", stringsAsFactors=FALSE)
Winners <- PoldataSPIndustries$AMOUNT[PoldataSPIndustries$WINNER==1 & PoldataSPIndustries$AMOUNT>=25500 & PoldataSPIndustries$AMOUNT<=157000]
Losers <- PoldataSPIndustries$AMOUNT[PoldataSPIndustries$WINNER==0 & PoldataSPIndustries$AMOUNT>=1500 & PoldataSPIndustries$AMOUNT<=40500]
Windata <- hist(Winners,breaks=30,plot = F)
Losedata <- hist(Losers,breaks=10,plot = F)
plot(0,0,type="n",xlim=c(0,160000),ylim=c(0,3000),xlab="Industry Contribution Amounts",ylab="Frequency",main="Frequency of Industry Contributions to Candidates (IQR)")
plot(Windata,col="green",density=20,add=T)
plot(Losedata,density=20,angle=135,add=T)
legend("topright",c("Winning Candidates","Losing Candidates"),fill=c("green","black"),density=20)
