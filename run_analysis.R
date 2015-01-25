setwd("~/RWorkspace")
## Create data download folder
if (!file.exists("course_project_data")) {
    dir.create("course_project_data")
}
## Download project data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./course_project_data/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
#Unzip the downloaded data archive
unzip("./course_project_data/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", exdir="course_project_data/dataset", junkpaths=TRUE)
## Merge the training and the test sets to create one data set.
#Read test data
X_test <- read.table("course_project_data/dataset/X_test.txt")
y_test <- read.table("course_project_data/dataset/y_test.txt")
subject_test <- read.table("course_project_data/dataset/subject_test.txt")
#Combine features, activity id and subject id
test <- cbind(X_test, y_test, subject_test)
#Read train data
X_train <- read.table("course_project_data/dataset/X_train.txt")
y_train <- read.table("course_project_data/dataset/y_train.txt")
subject_train <- read.table("course_project_data/dataset/subject_train.txt")
#Combine features, activity id and subject id
train <- cbind(X_train, y_train, subject_train)
#Merge the test and train datasets
merged <- rbind(test, train)
# Read feature labels
features <- read.table("course_project_data/dataset/features.txt")
# Create additional headings for activity and subject IDs
activity <- data.frame(V1=562, V2="ActivityID")
subject <- data.frame(V1=563, V2="SubjectID")
# Combine all labels into a master list
labels <- rbind(features,activity, subject)
# Add labels to the merged dataset
colnames(merged) <- labels[,2]
##Extract only the measurements on the mean and standard deviation for each measurement. 
#Use regex to specify columns refering to mean(), std() and pick up Activity and Subject IDs
merged <- merged[,grep("-mean\\(\\)|-std\\(\\)|ActivityID|SubjectID",names(merged),value=T)]
## Use descriptive activity names to name the activities in the data set
#Read the activity labels
activityLabels <- read.table("course_project_data/dataset/activity_labels.txt")
colnames(activityLabels) <- c("ActivityID", "ActivityName")
# Merge the ActivityName field into merged data set
merged <- merge(merged, activityLabels, by = "ActivityID")
## Create a second, independent tidy data set with the average of each variable for each activity and each subject.
#Aggregate all columns by SubjectID and ActivityName + remove ActivityID column
tidy <-  aggregate(. ~ SubjectID + ActivityName, data = merged[,-merged$ActivityID], mean)
#Write the tidy dataset to a file
write.table(tidy, file="course_project_data/tidy_data.txt", row.name=FALSE)  


