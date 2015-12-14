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

plot(Republicans~Year, data=winnings, type = "l", ylim = c(0.4,0.6), col = "red", ylab = "Percentage of Winners by Party")
lines(Democrats~Year, data=winnings, type = "l", col = "blue")
legend(x = "topleft", legend = c("Dem", "Rep"), col = c("blue", "red"), lty = 1)

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

plot(Republicans.finance~Year, data =winnings.finance, type = "l", col = "red", ylab = "Total Contributions by Party")
lines(Democrats.finance~Year,data =winnings.finance, type = "l", col = "blue")
legend(x = "topleft", legend = c("Dem", "Rep"), col = c("blue", "red"), lty = 1)

cor(c(Republicans, Democrats), c(Republicans.finance, Democrats.finance))

### SVM Implimentation
# Use Candidate Total to predict 
political_data_short$ID = (political_data_short$WINNER)
political_data_short$PARTY = as.character(political_data_short$PARTY)
political_data_short$ID = paste0(political_data_short$PARTY, political_data_short$INCUMBENT, political_data_short$WINNER)
# Id which will be the SVM response variable combines party, incumbent status, and winner.

for(i in 1:length(unique(political_data_short$ID))){
  print(unique(political_data_short$ID)[i])
  print(i)
  political_data_short$ID[political_data_short$ID==unique(political_data_short$ID)[i]] = i
}

# [1] "R11"
# [1] 1
# [1] "I00"
# [1] 2
# [1] "D00"
# [1] 3
# [1] "D11"
# [1] 4
# [1] "R00"
# [1] 5
# [1] "D10"
# [1] 6
# [1] "D01"
# [1] 7
# [1] "R01"
# [1] 8
# [1] "R10"
# [1] 9
# [1] "I01"
# [1] 10
# [1] "I11"
# [1] 11
political_data_short$ID = as.factor(as.numeric(political_data_short$ID))
k = 5
for(i in 1:k){
  index = sample(nrow(political_data_short), nrow(political_data_short)*(k-1)/k)
  train = political_data_short[index,]
  test = political_data_short[-index,]
  
  cv.pd = svm(ID~CANDTOTAL, data = train)
  test.predictions = predict(object = cv.pd, newdata = test)
  print(mean(test.predictions == test$ID))
}
table(test.predictions, test$ID)
# The SVM looked at different classifications. Based on the last table
# it confirms our theory that party doesn't matter as much because winners
# of one party are classified as winners from another party at an unusally high rate.
