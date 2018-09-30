# Getting-and-Cleaning-data-course-project

This repository contains the following files:

1) EADME.md, this file, which provides an overview of the data set and how it was created.

2) tidy_data.txt, which contains the data set.

3) CodeBook.md, the code book, which describes the contents of the data set.

4) run_analysis.R, the R script that was used to create the data set

# Study design.


Training and test data were first merged together to create one data set, then the measurements on the mean and standard deviation were extracted for each measurement, and then the measurements were averaged for each subject and activity, resulting in the final data set.


# Creating the data set.

The R script run_analysis.R is used for :-

1) Creating the data set. 

2) Downloading and unzip source data if it doesn't exist

3) Reading data.

4) Merging the training and the test sets to create one data set.

5) Extracting only the measurements on the mean and standard deviation for each measurement.

6) Using descriptive activity names to name the activities in the data set.

7) Appropriately labeling the data set with descriptive variable names.

8) Creating a second, independent tidy set with the average of each variable for each activity and each subject.

9) Writing the data set to the tidy_data.txt file.
