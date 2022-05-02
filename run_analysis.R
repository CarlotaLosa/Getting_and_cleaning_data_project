# Create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of 
#    each variable for each activity and each subject.

# Load required packages: reshape2 transposes data to wider format
library(data.table); library(tidyverse); library(reshape2)

# Load files
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[, 2]
features <- read.table("./UCI HAR Dataset/features.txt")[, 2]
extract_features <- str_detect(features, "mean|std")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Rename and organise
names(X_test) = features
X_test = X_test[, extract_features]
y_test[, 2] = activity_labels[y_test[, 1]]
names(y_test) = c("Activity_ID", "Activity_label")
names(subject_test) = "subject"
test_data <- cbind(subject_test, y_test, X_test)



names(X_train) = features
X_train = X_train[, extract_features]
y_train[, 2] = activity_labels[y_train[, 1]]
names(y_train) = c("Activity_ID", "Activity_label")
names(subject_train) = "subject"
train_data <- cbind(subject_train, X_train, y_train)

# Bind test and train data
data <- rbind(test_data, train_data)

# create vector of id labels
id_labels = c("subject", "Activity_ID", "Activity_label")

# create vector of data labels using setdiff (will select only names that are different between data and id_labels)
data_labels = setdiff(colnames(data), id_labels)

# melt the data (wide to long), measure.vars indicates the variables for melting
melt_data = melt(data, id = id_labels, measure.vars = data_labels)


# transpose variable into new columns, this column will contain the mean values for each variable and subject
tidy_data   = dcast(melt_data, subject + Activity_label ~ variable, mean)
write.table(tidy_data, file = "./UCI HAR Dataset/tidy_data.txt")

