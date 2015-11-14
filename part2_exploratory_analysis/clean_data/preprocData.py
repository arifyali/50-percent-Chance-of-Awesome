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

			row['STATE ABBREVIATION']=row['STATE ABBREVIATION'].strip()
			row['DISTRICT']=row['DISTRICT'].strip()
			row['FEC ID']=row['FEC ID'].strip()

			row['INCUMBENT INDICATOR']=row['INCUMBENT INDICATOR'].strip()
			if row['INCUMBENT INDICATOR']=="(I)":
				row['INCUMBENT INDICATOR'] = True
			else:
				row['INCUMBENT INDICATOR'] = False

			row['FIRST NAME']=row['FIRST NAME'].strip()
			row['LAST NAME']=row['LAST NAME'].strip()
			row['PARTY']=row['PARTY'].strip()

			row['KEY'] = row['STATE ABBREVIATION']+"|"+row['DISTRICT']+"|"+row['FIRST NAME']+"|"+row['LAST NAME']+"|"+row['YEAR']



			row['PRIMARY'] = row['PRIMARY'].strip()	
			row['PRIMARY %'] = row['PRIMARY %'].strip()
			if row['PRIMARY'] == "Unopposed":
				row['PRIMARY'] = 0
			else :
				try:
					row['PRIMARY'] = int(str(row['PRIMARY']).replace(",",""))
				except ValueError:
					row['PRIMARY'] = ""

			try:
				row['PRIMARY %'] = float(str(row['PRIMARY %']).strip('%'))/100
			except ValueError:
				row['PRIMARY %'] = ""

			row['RUNOFF']=row['RUNOFF'].strip()
			row['RUNOFF %']=row['RUNOFF %'].strip()
			if row['RUNOFF'] == "Unopposed":
				row['RUNOFF'] = 0
			else:
				try:
					row['RUNOFF'] = int(str(row['RUNOFF']).replace(",",""))
				except ValueError:
					row['RUNOFF'] = ""

			try:
				row['RUNOFF %'] = float(str(row['RUNOFF %']).strip('%'))/100
			except ValueError:
				row['RUNOFF %'] = ""

			row['GENERAL']=row['GENERAL'].strip()
			row['GENERAL %']=row['GENERAL %'].strip()
			if row['GENERAL'] == "Unopposed":
				row['GENERAL'] = 0;
			else:
				try:
					row['GENERAL'] = int(str(row['GENERAL']).replace(",",""))
				except ValueError:
					row['GENERAL'] = ""

			try:
				row['GENERAL %'] = float(str(row['GENERAL %']).strip('%'))/100
			except ValueError:
				row['GENERAL %'] = ""
		writer.writerow(row)

	ifile.close()
	ofile.close()

def main():
	inputDir = "./unclean/"
	outputDir = "./preproc/"
	for f in listdir(inputDir):
		if f == ".DS_Store":
			continue
		cleanFile(inputDir+f, outputDir+f)

main()