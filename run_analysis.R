## run_analysis.R
## Data Science Specialization - Coursera
## Getting and Cleaning Data
## Project - Peer Assessment

library(reshape2)

## Read in training data
train.x <- read.table("UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("UCI HAR Dataset/train/Y_train.txt")
train.subject <- read.table("UCI HAR Dataset/train/subject_train.txt")

## Column bind training data to create training data set
train.data <- cbind(train.subject, train.y, train.x)

## Repeat for test data
test.x <- read.table("UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("UCI HAR Dataset/test/Y_test.txt")
test.subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
test.data <- cbind(test.subject, test.y, test.x)

## Row bind training and test data sets to create one data set
data.set <- rbind(train.data, test.data)

## Read in feature names
x.labels <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)$V2

## Label the columns of the merged data set
labels <- c("subject", "activity", x.labels)
names(data.set) <- labels

## Extract mean and standard deviations for each measurement using grep
data.extracted <- data.set[, grep(paste(c("subject", "activity", "^.*mean[(].*$","^.*std.*$"), collapse = "|"),names(data.set), ignore.case = TRUE)]

## Create tidy data set with the average of each variable for
## each activity and each subject - load reshape2 library to cast and decast data

melteddata <- melt(data.extracted, id.vars = c("activity", "subject"))
tidydata <- dcast(melteddata, subject + activity ~ variable, mean)

## Read in activity names
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt")$V2[1:6]

## Replace activity ids with activity names using lapply in both tidy and extracted data sets
data.extracted$activity <- unlist(lapply(data.extracted$activity, function(x) x <- activity.labels[x]))
tidydata$activity <- unlist(lapply(tidydata$activity, function(x) x <- activity.labels[x]))


write.table(tidydata, file ="~/tidydata2.txt", sep="\t", row.names=FALSE)



