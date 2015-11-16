##### Logistic Model ####
# Please change setwd to wherever "part2_exploratory_analysis" is
setwd("~/Documents/Analytics 501 Fall 2015/50-percent-Chance-of-Awesome/part2_exploratory_analysis/")
political_data = read.csv("PoldataSPIndustriesStockData no outliers.csv")

# Null Hyothesis: The Amount of Money and the Number of Industries backinf a candidate do not affect
# the chances of the candidate winning said election.
political_data = political_data[order(political_data$INDRANK, decreasing = T),]
Logit_pol_data = political_data[!duplicated(political_data[,c("STATE", "DISTRICT", "CANDIDATE", "YEAR")]),]

model <- glm(WINNER ~ CANDTOTAL + INDRANK,data=Logit_pol_data, family = "binomial")
summary(model)

# Call:
#   glm(formula = WINNER ~ CANDTOTAL + INDRANK, family = "binomial", 
#       data = Logit_pol_data)
# 
# Deviance Residuals: 
#   Min       1Q   Median       3Q      Max  
# -3.1271  -0.6817   0.2709   0.7789   2.1813  
# 
# Coefficients:
#   Estimate Std. Error z value Pr(>|z|)    
# (Intercept) -4.711e+00  2.132e-01  -22.09   <2e-16 ***
#   CANDTOTAL    3.405e-06  1.295e-07   26.30   <2e-16 ***
#   INDRANK      4.718e-01  2.704e-02   17.45   <2e-16 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
# Null deviance: 5057.5  on 3668  degrees of freedom
# Residual deviance: 3351.9  on 3666  degrees of freedom
# AIC: 3357.9
# 
# Number of Fisher Scoring iterations: 5


# Number of Fisher Scoring iterations: 5
# The p-values for all three attributes is less than 0.05 and the overall F-Statistic P-value is 
# less than 0.05. Therefore we we reject the null hypothesis that none of these attributes affect
# the winning outcome of a Candidate in favor of the alternative hypthesis.

# In order to figure out ROC curves
# http://stackoverflow.com/questions/18449013/r-logistic-regression-area-under-curver
estimatedwinners = predict(model, type = c("response"))
estimatedwinners[estimatedwinners<.5] = 0
estimatedwinners[estimatedwinners>=.5] = 1
Logit_pol_data$prob = estimatedwinners
library(pROC)
g = roc(WINNER ~ CANDTOTAL + INDRANK,data=Logit_pol_data)
plot(g$CANDTOTAL, main = "CANDTOTAL")
plot(g$INDRANK, main = "Number of Industries")

#confusion matrix 
table(Logit_pol_data$WINNER,Logit_pol_data$prob)
#    0    1
# 0 1273  399
# 1  267 1730


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
