## 1. Merge the training and the test sets to create one data set.

# First lets load some libraries that will be useful, get the file downloaded,
# unzipped and loaded into memory.

library(downloader)
library(lubridate)
library(dplyr)
fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download(fileUrl, "run_data.zip")
unzip("run_data.zip")
traindata = read.table("./UCI HAR Dataset/train/X_train.txt")
trainlabels = read.table("./UCI HAR Dataset/train/y_train.txt")
testdata = read.table("./UCI HAR Dataset/test/X_test.txt")
testlabels = read.table("./UCI HAR Dataset/test/y_test.txt")

# Because the columns have identical names we can 
# combine the two data frames using rbind, and reformat using tbl_df to make 
# our data easier to handle
df = rbind(testdata, traindata)
df = tbl_df(df)

## 2. Extracts only the measurements on the mean and standard
## deviation for each measurement.

# Firstly we need to change the variable names to something more useful. The 
# headings are in the features.txt file, so let's read that into memory
varnames = read.table("./UCI HAR Dataset/features.txt")
varnames = tbl_df(varnames)

# Now reassign the variable names for df using names()
names(df) = varnames$V2

# From reading the support files we can see that each of the 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
