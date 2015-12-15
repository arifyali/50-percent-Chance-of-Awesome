import csv
import sys
def main(argv):
	f = open(argv[1], "r")
	reader = csv.DictReader(f)
	loserWriter = open("loser.tsv","wb")
	loserWriter.write("letter\tfrequency\n")

	winnerWriter = open("winner.tsv","wb")
	winnerWriter.write("letter\tfrequency\n")

	winnerMap = {}
	winnerTotal = 0

	loserMap = {}
	loserTotal = 0

	for line in reader:
		fund = float(line['RaceFundPerc'])
		fundBin = int(fund*10)
		switcher = {
			0:"0-0.1",
			1:"0.1-0.2",
			2:"0.2-0.3",
			3:"0.3-0.4",
			4:"0.4-0.5",
			5:"0.5-0.6",
			6:"0.6-0.7",
			7:"0.7-0.8",
			8:"0.8-0.9",
			9:"0.9-1.0",
			10:"0.9-1.0"
		}

		bin = switcher[fundBin]
		if line['WINNER']=='1':
			winnerTotal+=1
			if bin in winnerMap.keys():
				winnerMap[bin] = winnerMap[bin]+1
			else:
				winnerMap[bin] = 1
		else:
			loserTotal+=1
			if bin in loserMap.keys():
				loserMap[bin] = loserMap[bin]+1
			else:
				loserMap[bin] = 1
	keys = ["0-0.1","0.1-0.2","0.2-0.3","0.3-0.4","0.4-0.5","0.5-0.6",
		"0.6-0.7","0.7-0.8","0.8-0.9","0.9-1.0","0.9-1.0"]
	for key in keys:
		if key in winnerMap.keys():
			winnerWriter.write(key+"\t"+str(float(winnerMap[key])/float(winnerTotal))+"\n")
		else:
			winnerWriter.write(key+"\t0\n")
	winnerWriter.write(" \t0")

	for key in keys:
		if key in loserMap.keys():
			loserWriter.write(key+"\t"+str(float(loserMap[key])/float(loserTotal))+"\n")
		else:
			loserWriter.write(key+"\t0\n")
	loserWriter.write(" \t0")

main(sys.argv)