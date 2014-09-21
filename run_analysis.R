
# 1. Download and unzip files 
fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="assig2.zip")
unzip("assig2.zip", exdir="assig2")
setwd("C:/Users/keilor.rojas/Desktop/Mis Documentos/Coursera/z getting data/assig2/UCI HAR Dataset")


# 2. Read tables and label columns with appropiate names for test and train sets 
#    Also select only the columns with the mean and std calculations
library(data.table)
library(dplyr)
test_set <- read.table(".//test/X_test.txt",stringsAsFactors=FALSE, header=FALSE)
        features <- read.table("features.txt", header=FALSE)
        colnames(test_set) <- features$V2
        test_set <- select(test_set, contains("mean"), contains("std"))
test_label <- read.table(".//test/y_test.txt",header=FALSE)
        colnames(test_label) <- "Activity"
testsubject <- read.table(".//test/subject_test.txt", header=FALSE)
        colnames(testsubject) <- "Subject"
test_set <-cbind(test_set,test_label)
test_set<-cbind(test_set,testsubject)

train_set <- read.table(".//train/X_train.txt",stringsAsFactors=FALSE, header=FALSE)
        features <- read.table("features.txt", header=FALSE)
        colnames(train_set) <- features$V2
        train_set <- select(train_set, contains("mean"), contains("std"))
train_label <- read.table(".//train/y_train.txt",header=FALSE)
        colnames(train_label) <- "Activity"
trainsubject <- read.table(".//train/subject_train.txt",header=FALSE)
        colnames(trainsubject) <- "Subject"
train_set <-cbind(train_set,train_label)
train_set<-cbind(train_set,trainsubject)


# 3. Merge the data sets 
Data <-rbind(test_set,train_set)
dim(Data)


# 4. Edit Activity column with corresponding activity types and coerce Subject as factor
activities <- read.table("activity_labels.txt", header=FALSE)
Activity_type <- factor(Data$Activity, levels=activities$V1, labels=activities$V2)
Data <- mutate(Data, Activity=Activity_type)
Data$Subject <- as.factor(Data$Subject)


# 5. Make a new data frame with the mean value of each activity-subject interaction, 
#  eliminate from the same data set the values corresponding to activity and subject
tidy = aggregate(Data, by=list(Activity=Data$Activity, Subject=Data$Subject), mean)
tidy[,90] = NULL
tidy[,89] = NULL
dim(tidy)


# 6. Write tidy data set in a new file
write.table(tidy, file="tidy.txt")


