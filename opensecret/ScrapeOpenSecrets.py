print("Begin program: ScrapeOpenSecrets.py") #Indicate to user that program has begun.

#Load packages
import requests
import csv
from bs4 import BeautifulSoup

#Define a procedure for extracting industry donation information from all results in a given <table>.
def getIndustryDonation(table, industryWriter, state, district, year, candName):
    trList = table.findAll("tr")                      #Find all "tr" tags
    for tr in trList:                                 #Loop through all "tr" tags
        [industry, donation] = tr.findAll("td")       
        industryName = industry.get_text()
        industryName = " ".join(industryName.split())
        donationAmt = donation.get_text()
        donationAmt = " ".join(donationAmt.split())
        donationAmt = donationAmt.replace("$","")
        donationAmt = donationAmt.replace(",","")
        industryWriter.writerow([state,district,year,candName,industryName,donationAmt])


def scrapeOnePage(url, state, district, year, industryWriter, soup, r):
    mainColumn = soup.find("div",{"id":"mainColumn"})
    tableList  = mainColumn.findAll("table",{"class":"datadisplay"})
    h2Bucket   = mainColumn.findAll("h2")
    h2NotNames = mainColumn.findAll("h2",{"style":"font-size:1.5em;margin-bottom:10px;margin-top:10px"})
    tableNames = [item for item in h2Bucket if item not in h2NotNames]

    #http://stackoverflow.com/questions/17934785/remove-elements-in-one-list-present-in-another-list
    #http://stackoverflow.com/questions/4630465/how-to-include-a-quote-in-a-raw-python-string
    if len(tableList)!=len(tableNames):
        partialPageText = r.text
        nameLocation=[]
        for i in range(0,len(tableNames)):
            nameLocation.append(partialPageText.index('<h2>'))
            partialPageText = partialPageText[nameLocation[i] + 1:]
            if i > 0:
                nameLocation[i] = nameLocation[i] + nameLocation[i-1] + 1
            
        partialPageText = r.text
        tableLocation=[]
        for i in range(0,len(tableList)):
            tableLocation.append(partialPageText.index('<table class="datadisplay"><th>Industry</th><th>Total</th>'))
            partialPageText = partialPageText[tableLocation[i] + 1:]
            if i > 0:
                tableLocation[i] = tableLocation[i] + tableLocation[i-1] + 1

        j = 0
        for i in range(0,len(tableNames)):
            industryName = ""
            donationAmt = ""
            tableHead = tableNames[i]
            candName = tableHead.text.strip()
            candName = " ".join(candName.split())
            if i!=len(tableNames)-1 and j!=len(tableList):
                if tableLocation[j] > nameLocation[i] and tableLocation[j] < nameLocation[i+1]:
                    table = tableList[j]
                    getIndustryDonation(table,industryWriter,state,district,year,candName)
                    j = j + 1
                else:
                    industryWriter.writerow([state,district,year,candName,industryName,donationAmt])
            elif i==len(tableNames)-1 and j!=len(tableList):
                table = tableList[j]
                getIndustryDonation(table,industryWriter,state,district,year,candName)
            else:
                industryWriter.writerow([state,district,year,candName,industryName,donationAmt])
                        
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

def main():
    stateList = ["al", "ak", "az", "ar", "ca", "co", "ct", "de", "fl",
                 "ga", "hi", "id", "il" ,"in", "ia", "ks", "ky", "la",
                 "me", "md", "ma", "mi", "mn", "ms", "mo", "mt", "ne",
                 "nv", "nh", "nj", "nm", "ny", "nc", "nd", "oh", "ok",
                 "or", "pa", "ri", "sc", "sd", "tn", "tx", "ut", "vt",
                 "va", "wa", "wv", "wi", "wy"]
    yearList = ["2004", "2006", "2008", "2010", "2012", "2014"]
    houseDistrictList = ["01","02","03","04","05","06","07","08","09",
		         "10","11","12","13","14","15","16","17","18","19",
		         "20","21","22","23","24","25","26","27","28","29",
		         "30","31","32","33","34","35","36","37","38","39",
		         "40","41","42","43","44","45","46","47","48","49",
		         "50","51","52","53","54","55","56","57","58","59"]
    senateDistrictList = ["s1","s2"]
    districtList = senateDistrictList + houseDistrictList
	
    urlBase = "http://www.opensecrets.org/races/indus.php?id="
    with open("FundingCongress.csv","w", newline="", encoding="utf8") as csvfile:
        industryWriter = csv.writer(csvfile,delimiter=",")
        industryWriter.writerow(["State","District","Year","Candidate","Industry","Amount"])
        for state in stateList:
            for year in yearList:
                for district in districtList:
                    url = urlBase+state+district+"&cycle="+year
                    r = requests.get(url)
                    soup = BeautifulSoup(r.text, "html.parser")
                    try:
                        dataAvailable = soup.find("div",{"id":"profileLeftColumn"})
                        allTextAvailable = dataAvailable.text.strip()
                        dataExists = allTextAvailable.index("No data found for race")
                    except:
                        print("Data Found [state, district, year]=" + state + ", " + district + ", " + year)
                        scrapeOnePage(url, state, district, year, industryWriter, soup, r)
                    else:
                        print("NO Data Found [state, district, year]=" + state + ", " + district + ", " + year)
                        if district not in senateDistrictList:
                            break

main()

print("End program: ScrapeOpenSecrets.py")
