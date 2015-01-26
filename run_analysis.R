# get train and test data 
dataTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
dataTest <- read.table("UCI HAR Dataset/test/X_test.txt")

# combine train data and test data
dataTotal <- rbind(dataTrain, dataTest)

#get feature with mean() or std()
dataFeature <- read.table("UCI HAR Dataset/features.txt")
selectedFeatures <- grep("std\\(\\)|mean\\(\\)", feature.names$V2)

# get data only with selected features
dataTotal <- dataTotal[,selectedFeatures]

# add column names to selected total data
colnames(dataTotal) <- dataFeature[selectedFeatures, 2]

# combine train and test data for activity code (y_ .txt)
dataActivitiesTest <- read.table("UCI HAR Dataset/test/y_test.txt")
dataActivitiesTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
dataTotalActivities <- rbind(dataActivitiesTrain, dataActivitiesTest)

# replace activity code with activity label
dataActivitiesLabel <- read.table("UCI HAR Dataset/activity_labels.txt")
dataTotalActivities$activity <- factor(dataTotalActivities$V1, levels = dataActivitiesLabel$V1, labels = dataActivitiesLabel$V2)

# combine the id data of  train and test subject 
dataSubjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
dataSubjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
dataTotalSubject <- rbind(dataSubjectTrain, dataSubjectTest)

# combine name subject and activity name
dataSubjectActivities <- cbind(dataTotalSubject, dataTotalActivities$activity)
colnames(dataSubjectActivities) <- c("subject.id", "activity")

# combine name subject and activity name and data
dataTotalSubjectActivities <- cbind(dataSubjectActivities, dataTotal)

# calculate average of each variable for each activity and each subject
secondTidyDataset <- aggregate(dataTotalSubjectActivities[,3:68], by = list(dataTotalSubjectActivities$subject.id, dataTotalSubjectActivities$activity), FUN = mean)
colnames(secondTidyDataset)[1:2] <- c("subject.id", "activity")

# write into file for upload
write.table(secondTidyDataset, file="secondTidyDataset.txt", row.names = FALSE)
