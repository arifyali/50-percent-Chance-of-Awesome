# Given some of the different questions that I am 
# getting, I decided to add some more R informaton.
# Once you are in R, below are different useful
# commands. Much of this is based on an onlne
# tutorial - http://ww2.coastal.edu/kingw/statistics/R-tutorials/

# Quit
q()

# List the contents (variables, data frames, etc.) in 
# your workspace.
ls()

# Clear your workspace
rm(list=ls())

# List the files in the working directory 
dir()

# There are a lot of different data objects in R. You are
# not going to be able to use them all, but the flexibility
# to use the ones you need is important.

# Standard data frame
# In a standard data frame, each case or observation is a row. Each
# column is a varable. Many times, the first column is the identifier
# for the row. Data frame data looks like spreadsheet data. The
# first row is the header. It contains the variable names. Headers
# are not required, but they are useful.

# Let's load vector data (a list of values) in R
data(rivers)

# View vector of data (shortcut - only type 'rivers')
print(rivers)

# Let's see items 1 through 10. If you see an NA, that means that
# there is no value for the specified list element.
rivers[1:10]

# You can also have named vectors
data(islands)
print(islands)

# Now you can access data in the named vector by name or by value
islands["Victoria"]

# Create a vector
myTemperature = c(90, 88, 32, 100, 93)

# Create a second vector
myTemperatureWinter = c(2, 0, 10, 5, 4)

# Concatenate the two vectors
myWeather = c(myTemperature, myTemperatureWinter)

# Sort a vector
sort(myWeather)

# Using a logical condition to determine the vector values
# that meet the condition and those that do not.
myWeather >= 90

# You can use it within a function as well
# This statement below tells you how many times
# the myWeather vecto has a value over 90
sum(myWeather >= 90)

# Tables - Use if you want to create frequency tables 
# or cross tabulations from vector data or data frame data.
myRandomValuesA = rnorm(100, mean=10, sd=5)	# 100 normally distributed points 
myRandomValuesA = round(myRandomValuesA, 0) 	# Keep 0 decimal places

# Here is a one dimensional table.
myTable <- table(myRandomValuesA)

# Let's load a data frame that is already in R
data(women)
print(women)

# Get the names of the variabls in the data frame
names(women)

# Look at the internal structure of the data frame
str(women)

# Refer to different subsets of the frame
# Note that the index numbers in the data frame do not
# always remain the same.
women[10,2]		# row 10, column 2
women[8,]		# row 8, all columns
women[1:10,]		# rows 1 to 10, all columns
women[,2]	`	# all rows, column 2
women[c(1,2,5,7),]	# rows 1, 2, 5, 7, all columns

# Refer to a subse of the data dframe using the column name
women$height
mean(women$height)
cor(women$height, women$weight)

# Sort data and put it in a new frame after asigning to a new frame
mydata <- women
mydata[order(mydata$weight),] -> mydataSorted

# Create a new variable (column) in the data frame that is the addition of the
# height and weight
c(mydataSorted$height + mydataSorted$weight) -> mydataSorted$hwaddition

# Get rid of the column by setting everything to NULL (of course you can detach too)
mydataSorted$hwaddition <- NULL

# If you have missing values, you need to tell R before computing a stat
library(MASS)
data(Cars93)
Cars93$Luggage.room			# Variable with missing values (Notice NA values)
mean(Cars93$Luggage.room, na.rm=TRUE)	# Compute mean, ignore nulls

# Create a new data frame and remove all cases containing nulls
Cars93$Luggage.room -> myData
na.omit(myData) -> myDataNoNulls

# Use ifelse to create new variable values. In this example, 
# a new variable is tall or short depending on the height.
ifelse(mydataSorted$height >= 70, "tall", "short") -> mydataSorted$heightBin

# Suppose I only want those rows that have a height of 70 or above
subset(mydataSorted, subset=(mydataSorted$height >= 70)) -> myDataChunk


# A boxplot of the island data set using a log scale.
boxplot(log(islands), main="Boxplot of Islands", ylab="logscale(Land Area)")

