setwd("~/Documents/Analytics 501 Fall 2015/50-percent-Chance-of-Awesome/")
political_data = read.csv("part2_exploratory_analysis/Datasets/PoldataSPIndustries.csv")

political_data_short = political_data[!duplicated(political_data[, c("YEAR", "STATE", "FIRST", "LAST", "DISTRICT", "PARTY")]),]


t.test(political_data_short$CANDTOTAL[political_data_short$PARTY=="R"],
       political_data_short$CANDTOTAL[political_data_short$PARTY=="D"])

t.test(political_data_short$CANDTOTAL[political_data_short$PARTY=="R" & political_data_short$INCUMBENT == 1],
       political_data_short$CANDTOTAL[political_data_short$PARTY=="D" & political_data_short$INCUMBENT == 1])

t.test(political_data_short$CANDTOTAL[political_data_short$INCUMBENT == 1],
       political_data_short$CANDTOTAL[political_data_short$INCUMBENT == 0])


Republicans = c()
Democrats = c()


for(i in unique(political_data_short$YEAR)){
  Total = length(political_data_short$CANDTOTAL[political_data_short$WINNER == 1 & political_data_short$YEAR == i])
  Republicans = c(Republicans,length(political_data_short$CANDTOTAL[political_data_short$WINNER == 1 & 
                                                        political_data_short$PARTY == "R" & 
                                                        political_data_short$YEAR == i])/Total)
  Democrats = c(Democrats, length(political_data_short$CANDTOTAL[political_data_short$WINNER == 1 & 
                                                        political_data_short$PARTY == "D" & 
                                                        political_data_short$YEAR == i])/Total)
  
}

winnings = data.frame(Democrats, Republicans, Year = unique(political_data_short$YEAR))  

plot(Republicans~Year, data=winnings, type = "l", ylim = c(0.4,0.6), col = "red")
lines(Democrats~Year, data=winnings, type = "l", col = "blue")


Republicans.finance = c()
Democrats.finance = c()


for(i in unique(political_data_short$YEAR)){
  #Total = length(political_data_short$CANDTOTAL[political_data_short$WINNER == 1 & political_data_short$YEAR == i])
  Republicans.finance = c(Republicans.finance,sum(political_data_short$CANDTOTAL[
                                                                      political_data_short$PARTY == "R" & 
                                                                      political_data_short$YEAR == i]))
  Democrats.finance = c(Democrats.finance, sum(political_data_short$CANDTOTAL[ 
                                                                   political_data_short$PARTY == "D" & 
                                                                   political_data_short$YEAR == i]))
  
}

winnings.finance = data.frame(Democrats.finance, Republicans.finance, Year = unique(political_data_short$YEAR))  

plot(y = winnings.finance$Republicans.finance, x = winnings.finance$Year, type = "l", col = "red")
lines(y = winnings.finance$Democrats.finance, x = winnings.finance$Year, type = "l", col = "blue")

cor(c(Republicans, Democrats), c(Republicans.finance, Democrats.finance))
