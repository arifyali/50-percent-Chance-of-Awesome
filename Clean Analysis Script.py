
# coding: utf-8

# In[40]:

import pandas
import numpy as np

outputLog = pandas.DataFrame(index = ['file', 'column', "data type", 'summary', 'missing values', 'length'])
outputLog = outputLog.transpose()
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


# In[43]:

def cleaniness(filePath, outputLog, csv = True, sheet = 2):
    T = outputLog
    if(csv):
        data = pandas.read_csv(filePath)
    else:
        #FEC data we had was in XLS format, so we had to figure out how to import XLS data 
        #http://pandas.pydata.org/pandas-docs/stable/generated/pandas.ExcelFile.parse.html
        data = pandas.ExcelFile(filePath)
        data = data.parse(data.sheet_names[sheet-1])
    data.count(axis = 1)
    for column in data.columns:
        #Pandas sets missing values to nan so I found an answer on a stackexchange post
        #http://stackoverflow.com/questions/26266362/how-to-count-the-nan-values-in-the-column-in-panda-data-frame
        summary = data[column].describe()
        #print(data[column].dtype)
        missingValue = (data[column].isnull().sum() + textUncleanCounter(data[column]))
        #print(missingValue)
        
        columndata = (pandas.DataFrame(data = [filePath, column,data[column].dtype, summary, missingValue, len(data[column])],index = ['file', 'column',"data type", 'summary', 'missing values', 'length']))
        T = T.append(columndata.transpose())
    return(T)


# In[3]:

outputLog = outputLog.append(cleaniness("SP500HistoricalDataPart1.csv", outputLog))
#outputLog.to_csv("OutputLog.csv")


# In[4]:

outputLog = outputLog.append(cleaniness("SP500HistoricalDataPart2.csv", outputLog))
#outputLog.to_csv("OutputLog.csv")


# In[5]:

outputLog = outputLog.append(cleaniness("dJIndustialHistoricalData.csv", outputLog))
#outputLog.to_csv("OutputLog.csv")


# In[6]:

outputLog = outputLog.append(cleaniness("Sector base Indices/CBOE Gold Index.csv", outputLog))
#outputLog.to_csv("OutputLog.csv")           


# In[7]:

outputLog = outputLog.append(cleaniness("Sector base Indices/NASDAQ Banking Index.csv", outputLog))
#outputLog.to_csv("OutputLog.csv")


# In[8]:

outputLog = outputLog.append(cleaniness("Sector base Indices/NASDAQ Biotechnology Index.csv", outputLog))
#outputLog.to_csv("OutputLog.csv")


# In[9]:

outputLog = outputLog.append(cleaniness("Sector base Indices/NASDAQ Industrial Index.csv", outputLog))
#outputLog.to_csv("OutputLog.csv")


# In[10]:

outputLog = outputLog.append(cleaniness("Sector base Indices/NYSE AMEX Oil Index.csv", outputLog))


# In[11]:

#NaN were messing up the basic analysis, so I had replaces them with zeros
# I found out how from the pandas developer site
#http://pandas.pydata.org/pandas-docs/stable/missing_data.html
nytimesTemp = pandas.read_csv("NYTimes2014elections.csv").fillna('00')


# In[12]:

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


# In[13]:

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


# In[14]:

nytimesTemp = nytimesTemp.replace('0', np.nan)
nytimesTemp = nytimesTemp.replace('00', np.nan)
nytimesTemp = nytimesTemp.replace(0, np.nan)
nytimesTemp.to_csv("nytimesTemps.csv")


# In[15]:

outputLog = outputLog.append(cleaniness("nytimesTemps.csv", outputLog))


# In[44]:

outputLog = outputLog.append(cleaniness("FEC Elections Data/2004congresults.xls", outputLog, csv = False, sheet = 2))


# In[45]:

outputLog = outputLog.append(cleaniness("FEC Elections Data/2008congresults.xls", outputLog, csv = False, sheet = 2))


# In[46]:

outputLog = outputLog.append(cleaniness("FEC Elections Data/2012congresults.xls", outputLog, csv = False, sheet = 4))


# In[48]:

outputLog = outputLog.append(cleaniness("Contributions by Industry 2012-2014.csv", outputLog))


# In[49]:

#I had a bunch of duplicating rows so I decided it would be easier to dedup. 
#It's probably costing me time but fixing function might take longer.
#http://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.drop_duplicates.html
#http://stackoverflow.com/questions/26469551/drop-duplicates-within-a-set
outputLog = outputLog.drop_duplicates(['file','column'])
outputLog.to_csv("Cleaning Analysis output.csv")

