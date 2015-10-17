# In accordance with the class policies and Georgetown's Honor Code,
# I certify that, with the exceptions of the lecture notes and those
# items noted below, this work is my own. I know that I can speak to
# others about my code, but I cannot share the code itself.
# If I received any help, I have noted it

print("Begin program: ScrapeOpenSecrets.py") #Indicate to user that program has begun.

#Load packages
import requests
import csv
from bs4 import BeautifulSoup
import pandas

#Define a procedure for extracting industry donation information from all results in a given <table>.
def getIndustryDonation(table, industryWriter, state, district, year, candName):
    #Parameters:
    #table - soup for the table to be parsed
    #industryWriter - csv writer
    #state - state for output in the row with industry donation information
    #district - district for output in the row with industry donation information
    #year - year for output in the row with industry donation information
    #candName - Candidate name for output in the row with industry donation information
    
    trList = table.findAll("tr")                      #Find all "tr" tags
    for tr in trList:                                 #Loop through all "tr" tags
        
        [industry, donation] = tr.findAll("td")       #Find industry,donation combinations within tr tags, designated with td tags.
        
        #Parse Industry
        industryName = industry.get_text()            
        industryName = " ".join(industryName.split()) #Remove odd spacing, if any exists.
        
        #Parse Donation Amount
        donationAmt = donation.get_text()             #Extract donation amount            
        donationAmt = " ".join(donationAmt.split())   #Remove odd spacing, if any exists.
        donationAmt = donationAmt.replace("$","")     #Remove dollar signs from donation amounts
        donationAmt = donationAmt.replace(",","")     #Remove commas from amounts in thousands from donation amounts

        #Output to csv
        industryWriter.writerow([state,district,year,candName,industryName,donationAmt])

#Define a procedure for scraping the contents of a single state-district-year page.
def scrapeOnePage(state, district, year, industryWriter, soup, r):
    #Parameters:
    #state - state for output in the row with industry donation information
    #district - district for output in the row with industry donation information
    #year - year for output in the row with industry donation information
    #soup - the entire soup belonging to the page to be scraped
    #r - all of the results of the page brought back by requests prior to being "souped"
    #industryWriter - csv writer

    #All table results are stored in this section of the soup
    mainColumn = soup.find("div",{"id":"mainColumn"})

    #All tables that we are interested in have this characteristic.
    tableList  = mainColumn.findAll("table",{"class":"datadisplay"})

    #Extract all Candidate Names
    h2Bucket   = mainColumn.findAll("h2") #All h2 tags, contain names and other random items.
    h2NotNames = mainColumn.findAll("h2",{"style":"font-size:1.5em;margin-bottom:10px;margin-top:10px"}) #Get just random items
    tableNames = [item for item in h2Bucket if item not in h2NotNames] #Take list of all h2 tags and remove those that don't belong to names.
                                                                       #Googled and found the following stack overflow regarding combining lists.
                                                                       #http://stackoverflow.com/questions/17934785/remove-elements-in-one-list-present-in-another-list

    #Unfortunately, the website was not easily scraped since the number of tables with industry information and the number of names
    #that could have information did not always match.  When they didn't match, I had to get creative in figuring out how to make
    #sure the names were correctly paired with their corresponding industry information.  However, concerned about total runtime
    #of the code, I set it up to only go through the extra steps when this mismatch might occur, which is to say when the number
    #of tables containing industry information and the number of candidate names differed. Note that it will always be the case that
    #(Number of Names) >= (Number of tables)
    if len(tableList)!=len(tableNames):
        #Strategy: Find the relative locations of names and tables on the page.  Since the table for a given candidate would always
        #come directly after that candidate's name, we can use that knowledge to appropriately pair by hand.

        #Find the relative location of Candidate Names
        partialPageText = r.text #Initialize partial page text 
        nameLocation=[]          #This variable will store all of the locations in the page of names.
        for i in range(0,len(tableNames)):
            nameLocation.append(partialPageText.index('<h2>'))      #Load location of name into the nameLocation variable.  Used the following resource to
                                                                    #learn about the index() method: http://www.tutorialspoint.com/python/list_index.htm
                                                                    #I did this after learning of the method from stackoverflow:
                                                                    #http://stackoverflow.com/questions/2294493/how-to-get-the-position-of-a-character-in-python
            partialPageText = partialPageText[nameLocation[i] + 1:] #Refine partialPageText to the next chunk in order to find the next instance of a name.
            if i > 0:
                nameLocation[i] = nameLocation[i] + nameLocation[i-1] + 1 #If the name is not the first, we must use this strategy to get the overall
                                                                          #location within the original text of the name.  This is necessary due to the
                                                                          #subsequent names found only in partial text chunks.

        #Find the relative location of the desired industry information
        partialPageText = r.text
        tableLocation=[]
        for i in range(0,len(tableList)):
            #Used stackoverflow to determine how to do compound quoting in Python for the following index command:
            #http://stackoverflow.com/questions/4630465/how-to-include-a-quote-in-a-raw-python-string
            tableLocation.append(partialPageText.index('<table class="datadisplay"><th>Industry</th><th>Total</th>')) 
            partialPageText = partialPageText[tableLocation[i] + 1:]
            if i > 0:
                tableLocation[i] = tableLocation[i] + tableLocation[i-1] + 1

        #Loop through Names, outputting to the csv when appropriate.
        j = 0 #Initialize counter to be used with tables since the loop counter will be used with names
        for i in range(0,len(tableNames)):

            #For each loop initialize industry name and donation amount to missing so each isn't accidentally output for a Candidate that they don't belong to.
            industryName = ""                     
            donationAmt = ""            

            #Extract candidate Name
            tableHead = tableNames[i]
            candName = tableHead.text.strip()
            candName = " ".join(candName.split())

            #Only check to see if the candidate has a table if all of the tables haven't already been used and it isn't the last candidate in the loop.
            if i!=len(tableNames)-1 and j!=len(tableList):
                
                #Check to see if the next table belongs to this candidate.
                #It must have a relative location to the candidate's name after their name but before the next candidate's name.
                if tableLocation[j] > nameLocation[i] and tableLocation[j] < nameLocation[i+1]:
                    table = tableList[j]                                                   #Call the next table soup into table
                    getIndustryDonation(table,industryWriter,state,district,year,candName) #Extract industry information and output rows for the candidate.
                    j = j + 1                                                              #Iterate j so that the next table will be used next.
                    
                #If the next table does not belong to this candidate, this candidate does not have a table, so simply output.
                else:
                    industryWriter.writerow([state,district,year,candName,industryName,donationAmt])

            #If all of the tables haven't been used up but the loop is on the last candidate, the table must belong to him or her.
            elif i==len(tableNames)-1 and j!=len(tableList):
                table = tableList[j]
                getIndustryDonation(table,industryWriter,state,district,year,candName)

            #If all of the tables have been used, any remaining Names in the loop will be output without industry information.
            else:
                industryWriter.writerow([state,district,year,candName,industryName,donationAmt])

    #If (Number of Names) = (Number of tables) then there is no need for all of the extra analytical architecture, above.
    #Code is similar to the above code, and therefore not commented.
    else:
        for i in range(0,len(tableNames)):
            industryName = ""
            donationAmt = ""
            tableHead = tableNames[i]
            candName = tableHead.text.strip()
            candName = " ".join(candName.split())
            table = tableList[i]
            getIndustryDonation(table,industryWriter,state,district,year,candName)
            trList = table.findAll("tr")
            if trList==None:
                industryWriter.writerow([state,district,year,candName,industryName,donationAmt])

#Define the program's core procedure.
def main():

    #List of state abbreviations - used while looping for the url and for output.
    stateList = ["al", "ak", "az", "ar", "ca", "co", "ct", "de", "fl",
                 "ga", "hi", "id", "il" ,"in", "ia", "ks", "ky", "la",
                 "me", "md", "ma", "mi", "mn", "ms", "mo", "mt", "ne",
                 "nv", "nh", "nj", "nm", "ny", "nc", "nd", "oh", "ok",
                 "or", "pa", "ri", "sc", "sd", "tn", "tx", "ut", "vt",
                 "va", "wa", "wv", "wi", "wy"]

    #List of years for use while looping in the url.
    yearList = ["2004", "2006", "2008", "2010", "2012", "2014"]

    #List of possible districts for candidates of the house,
    #CA has the most with 53, so this just ensures everything is caught.
    houseDistrictList = ["01","02","03","04","05","06","07","08","09",
		         "10","11","12","13","14","15","16","17","18","19",
		         "20","21","22","23","24","25","26","27","28","29",
		         "30","31","32","33","34","35","36","37","38","39",
		         "40","41","42","43","44","45","46","47","48","49",
		         "50","51","52","53","54","55","56","57","58","59"]

    #There are only two senate seats, which for the sake of the program and output are treated as "districts".
    senateDistrictList = ["s1","s2"]

    #Combine the senate seats and house districts into one list for looping.
    #House must come after senate since senate seats may not have elections, but which seat is up changes between years.
    #When an invalid house district is encountered, we break the loop.
    #This significantly reduces runtime since the site actually manages urls for impossible districts.
    districtList = senateDistrictList + houseDistrictList

    #Declare the url stem used by all urls that are to be scraped.
    urlBase = "http://www.opensecrets.org/races/indus.php?id="

    #Open the csv to which the output will be written.
    with open("FundingCongress.csv","w", newline="", encoding="utf8") as csvfile:

        #Declare csv writer and write the header row to the csv.
        industryWriter = csv.writer(csvfile,delimiter=",")
        industryWriter.writerow(["State","District","Year","Candidate","Industry","Amount"])

        #Loop through state-year-district combinations - this is the level of the url.
        for state in stateList:
            for year in yearList:
                for district in districtList:

                    #Parse url for use in the program
                    url = urlBase+state+district+"&cycle="+year #Create state-year-district level url.
                    r = requests.get(url)                       #Pull back text of url.
                    soup = BeautifulSoup(r.text, "html.parser") #Turn resulting text into a soup.

                    #On invalid house district pages, there will be text that reads "No data found for race" in a particular section.
                    #If this text exists, we know that we are on a page without real data.
                    #This is in a try except block because if we try to find an index for a substring that does not exist the code crashes.
                    try:
                        dataAvailable = soup.find("div",{"id":"profileLeftColumn"})
                        allTextAvailable = dataAvailable.text.strip()
                        dataExists = allTextAvailable.index("No data found for race")
                        
                    #If the page is a real page, print that fact to the console and then scrape the page.
                    except:
                        print("Data Found [state, district, year]=" + state + ", " + district + ", " + year)
                        scrapeOnePage(state, district, year, industryWriter, soup, r)
                        
                    #If the page is not a real page, print that fact to the console.
                    else:
                        print("NO Data Found [state, district, year]=" + state + ", " + district + ", " + year)

                        #If the district that failed was a district from the house list, that means the remaining districts
                        #would also fail and the code should exit the loop for this state-year-district combination.
                        if district not in senateDistrictList:
                            break

#Launch program via the primary module.
main()

print("End program: ScrapeOpenSecrets.py") #Notify the user that the program is finished.

### Feature generation; I generated two features based on this dataset:
### candtotal is the total contributions from all industries that the candidate received in an election cycle
### industrypercent is the percentage of a candidate's total contributions in a cycle that came from each industry

cycles = {2004,2006,2008,2010,2012,2014}
# read in data
data = pandas.read_csv('FundingCongress.csv')
# create vector of unique candidate names
names = list(set(data.Candidate))
# http://stackoverflow.com/questions/12897374/get-unique-values-from-a-list-in-python
# create empty column for candtotal feature
data['candtotal'] = 0
for cycle in cycles:    
    for name in names:
        data.candtotal[(data.Candidate==name) & (data.Year==cycle)] = sum(data.Amount[(data.Year == cycle) & (data.Candidate == name)])
# create empty column for industrypercent feature
data['industrypercent'] = 0
data.industrypercent = data.Amount/data.candtotal
pandas.DataFrame.to_csv(data,'FundingCongress.csv')
