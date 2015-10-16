# -*- coding: utf-8 -*-
# Project Part 1
# Group Name: 50% Chance of Awesome
# ANLY-501
# In accordance with the class policies and Georgetown's Honor Code,
# I certify that, with the exceptions of the lecture notes and those
# items noted below, this work is my own. I know that I can speak to
# others about my code, but I cannot share the code itself.
# If I received any help, I have noted it. 
#
# Script to get data from Opensecrets.org, via their APIs

# List of state abbreviations
states = {
        'AK','AL','AR','AZ','CA','CO','CT','DE','FL','GA','HI','IA','ID','IL','IN','KS','KY','LA','MA','MD','ME','MI','MN','MO','MS','MT','NC','ND','NE','NH','NJ','NM','NV','NY','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VA','VT','WA','WI','WV','WY',
}

# Import required packages
import json, requests
import csv
import pandas

# Comment out all keys but the one to be used - max of 200 calls per API per day per key
# apikey = '32426dda76cf84e7157b8f7b54b39239' #Josh's key
# apikey = '5a932418c68183c0d1532fd63b8c3273' #tim's key
# apikey = 'f42a62e774d19b225e4853f2e6486d82' #John's key
apikey = '7793241614c32302b7bc183cb210093b' #Arif's key

# API parameters
output = 'json'
data = []
cycle = '2012'

# get basic candidate info for 113th Congress, including ID code, using getLegislators API
for state in states: 
    url = "http://www.opensecrets.org/api/?method=getLegislators&id=" + state + "&apikey=" + apikey + '&output=' + output
    resp = requests.get(url=url)
    data.append(json.loads(resp.text)) 
    # http://stackoverflow.com/questions/6386308/http-requests-and-json-parsing-in-python

# candidate info comes in one chunk for each state; break it up into individuals
legislators = []    
for i in range(50):
        legislators.append(data[i]['response']['legislator'])

# creaate vector of candidate ID codes 
cid = []
for no in range(len(legislators)):
    for i in range(len(legislators[no])):    
        cid.append(legislators[no][i]['@attributes']['cid'])
        
### getLegislators API is only set up to give data on current (113th) Congress,
### HJ Rivera at Opensecrets was kind enough to send me CIDs for the 112th Congress
# read in 112th Congress CIDs, delete all US territories
cid112 = pandas.read_csv('112cong.csv')
cid112 = cid112[(cid112.State != 'District of Columbia') & (cid112.State != 'Guam') & (cid112.State != 'Virgin Islands') & (cid112.State != 'American Samoa') & (cid112.State != 'Puerto Rico')]
# http://stackoverflow.com/questions/15315452/selecting-with-complex-criteria-from-pandas-dataframe
cid112 = cid112.CID
cid112.index = range(len(cid112))
        
# get political contribution data by industry for each candidate in each year, using candIndustry API
data = []
for id in cid:
    url ="http://www.opensecrets.org/api/?method=candIndustry&cid=" + id + "&cycle=" + cycle + "&apikey=" + apikey + '&output=' + output
    resp = requests.get(url=url)
    data.append(json.loads(resp.text))
    
### Opensecrets.org has some bugged pages where contributions data by industry doesn't populate; 
### they break the API so I skipped over them manually
### Opensecrets has been notified of this bug, but didn't fix it in time for those pages to make it into our dataset
# These commands create new vectors of CIDs, starting after a bugged one, to be input into the candIndustry API
cid1 = cid[31:]
cid2 = cid[97:]
cid3 = cid[129:]
cid4 = cid[158:]
cid5 = cid[358:]
cid6 = cid[364:]
cid7 = cid[365:]

# the Name field in the data from the candIndustry API contains the candidate's party as well as their name,
# this loop strips the name and puts it into its own vector
party = []
for i in range(len(data)):
    party.append(data[i]['response']['industries']['@attributes']['cand_name'][-2:-1])
    # http://stackoverflow.com/questions/11922383/access-process-nested-objects-arrays-or-json
# dealing with bugged pages for 112th Congress, same procedure as 113th
cid1121 = cid112[127:]
cid1122 = cid112[201:]
cid1123 = cid112[401:]

# save data as CSV; API limited me to collecting data on one Congress per day, 
# so I saved each Congress' data separately and then combined them
csvname = "2012data.csv"
with open(csvname, 'wb') as csvfile:
    datawriter = csv.writer(csvfile, delimiter=',')        
    datawriter.writerow(['CID','Name','Party','Cycle','Industry','Industry Code','Total','PACs','Individuals','Origin','Last Updated', 'Source'])
    for i in range(len(data)):
        # some candidates only had contributions from 1 industry        
        if (len(data[i]['response']['industries']['industry'])==1):        
            datawriter.writerow([data[i]['response']['industries']['@attributes']['cid'],data[i]['response']['industries']['@attributes']['cand_name'].replace('','')[:-4],party[i],data[i]['response']['industries']['@attributes']['cycle'],data[i]['response']['industries']['industry']['@attributes']['industry_name'],data[i]['response']['industries']['industry']['@attributes']['industry_code'],data[i]['response']['industries']['industry']['@attributes']['total'],data[i]['response']['industries']['industry']['@attributes']['pacs'],data[i]['response']['industries']['industry']['@attributes']['indivs'],data[i]['response']['industries']['@attributes']['origin'],data[i]['response']['industries']['@attributes']['last_updated'],data[i]['response']['industries']['@attributes']['source']])
        else:        
            for j in range(len(data[i]['response']['industries']['industry'])):
                datawriter.writerow([data[i]['response']['industries']['@attributes']['cid'],data[i]['response']['industries']['@attributes']['cand_name'].replace('','')[:-4],party[i],data[i]['response']['industries']['@attributes']['cycle'],data[i]['response']['industries']['industry'][j]['@attributes']['industry_name'],data[i]['response']['industries']['industry'][j]['@attributes']['industry_code'],data[i]['response']['industries']['industry'][j]['@attributes']['total'],data[i]['response']['industries']['industry'][j]['@attributes']['pacs'],data[i]['response']['industries']['industry'][j]['@attributes']['indivs'],data[i]['response']['industries']['@attributes']['origin'],data[i]['response']['industries']['@attributes']['last_updated'],data[i]['response']['industries']['@attributes']['source']])
                
# combine 112th and 113th congress data
data = pandas.read_csv('2012data.csv')
data = data.append(pandas.read_csv('2014data.csv'))
pandas.DataFrame.to_csv(data,'Contributions by Industry 2012-2014.csv')

### Feature generation; I generated two features based on this dataset:
### candtotal is the total contributions from all industries that the candidate received in an election cycle
### industrypercent is the percentage of a candidates' total contributions in a cycle that came from each industry

cycles = {2012,2014}
# read in data
data = pandas.read_csv('Contributions by Industry 2012-2014.csv')
# delete extra column (index got duplicated at some point)
data = data.ix[:len(data),1:13]
# http://pandas.pydata.org/pandas-docs/stable/indexing.html
# create vector of unique candidate names
names = list(set(data.Name))
# create empty column for candtotal feature
data['candtotal'] = 0
for cycle in cycles:    
    for name in names:
        data.candtotal[(data.Name==name) & (data.Cycle==cycle)] = sum(data.Total[(data.Cycle == cycle) & (data.Name == name)])
# create empty column for industrypercent feature
data['industrypercent'] = 0
data.industrypercent = data.Total/data.candtotal
pandas.DataFrame.to_csv(data,'Contributions by Industry 2012-2014.csv')
