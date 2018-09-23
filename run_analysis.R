
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
humanActivity <- rbind(
  cbind(trainSubjects, trainValues, trainActivity),
  cbind(testSubjects, testValues, testActivity)
)


# assigning column names
colnames(humanActivity) <- c("subject", features[, 2], "activity")



# determining columns of dataset to keep it based on column name
columnskeep <- grepl("subject|activity|mean|std", colnames(humanActivity))

# keeping data in these columns only
humanActivity <- humanActivity[, columnskeep]



# replacing activity values with named factor levels
humanActivity$activity <- factor(humanActivity$activity, 
                                 levels = activities[, 1], labels = activities[, 2])


# getting column names
humanActivityCols <- colnames(humanActivity)

# removing special characters
humanActivityCols <- gsub("[\\(\\)-]", "", humanActivityCols)

# expanding abbreviations and clean up names
humanActivityCols <- gsub("^f", "frequencyDomain", humanActivityCols)
humanActivityCols <- gsub("^t", "timeDomain", humanActivityCols)
humanActivityCols <- gsub("Acc", "Accelerometer", humanActivityCols)
humanActivityCols <- gsub("Gyro", "Gyroscope", humanActivityCols)
humanActivityCols <- gsub("Mag", "Magnitude", humanActivityCols)
humanActivityCols <- gsub("Freq", "Frequency", humanActivityCols)
humanActivityCols <- gsub("mean", "Mean", humanActivityCols)
humanActivityCols <- gsub("std", "StandardDeviation", humanActivityCols)

# correcting typo
humanActivityCols <- gsub("BodyBody", "Body", humanActivityCols)

# using new labels as column names
colnames(humanActivity) <- humanActivityCols


# grouping by subject and activity and summarise using mean
humanActivityMeans <- humanActivity %>% 
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

# output to file "tidy_data.txt"
write.table(humanActivityMeans, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)