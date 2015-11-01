import requests
from bs4 import BeautifulSoup

url = "http://www.opensecrets.org/races/indus.php?id=CA01&cycle=2004"
r = requests.get(url);

soup = BeautifulSoup(r.text, "html.parser")
mainColumn = soup.find("div",{"id":"mainColumn"})

tableList  = soup.findAll("table",{"class":"datadisplay"})

for table in tableList:
	print table.get_text()
