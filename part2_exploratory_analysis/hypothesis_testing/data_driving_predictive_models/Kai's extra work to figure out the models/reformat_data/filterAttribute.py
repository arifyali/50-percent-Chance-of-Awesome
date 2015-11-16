import csv
def reformat(inputFile, outputFile):
	ifile  = open(inputFile, "rb")
	reader = csv.DictReader(ifile)
	ofile  = open(outputFile, "wb")
	
	#writer = csv.writer(ofile, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL)
	originField = ['KEY','YEAR','STATE','FIRST','LAST','DISTRICT','CANDIDATE',
	'PARTY','INDUSTRYPERCENT','CANDTOTAL','INCUMBENT','VOTES','PERCENT','WINNER',
	'rank 1','rank 2','rank 3','rank 4','rank 5','rank 6',
	'rank 7','rank 8','rank 9','rank 10','rank 11','rank 12',
	'AMOUNT of 1','AMOUNT of 2','AMOUNT of 3',
	'AMOUNT of 4','AMOUNT of 5','AMOUNT of 6',
	'AMOUNT of 7','AMOUNT of 8','AMOUNT of 9',
	'AMOUNT of 10','AMOUNT of 11','AMOUNT of 12'
	]

	unwantedFields = [
		'STATE','KEY','YEAR','FIRST','LAST','DISTRICT','CANDIDATE','VOTES','PERCENT',

		#I don't want them in analysis
		'rank 6','rank 7','rank 8','rank 9','rank 10','rank 11','rank 12',

		#I don't want them in analysis
		'AMOUNT of 6','AMOUNT of 7','AMOUNT of 8','AMOUNT of 9',
		'AMOUNT of 10','AMOUNT of 11','AMOUNT of 12'
	]

	fieldnames = []
	for field in originField:
		if field not in unwantedFields:
			fieldnames.append(field)

	writer = csv.DictWriter(ofile, fieldnames=fieldnames)
	writer.writeheader()
	candidateDict = {}

	for row in reader:
		for field in unwantedFields:
			del row[field]
		writer.writerow(row)
	
	ifile.close()
	ofile.close()

def main():
	#inputFile = "./noMissingData.csv"
	inputFile = "./factorData.csv"
	outputFile = "./filterAttribute.csv"

	reformat(inputFile, outputFile)

main()