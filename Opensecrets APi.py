# -*- coding: utf-8 -*-
"""
Created on Mon Oct  5 17:16:51 2015

@author: joshuakaplan
"""
states = {
        'AK','AL','AR','AZ','CA','CO','CT','DC','DE','FL','GA','HI','IA','ID','IL','IN','KS','KY','LA','MA','MD','ME','MI','MN','MO','MS','MT','NC','ND','NE','NH','NJ','NM','NV','NY','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VA','VT','WA','WI','WV','WY',
}

import urllib2
import json, requests
import csv
apikey = '32426dda76cf84e7157b8f7b54b39239'
output = 'json'
data = []

#for state in states: 
 #   url = "http://www.opensecrets.org/api/?method=getLegislators&id=" + state + "&apikey=" + apikey + '&output=' + output
  #  resp = requests.get(url=url)
   # data.append(json.loads(resp.text)) 
#csvName = "legislatorinfo.csv"
legislators = []    
for i in range(51):
    if len(data[i]['response']['legislator'])>1:        
        for no in range(len(data[i]['response']['legislator'])):
            legislators.append(data[i]['response']['legislator'][no])            
    else:
        legislators.append(data[i]['response']['legislator'])
cid = []
for no in range(len(legislators)):
    cid.append(legislators[no]['@attributes']['cid'])
    #names.append(legislators)[no]['@attributes'][]
#with open(csvName, 'wb') as csvfile:
 #opensecretswriter = csv.writer(csvfile, delimiter=',')     
    #opensecretswriter.writerow()
cycles = {'2012','2014'}
for cycle in cycles
    for id in cid:
        url ="http://www.opensecrets.org/api/?method=candIndustry&cid=" + id + "&cycle=" + cycle + "&apikey=" + apikey + '&output=' + output
            resp = requests.get(url=url)
            data.append(json.loads)
