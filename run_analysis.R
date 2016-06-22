## 1. Merge the training and the test sets to create one data set.

# First let's load some libraries that will be useful, get the files downloaded,
# unzipped and loaded into memory.

library(downloader)
library(reshape2)
library(dplyr)
fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download(fileUrl, "run_data.zip")
unzip("run_data.zip")
traindata = read.table("./UCI HAR Dataset/train/X_train.txt")
trainlabels = read.table("./UCI HAR Dataset/train/y_train.txt")
trainsubject = read.table("./UCI HAR Dataset/train/subject_train.txt")
testdata = read.table("./UCI HAR Dataset/test/X_test.txt")
testlabels = read.table("./UCI HAR Dataset/test/y_test.txt")
testsubject = read.table("./UCI HAR Dataset/test/subject_test.txt")
varnames = read.table("./UCI HAR Dataset/features.txt")

# Let's change the variable names to be more useful
names(testdata) = varnames$V2
names(traindata) = varnames$V2
testlabels = rename(testlabels, activityid = V1)
testsubject = rename(testsubject, subjectid = V1)
trainlabels = rename(trainlabels, activityid = V1)
trainsubject = rename(trainsubject, subjectid = V1)

# Now we need to bind the subject identifiers, activity identifiers and the 
# data together using cbind() for the training and test data
traindata2 = cbind(trainsubject, trainlabels, traindata)
testdata2 = cbind(testsubject, testlabels, testdata)

# And then combine the two data frames using rbind, change the variable names 
# for subjectid and activityid, and reformat using tbl_df to make the data 
# easier to handle
df = rbind(traindata2, testdata2)
df = tbl_df(df)

## 2. Extract only the measurements on the mean and standard
## deviation for each measurement.

# There are a bunch of duplicate variable names, but none of them are for mean
# or standard deviation measurements, so let's get rid of those
df2 = df[ , !duplicated(colnames(df))]

# Use select() and matches() to select only those columns that 
# contain "mean()" or "std()", and assign to df3, then bind that back to the 
# subjectid and activityid columns
df3 = select(df2, matches("mean\\(\\)|std\\(\\)"))
df4 = cbind(df2$subjectid, df2$activityid, df3)
df4 = rename(df4, subjectid = `df2$subjectid`, activityid = `df2$activityid`)
df4 = tbl_df(df4)

## 3. Uses descriptive activity names to name the activities in the data set

# We have integers in the activityid column, which we need to change to 
# factors in keeping with the labels in activity_labels.txt. Let's read that 
# file into memory
act_labels = read.table("./UCI HAR Dataset/activity_labels.txt")
charlabels = as.character(act_labels$V2)

# And now change the integers to factors and relabel them with the character 
# vector charlabels created above
df4$subjectid = as.factor(df4$subjectid)
df4$activityid = as.factor(df4$activityid)
levels(df4$activityid) = charlabels

# That gives us useful labels for the activities in the data set

## 4. Appropriately labels the data set with descriptive variable names.
# This was handled above

## 5. From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.

# First we melt the data frame down, and then cast it with mean values as 
# required

melted = melt(df4, id = c("subjectid", "activityid"))
recast = dcast(melted, subjectid + activityid ~ variable, mean)

# And finally write out the file we need, calling it tidydata.txt

write.table(recast, "tidydata.txt", quote = FALSE, row.names = FALSE)