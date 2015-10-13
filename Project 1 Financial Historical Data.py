
# coding: utf-8

# In[1]:

import json
import requests
import urllib2
import pandas
import csv


# In[2]:

dJIndustial = pandas.read_csv("dowjonesIA.csv")
dJIndustialTickers = (dJIndustial['Ticker']).tolist()


# In[3]:

url = 'https://www.quandl.com/api/v3/datasets/YAHOO/'+dJIndustialTickers[0]+'.csv?api_key=p3bC2cMj_FbQGSDDjs4y'
data = pandas.read_csv(url)
data['ticker'] = dJIndustialTickers[0] 


# In[4]:

for ticker in dJIndustialTickers[1:]:
    url = 'https://www.quandl.com/api/v3/datasets/YAHOO/'+ticker+'.csv?api_key=p3bC2cMj_FbQGSDDjs4y'
    company = pandas.read_csv(url)
    company['ticker'] = ticker 
    data = data.append(company)


# In[5]:

data.to_csv("dJIndustialHistoricalData.csv")


# In[6]:

sNP500 = pandas.read_csv("SP500.csv")
sNP500Tickers = sNP500['Ticker']
sNP500Sector = sNP500['Sector']


# In[7]:

#did sNP500Tickers[0] first
url = 'https://www.quandl.com/api/v3/datasets/YAHOO/'+sNP500Tickers[0]+'.csv?api_key=p3bC2cMj_FbQGSDDjs4y'
data = pandas.read_csv(url)
data['ticker'] = sNP500Tickers[0] 
data['Sector'] = sNP500Sector[0] 


# In[8]:

for i in range(1, 250):
    url = 'https://www.quandl.com/api/v3/datasets/YAHOO/'+sNP500Tickers[i]+'.csv?api_key=p3bC2cMj_FbQGSDDjs4y'
    try:
        company = pandas.read_csv(url)
        company['ticker'] = sNP500Tickers[i] 
        company['Sector'] = sNP500Sector[i] 
        data = data.append(company)
    except:
        print(sNP500Tickers[i])


# In[9]:

data.to_csv("SP500HistoricalDataPart1.csv")


# In[10]:

url = 'https://www.quandl.com/api/v3/datasets/YAHOO/'+sNP500Tickers[250]+'.csv?api_key=p3bC2cMj_FbQGSDDjs4y'
data = pandas.read_csv(url)
data['ticker'] = sNP500Tickers[0] 
data['Sector'] = sNP500Sector[0] 


# In[19]:

for i in range(251, (len(sNP500)-1)):
    url = 'https://www.quandl.com/api/v3/datasets/YAHOO/'+sNP500Tickers[i]+'.csv?api_key=p3bC2cMj_FbQGSDDjs4y'
    try:
        company = pandas.read_csv(url)
        company['ticker'] = sNP500Tickers[i] 
        company['Sector'] = sNP500Sector[i] 
        data = data.append(company)
    except:
        print(sNP500Tickers[i])


# In[20]:

data.to_csv("SP500HistoricalDataPart2.csv")


# In[27]:

#For The NASDAQ Financial 100 Index, I found a list of certain stocks from as of 10/12/15
#https://indexes.nasdaqomx.com/Index/Weighting/IXF


# In[ ]:

#For The NASDAQ Biotechnology Index, I found a list of certain stocks from as of 10/12/15
#https://indexes.nasdaqomx.com/Index/Weighting/NBI

