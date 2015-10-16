
# coding: utf-8

# In[10]:

import json#I ended up on needing this packages after finding out the API can output CSVs
import requests#I ended up on needing this packages after finding out the API can output CSVs
import urllib2#I ended up on needing this packages after finding out the API can output CSVs
import pandas
import csv#I thought I might need it


# In[11]:

#Quandl (the website used) required I use tickers and provided a csv with the tickers
dJIndustial = pandas.read_csv("dowjonesIA.csv")
##In hindsight, dJIndustial['Ticker'] would have been good enough
dJIndustialTickers = (dJIndustial['Ticker']).tolist()


# In[12]:

##I needed to set a base data case for my loop, therefore I look the first stock to set up the Pandas DataFrame
##The URL is set up based on the API info from Quandl. 
url = 'https://www.quandl.com/api/v3/datasets/YAHOO/'+dJIndustialTickers[0]+'.csv?api_key=p3bC2cMj_FbQGSDDjs4y'
data = pandas.read_csv(url)
#http://stackoverflow.com/questions/26763344/convert-pandas-column-to-datetime
#I had to subset data by date, so I needed to convert DataFrame column to Dates
data['Date']= pandas.to_datetime(data['Date'])
#I needed to create a datetime that Pandas would recognize so under Time Stamps I found it 
#http://pandas.pydata.org/pandas-docs/stable/timeseries.html
#We were able to obtain election data from 2004, so I grabs corresponding stock data
data = data.loc[(data.Date >pandas.datetime(2004,1,1))]
#good way of knowing the companies of data Im collecting is using tickers to identify
data['ticker'] = dJIndustialTickers[0] 
#feature 1
data['price change'] = data['Close'] - data['Open']
#feature 2
data['percentage change'] = data['price change']/data['Open']
#feature 3
data['Opening Total Value'] = data['Open']*data['Volume']
#feature 4
data['Closing Total Value'] = data['Close']*data['Volume']


# In[9]:

#In reality, I should have made this a function, but I was a bit overworked


# In[13]:

#For Loop, basically every thing from the base.
for ticker in dJIndustialTickers[1:(len(dJIndustialTickers)-1)]:
    url = 'https://www.quandl.com/api/v3/datasets/YAHOO/'+ticker+'.csv?api_key=p3bC2cMj_FbQGSDDjs4y'
    company = pandas.read_csv(url)
    company['Date']= pandas.to_datetime(company['Date'])
    company = company.loc[(company.Date >pandas.datetime(2004,1,1))]
    company['ticker'] = ticker
    company['price change'] = company['Open'] - company['Close']
    company['percentage change'] = company['price change']/company['Open']
    company['Opening Total Value'] = company['Open']*company['Volume']
    company['Closing Total Value'] = company['Close']*company['Volume']
    print(ticker)
    data = data.append(company)


# In[14]:

data.to_csv("dJIndustialHistoricalData.csv")


# In[2]:

#followed through on hindsight 
sNP500 = pandas.read_csv("SP500.csv")
sNP500Tickers = sNP500['Ticker']
#SP 500 had sector in the quandl provided csv, so I included it
sNP500Sector = sNP500['Sector']


# In[3]:

#did sNP500Tickers[0] first, as part of the base idea
url = 'https://www.quandl.com/api/v3/datasets/YAHOO/'+sNP500Tickers[0]+'.csv?api_key=p3bC2cMj_FbQGSDDjs4y'
data = pandas.read_csv(url)
data['Date']= pandas.to_datetime(data['Date'])
data = data.loc[(data.Date >pandas.datetime(2004,1,1))]
data['ticker'] = sNP500Tickers[0] 
data['Sector'] = sNP500Sector[0]
data['price change'] = data['Close'] - data['Open']
data['percentage change'] = data['price change']/data['Open']
data['Opening Total Value'] = data['Open']*data['Volume']
data['Closing Total Value'] = data['Close']*data['Volume']


# In[4]:

#I kept getting strange no response call errors so I limited the range
for i in range(1, 250):
    url = 'https://www.quandl.com/api/v3/datasets/YAHOO/'+sNP500Tickers[i]+'.csv?api_key=p3bC2cMj_FbQGSDDjs4y'
    #ran into errors when certain stock data was taken out, so I added try 
    #so for loop wouldn't break
    try:
        company = pandas.read_csv(url)
        company['Date']= pandas.to_datetime(company['Date'])
        company = company.loc[(company.Date >pandas.datetime(2004,1,1))]
        company['ticker'] = sNP500Tickers[i] 
        company['Sector'] = sNP500Sector[i]
        company['price change'] = company['Open'] - company['Close']
        company['percentage change'] = company['price change']/company['Open']
        company['Opening Total Value'] = company['Open']*company['Volume']
        company['Closing Total Value'] = company['Close']*company['Volume']

        data = data.append(company)
    except:
        #I wanted to know what and how many stocks failed
        print(sNP500Tickers[i])


# In[5]:

data.to_csv("SP500HistoricalDataPart1.csv")


# In[6]:

#Another For loop base
url = 'https://www.quandl.com/api/v3/datasets/YAHOO/'+sNP500Tickers[250]+'.csv?api_key=p3bC2cMj_FbQGSDDjs4y'
data = pandas.read_csv(url)
data['Date']= pandas.to_datetime(data['Date'])
data = data.loc[(data.Date >pandas.datetime(2004,1,1))]
data['ticker'] = sNP500Tickers[0] 
data['Sector'] = sNP500Sector[0]
data['price change'] = data['Close'] - data['Open']
data['percentage change'] = data['price change']/data['Open']
data['Opening Total Value'] = data['Open']*data['Volume']
data['Closing Total Value'] = data['Close']*data['Volume']


# In[7]:

##picked up remaining S&P 500
for i in range(251, (len(sNP500)-1)):
    url = 'https://www.quandl.com/api/v3/datasets/YAHOO/'+sNP500Tickers[i]+'.csv?api_key=p3bC2cMj_FbQGSDDjs4y'
    try:
        company = pandas.read_csv(url)
        company['Date']= pandas.to_datetime(company['Date'])
        company = company.loc[(company.Date >pandas.datetime(2004,1,1))]
        company['ticker'] = sNP500Tickers[i] 
        company['Sector'] = sNP500Sector[i]
        company['price change'] = company['Open'] - company['Close']
        company['percentage change'] = company['price change']/company['Open']
        company['Opening Total Value'] = company['Open']*company['Volume']
        company['Closing Total Value'] = company['Close']*company['Volume']

        data = data.append(company)
    except:
        print(sNP500Tickers[i])
        #after finishing, it turns out only stock I couldn't get was NAVI


# In[8]:

data.to_csv("SP500HistoricalDataPart2.csv")

