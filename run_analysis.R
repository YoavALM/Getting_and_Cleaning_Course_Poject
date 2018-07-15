# Getting and Cleaning Data - week 4 - Course Project

#-----------------------------------------------------------------------------------------------------------------
# Downloading the raw data from it's URL:


# Create data folder within working directory (only IF doesn't exist yet)

if(!file.exists("./data")){dir.create("./data")}

# Downloding the data for the assignment (Please note that a full description of the data obtained can be
# found in: "http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones")

dataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataURL,destfile="./original_data.zip")
unzip(zipfile="./original_data.zip",exdir="./data")

#-----------------------------------------------------------------------------------------------------------------
# Reading the data into variables

test_set        <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
test_activity   <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
test_subject    <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

train_set       <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
train_activity  <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
train_subject   <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

features <- read.table('./data/UCI HAR Dataset/features.txt')

activity_labels = read.table('./data/UCI HAR Dataset/activity_labels.txt')


#-----------------------------------------------------------------------------------------------------------------
# Merging the training and the test sets to create one data set:

full_subject  <- rbind(test_subject, train_subject)
full_activity <- rbind(test_activity, train_activity)
full_set      <- rbind(test_set, train_set)

names(full_subject)  <-"subject"
names(full_activity) <-"activity"
names(full_set)      <- read.table(file.path("./data", "UCI HAR Dataset", "features.txt"),head=FALSE)$V2

full_data     <- cbind(full_subject, full_activity, full_set)


#-----------------------------------------------------------------------------------------------------------------
# Extracting only the measurements on the mean and standard deviation for each measurement

subset_i  <- names(full_set)[grep("mean\\(\\)|std\\(\\)", names(full_set))]
selected  <- c(as.character(subset_i), "subject", "activity" )
full_data <- subset(full_data,select=selected)


#-----------------------------------------------------------------------------------------------------------------
# Using descriptive activity names to name the activities in the data set

activity_labels <- read.table(file.path("./data", "UCI HAR Dataset", "activity_labels.txt"),header = FALSE)
full_data$activity <- factor(full_data$activity, labels = as.character(activity_labels[,2]))


#-----------------------------------------------------------------------------------------------------------------
# Appropriately labels the data set with descriptive variable names

names(full_data)<-gsub("^t", "Time", names(full_data))
names(full_data)<-gsub("^f", "Frequency", names(full_data))
names(full_data)<-gsub("Acc", "Accelerometer", names(full_data))
names(full_data)<-gsub("Gyro", "Gyroscope", names(full_data))
names(full_data)<-gsub("Mag", "Magnitude", names(full_data))
names(full_data)<-gsub("BodyBody", "Body", names(full_data))


#-----------------------------------------------------------------------------------------------------------------
# create a second, independent tidy data set with the average of each variable for each activity and each subject

tidy_data <- aggregate(. ~subject + activity, full_data, mean)
tidy_data <- tidy_data[order(tidy_data$subject, tidy_data$activity),]
write.table(tidy_data, file = "tidy_data.txt",row.name=FALSE)

