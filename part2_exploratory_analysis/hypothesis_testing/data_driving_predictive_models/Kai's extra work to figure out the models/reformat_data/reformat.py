import csv

def reformat(inputFile, outputFile):
	ifile  = open(inputFile, "rb")
	reader = csv.DictReader(ifile)
	ofile  = open(outputFile, "wb")
	#writer = csv.writer(ofile, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL)
	fieldnames = ['KEY','YEAR','STATE','FIRST','LAST','DISTRICT','CANDIDATE',
	'PARTY','INDUSTRYPERCENT','CANDTOTAL','INCUMBENT','VOTES','PERCENT','WINNER',
	'rank 1','rank 2','rank 3','rank 4','rank 5','rank 6',
	'rank 7','rank 8','rank 9','rank 10','rank 11','rank 12',
	'AMOUNT of 1','AMOUNT of 2','AMOUNT of 3',
	'AMOUNT of 4','AMOUNT of 5','AMOUNT of 6',
	'AMOUNT of 7','AMOUNT of 8','AMOUNT of 9',
	'AMOUNT of 10','AMOUNT of 11','AMOUNT of 12'
	]

	writer = csv.DictWriter(ofile, fieldnames=fieldnames)
	writer.writeheader()
	candidateDict = {}

	for row in reader:
		row['KEY'] = row['STATE']+"|"+row['DISTRICT']+"|"+row['FIRST']+"|"+row['LAST']+"|"+row['YEAR']
		key = row['KEY']
		value = row
		#print row
		if candidateDict.has_key(key):
			writeRow = candidateDict.get(key)

			industry = row['PRIMARY.INDUSTRY']
			indrank = row['indrank']
			if industry == "":
				industry = "Other"
			writeRow['rank '+indrank] = industry

			amount = row['AMOUNT']
			writeRow['AMOUNT of '+indrank] = amount

			candidateDict[key] = writeRow
		else:
			industry = row['PRIMARY.INDUSTRY']
			indrank = row['indrank']
			if industry == "":
				industry = "Other"
			row['rank '+indrank] = industry
			del row['PRIMARY.INDUSTRY']
			del row['indrank']

			amount = row['AMOUNT']
			row['AMOUNT of '+indrank] = amount
			del row['AMOUNT']

			if row['WINNER'] == "0":
				row['WINNER'] = "L"
			else:
				row['WINNER'] = "W"
				
			candidateDict[key] = value
		#print candidateDict[key]

	for key, value in candidateDict.iteritems():
		writer.writerow(value)

	ifile.close()
	ofile.close()

def main():
	inputFile = "./PoldataSPIndustries.csv"
	outputFile = "./reformatData.csv"

	reformat(inputFile, outputFile)

main()