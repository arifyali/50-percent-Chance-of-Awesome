#add more information on id
import csv
def getCandInfoFromCSV(csvReader, dictOfStateCode):
	informationDict = {}
	for row in csvReader:
		#print row
		row['KEY'] = row['STATE']+"|"+row['DISTRICT']+"|"+row['YEAR']
		row['CODE'] = dictOfStateCode[row['STATE']]

		#print row['CODE']+" "+row['STATE']
		try: 
			a=int(row['DISTRICT'])
		except:
			continue

		if int(row['DISTRICT'])<10:
			key = row['CODE']+"0"+row['DISTRICT']
		else:
			key = row['CODE']+row['DISTRICT']

		candInfo = "candidate:"+row['CANDIDATE']+", party:"+\
			row['PARTY']+", total_funding:"+row['CANDTOTAL']
		if row['INCUMBENT'] == 1:
			candInfo = candInfo+", incumbent"
		else:
			candInfo = candInfo+", not_incumbent"
		if row['WINNER'] == 1:
			candInfo = candInfo+", winner"
		else:
			candInfo = candInfo+", loser"

		if key in informationDict:
			informationDict[key]=informationDict[key]+candInfo
		else:
			informationDict[key]=candInfo
	return informationDict

def writeFile(candidateFile,congressFile, dictOfStateCode):
	csvFile = open(candidateFile+".csv", "r")
	csvReader = csv.DictReader(csvFile)

	reader = open(congressFile,"r")
	writer = open("./us-congress-113-"+candidateFile+".json","w")

	informationDict = getCandInfoFromCSV(csvReader, dictOfStateCode)
	# for key in informationDict:
	# 	print key

	for line in reader:
		#prefix+"id":+id+,+rest
		if "\"id\":" in line:
			elems = line.split("\"id\":",2)
			temp = elems[1].split(",",2)
			id = str(temp[0])
			if id in informationDict:
				line = line.replace("\"id\":"+id, "\"id\":"+"\""+id+" "+informationDict[str(id)]+"\"")
		writer.write(line)


def main():
	#fileList = ["2004","2006","2008","2010","2012","2014"]
	fileList = ["2014"]
	congressFile = "./us-congress-113.json"
	dictOfStateCode = {}
	stateCodeFile = open("state_code.txt","r")
	for line in stateCodeFile:
		elems = line.split("\t")
		dictOfStateCode[elems[1]] = elems[0]

	#print dictOfStateCode
	for candidateFile in fileList:
		print candidateFile
		writeFile(candidateFile, congressFile, dictOfStateCode)

main()
	
