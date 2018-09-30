

library(dplyr)

# downloading zip file containing data if it hasn't already been downloaded
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
File <- "UCI HAR Dataset.zip"

if (!file.exists(File)) {
  download.file(Url, File, mode = "wb")
}

# unzip zip file containing data if data directory doesn't already exist
datapath <- "UCI HAR Dataset"
if (!file.exists(datapath)) {
  unzip(File)
}




# reading training data
trainSubjects <- read.table(file.path(datapath, "train", "subject_train.txt"))
trainValues <- read.table(file.path(datapath, "train", "X_train.txt"))
trainActivity <- read.table(file.path(datapath, "train", "y_train.txt"))

# read test data
testSubjects <- read.table(file.path(datapath, "test", "subject_test.txt"))
testValues <- read.table(file.path(datapath, "test", "X_test.txt"))
testActivity <- read.table(file.path(datapath, "test", "y_test.txt"))

# read features, don't convert text labels to factors
features <- read.table(file.path(datapath, "features.txt"), as.is = TRUE)


# reading activity labels
activities <- read.table(file.path(datapath, "activity_labels.txt"))
colnames(activities) <- c("activityId", "activityLabel")



# concatenating individual data tables to make single data table
human_Activity <- rbind(
  cbind(trainSubjects, trainValues, trainActivity),
  cbind(testSubjects, testValues, testActivity)
)


# assigning column names
colnames(human_Activity) <- c("subject", features[, 2], "activity")



# determining columns of dataset to keep it based on column name
columnskeep <- grepl("subject|activity|mean|std", colnames(human_Activity))

# keeping data in these columns only
human_Activity <- human_Activity[, columnskeep]



# replacing activity values with named factor levels
human_Activity$activity <- factor(human_Activity$activity, 
                                 levels = activities[, 1], labels = activities[, 2])


# getting column names
human_Activity_Cols <- colnames(human_Activity)

# removing special characters
human_Activity_Cols <- gsub("[\\(\\)-]", "", human_Activity_Cols)

# expanding abbreviations and clean up names
human_Activity_Cols <- gsub("^f", "frequencyDomain", human_Activity_Cols)
human_Activity_Cols <- gsub("^t", "timeDomain", human_Activity_Cols)
human_Activity_Cols <- gsub("Acc", "Accelerometer", human_Activity_Cols)
human_Activity_Cols <- gsub("Gyro", "Gyroscope", human_Activity_Cols)
human_Activity_Cols <- gsub("Mag", "Magnitude", human_Activity_Cols)
human_Activity_Cols <- gsub("Freq", "Frequency", human_Activity_Cols)
human_Activity_Cols <- gsub("mean", "Mean", human_Activity_Cols)
human_Activity_Cols <- gsub("std", "StandardDeviation", human_Activity_Cols)

# correcting typo
human_Activity_Cols <- gsub("BodyBody", "Body", human_Activity_Cols)

# using new labels as column names
colnames(human_Activity) <- human_Activity_Cols


# grouping by subject and activity and summarise using mean
human_Activity_Means <- human_Activity %>% 
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

write.table(human_Activity_Means, "tidy_data.txt", row.names = FALSE)
