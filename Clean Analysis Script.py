
# coding: utf-8

# In[1]:

import pandas
import numpy as np
#To check if words exists in the english language I found this package on stackoverflow
#http://stackoverflow.com/questions/3788870/how-to-check-if-a-word-is-an-english-word-with-python
#http://pythonhosted.org/pyenchant/
outputLog = pandas.DataFrame(index = ['file', 'column', "data type", 'summary', 'missing values'])
outputLog = outputLog.transpose()
#import enchant


# In[2]:

def cleaniness(filePath, outputLog, csv = True):
    T = outputLog
    if(csv):
        data = pandas.read_csv(filePath)
    else:
        data = pandas.read_table(filePath)
    data.count(axis = 1)
    for column in data.columns:
        #Pandas sets missing values to nan so I found an answer on a stackexchange post
        #http://stackoverflow.com/questions/26266362/how-to-count-the-nan-values-in-the-column-in-panda-data-frame
        summary = data[column].describe()
        missingValue = data[column].isnull().sum()/len(data[column])
        columndata = (pandas.DataFrame(data = [filePath, column,data[column].dtype, summary, missingValue],index = ['file', 'column',"data type", 'summary', 'missing values']))
        T = T.append(columndata.transpose())
    return(T)
outputLog = outputLog.append(cleaniness("Contributions by Industry 2012-2014.csv", outputLog))


# In[19]:

outputLog = outputLog.append(cleaniness("SP500HistoricalDataPart1.csv", outputLog))
#outputLog.to_csv("OutputLog.csv")


# In[20]:

outputLog = outputLog.append(cleaniness("SP500HistoricalDataPart2.csv", outputLog))
#outputLog.to_csv("OutputLog.csv")


# In[21]:

outputLog = outputLog.append(cleaniness("dJIndustialHistoricalData.csv", outputLog))
#outputLog.to_csv("OutputLog.csv")


# In[22]:

outputLog = outputLog.append(cleaniness("Sector base Indices/CBOE Gold Index.csv", outputLog))
#outputLog.to_csv("OutputLog.csv")           


# In[23]:

outputLog = outputLog.append(cleaniness("Sector base Indices/NASDAQ Banking Index.csv", outputLog))
#outputLog.to_csv("OutputLog.csv")


# In[24]:

outputLog = outputLog.append(cleaniness("Sector base Indices/NASDAQ Biotechnology Index.csv", outputLog))
#outputLog.to_csv("OutputLog.csv")


# In[25]:

outputLog = outputLog.append(cleaniness("Sector base Indices/NASDAQ Industrial Index.csv", outputLog))
#outputLog.to_csv("OutputLog.csv")


# In[26]:

outputLog = outputLog.append(cleaniness("Sector base Indices/NYSE AMEX Oil Index.csv", outputLog))
#I had a bunch of duplicating rows so I decided it would be easier to dedup. 
#It's probably costing me time but fixing function might take longer.
#http://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.drop_duplicates.html
#http://stackoverflow.com/questions/26469551/drop-duplicates-within-a-set


    

