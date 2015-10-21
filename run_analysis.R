# Download and extract the dataset
URL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file <- "UCI_HAR_data.zip"
download.file(URL, destfile = file, method="auto", mode = "wb")
unzip(file)
file.remove("UCI_HAR_data.zip")

# Merge the training and the test sets to create one dataset
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

x_dataset <- rbind(x_train, x_test)
y_dataset <- rbind(y_train, y_test)
subject_dataset <- rbind(subject_train, subject_test)

# Extract only the measurements on the mean and standard deviation for each measurement
features <- read.table("UCI HAR Dataset/features.txt")
mean <- grepl("mean()", features[, 2])
std <- grepl("std()", features[, 2])
x_dataset <- x_dataset[, (mean | std)]

# Rename activities with descriptive activity names
colnames(y_dataset) <- "activity"
y_dataset$activity[y_dataset$activity == 1] <- "WALKING"
y_dataset$activity[y_dataset$activity == 2] <- "WALKING_UPSTAIRS"
y_dataset$activity[y_dataset$activity == 3] <- "WALKING_DOWNSTAIRS"
y_dataset$activity[y_dataset$activity == 4] <- "SITTING"
y_dataset$activity[y_dataset$activity == 5] <- "STANDING"
y_dataset$activity[y_dataset$activity == 6] <- "LAYING"

# Rename variables with descriptive variable names
colnames(x_dataset) <- features[(mean | std), 2]

colnames(subject_dataset) <- "subject"

# Combine x, y and subject datasets 
dataset <- cbind(x_dataset, y_dataset, subject_dataset)

# Create tidy dataset with the average of each variable for each activity and each subject.
library(plyr)
tidy_data <- ddply(dataset, .(activity, subject), function(x) colMeans(x[, 1:79]))
# Write tidy dataset into a txt file
write.table(tidy_data, "UCI_HAR_tidy.txt", row.names=FALSE)
