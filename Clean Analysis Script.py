
# coding: utf-8

# In[161]:

# In accordance with the class policies and Georgetown's Honor Code,
# I certify that, with the exceptions of the lecture notes and those
# items noted below, this work is my own. I know that I can speak to
# others about my code, but I cannot share the code itself.
# If I received any help, I have noted it

import pandas
import numpy as np

outPutLog = pandas.DataFrame(index = ['file', 'column',"data type", 'outlier', 'missing values', 'length', 'outlier score', 'Missing Data Score'])
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


# In[162]:

def cleaniness(filePath, outPutLog, csv = True, sheet = 2):
    T = pandas.DataFrame(index = ['file', 'column',"data type", 'outlier', 'missing values', 'length', 'outlier score', 'Missing Data Score'])
    T = T.transpose()
    if(csv):
        data = pandas.read_csv(filePath)
    else:
        #FEC data we had was in XLS format, so we had to figure out how to import XLS data 
        #http://pandas.pydata.org/pandas-docs/stable/generated/pandas.ExcelFile.parse.html
        data = pandas.ExcelFile(filePath)
        data = data.parse(data.sheet_names[sheet-1])
    print(len(data.columns))
    data.count(axis = 1)
    for column in data.columns:
        #Pandas sets missing values to nan so I found an answer on a stackexchange post
        #http://stackoverflow.com/questions/26266362/how-to-count-the-nan-values-in-the-column-in-panda-data-frame
        summary = data[column].describe()
        #print(data[column].dtype)
        missingValue = ((data[column].isnull().sum() + textUncleanCounter(data[column])))
        #print(missingValue)
        #I know what an outlier is, but the following code came about trying to find the standard deviation.
        #http://stackoverflow.com/questions/23199796/detect-and-exclude-outliers-in-pandas-dataframe
        if(data[column].dtype == 'float64' or data[column].dtype == 'int64'):
            outlier = sum(abs(data[column]-data[column].mean())>3*data[column].std())
        else:
            outlier = 0
        #print(outlier)    
        columndata = (pandas.DataFrame(data = [filePath, column,data[column].dtype ,outlier, missingValue, len(data[column])],index = ['file', 'column',"data type", 'outlier', 'missing values', 'length']))
        columndata = columndata.transpose()
        columndata['outlier score'] = (columndata['outlier']/columndata['length']).sum()
        print(columndata['outlier score'])
        columndata['Missing Data Score'] = (columndata['missing values']/columndata['length']).sum()
        T = T.append(columndata)
        

    return(T)


# In[164]:

outPutLog = outPutLog.append(cleaniness("SP500HistoricalDataPart1.csv", outPutLog))
#outPutLog.to_csv("OutputLog.csv")


# In[165]:

outPutLog = outPutLog.append(cleaniness("SP500HistoricalDataPart2.csv", outPutLog))
#outputLog.to_csv("OutputLog.csv")


# In[166]:

outPutLog = outPutLog.append(cleaniness("dJIndustialHistoricalData.csv", outPutLog))
#outPutLog.to_csv("OutputLog.csv")


# In[167]:

outPutLog = outPutLog.append(cleaniness("Sector base Indices/CBOE Gold Index.csv", outPutLog))
#outPutLog.to_csv("OutputLog.csv")           


# In[168]:

outPutLog = outPutLog.append(cleaniness("Sector base Indices/NASDAQ Banking Index.csv", outPutLog))
#outPutLog.to_csv("OutputLog.csv")


# In[169]:

outPutLog = outPutLog.append(cleaniness("Sector base Indices/NASDAQ Biotechnology Index.csv", outPutLog))
#outputLog.to_csv("OutputLog.csv")


# In[170]:

outPutLog = outPutLog.append(cleaniness("Sector base Indices/NASDAQ Industrial Index.csv", outPutLog))
#outputLog.to_csv("OutputLog.csv")


# In[171]:

outPutLog = outPutLog.append(cleaniness("Sector base Indices/NYSE AMEX Oil Index.csv", outPutLog))


# In[172]:

#NaN were messing up the basic analysis, so I had replaces them with zeros
# I found out how from the pandas developer site
#http://pandas.pydata.org/pandas-docs/stable/missing_data.html
nytimesTemp = pandas.read_csv("NYTimes2014elections.csv").fillna('00')


# In[173]:

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


# In[174]:

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


# In[175]:

nytimesTemp = nytimesTemp.replace('0', np.nan)
nytimesTemp = nytimesTemp.replace('00', np.nan)
nytimesTemp = nytimesTemp.replace(0, np.nan)
nytimesTemp.to_csv("nytimesTemps.csv")


# In[176]:

outPutLog = outPutLog.append(cleaniness("nytimesTemps.csv", outPutLog))


# In[177]:

outPutLog = outPutLog.append(cleaniness("FEC Elections Data/2004congresults.xls", outPutLog, csv = False, sheet = 2))


# In[178]:

outPutLog = outPutLog.append(cleaniness("FEC Elections Data/2008congresults.xls", outPutLog, csv = False, sheet = 2))


# In[179]:

outPutLog = outPutLog.append(cleaniness("FEC Elections Data/2012congresults.xls", outPutLog, csv = False, sheet = 4))


# In[180]:

outPutLog = outPutLog.append(cleaniness("Contributions by Industry 2012-2014.csv", outPutLog))


# In[181]:

outPutLog = outPutLog.append(cleaniness("opensecret/fundingCongress.csv", outPutLog))


# In[188]:

#I had a bunch of duplicating rows so I decided it would be easier to dedup. 
#It's probably costing me time but fixing function might take longer.
#http://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.drop_duplicates.html
#http://stackoverflow.com/questions/26469551/drop-duplicates-within-a-set
outPutLog.drop_duplicates(['file', 'column'])
outPutLog['Missing Data Score'] = outPutLog['missing values']/outPutLog['length']
outPutLog['outlier Score'] = outPutLog['outlier']/outPutLog['length']
outPutLog.to_csv("Cleaning Analysis output.csv")


# In[ ]:

#outPutLog.transpose().to_csv("Cleaning Analysis output.csv")


# In[187]:



