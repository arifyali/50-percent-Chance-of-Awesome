##### Logistic Model ####
# Please change setwd to wherever "part2_exploratory_analysis" is
setwd("~/Documents/Analytics 501 Fall 2015/50-percent-Chance-of-Awesome/part2_exploratory_analysis/")
political_data = read.csv("PoldataSPIndustriesStockData.csv")

# Null Hypothesis: There is no linear relation between the percentage of votes and the rank of 
# industry contributions by condidate for the candidates

model <- lm(YrPercentChange ~ CANDTOTAL + indrank + WINNER,data=political_data)
summary(model)

# Call:
#   lm(formula = YrPercentChange ~ CANDTOTAL + indrank + WINNER, 
#      data = political_data)
# 
# Residuals:
#   Min       1Q   Median       3Q      Max 
# -101.208  -13.349    2.522   24.508  106.927 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept)  2.993e+01  7.581e-01  39.479  < 2e-16 ***
#   CANDTOTAL    5.358e-07  2.065e-07   2.594  0.00949 ** 
#   indrank     -4.196e-01  1.302e-01  -3.222  0.00128 ** 
#   WINNER      -1.683e-01  5.680e-01  -0.296  0.76700    
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 38.21 on 20244 degrees of freedom
# Multiple R-squared:  0.0008614,	Adjusted R-squared:  0.0007134 
# F-statistic: 5.818 on 3 and 20244 DF,  p-value: 0.0005719

model <- lm(WINNER ~ CANDTOTAL + indrank,data=political_data)
summary(model)

# Call:
#   lm(formula = WINNER ~ CANDTOTAL + indrank, data = political_data)
# 
# Residuals:
#   Min      1Q  Median      3Q     Max 
# -1.9110 -0.5380  0.3038  0.3928  0.5530 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept) 4.087e-01  8.930e-03   45.76   <2e-16 ***
#   CANDTOTAL   6.911e-08  2.509e-09   27.54   <2e-16 ***
#   indrank     3.005e-02  1.598e-03   18.80   <2e-16 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 0.4728 on 20245 degrees of freedom
# Multiple R-squared:  0.05244,	Adjusted R-squared:  0.05235 
# F-statistic: 560.2 on 2 and 20245 DF,  p-value: < 2.2e-16


# t-test
# Null Hypothesis: There is no difference between the amount of money
# an incumbent receives vs what a challenger receives.
Logit_pol_data = political_data[!duplicated(political_data[,c("STATE", "DISTRICT", "CANDIDATE")]),]
x = Logit_pol_data$CANDTOTAL[Logit_pol_data$INCUMBENT==1]
y = Logit_pol_data$CANDTOTAL[Logit_pol_data$INCUMBENT==0]


pol_t_test = t.test(x,y)
pol_t_test

# Welch Two Sample t-test

# data:  x and y
# t = 12.351, df = 1003.8, p-value < 2.2e-16
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   786386.1 1083463.8
# sample estimates:
#   mean of x mean of y 
# 1432873.0  497948.1 


Logit_pol_data = political_data[!duplicated(political_data[,c("STATE", "DISTRICT", "CANDIDATE")]),]
x = Logit_pol_data$YrPercentChange[Logit_pol_data$INCUMBENT==1]
y = Logit_pol_data$YrPercentChange[Logit_pol_data$INCUMBENT==0]


pol_t_test = t.test(x,y)
pol_t_test

# Welch Two Sample t-test
# 
# data:  x and y
# t = 0.59683, df = 1694.7, p-value = 0.5507
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   -2.315327  4.340724
# sample estimates:
#   mean of x mean of y 
# 32.57581  31.56311 
