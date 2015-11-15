##### Logistic Model ####
# Please change setwd to wherever "part2_exploratory_analysis" is
setwd("~/Documents/Analytics 501 Fall 2015/50-percent-Chance-of-Awesome/part2_exploratory_analysis/")
political_data = read.csv("PoldataSPIndustriesStockData no outliers.csv")

# Null Hypothesis: There is no relation between the YrPercentChange of Industry Stocks and the amount 
# an industry contributes the rank of that industry for comtribute to a candidate and if the candidate wins

model <- lm(YrPercentChange ~ CANDTOTAL + INDRANK + WINNER,data=political_data)
summary(model)

# Call:
#   lm(formula = YrPercentChange ~ CANDTOTAL + INDRANK + WINNER, 
#      data = political_data)
# 
# Residuals:
#   Min       1Q   Median       3Q      Max 
# -0.61350 -0.13918  0.01366  0.20836  0.63036 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept)  3.391e-01  5.919e-03  57.288  < 2e-16 ***
#   CANDTOTAL    6.517e-08  5.607e-09  11.623  < 2e-16 ***
#   INDRANK     -1.054e-02  9.713e-04 -10.855  < 2e-16 ***
#   WINNER      -3.062e-02  4.848e-03  -6.317 2.74e-10 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 0.255 on 15821 degrees of freedom
# Multiple R-squared:  0.01603,	Adjusted R-squared:  0.01584 
# F-statistic: 85.89 on 3 and 15821 DF,  p-value: < 2.2e-16

# The p-values for all three attributes is less than 0.05 and the overall F-Statistic P-value is 
# less than 0.05. Therefore we we reject the null hypothesis that none of these attributes affect
# an aggregate of the stock prices.

# Null Hyothesis: The Amount of Money and the Number of Industries back a candidate do not affect
# the chances of the candidate winning said election.
political_data = political_data[order(political_data$INDRANK, decreasing = T),]
Logit_pol_data = political_data[!duplicated(political_data[,c("STATE", "DISTRICT", "CANDIDATE", "YEAR")]),]

model <- lm(WINNER ~ CANDTOTAL + INDRANK,data=political_data)
summary(model)

# Call:
#   lm(formula = WINNER ~ CANDTOTAL + INDRANK, data = political_data)
# 
# Residuals:
#   Min      1Q  Median      3Q     Max 
# -1.3460 -0.3278  0.1191  0.3582  0.7281 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept) 1.787e-01  9.602e-03   18.61   <2e-16 ***
#   CANDTOTAL   5.666e-07  8.015e-09   70.69   <2e-16 ***
#   INDRANK     2.488e-02  1.581e-03   15.74   <2e-16 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 0.4181 on 15822 degrees of freedom
# Multiple R-squared:  0.2557,	Adjusted R-squared:  0.2556 
# F-statistic:  2717 on 2 and 15822 DF,  p-value: < 2.2e-16


# The p-values for all three attributes is less than 0.05 and the overall F-Statistic P-value is 
# less than 0.05. Therefore we we reject the null hypothesis that none of these attributes affect
# the winning outcome of a Candidate.


# t-test
# Null Hypothesis: An incumbent and a challenger receive the same amount of money
x = Logit_pol_data$CANDTOTAL[Logit_pol_data$INCUMBENT==1]
y = Logit_pol_data$CANDTOTAL[Logit_pol_data$INCUMBENT==0]


pol_t_test = t.test(x,y)
pol_t_test

# Welch Two Sample t-test
# 
# data:  x and y
# t = 35.004, df = 3640.8, p-value < 2.2e-16
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   412835.6 461826.3
# sample estimates:
#   mean of x mean of y 
# 742476.6  305145.6

# Due to the p-value being less than .05, we would reject the null hypothesis, which leads us to accept
# the alternative hypothesis which is that a candidates status of being an incumbent affects the amount of
# money received. Based on the mean, being an incumbent indicates better corporate funding.
