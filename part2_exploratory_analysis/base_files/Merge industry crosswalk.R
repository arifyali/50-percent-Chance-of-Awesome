# Merging industry crosswalk with political data
library(RSQLite)
names(Industry.Crosswalk) = c("INDUSTRY", "PRIMARY INDUSTRY", "SECONDARY INDUSTRY 1", "SECONDARY INDUSTRY 2", "SECONDARY INDUSTRY 3")
OpenSecretsFECIndustry = merge(OpenSecretsFECmerged,Industry.Crosswalk,by="INDUSTRY",all=TRUE)
OpenSecretsFECIndustry = OpenSecretsFECIndustry[,c(1,3:ncol(OpenSecretsFECIndustry))]
names(OpenSecretsFECIndustry)[1] = "OPENSECRETS INDUSTRY"
# remove donation amounts <=0; these must be errors
OpenSecretsFECIndustry = OpenSecretsFECIndustry[OpenSecretsFECIndustry$AMOUNT>0,]
# clean up industries
OpenSecretsFECIndustry$PRIMARY.INDUSTRY[OpenSecretsFECIndustry$PRIMARY.INDUSTRY=="not for profit"] = "Not for profit"


write.csv(OpenSecretsFECIndustry,file = "OpenSecretsFECIndustry.csv")
