library(reshape2)
library(plyr)


## download and unzip files
rm(list = ls())
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "dataset.zip", mode = "wb")
unzip("dataset.zip")

folder <- unzip("dataset.zip", list=TRUE)
setwd("./UCI HAR Dataset")

## read files into R objects
feature <- read.table("./features.txt")
activity <- read.table("./activity_labels.txt")
subject_train <- read.table("./train/subject_train.txt")
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_test <- read.table("./test/subject_test.txt")
x_test <- read.table("./test/X_test.txt")
y_test  <- read.table("./test/y_test.txt")


## 1. Merges the training and the test sets to create one data set.
combined_overall <- rbind(x_train,x_test)

## 2. Extracts only the measurements on the mean and standard 
##   deviation for each measurement.
mean_pos <- grep("mean\\(\\)", feature[[2]])
std_pos <- grep("std\\(\\)",feature[[2]])
combined_stat <- combined_overall[c(mean_pos,std_pos)]

## 3.Uses descriptive activity names to name the activities in the data set
y_overall <- rbind(y_train,y_test)
subject_overall <- rbind(subject_train, subject_test)
colnames(y_overall) <- "Act_ID"
colnames(activity)[1] <-"Act_ID"
colnames(activity)[2] <- "Activity"
combined_stat1 <- cbind(combined_stat, y_overall,subject_overall)
activity_mapped <- merge(activity,combined_stat1, by = "Act_ID")


## 4.Appropriately labels the data set with descriptive variable names.
for(i in 1: length(combined_stat))
{
colnames(activity_mapped)[i+2] <- as.character(feature[extract_numeric(colnames(activity_mapped)[i+2])==feature[,1],2])
}

## improve on descriptive names on variables
colnames(activity_mapped)[length(activity_mapped)] <- "Subject"
names(activity_mapped)<-gsub("^t", "time", names(activity_mapped))
names(activity_mapped)<-gsub("^f", "frequency", names(activity_mapped))
names(activity_mapped)<-gsub("Acc", "Accelerometer", names(activity_mapped))
names(activity_mapped)<-gsub("Gyro", "Gyroscope", names(activity_mapped))
names(activity_mapped)<-gsub("Mag", "Magnitude", names(activity_mapped))
names(activity_mapped)<-gsub("BodyBody", "Body", names(activity_mapped))

write.table(activity_mapped, file = "tidydata.txt",row.name=FALSE)

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of 
##    each variable for each activity and each subject.
activity_mapped$Activity <- factor(activity_mapped$Activity)
activity_mapped$Subject <- factor(activity_mapped$Subject)

## Method 1 - Using decast approach based on reshape2
data_melt <- melt(activity_mapped, id = c("Activity", "Subject"))
data_decast_m <- dcast(data_melt, Subject+Activity ~ variable, mean)

## Method 2 - using aggregate approach based on plyr
by_groups <- aggregate(. ~ Subject + Activity, activity_mapped, mean)
by_groups<-by_groups[order(by_groups$Subject,by_groups$Activity),]
write.table(by_groups, file = "tidydata.txt",row.name=FALSE)


