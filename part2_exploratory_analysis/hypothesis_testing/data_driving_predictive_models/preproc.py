import csv
import sys
import random
def main():
	f = open(sys.argv[1])
	train = open(sys.argv[1][:-5]+"csv","wb")
	#test = open("test.csv","wb")
	trainWriter = csv.writer(train,delimiter=',')
	#testWriter = csv.writer(test)

	#testWriter.writerow(["attr1","attr2","attr3","attr4","class"])
	#trainWriter.writerow(["attr1","attr2","attr3","attr4","class"])
	for line in f:
		#r = random.randint(0, 9)
		array = line.strip('\n').split(",")
		
		#if r<1:
		#	print ",".join(array)
		#	testWriter.writerow(array)
		#else:
		trainWriter.writerow(array)

main()

