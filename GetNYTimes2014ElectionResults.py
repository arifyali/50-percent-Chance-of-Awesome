print("Begin program: GetNYTimes2014ElectionResults.py")

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

csvName = "NYTimes2014elections.csv"

with open(csvName,"w", newline="", encoding="utf8") as csvfile:
    electionWriter = csv.writer(csvfile,delimiter=",")
    electionWriter.writerow (["State", "CongressionalMembership",
                              "Candidate1",  "PartyAffiliation1",  "Votes1",  "VotePercent1",
                              "Candidate2",  "PartyAffiliation2",  "Votes2",  "VotePercent2",
                              "Candidate3",  "PartyAffiliation3",  "Votes3",  "VotePercent3",
                              "Candidate4",  "PartyAffiliation4",  "Votes4",  "VotePercent4",
                              "Candidate5",  "PartyAffiliation5",  "Votes5",  "VotePercent5",
                              "Candidate6",  "PartyAffiliation6",  "Votes6",  "VotePercent6",
                              "Candidate7",  "PartyAffiliation7",  "Votes7",  "VotePercent7",
                              "Candidate8",  "PartyAffiliation8",  "Votes8",  "VotePercent8",
                              "Candidate9",  "PartyAffiliation9",  "Votes9",  "VotePercent9",
                              "Candidate10", "PartyAffiliation10", "Votes10", "VotePercent10",
                              "Candidate11", "PartyAffiliation11", "Votes11", "VotePercent11",
                              "Candidate12", "PartyAffiliation12", "Votes12", "VotePercent12"])

    for stateNum in range (0,50):
        print("Current state =", stateNameList[stateNum])
    
        url = "http://elections.nytimes.com/2014/" + stateNameList[stateNum] + "-elections"
        page = requests.get(url)
        soup = BeautifulSoup(page.text, "lxml")

        header = [stateNameList[stateNum], "Senate"]
        senateRace = soup.find(id="race-" + stateAbbrevList[stateNum] + "-senate-class-ii-2014-general")
        if senateRace!=None:
            data = []
            td = senateRace.find_all("td")
            datastring = "header[0],header[1]"
            noContest="no"
            for i in range (0,len(td)):
                currData = td[i].text.strip()
                currData = currData.replace("\n","")
                currData = " ".join(currData.split())
                if currData[-11:]=="Uncontested":
                    noContest = "yes"
                    currData = currData[:-11]
                if currData!="SHOW ALL HIDE":
                    data.append(currData)
                    datastring = datastring + ", data[" + str(i) + "]"
                    if i==(len(td)-1) and noContest=="yes":
                        for j in range (0,2):
                            data.append("")
                            nextI = i + 1 + j
                            datastring = datastring + ", data[" + str(nextI) + "]"
                        data.append("Uncontested")
                        nextI = nextI + 1
                        datastring = datastring + ", data[" + str(nextI) + "]"
            electionWriter.writerow(eval(datastring))
            
        header = [stateNameList[stateNum], "Senate Special"]
        senateSpecialRace = soup.find(id="race-" + stateAbbrevList[stateNum] + "-senate-class-ii-2014-special-general")
        if senateSpecialRace!=None:
            data = []
            td = senateSpecialRace.find_all("td")
            datastring = "header[0],header[1]"
            noContest="no"
            for i in range (0,len(td)):
                currData = td[i].text.strip()
                currData = currData.replace("\n","")
                currData = " ".join(currData.split())
                if currData[-11:]=="Uncontested":
                    noContest = "yes"
                    currData = currData[:-11]
                if currData!="SHOW ALL HIDE":
                    data.append(currData)
                    datastring = datastring + ", data[" + str(i) + "]"
                    if i==(len(td)-1) and noContest=="yes":
                        for j in range (0,2):
                            data.append("")
                            nextI = i + 1 + j
                            datastring = datastring + ", data[" + str(nextI) + "]"
                        data.append("Uncontested")
                        nextI = nextI + 1
                        datastring = datastring + ", data[" + str(nextI) + "]"
            electionWriter.writerow(eval(datastring))

        header = [stateNameList[stateNum], "Senate Special"]
        senateSpecialRace = soup.find(id="race-" + stateAbbrevList[stateNum] + "-senate-class-iii-2014-general")
        if senateSpecialRace!=None:
            data = []
            td = senateSpecialRace.find_all("td")
            datastring = "header[0],header[1]"
            noContest="no"
            for i in range (0,len(td)):
                currData = td[i].text.strip()
                currData = currData.replace("\n","")
                currData = " ".join(currData.split())
                if currData[-11:]=="Uncontested":
                    noContest = "yes"
                    currData = currData[:-11]
                if currData!="SHOW ALL HIDE":
                    data.append(currData)
                    datastring = datastring + ", data[" + str(i) + "]"
                    if i==(len(td)-1) and noContest=="yes":
                        for j in range (0,2):
                            data.append("")
                            nextI = i + 1 + j
                            datastring = datastring + ", data[" + str(nextI) + "]"
                        data.append("Uncontested")
                        nextI = nextI + 1
                        datastring = datastring + ", data[" + str(nextI) + "]"
            electionWriter.writerow(eval(datastring))
        

        houseDistrictNum = 1
        header = [stateNameList[stateNum], "House District " + str(houseDistrictNum)]
        nextHouse = soup.find(id="race-" + stateAbbrevList[stateNum] + "-house-district-" + str(houseDistrictNum) + "-2014-general")
        while nextHouse!=None:
            data = []
            td = nextHouse.find_all("td")
            datastring = "header[0],header[1]"
            noContest="no"
            for i in range (0,len(td)):
                currData = td[i].text.strip()
                currData = currData.replace("\n","")
                currData = " ".join(currData.split())
                if currData[-11:]=="Uncontested":
                    noContest = "yes"
                    currData = currData[:-11]
                if currData!="SHOW ALL HIDE":
                    data.append(currData)
                    datastring = datastring + ", data[" + str(i) + "]"
                    if i==(len(td)-1) and noContest=="yes":
                        for j in range (0,2):
                            data.append("")
                            nextI = i + 1 + j
                            datastring = datastring + ", data[" + str(nextI) + "]"
                        data.append("Uncontested")
                        nextI = nextI + 1
                        datastring = datastring + ", data[" + str(nextI) + "]"
            electionWriter.writerow(eval(datastring))
            
            houseDistrictNum = houseDistrictNum + 1
            header = [stateNameList[stateNum], "House District " + str(houseDistrictNum)]
            nextHouse = soup.find(id="race-" + stateAbbrevList[stateNum] + "-house-district-" + str(houseDistrictNum) + "-2014-general")

print("End program: GetNYTimes2014ElectionResults.py")
 
#Sources:
#https://docs.python.org/3/library/functions.html#eval
#http://stackoverflow.com/questions/961632/converting-integer-to-string-in-python
#http://stackoverflow.com/questions/6496884/compress-whitespaces-in-string
#http://www.tutorialspoint.com/python/string_join.htm
#http://www.tutorialspoint.com/python/string_replace.htm
#http://stackoverflow.com/questions/275018/how-can-i-remove-chomp-a-newline-in-python
#http://stackoverflow.com/questions/1762484/how-to-find-the-position-of-an-element-in-a-list-in-python
#http://stackoverflow.com/questions/663171/is-there-a-way-to-substring-a-string-in-python
