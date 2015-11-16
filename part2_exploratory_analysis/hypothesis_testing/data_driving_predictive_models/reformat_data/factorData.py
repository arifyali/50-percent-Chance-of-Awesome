#factor data


import csv
def factor(inputFile, outputFile):
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
	industryFactorDict = {
		"NULL":0,
		"Not for profit":1,
		"Financials":2,
		"Consumer Staples":3,
		"Industrials":4,
		"Consumer Discretionary":5,
		"Materials":13,
		"Utilities":6,
		"Information Technology":7,
		"Not publicly traded":8,
		"Health Care":9,
		"Telecommunication Services":10,
		"Energy":11,
		"Other":12
	}
	partyDict = {
		"D":1,
		"I":2,
		"R":3
	}
	rankList = ["rank 1", "rank 2", "rank 3", "rank 4", "rank 5"]

	writer = csv.DictWriter(ofile, fieldnames=fieldnames)
	writer.writeheader()
	candidateDict = {}

	for row in reader:
		for key in rankList:
			row[key] = industryFactorDict[row[key]]
		row['PARTY'] = partyDict[row['PARTY']]

		writer.writerow(row)
	
	ifile.close()
	ofile.close()

def main():
	inputFile = "./noMissingData.csv"
	outputFile = "./factorData.csv"

	factor(inputFile, outputFile)

main()