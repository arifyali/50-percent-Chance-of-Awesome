import requests
from bs4 import BeautifulSoup

def scrapeOnePage(url, state, district, year):
	#url = "http://www.opensecrets.org/races/indus.php?id=CA01&cycle=2004"
	r = requests.get(url);

	soup = BeautifulSoup(r.text, "html.parser")
	mainColumn = soup.find("div",{"id":"mainColumn"})

	tableList  = mainColumn.findAll("table",{"class":"datadisplay"})
	if not len(tableList):
		return
	print "[state, district, year]="+state+", "+district+", "+year


	tableNames = mainColumn.findAll("h2")
	#print tableNames
	for i in range(0,len(tableList)):

		tableHead = tableNames[i]
		print tableHead.get_text().encode('utf8')

		table = tableList[i]
		thList = table.findAll("th")
		for th in thList:
			print th.get_text().encode('utf8')+"\t",
		print ""

		trList = table.findAll("tr")
		for tr in trList:
			[industry, donation] = tr.findAll("td")
			print industry.get_text()+"\t"+donation.get_text()

		print ""

def main():
	stateList = ["al", "ak", "az", "ar", "ca", "co", "ct", "de", "fl",
                   "ga", "hi", "id", "il" ,"in", "ia", "ks", "ky", "la",
                   "me", "md", "ma", "mi", "mn", "ms", "mo", "mt", "ne",
                   "nv", "nh", "nj", "nm", "ny", "nc", "nd", "oh", "ok",
                   "or", "pa", "ri", "sc", "sd", "tn", "tx", "ut", "vt",
                   "va", "wa", "wv", "wi", "wy"]
	#stateList = ["al"]
	yearList = ["2004", "2006", "2008", "2010", "2012", "2014"]
	#yearList = ["2008"]
	districtList = ["s1","s2"]
	url = "http://www.opensecrets.org/races/indus.php?id="
	for state in stateList:
		for year in yearList:
			for district in districtList:
				try:
					url = url+state+district+"&cycle="+year
					scrapeOnePage(url, state, district, year)
				except Exception:
					continue


main()
