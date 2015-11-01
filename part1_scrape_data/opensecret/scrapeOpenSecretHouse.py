import requests
from bs4 import BeautifulSoup

def scrapeOnePage(url, state, district, year):
	#url = "http://www.opensecrets.org/races/indus.php?id=CA01&cycle=2004"
	r = requests.get(url);

	soup = BeautifulSoup(r.text, "html.parser")
	mainColumn = soup.find("div",{"id":"mainColumn"})

	tableList  = mainColumn.findAll("table",{"class":"datadisplay"})
	if not len(tableList):
		raise Exception("no more")
	print "[state, district, year]="+state+", "+district+", "+year

	tableNames = mainColumn.findAll("h2")
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
	yearList = ["2004", "2006", "2008", "2010", "2012", "2014"]
	districtList = [
					"01","02","03","04","05","06","07","08","09",
					"10","11","12","13","14","15","16","17","18","19",
					"20","21","22","23","24","25","26","27","28","29",
					"30","31","32","33","34","35","36","37","38","39",
					"40","41","42","43","44","45","46","47","48","49",
					"50","51","52","53","54","55","56","57","58","59"
					]
	url = "http://www.opensecrets.org/races/indus.php?id="
	for state in stateList:
		for year in yearList:
			try:
				for district in districtList:
					url = url+state+district+"&cycle="+year
					scrapeOnePage(url, state, district, year)
			except Exception:
				continue;

main()