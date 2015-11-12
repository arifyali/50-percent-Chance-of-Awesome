# Merging industry crosswalk with political data
library(RSQLite)
names(Industry.Crosswalk) = c("INDUSTRY", "PRIMARY INDUSTRY", "SECONDARY INDUSTRY 1", "SECONDARY INDUSTRY 2", "SECONDARY INDUSTRY 3")
OpenSecretsFECIndustry = merge(OpenSecretsFECmerged,Industry.Crosswalk,by="INDUSTRY",all=TRUE)
OpenSecretsFECIndustry = OpenSecretsFECIndustry[,c(1,3:ncol(OpenSecretsFECIndustry))]
names(OpenSecretsFECIndustry)[1] = "OPENSECRETS INDUSTRY"

write.csv(OpenSecretsFECIndustry,file = "OpenSecretsFECIndustry")
