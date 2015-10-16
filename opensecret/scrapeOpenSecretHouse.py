import requests
import csv
from bs4 import BeautifulSoup

def scrapeOnePage(url, state, district, year, industryWriter):
    r = requests.get(url);

    soup = BeautifulSoup(r.text, "html.parser")
    mainColumn = soup.find("div",{"id":"mainColumn"})

    tableList  = mainColumn.findAll("table",{"class":"datadisplay"})
    if not len(tableList):
        raise Exception("no more")
    print("[state, district, year]=" + state + ", " + district + ", " + year)
    tableNames = mainColumn.findAll("h2")
    #print(tableNames)
    #print(len(tableList))
    for i in range(0,len(tableNames)):
        industryName = ""
        donationAmt = ""
        tableHead = tableNames[i]
        candName = tableHead.text.strip()
        candName = " ".join(candName.split())

        table = tableList[i]
        trList = table.findAll("tr")
        for tr in trList:
            [industry, donation] = tr.findAll("td")
            industryName = industry.get_text()
            industryName = " ".join(industryName.split())
            donationAmt = donation.get_text()
            donationAmt = " ".join(donationAmt.split())
        industryWriter.writerow([state,district,year,candName,industryName,donationAmt])

def main():
    stateList = ["wy"]#"al", "ak", "az", "ar", "ca", "co", "ct", "de", "fl",
                 #"ga", "hi", "id", "il" ,"in", "ia", "ks", "ky", "la",
                 #"me", "md", "ma", "mi", "mn", "ms", "mo", "mt", "ne",
                 #"nv", "nh", "nj", "nm", "ny", "nc", "nd", "oh", "ok",
                 #"or", "pa", "ri", "sc", "sd", "tn", "tx", "ut", "vt",
                 #"va", "wa", "wv", "wi", "wy"]
    yearList = ["2014"]#"2004", "2006", "2008", "2010", "2012", "2014"]
    districtList = ["01","02","03","04","05","06","07","08","09",
		    "10","11","12","13","14","15","16","17","18","19",
		    "20","21","22","23","24","25","26","27","28","29",
		    "30","31","32","33","34","35","36","37","38","39",
		    "40","41","42","43","44","45","46","47","48","49",
		    "50","51","52","53","54","55","56","57","58","59"]
	
    urlBase = "http://www.opensecrets.org/races/indus.php?id="
    with open("fundingHouse.csv","w", newline="", encoding="utf8") as csvfile:
        industryWriter = csv.writer(csvfile,delimiter=",")
        industryWriter.writerow(["State","District","Year","Candidate","Industry","Amount"])
        for state in stateList:
            for year in yearList:
                try:
                    for district in districtList:
                        url = urlBase+state+district+"&cycle="+year
                        scrapeOnePage(url, state, district, year, industryWriter)
                except Exception:
                    continue;

main()
