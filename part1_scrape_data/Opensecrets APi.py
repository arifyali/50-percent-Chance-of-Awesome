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
# apikey = '32426dda76cf84e7157b8f7b54b39239' #Josh's key
# apikey = '5a932418c68183c0d1532fd63b8c3273' #tim's key
apikey = 'f42a62e774d19b225e4853f2e6486d82' #John's key
# apikey = '7793241614c32302b7bc183cb210093b' #Arif's key

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
#data = []
for id in cid7:
    url ="http://www.opensecrets.org/api/?method=candIndustry&cid=" + id + "&cycle=" + '2014' + "&apikey=" + apikey + '&output=' + output
    resp = requests.get(url=url)
    data.append(json.loads(resp.text))
# to deal with blank pages
cid1 = cid[31:]
cid2 = cid[97:]
cid3 = cid[129:]
cid4 = cid[158:]
cid5 = cid[358:]
cid6 = cid[364:]
cid7 = cid[365:]


# saves data as basic json file
# with open('2014data.json', 'w') as outfile:
#    json.dump(data, outfile)  
# with open('2014data.json', 'r') as infile:
#    data1 = json.load(infile)
party = []
for i in range(len(data)):
    party.append(data[i]['response']['industries']['@attributes']['cand_name'][-2:-1])

# trying to convert data to usable csv
csvname = "2014data.csv"
with open(csvname, 'wb') as csvfile:
    datawriter = csv.writer(csvfile, delimiter=',')        
    #datawriter.writerow(['CID', 'Name','Cycle','Origin','Last Updated', 'Source'])
    datawriter.writerow(['CID','Name','Party','Cycle','Industry','Industry Code','Total','PACs','Individuals','Origin','Last Updated', 'Source'])
    for i in range(len(data)):
        #datawriter.writerow([data[i]['response']['industries']['@attributes']['cid']],data[i]['response']['industries']['@attributes']['cand_name'],data[i]['response']['industries']['@attributes']['cycle'],data[i]['response']['industries']['@attributes']['origin'],data[i]['response']['industries']['@attributes']['last_updated'],data[i]['response']['industries']['@attributes']['source']])
        for j in range(len(data[i]['response']['industries']['industry'])):
            datawriter.writerow([data[i]['response']['industries']['@attributes']['cid'],data[i]['response']['industries']['@attributes']['cand_name'].replace('','')[:-4],party[i],data[i]['response']['industries']['@attributes']['cycle'],data[i]['response']['industries']['industry'][j]['@attributes']['industry_name'],data[i]['response']['industries']['industry'][j]['@attributes']['industry_code'],data[i]['response']['industries']['industry'][j]['@attributes']['total'],data[i]['response']['industries']['industry'][j]['@attributes']['pacs'],data[i]['response']['industries']['industry'][j]['@attributes']['indivs'],data[i]['response']['industries']['@attributes']['origin'],data[i]['response']['industries']['@attributes']['last_updated'],data[i]['response']['industries']['@attributes']['source']])
                
                
# This is how to access contribution data by industry
# for i in range(len(data)):
 #   for j in range(len(data[i]['response']['industries']['industry']))    
  #      data[i]['response']['industries']['industry'][j]
