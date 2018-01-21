
# The code assumes that the data has already been downloaded and unzipped manually

# remove all items in workspace
rm(list = ls())

# load libraries
library(dplyr)

## 1. Merges the training and the test sets to create one data set.
# set the working directory
setwd(
      'C:/Users/claudia.brem/Desktop/R_Skripte/coursera/2_Getting_and_Cleaning_Data/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/'
)

# read the data about features and activity
features <- read.table(file = "./features.txt"
                       , sep = " ")

activity_labels <- read.table(file = "./activity_labels.txt"
                              , sep = " ")

# read the training data
subject_train <- read.table(file = "./train/subject_train.txt"
                            , sep = " ")

x_train <- read.table(file = "./train/X_train.txt")

y_train <- read.table(file = "./train/y_train.txt"
                      , sep = " ")

# read the test data
subject_test <- read.table(file = "./test/subject_test.txt"
                           , sep = " ")

x_test <- read.table(file = "./test/X_test.txt")

y_test <- read.table(file = "./test/y_test.txt"
                     , sep = " ")

## 3. Uses descriptive activity names to name the activities in the data set
colnames(activity_labels) <- c("activity_id", "activity_type")
colnames(subject_train) <- "subject_id"
colnames(x_train) <- features[, 2]
colnames(y_train) <- "activity_id"
colnames(subject_test) <- "subject_id"
colnames(x_test) <- features[, 2]
colnames(y_test) <- "activity_id"

# merge the training and test data into one data set, respectively
training_data <- cbind(subject_train, x_train, y_train)
test_data <- cbind(subject_test, x_test, y_test)

# combine test and training data
final_data <- rbind(training_data, test_data)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
names <- names(final_data)
names_wanted <- (
      grepl("subject_id", names) |
            grepl("mean\\(\\)", names) |
            grepl("std\\(\\)", names)  |
            grepl("activity_id", names)
)

names <- names[names_wanted]
final_data <- final_data[, names]

## 4. Appropriately label the data set with descriptive activity names.
final_data <- merge(final_data, activity_labels, by = "activity_id")

names(final_data) <- gsub("^t", "time", names(final_data))
names(final_data) <- gsub("^f", "frequency", names(final_data))
names(final_data) <- gsub("Acc", "Accelerometer", names(final_data))
names(final_data) <- gsub("Gyro", "Gyroscope", names(final_data))
names(final_data) <- gsub("Mag", "Magnitude", names(final_data))
names(final_data) <- gsub("BodyBody", "Body", names(final_data))

## 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.
by_group <-
      group_by(final_data, subject_id, activity_id, activity_type)
final_data <- summarize_all(by_group, "mean")

#write table
write.table(final_data, "./tidy_data.txt", sep = "\t", row.names = FALSE)
