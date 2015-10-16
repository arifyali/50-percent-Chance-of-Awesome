print("Begin program: GetNYTimes2014ElectionResults.py") #Indicate to user that program has begun.

#Load packages
from bs4 import BeautifulSoup
import requests
import csv

#List of state names for use while looping - lowercase as they appear in NYTimes url.
#Alphabetical order.
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

#List of state abbreviations - also for use while looping.
#Order matches state names.
stateAbbrevList = ["al", "ak", "az", "ar", "ca", "co", "ct", "de", "fl",
                   "ga", "hi", "id", "il" ,"in", "ia", "ks", "ky", "la",
                   "me", "md", "ma", "mi", "mn", "ms", "mo", "mt", "ne",
                   "nv", "nh", "nj", "nm", "ny", "nc", "nd", "oh", "ok",
                   "or", "pa", "ri", "sc", "sd", "tn", "tx", "ut", "vt",
                   "va", "wa", "wv", "wi", "wy"]

#Output csv that will contain election data.
#Will contain one row per election.
csvName = "NYTimes2014elections.csv"

#Define a procedure for extracting table information from a soup.
def extractRaceData(raceSoup, header, electionWriter):
    #raceSoup - string containing soup output for a given race.
    #header - list of two elements, first element - state, second element - race e.g. Senate.
    #electionWriter - csv.writer to use to write output.
    
    data = []                          #Initialize data list to empty
    td = raceSoup.find_all("td")       #Find all table entries
    datastring = "header[0],header[1]" #datastring will contain all output to be written.
    noContest="no"                     #Flag indicating whether or not there were opponents in the election.
                                       #The flag is dynamically set to "yes" based on soup.
    
    for i in range (0,len(td)):        #Loop through all table entries
        
        currData = td[i].text.strip()         #Pull out table value
        currData = currData.replace("\n","")  #Some table entries had lots of newline characters - Remove them.
                                              #I have used this strategy before in other languages,
                                              #but for the Python syntax I googled http://www.tutorialspoint.com/python/string_replace.htm
        currData = " ".join(currData.split()) #Reduces white space to a single white space between elements.
                                              #Found this technique on stack overflow:
                                              #http://stackoverflow.com/questions/6496884/compress-whitespaces-in-string
                                              #Verified understanding of its use from python:
                                              #http://www.tutorialspoint.com/python/string_join.htm
        
        if currData[-11:]=="Uncontested":     #If the current candidate is "Uncontested" currData will contain a name and "Unconctested".
                                              #Apply special process.  Indexing strategy used inspired by stackoverflow:
                                              #http://stackoverflow.com/questions/663171/is-there-a-way-to-substring-a-string-in-python
            noContest = "yes"                 #Flip no contest flag.
            currData = currData[:-11]         #Strip "Uncontested" away from the name of the candidate.
            
        if currData!="SHOW ALL HIDE":         #Sometimes this would get pulled with the soup and appear after all candidates in an election.
                                              #If it does, don't save that information.
            data.append(currData)                              #Append current table field info to the data variable
            datastring = datastring + ", data[" + str(i) + "]" #Add this new element of the data variable
                                                               #to the string that will be evaluated by the writer.
                                                               #Found this numeric-string conversion strategy on stack overflow:
                                                               #http://stackoverflow.com/questions/961632/converting-integer-to-string-in-python
            
            if i==(len(td)-1) and noContest=="yes":            #Continue special processing in "Unconctested" elections.
                
                #Loop through the next two fields (Votes and Votes Percentage) which will be empty,
                #then enter Uncontested in the "Candidate2" Column.
                for j in range (0,2):                          
                    data.append("")
                    nextI = i + 1 + j
                    datastring = datastring + ", data[" + str(nextI) + "]"
                    
                data.append("Uncontested")
                nextI = nextI + 1
                datastring = datastring + ", data[" + str(nextI) + "]"
                
    electionWriter.writerow(eval(datastring)) #Write data to csv. Since the number of entries output to any given row varied by election,
                                              #I wasn't sure of the best way to parameterize the output.  A string seemed straight forward, 
                                              #but then I had to find a way to force its contents to resolve. After googling I found the eval
                                              #function that I used: https://docs.python.org/3/library/functions.html#eval

#Open a csv file to which output will be written.
with open(csvName,"w", newline="", encoding="utf8") as csvfile:
    electionWriter = csv.writer(csvfile,delimiter=",")
    
    #Write header row to the file.
    #Max number of candidates for any individual election determined by trial and error.
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

    #Loop through all 50 states
    for stateNum in range (0,50):
        print("Current state =", stateNameList[stateNum]) #Print state current under analysis for purposes
                                                          #of debugging and to provide confidence the program
                                                          #is still running to user.
        
        url = "http://elections.nytimes.com/2014/" + stateNameList[stateNum] + "-elections" #url to soup for this state.
        page = requests.get(url)                                                            
        soup = BeautifulSoup(page.text, "lxml")

        for raceType in ["senate", "senateSpecialii", "senateSpecialiii", "house"]: #There are four types of race to pull for 2014 elections.
            #By raceType, set the header (which will become the first two columns of data in the output),
            #and find the section of soup corresponding to that election.  This is necessary to avoid pulling state-level races.
            #Each race has a section heading identifiable in the soup.
            
            if raceType=="senate":
                header = [stateNameList[stateNum], "Senate"]
                raceSoup = soup.find(id="race-" + stateAbbrevList[stateNum] + "-senate-class-ii-2014-general")
                
            elif raceType in ["senateSpecialii", "senateSpecialiii"]: #Special elections are seats that wouldn't normally be in this election cycle.
                header = [stateNameList[stateNum], "Senate Special"]
                
                if raceType=="senateSpecialii":
                    raceSoup = soup.find(id="race-" + stateAbbrevList[stateNum] + "-senate-class-ii-2014-special-general")
                    
                elif raceType=="senateSpecialiii":
                    raceSoup = soup.find(id="race-" + stateAbbrevList[stateNum] + "-senate-class-iii-2014-general")
                    
            elif raceType=="house":
                houseDistrictNum = 1 #There are different numbers of house districts per state.
                header = [stateNameList[stateNum], "House District " + str(houseDistrictNum)]
                #Note the raceSoup for the house districts are based on state AND district number.
                raceSoup = soup.find(id="race-" + stateAbbrevList[stateNum] + "-house-district-" + str(houseDistrictNum) + "-2014-general")

            if raceType in ["senate", "senateSpecialii", "senateSpecialiii"] and raceSoup!=None: #Some states may not have had a senate race.
                extractRaceData(raceSoup, header, electionWriter)
                
            elif raceType=="house":
                
                while raceSoup!=None: #Loop through house district soups until the next district is not found - you have completed the last district.
                    
                    extractRaceData(raceSoup, header, electionWriter)
                    houseDistrictNum = houseDistrictNum + 1 #Iterate house district
                    header = [stateNameList[stateNum], "House District " + str(houseDistrictNum)]
                    raceSoup = soup.find(id="race-" + stateAbbrevList[stateNum] + "-house-district-" + str(houseDistrictNum) + "-2014-general")

print("End program: GetNYTimes2014ElectionResults.py") #Indicate to user program is finished running.
