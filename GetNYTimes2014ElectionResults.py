print("Begin program: 2014 Election Results")

from bs4 import BeautifulSoup
import requests
import csv

stateNameList = ["alabama",        "alaska",        "arizona",
                 "arkansas",       "california",    "colorado",
                 "connecticut",    "delaware",      "florida",
                 "georgia",        "hawaii",        "idaho",
                 "illinois",       "indiana",       "iowa",
                 "kansas",         "kentucky",      "louisiana",
                 "maine",          "maryland",      "massachusetts",
                 "michigan",       "minnesota",     "mississippi",
                 "missouri",       "montana",       "nebraska",
                 "nevada",         "new-hampshire", "new-jersey",
                 "new-mexico",     "new-york",      "north-carolina",
                 "north-dakota",   "ohio",          "oklahoma",
                 "oregon",         "pennsylvania",  "rhode-island",
                 "south-carolina", "south-dakota",  "tennessee",
                 "texas",          "utah",          "vermont",
                 "virginia",       "washington",    "west-virginia",
                 "wisconsin",      "wyoming"]

stateAbbrevList = ["al", "ak", "az", "ar", "ca", "co", "ct", "de", "fl",
                   "ga", "hi", "id", "il" ,"in", "ia", "ks", "ky", "la",
                   "me", "md", "ma", "mi", "mn", "ms", "mo", "mt", "ne",
                   "nv", "nh", "nj", "nm", "ny", "nc", "nd", "oh", "ok",
                   "or", "pa", "ri", "sc", "sd", "tn", "tx", "ut", "vt",
                   "va", "wa", "wv", "wi", "wy"]

for stateNum in range (0,50):
    if stateNameList[stateNum]=="california":
        print("Current state =", stateNameList[stateNum])
        
        url = "http://elections.nytimes.com/2014/" + stateNameList[stateNum] + "-elections"
        page = requests.get(url)
        soup = BeautifulSoup(page.text, "lxml")

        csvName = stateNameList[stateNum] + "2014elections.csv"

        with open(csvName,"w", newline="", encoding="utf8") as csvfile:
            electionWriter = csv.writer(csvfile,delimiter=",")
            
            #id=
            #ALABAMA:
            #"race-al-house-district-1-2014-general"
            #"race-al-house-district-2-2014-general"
            #"race-al-house-district-#-2014-general"
            #"race-al-senate-class-ii-2014-general"
            #CALIFORNIA:
            #No Senate
            #race-ca-house-district-1-2014-general
            #race-ca-house-district-#-2014-general
            #IOWA:
            #race-ia-senate-class-ii-2014-general

            SenateRace = soup.find(id="race-" + stateAbbrevList[stateNum] + "-senate-class-ii-2014-general")
            if SenateRace!=None:
                DO
                
            houseDistrictNum = 1
            nextHouse = soup.find(id="race-" + stateAbbrevList[stateNum] + "-house-district-" + str(houseDistrictNum) + "-2014-general")
            while nextHouse!=None:
                data = []
                td = nextHouse.find_all("td")
                datastring = ""
                for i in range (0,len(td)):
                    currData = td[i].text.strip()
                    currData = currData.replace("\n","")
                    currData = " ".join(currData.split())
                    print(currData)
                    data.append(currData)
                    if i==0:
                        datastring = datastring + "data[" + str(i) + "]"
                    else:
                        datastring = datastring + ", data[" + str(i) + "]"
                electionWriter.writerow(eval(datastring))
                houseDistrictNum = houseDistrictNum + 1
                nextHouse = soup.find(id="race-" + stateAbbrevList[stateNum] + "-house-district-" + str(houseDistrictNum) + "-2014-general")



            

            #https://docs.python.org/3/library/functions.html#eval
            #http://stackoverflow.com/questions/961632/converting-integer-to-string-in-python
            #http://stackoverflow.com/questions/6496884/compress-whitespaces-in-string
            #http://www.tutorialspoint.com/python/string_join.htm
            #http://www.tutorialspoint.com/python/string_replace.htm
            #http://stackoverflow.com/questions/275018/how-can-i-remove-chomp-a-newline-in-python
            #http://stackoverflow.com/questions/1762484/how-to-find-the-position-of-an-element-in-a-list-in-python
                
            #for td in nexthouse.find_all("td"):
            #    print(td)
            #    test = td.text.strip()
            #    print(test)
                #for i in range (0,len(td)):
                 #   print(i)
                    
                #print(test)
                    
                
            #i = -1
            #td = nexthouse.find_all("td")
            #print(td[0])
            #test = td[0].text.strip()
            #print(test)
            #length = len(td)
            #print(length)
            
            
            #for td in nexthouse.find_all("td"):
            #    i = i + 1
            #    x = []
            #    print(i)
            #    x[i] = td.text.strip()
            #    print(x)
        
