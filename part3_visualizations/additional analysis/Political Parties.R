setwd("~/Documents/Analytics 501 Fall 2015/50-percent-Chance-of-Awesome/")
political_data = read.csv("part2_exploratory_analysis/Datasets/PoldataSPIndustries.csv")

political_data_short = political_data[!duplicated(political_data[, c("YEAR", "STATE", "FIRST", "LAST", "DISTRICT", "PARTY")]),]


t.test(political_data_short$CANDTOTAL[political_data_short$PARTY=="R"],
       political_data_short$CANDTOTAL[political_data_short$PARTY=="D"])

