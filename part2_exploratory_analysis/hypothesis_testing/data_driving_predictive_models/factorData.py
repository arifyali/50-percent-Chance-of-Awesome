

import csv
def factor(inputFile, outputFile):
	ifile  = open(inputFile, "rb")
	reader = csv.DictReader(ifile)
	ofile  = open(outputFile, "wb")
	
	#writer = csv.writer(ofile, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL)
	#factor data
	industryFactorDict = {
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
	rankList = ['rank 1','rank 2','rank 3','rank 4','rank 5']

	writer = csv.DictWriter(ofile, fieldnames=fieldnames)
	writer.writeheader()
	candidateDict = {}

	for row in reader:
		for key in rankList:
			row[key] = industryFactorDict[row[key]]
		row['PARTY'] = parityDict[row['PARTY']]
		writer.writerow(row)
	
	ifile.close()
	ofile.close()

def main():
	inputFile = "./noMissingData.csv"
	outputFile = "./filterAttribute.csv"

	reformat(inputFile, outputFile)

main()