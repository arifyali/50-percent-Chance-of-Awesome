
# coding: utf-8

# In[1]:

import json
import requests
import urllib2
import pandas
import csv


# In[41]:

dJIndustial = pandas.read_csv("dowjonesIA.csv")
dJIndustialTickers = (dJIndustial['Ticker']).tolist()


# In[42]:

url = 'https://www.quandl.com/api/v3/datasets/YAHOO/'+dJIndustialTickers[0]+'.csv?api_key=p3bC2cMj_FbQGSDDjs4y'
data = pandas.read_csv(url)
#http://stackoverflow.com/questions/26763344/convert-pandas-column-to-datetime
#I had to subset data by date, so I needed to convert DataFrame column to Dates
data['Date']= pandas.to_datetime(data['Date'])
#I needed to create a datetime that Pandas would recognize so under Time Stamps I found it 
#http://pandas.pydata.org/pandas-docs/stable/timeseries.html
data = data.loc[(data.Date >pandas.datetime(2011,1,1))]
data['ticker'] = dJIndustialTickers[0] 
data['price change'] = data['Close'] - data['Open']
data['percentage change'] = data['price change']/data['Open']


# In[39]:




# In[43]:

for ticker in dJIndustialTickers[1:(len(dJIndustialTickers)-1)]:
    url = 'https://www.quandl.com/api/v3/datasets/YAHOO/'+ticker+'.csv?api_key=p3bC2cMj_FbQGSDDjs4y'
    company = pandas.read_csv(url)
    company['Date']= pandas.to_datetime(company['Date'])
    company = company.loc[(company.Date >pandas.datetime(2011,1,1))]
    company['ticker'] = ticker
    company['price change'] = company['Open'] - company['Close']
    company['percentage change'] = company['price change']/company['Open']
    print(ticker)
    data = data.append(company)


# In[44]:

data.to_csv("dJIndustialHistoricalData.csv")


# In[3]:

sNP500 = pandas.read_csv("SP500.csv")
sNP500Tickers = sNP500['Ticker']
sNP500Sector = sNP500['Sector']


# In[46]:

#did sNP500Tickers[0] first
url = 'https://www.quandl.com/api/v3/datasets/YAHOO/'+sNP500Tickers[0]+'.csv?api_key=p3bC2cMj_FbQGSDDjs4y'
data = pandas.read_csv(url)
data['Date']= pandas.to_datetime(data['Date'])
data = data.loc[(data.Date >pandas.datetime(2011,1,1))]
data['ticker'] = sNP500Tickers[0] 
data['Sector'] = sNP500Sector[0]
data['price change'] = data['Close'] - data['Open']
data['percentage change'] = data['price change']/data['Open']


# In[47]:

for i in range(1, 250):
    url = 'https://www.quandl.com/api/v3/datasets/YAHOO/'+sNP500Tickers[i]+'.csv?api_key=p3bC2cMj_FbQGSDDjs4y'
    try:
        company = pandas.read_csv(url)
        company['Date']= pandas.to_datetime(company['Date'])
        company = company.loc[(company.Date >pandas.datetime(2011,1,1))]
        company['ticker'] = sNP500Tickers[i] 
        company['Sector'] = sNP500Sector[i]
        company['price change'] = company['Open'] - company['Close']
        company['percentage change'] = company['price change']/company['Open']
        data = data.append(company)
    except:
        print(sNP500Tickers[i])


# In[48]:

data.to_csv("SP500HistoricalDataPart1.csv")


# In[4]:

url = 'https://www.quandl.com/api/v3/datasets/YAHOO/'+sNP500Tickers[250]+'.csv?api_key=p3bC2cMj_FbQGSDDjs4y'
data = pandas.read_csv(url)
data['Date']= pandas.to_datetime(data['Date'])
data = data.loc[(data.Date >pandas.datetime(2011,1,1))]
data['ticker'] = sNP500Tickers[0] 
data['Sector'] = sNP500Sector[0]


# In[5]:

for i in range(251, (len(sNP500)-1)):
    url = 'https://www.quandl.com/api/v3/datasets/YAHOO/'+sNP500Tickers[i]+'.csv?api_key=p3bC2cMj_FbQGSDDjs4y'
    try:
        company = pandas.read_csv(url)
        company['Date']= pandas.to_datetime(company['Date'])
        company = company.loc[(company.Date >pandas.datetime(2011,1,1))]
        company['ticker'] = sNP500Tickers[i] 
        company['Sector'] = sNP500Sector[i]
        company['price change'] = company['Open'] - company['Close']
        company['percentage change'] = company['price change']/company['Open']
        data = data.append(company)
    except:
        print(sNP500Tickers[i])


# In[6]:

data.to_csv("SP500HistoricalDataPart2.csv")


# In[ ]:

#For The NASDAQ Financial 100 Index, I found a list of certain stocks from as of 10/12/15
#https://indexes.nasdaqomx.com/Index/Weighting/IXF


# In[ ]:

#For The NASDAQ Biotechnology Index, I found a list of certain stocks from as of 10/12/15
#https://indexes.nasdaqomx.com/Index/Weighting/NBI

