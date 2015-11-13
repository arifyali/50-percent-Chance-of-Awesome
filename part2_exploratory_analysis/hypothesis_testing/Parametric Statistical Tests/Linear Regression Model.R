##### Logistic Model ####
political_data = read.csv("OpenSecretsFECIndustry.csv")

# Null Hypothesis: There is no linear relation between the percentage of votes and the rank of 
# industry contributions for the candidates



Logit_pol_data = political_data[!duplicated(political_data[,c("STATE", "DISTRICT", "CANDIDATE")]),]

# I'm standardizing the Candidate total contribution in order to better compare it to the vote percentages.
# Because this is a better representation of contribtuions compared to a ranking.


# Remove outliers does exactly what it is designed to, remove outliers. I found this on a stackoverflow board:
# http://stackoverflow.com/questions/4787332/how-to-remove-outliers-from-a-dataset


Logit_pol_data$CANDTOTAL = Logit_pol_data$CANDTOTAL/max(Logit_pol_data$CANDTOTAL)
model <- glm(PERCENT ~CANDTOTAL,data=Logit_pol_data)
summary(model)

# The B1 coefficient is 0.9519, thus we reject the null hypothesis in favor of the alternative 
# indicating that there is a somewhat linear relation between the Rank of donations by 
# candidate and the percentage of votes received. 