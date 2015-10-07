# -*- coding: utf-8 -*-
"""
Created on Mon Oct  5 17:16:51 2015

@author: joshuakaplan
"""
states = {
        'AK','AL','AR','AZ','CA','CO','CT','DE','FL','GA','HI','IA','ID','IL','IN','KS','KY','LA','MA','MD','ME','MI','MN','MO','MS','MT','NC','ND','NE','NH','NJ','NM','NV','NY','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VA','VT','WA','WI','WV','WY',
}

import urllib2
import json, requests
import csv
import pandas
apikey = '32426dda76cf84e7157b8f7b54b39239'
output = 'json'
data = []

for state in states: 
    url = "http://www.opensecrets.org/api/?method=getLegislators&id=" + state + "&apikey=" + apikey + '&output=' + output
    resp = requests.get(url=url)
    data.append(json.loads(resp.text)) 
# csvName = "legislatorinfo.csv"
legislators = []    
for i in range(50):
        legislators.append(data[i]['response']['legislator'])
cid = []
for no in range(len(legislators)):
    for i in range(len(legislators[no])):    
        cid.append(legislators[no][i]['@attributes']['cid'])
    #names.append(legislators)[no]['@attributes'][]
#with open(csvName, 'wb') as csvfile:
 #opensecretswriter = csv.writer(csvfile, delimiter=',')     
    #opensecretswriter.writerow()
#cycles = {'2012','2014'}
#for cycle in cycles
#data = []
for id in cid3:
    url ="http://www.opensecrets.org/api/?method=candIndustry&cid=" + id + "&cycle=" + '2012' + "&apikey=" + apikey + '&output=' + output
    resp = requests.get(url=url)
    data.append(json.loads(resp.text))
# to deal with blank pages
cid1 = cid[32:]
cid2 = cid[95:]
cid3 = cid[127:]
names = []
for no in range(len(data)):
    names.append(data[no]['response']['industries']['@attributes']['cand_name'])