import csv
from os import listdir

def cleanFile(inputFile, outputFile):
	ifile  = open(inputFile, "rb")
	reader = csv.DictReader(ifile)
	ofile  = open(outputFile, "wb")
	#writer = csv.writer(ofile, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL)
	fieldnames = ['KEY','STATE ABBREVIATION','DISTRICT','FEC ID','INCUMBENT INDICATOR','FIRST NAME','LAST NAME','PARTY','YEAR','PRIMARY','PRIMARY %','RUNOFF','RUNOFF %','GENERAL','GENERAL %']
	writer = csv.DictWriter(ofile, fieldnames=fieldnames)
	writer.writeheader()

	for row in reader:
		if row['DISTRICT']=="" or row['FIRST NAME']=="" or row['LAST NAME']=="": 
			continue
		else:
			#row['KEY']
			#print row
			row['YEAR'] = inputFile[10:14]

			row['KEY'] = row['STATE ABBREVIATION']+"|"+row['DISTRICT']+"|"+row['FIRST NAME']+"|"+row['LAST NAME']+"|"+row['YEAR']


			#row['STATE ABBREVIATION']
			#row['DISTRICT']
			#row['FEC ID']

			#row['INCUMBENT INDICATOR']
			if row['INCUMBENT INDICATOR']=="(I)":
				row['INCUMBENT INDICATOR'] = True
			else:
				row['INCUMBENT INDICATOR'] = False

			#row['FIRST NAME']
			#row['LAST NAME']
			#row['PARTY']



			#row['PRIMARY']	
			#row['PRIMARY %']
			#row['RUNOFF']
			#row['RUNOFF %']
			#row['GENERAL']
			#row['GENERAL %']
			try:
				row['PRIMARY'] = int(str(row['PRIMARY']).replace(",",""))
			except ValueError:
				row['PRIMARY'] = "nan"

			#float(x.strip('%'))/100
			try:
				row['PRIMARY %'] = float(str(row['PRIMARY %']).strip('%'))/100
			except ValueError:
				row['PRIMARY %'] = "nan"

			try:
				row['RUNOFF'] = int(str(row['RUNOFF']).replace(",",""))
			except ValueError:
				row['RUNOFF'] = "nan"

			try:
				row['RUNOFF %'] = float(str(row['RUNOFF %']).strip('%'))/100
			except ValueError:
				row['RUNOFF %'] = "nan"

			try:
				row['GENERAL'] = int(str(row['GENERAL']).replace(",",""))
			except ValueError:
				row['GENERAL'] = "nan"

			try:
				row['GENERAL %'] = float(str(row['GENERAL %']).strip('%'))/100
			except ValueError:
				row['GENERAL %'] = "nan"
		writer.writerow(row)

	ifile.close()
	ofile.close()

def main():
	inputDir = "./unclean/"
	outputDir = "./clean/"
	for f in listdir(inputDir):
		if f == ".DS_Store":
			continue
		cleanFile(inputDir+f, outputDir+f)

main()