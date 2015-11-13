##### Logistic Model ####
political_data = read.csv("OpenSecretsFECIndustry")
model <- glm(Survived ~.,family=binomial(link='logit'),data=train)
