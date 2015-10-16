
# coding: utf-8

# In[76]:

# In accordance with the class policies and Georgetown's Honor Code,
# I certify that, with the exceptions of the lecture notes and those
# items noted below, this work is my own. I know that I can speak to
# others about my code, but I cannot share the code itself.
# If I received any help, I have noted it

import pandas
import numpy as np

outPutLog = pandas.DataFrame(index = ['file', 'score'])
outPutLog = outPutLog.transpose()
#import enchant
def textUncleanCounter(column):
    count = 0
    for words in column:
        #found way to count upper case via this stackoverflow post
        #http://stackoverflow.com/questions/18129830/count-the-uppercase-letters-in-a-string
        #compared number of upper case to
        #print(words)
        #is.nan doesn't work for strings so I have to handle it in here
        #http://stackoverflow.com/questions/4843173/how-to-check-if-type-of-a-variable-is-string-in-python
        #used same logic for isinstance when dealing with unicode stuff.
        #Notable issues are that sometimes abbreviations aren't capitalized, I consider this an error because it
        #will affect merging.
        if(isinstance(words, str) or isinstance(words, unicode)):
            if(sum(1 for c in words if c.isupper()) == len(words.split())):
                count += 0
            else:
                count += 1
        else:
            #print(words)
            if(np.isnan(words)):
                count += 1
            else:
                count += 0
    return(count)


# In[77]:

def cleaniness(filePath, csv = True, sheet = 2):
    missingData = 0
    outliers = 0
    if(csv):
        data = pandas.read_csv(filePath)
    else:
        #FEC data we had was in XLS format, so we had to figure out how to import XLS data 
        #http://pandas.pydata.org/pandas-docs/stable/generated/pandas.ExcelFile.parse.html
        data = pandas.ExcelFile(filePath)
        data = data.parse(data.sheet_names[sheet-1])
    for column in data.columns:
        print(column)
        summary = data[column].describe()
        missing = ((data[column].isnull().sum() + textUncleanCounter(data[column])))
        #print(missing)
        missingData += missing
        if(data[column].dtype == 'float64' or data[column].dtype == 'int64'):
            outlier = sum(abs(data[column]-data[column].mean())>3*data[column].std())
            outliers += outlier
        else:
            outliers += 0
    #print(outliers)
    #print(missingData)
    ##Fixing the float was a pain, but good reminder that int and float do different things
    score = 1-float(outliers+missingData)/(2*data.shape[0]*data.shape[1])
    T = pandas.DataFrame(data = [filePath, score] ,index = ['file', 'score'])
    T = T.transpose()
    #print(T)
    return(T)


# In[78]:

outPutLog = outPutLog.append(cleaniness("SP500HistoricalDataPart1.csv"))


# In[79]:

outPutLog = outPutLog.append(cleaniness("SP500HistoricalDataPart2.csv"))
print(outPutLog)


# In[80]:

outPutLog = outPutLog.append(cleaniness("dJIndustialHistoricalData.csv"))
#outPutLog.to_csv("OutputLog.csv")


# In[81]:

outPutLog = outPutLog.append(cleaniness("Sector base Indices/CBOE Gold Index.csv"))
#outPutLog.to_csv("OutputLog.csv")           


# In[82]:

outPutLog = outPutLog.append(cleaniness("Sector base Indices/NASDAQ Banking Index.csv"))
#outPutLog.to_csv("OutputLog.csv")


# In[83]:

outPutLog = outPutLog.append(cleaniness("Sector base Indices/NASDAQ Biotechnology Index.csv"))
#outputLog.to_csv("OutputLog.csv")


# In[84]:

outPutLog = outPutLog.append(cleaniness("Sector base Indices/NASDAQ Industrial Index.csv"))
#outputLog.to_csv("OutputLog.csv")


# In[85]:

outPutLog = outPutLog.append(cleaniness("Sector base Indices/NYSE AMEX Oil Index.csv"))


# In[86]:

#NaN were messing up the basic analysis, so I had replaces them with zeros
# I found out how from the pandas developer site
#http://pandas.pydata.org/pandas-docs/stable/missing_data.html
nytimesTemp = pandas.read_csv("NYTimes2014elections.csv").fillna('00')


# In[87]:

#In order to actually evaluate the Nytimes I had to make changes to understand numeric data that was pulled as string
#had to remove percentage sign from VotePercent columns
#http://stackoverflow.com/questions/3559559/how-to-delete-a-character-from-a-string-using-python
def floatConverter(column, percentSign = True): #If no percent sign then there is a comma
    oldstr = column
    #print(oldstr[10])
    data = []
    for cell in oldstr:
        if(percentSign):
            cellNoPercent = (cell[:-1])
        else:
            cellNoPercent = cell.replace(",", "")
            #If there wasn't percent then they were whole numbers, many of which had 
        data.append(cellNoPercent)
    #Iterating and changing to floats wasnt working, so I found a method to do it to a list post cleaning        
    #http://stackoverflow.com/questions/4004550/converting-string-series-to-float-list-in-python
    
    return([float(x) for x in data])    
    
nytimesTemp['VotePercent1'] = floatConverter(nytimesTemp['VotePercent1'])
nytimesTemp['VotePercent2'] = floatConverter(nytimesTemp['VotePercent2'])
nytimesTemp['VotePercent3'] = floatConverter(nytimesTemp['VotePercent3'])
nytimesTemp['VotePercent4'] = floatConverter(nytimesTemp['VotePercent4'])
nytimesTemp['VotePercent5'] = floatConverter(nytimesTemp['VotePercent5'])
nytimesTemp['VotePercent6'] = floatConverter(nytimesTemp['VotePercent6'])
nytimesTemp['VotePercent7'] = floatConverter(nytimesTemp['VotePercent7'])
nytimesTemp['VotePercent8'] = floatConverter(nytimesTemp['VotePercent8'])
nytimesTemp['VotePercent9'] = floatConverter(nytimesTemp['VotePercent9'])
nytimesTemp['VotePercent10'] = floatConverter(nytimesTemp['VotePercent10'])
nytimesTemp['VotePercent11'] = floatConverter(nytimesTemp['VotePercent11'])
nytimesTemp['VotePercent12'] = floatConverter(nytimesTemp['VotePercent12'])


# In[88]:

nytimesTemp['Votes1'] = floatConverter(nytimesTemp['Votes1'],percentSign = False)
nytimesTemp['Votes2'] = floatConverter(nytimesTemp['Votes2'],percentSign = False)
nytimesTemp['Votes3'] = floatConverter(nytimesTemp['Votes3'],percentSign = False)
nytimesTemp['Votes4'] = floatConverter(nytimesTemp['Votes4'],percentSign = False)
nytimesTemp['Votes5'] = floatConverter(nytimesTemp['Votes5'],percentSign = False)
nytimesTemp['Votes6'] = floatConverter(nytimesTemp['Votes6'],percentSign = False)
nytimesTemp['Votes7'] = floatConverter(nytimesTemp['Votes7'],percentSign = False)
nytimesTemp['Votes8'] = floatConverter(nytimesTemp['Votes8'],percentSign = False)
nytimesTemp['Votes9'] = floatConverter(nytimesTemp['Votes9'],percentSign = False)
nytimesTemp['Votes10'] = floatConverter(nytimesTemp['Votes10'],percentSign = False)
nytimesTemp['Votes11'] = floatConverter(nytimesTemp['Votes11'],percentSign = False)
nytimesTemp['Votes12'] = floatConverter(nytimesTemp['Votes12'],percentSign = False)


# In[89]:

nytimesTemp = nytimesTemp.replace('0', np.nan)
nytimesTemp = nytimesTemp.replace('00', np.nan)
nytimesTemp = nytimesTemp.replace(0, np.nan)
nytimesTemp.to_csv("nytimesTemps.csv")


# In[90]:

outPutLog = outPutLog.append(cleaniness("nytimesTemps.csv"))


# In[91]:

outPutLog = outPutLog.append(cleaniness("FEC Elections Data/2004congresults.xls", csv = False, sheet = 2))


# In[92]:

outPutLog = outPutLog.append(cleaniness("FEC Elections Data/2008congresults.xls", csv = False, sheet = 2))


# In[93]:

outPutLog = outPutLog.append(cleaniness("FEC Elections Data/2012congresults.xls", csv = False, sheet = 4))


# In[94]:

outPutLog = outPutLog.append(cleaniness("Contributions by Industry 2012-2014.csv"))


# In[95]:

outPutLog = outPutLog.append(cleaniness("opensecret/fundingCongress.csv"))


# In[96]:

outPutLog.to_csv("Cleaning Analysis output.csv")

