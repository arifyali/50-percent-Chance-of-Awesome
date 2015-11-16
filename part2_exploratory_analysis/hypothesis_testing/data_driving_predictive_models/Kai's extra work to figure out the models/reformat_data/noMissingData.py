import csv
def reformat(inputFile, outputFile):
	ifile  = open(inputFile, "rb")
	reader = csv.DictReader(ifile)
	ofile  = open(outputFile, "wb")

	fieldnames = ['KEY','YEAR','STATE','FIRST','LAST','DISTRICT','CANDIDATE',
	'PARTY','INDUSTRYPERCENT','CANDTOTAL','INCUMBENT','VOTES','PERCENT','WINNER',
	'rank 1','rank 2','rank 3','rank 4','rank 5','rank 6',
	'rank 7','rank 8','rank 9','rank 10','rank 11','rank 12',
	'AMOUNT of 1','AMOUNT of 2','AMOUNT of 3',
	'AMOUNT of 4','AMOUNT of 5','AMOUNT of 6',
	'AMOUNT of 7','AMOUNT of 8','AMOUNT of 9',
	'AMOUNT of 10','AMOUNT of 11','AMOUNT of 12'
	]

	categoricalFields = ['KEY','YEAR','STATE','FIRST','LAST','DISTRICT','CANDIDATE',
	'PARTY','INCUMBENT','WINNER',
	'rank 1','rank 2','rank 3','rank 4','rank 5','rank 6',
	'rank 7','rank 8','rank 9','rank 10','rank 11','rank 12'
	]

	numericFields = [
	'VOTES','PERCENT','INDUSTRYPERCENT','CANDTOTAL','AMOUNT of 1','AMOUNT of 2','AMOUNT of 3',
	'AMOUNT of 4','AMOUNT of 5','AMOUNT of 6',
	'AMOUNT of 7','AMOUNT of 8','AMOUNT of 9',
	'AMOUNT of 10','AMOUNT of 11','AMOUNT of 12'
	]

	writer = csv.DictWriter(ofile, fieldnames=fieldnames)
	writer.writeheader()
	candidateDict = {}

	for row in reader:
		for key, value in row.iteritems():
			if value == '':
				if key in numericFields:
					row[key] = 0
				if key in categoricalFields:
					row[key] = "NULL"
		#print row
		writer.writerow(row)
	
	ifile.close()
	ofile.close()

def main():
	inputFile = "./reformatData.csv"
	outputFile = "./noMissingData.csv"

	reformat(inputFile, outputFile)

main()