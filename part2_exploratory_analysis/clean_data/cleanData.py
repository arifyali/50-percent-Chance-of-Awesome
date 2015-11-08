import csv
from os import listdir
def parseRow(row):
	key = row['KEY']
	value = row
	return (key, value)

def merge(value1, value2):
	#KEY	STATE ABBREVIATION	DISTRICT	FEC ID	INCUMBENT INDICATOR	
	#FIRST NAME	LAST NAME	PARTY	YEAR	
	#PRIMARY	PRIMARY %	RUNOFF	RUNOFF %	GENERAL	GENERAL %
	value = {}
	value['KEY'] = value1['KEY']
	value['STATE ABBREVIATION'] = value1['STATE ABBREVIATION']
	value['DISTRICT'] = value1['DISTRICT']
	value['FEC ID'] = value1['FEC ID']
	value['INCUMBENT INDICATOR'] = value1['INCUMBENT INDICATOR']
	value['FIRST NAME'] = value1['FIRST NAME']
	value['LAST NAME'] = value1['LAST NAME']
	value['PARTY'] = value1['PARTY']+","+value2['PARTY']
	value['YEAR'] = value1['YEAR']

	#merge PRIMARY and PRIMARY %
	if value1['PRIMARY']=="" and value2['PRIMARY']=="":
		value['PRIMARY'] = ""
	elif value1['PRIMARY']=="":
		value['PRIMARY'] = value2['PRIMARY']
	elif value2['PRIMARY']=="":
		value['PRIMARY'] = value1['PRIMARY']
	else:
		value['PRIMARY'] = max(int(value1['PRIMARY']),int(value2['PRIMARY']))

	if value1['PRIMARY %']=="" and value2['PRIMARY %']=="":
		value['PRIMARY %'] = ""
	elif value1['PRIMARY %']=="":
		value['PRIMARY %'] = value2['PRIMARY %']
	elif value2['PRIMARY %']=="":
		value['PRIMARY %'] = value1['PRIMARY %']
	else:
		value['PRIMARY %'] = max(float(value1['PRIMARY %']),float(value2['PRIMARY %']))

	#merge RUNOFF and RUNOFF %
	if value1['RUNOFF']=="" and value2['RUNOFF']=="":
		value['RUNOFF'] = ""
	elif value1['RUNOFF']=="":
		value['RUNOFF'] = value2['RUNOFF']
	elif value2['RUNOFF']=="":
		value['RUNOFF'] = value1['RUNOFF']
	else:
		value['RUNOFF'] = max(int(value1['RUNOFF']),int(value2['RUNOFF']))

	if value1['RUNOFF %']=="" and value2['RUNOFF %']=="":
		value['RUNOFF %'] = ""
	elif value1['RUNOFF %']=="":
		value['RUNOFF %'] = value2['RUNOFF %']
	elif value2['RUNOFF %']=="":
		value['RUNOFF %'] = value1['RUNOFF %']
	else:
		value['RUNOFF %'] = max(float(value1['RUNOFF %']),float(value2['RUNOFF %']))

	#merge GENERAL and GENERAL %
	if value1['GENERAL']=="" and value2['GENERAL']=="":
		value['GENERAL'] = ""
	elif value1['GENERAL']=="":
		value['GENERAL'] = value2['GENERAL']
	elif value2['GENERAL']=="":
		value['GENERAL'] = value1['GENERAL']
	else:
		value['GENERAL'] = max(int(value1['GENERAL']),int(value2['GENERAL']))

	if value1['GENERAL %']=="" and value2['GENERAL %']=="":
		value['GENERAL %'] = ""
	elif value1['GENERAL %']=="":
		value['GENERAL %'] = value2['GENERAL %']
	elif value2['GENERAL %']=="":
		value['GENERAL %'] = value1['GENERAL %']
	else:
		value['GENERAL %'] = max(float(value1['GENERAL %']),float(value2['GENERAL %']))
		
	return value

def cleanFile(inputFile, outputFile):
	ifile  = open(inputFile, "rb")
	reader = csv.DictReader(ifile)
	ofile  = open(outputFile, "wb")
	#writer = csv.writer(ofile, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL)
	fieldnames = ['KEY','STATE ABBREVIATION','DISTRICT','FEC ID','INCUMBENT INDICATOR','FIRST NAME','LAST NAME','PARTY','YEAR','PRIMARY','PRIMARY %','RUNOFF','RUNOFF %','GENERAL','GENERAL %']
	writer = csv.DictWriter(ofile, fieldnames=fieldnames)
	writer.writeheader()
	candidateDict = {}

	for row in reader:
		(key, value) = parseRow(row)
		#print (key, value)

		if candidateDict.has_key(key):
			value1 = candidateDict.get(key)
			mergeValue = merge(value, value1)
			candidateDict[key] = mergeValue;
		else:
			candidateDict[key] = value
		#print candidateDict[key]

	for key, value in candidateDict.iteritems():
		#if value['STATE ABBREVIATION']=="NY":
		#	print value
		writer.writerow(value)

	ifile.close()
	ofile.close()

def main():
	outputDir = "./clean/"
	inputDir = "./preproc/"
	for f in listdir(inputDir):
		if f == ".DS_Store":
			continue
		cleanFile(inputDir+f, outputDir+f)

main()