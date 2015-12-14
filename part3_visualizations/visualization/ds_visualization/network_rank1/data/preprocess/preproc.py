import csv
import json

industryList = ['Consumer Discretionary', 'Consumer Staples',
	'Energy', 'Financials', 'Health Care', 'Industrials',
	'Information Technology', 'Materials', 'Not for profit',
	'Not publicly traded', 
	'Telecommunication Services', 'Utilities']

def initializeNodeList():
	list = []
	for industry in industryList:
		map = {}
		map['match'] = 0.1
		map['name'] = industry
		map['artist'] = "no detail information"
		map['id'] = industry
		map['playcount'] = 661020
		list.append(map)
	return list

def initializeCheckMap():
	checkMap = {}
	for industry in industryList:
		checkMap[industry] = True
	return checkMap

def writeFile(candidateFile):
	csvFile = open(candidateFile+".csv", "r")
	csvReader = csv.DictReader(csvFile)
	writer = open("./call_me_al.json","w")

	jsonMap = {}
	listOfNodes = initializeNodeList()
	links = []

	for row in csvReader:
		mapNode = {}
		mapNode['match'] = 1.0
		mapNode['name'] = row['CANDIDATE']
		mapNode['artist'] = row['STATE']+row['DISTRICT']+" "+row['PARTY']+" "+row['CANDTOTAL']
		mapNode['id'] = row['CANDIDATE']
		mapNode['playcount'] = 661020
		listOfNodes.append(mapNode)
		
		if row['rank 1'] not in industryList:
			continue
		mapLink1 = {}
		mapLink1['target']=row['CANDIDATE']
		mapLink1['source']=row['rank 1']
		links.append(mapLink1)

		if row['rank 2'] not in industryList:
			continue
		mapLink1 = {}
		mapLink1['target']=row['CANDIDATE']
		mapLink1['source']=row['rank 2']
		links.append(mapLink1)
		
	jsonMap['nodes'] = listOfNodes
	jsonMap['links'] = links

	writer.write(json.dumps(jsonMap))
	writer.close()


def main():
	fileList = ["2014"]
	for candidateFile in fileList:
		print candidateFile
		writeFile(candidateFile)

main()