

library(dplyr)

CreateLabels <- function(x) {
  # takes a vector with character entries which contain the encoded integer and the actual activity (thats how it got read into by read.table("activity.labels.txt"))

  # splitting up the characters to have the encoding integer and its corresponding activiy in one entry in one list
  labels.list <- strsplit(x, " ")
  
  # create functions to get the activity and the encoding integer from the list
  SecondElement <- function(x){tolower(x[2])}
  NameElement <- function(x){x[1]}

  # create a vector that has the descriptive activiy labels as entries and the encoding integers as names and return it
  labels.named <- sapply(labels.list,SecondElement)
  labels.named <- gsub("_"," ",labels.named)
  names(labels.named) <- sapply(labels.list,NameElement)
  
  return(labels.named)
}

MergeDataSets <- function(df.1,df.2,activity.1,activity.2,subject.1,subject.2,features,labels){
# Concatinates a dataframe from the given arguments
# This function perfomes step 1 from the 5 step list given in the course project overview 
# 
# Arguments: 
# df.1, df.2: two dataframes from the train and test datasets with the same features and concatinates them row-wise
# activity.1, activity.2: Activity vectors form the tran and test datasets, contains activity encoded as integers of the subjects
# subject.1, subject.2: Subject vectoros from the train and test datasets, contains the ids of the subjects
# features: names of the features for the columns in df.1 and df.2
# labels: lables for the acitivity.1 and activity.2 vectors who points the integers to one of 6 activities while recording.

# Functionaltiy of function:
# concatenates df.1 and df.2, activity.1 and acitvity.2, subject.1 and subject.2 each row-wise and concatenates all 3 results colum wise into a data frame. 
# The labels-vector is used to switcht the integers in "activity" to the descriptive activity with the function CreateLabels. 
# The features vector is used to rename the features of the resulting dataframe of the concatenation of df.1 and df.2.
# Optional Argument is the list.with.data.frames parameter, that can add the intertial data to the whole data.

  # merge the two datasets and rename the names to the features, which are given by the vector features
  whole.data <- rbind(df.1,df.2)
  names(whole.data) <- features

  # combine the subject vectors to one long vector
  all.subjects <- append(subject.1,subject.2)

  # use the activity column for dataframe 1 and dataframe 2 and append them to one long vector with the same length as the dataframe
  # watch out for the order and make sure the activiy form dataframe one is first in the vector
  activity <- append(activity.1,activity.2)

  # Add the activity vector and subject vector as id and activiy features to the dataset.
  whole.data$activity <- activity 
  whole.data$id <- all.subjects

  # Reoder the features to have the id as first entry and the activity as second
  whole.data <- whole.data[ , c(563,562,1:length(features))]

  # return the final dataset
  return(whole.data)
}

CheckforAllActivities <- function(whole.data) {
  # This function checks, if all subjects performed all tasks, according to https://class.coursera.org/getdata-030/forum/thread?thread.id=86#comment-478
  # every person should have performed each task at least once. This is a check, if the data got concatenated correctly. 

  # use for loop to get each person and a nested for loop to get every activity that every person performed at least once
  for (person in unique(whole.data$id)){
    for (act in unique(whole.data$activity)) {
        # if there is one person who didn't perform one task, it throws an error and stops the process
        if (!any(whole.data[(whole.data$id==person), 2]==act)) {
            message <- sprintf("%s didn't perfom activity %s",person,act)
            stop(act, message)
            geterrmessage()
        }
    }
  }
}

TakeTheMeanAndStd <- function(whole.data) {
  # This function performes Step2 and extracts the columns that carry a mean or std in their names 
  
  # Take all the feature names, that have the word mean in them and save them in avector 
  selectionvector.mean <- grep("mean", names(whole.data))
  # append it to c(1,2), as it will select the id and activiy column
  selectionvector <- append(c(1,2),selectionvector.mean)

  # Take all tehe feature names, which have the string std in them and save them in an extra vector
  selectionvector.std <- grep("std", names(whole.data)) 
  # append them to the selectionvector
  selectionvector <- append(selectionvector, selectionvector.std)

  # Select only the columns that have mean or std in their name from the data set and save it, return that data set
  smaller.data <- whole.data[ , selectionvector]
  return(smaller.data)
}

RenameActivity <- function(smaller.data,labels)  {
  # This function performes step 3 in the the 5 step instructionslist giben in the course project overview

  # Takes: a data set with one feature called activities and a list of labels, which has the descriptive labels for the encoded activies in the data frame
  # The labels list has the form: names: "1" "2" "3" "4" "5" "6", entries per name: "walking" "warking upstairs" "walking downstairs" "sitting" "standing" "laying"
  # Returns: a data set with desciptive values in the activites column.  
  
  # save the activity column in vector x
  x <- smaller.data$activity
    # using a for loop with seq_along to extract every value from x once and in order, where i is the index for each element
    for (i in seq_along(x)) {

      # use the index to get the value of that index in x, entry could be "4"
      entry <- as.character(x[i])
    # using if statement to have the possibility of tracking down na's or other possible errors in the data frame or the code
    if(entry %in% names(labels)){
      # knowing the value of the current entry, it can be retrieved from the labels-list, using the fact, that labels has all possible encodings as names
      activity <- labels[entry]
    # if the entry is not in the labels list, return an error and a error message
    } else {
      message <- sprintf(": No such label for an acitivity in row %i", i)
      stop(entry, message)
      geterrmessage()
    }
    # save the descriptive activity label in x at the very same index, where the encoded activiy was before (Replacing number with descriptive label)
    x[i] <- activity
  }
  x
  # Rename the activity column in the smaller.data dataframe
  smaller.data$activity <- x
  return(smaller.data)
}

RenameFeatures <- function(smaller.data) {
  # This function performs step 4 of the 5 step instruction list given in the course project overview

  # takes: a dataframe
  # returns: the same data frame with differen feature names, that are descriptive, without getting too long and formatted regarding the google's R style format 

  # read in the features
  features.old <- names(smaller.data)

  # Replace t for time series and f for fouriertransformed with time and fourier respectively
  renamed.features <- gsub("^t","time",features.old)
  renamed.features <- gsub("^f","fourier",renamed.features)

  # Remove the the naming mistakes in the original data set
  renamed.features <- gsub("BodyBody","Body",renamed.features)

  # Use dots to make the different components more visible, change everything to lower case
  # Choose 3 shortcuts, to replace them with a more descriptive, but longer and better understandable version: Acc, Gyro, Mag
  renamed.features <- gsub("Body",".body",renamed.features)
  renamed.features <- gsub("Gravity",".gravity",renamed.features)
  renamed.features <- gsub("Acc",".accelerometer",renamed.features)
  renamed.features <- gsub("Gyro",".gyroscope",renamed.features)
  renamed.features <- gsub("Jerk",".jerk",renamed.features)
  renamed.features <- gsub("Mag",".magnit",renamed.features)

  # Replace the not-standard-way of naming variables and remove extra parentheses. Additionally make the XYZ axes clear
  renamed.features <- gsub("-",".",renamed.features)
  renamed.features <- gsub("X$","X.axis",renamed.features)
  renamed.features <- gsub("Y$","Y.axis",renamed.features)
  renamed.features <- gsub("Z$","Z.axis",renamed.features)
  renamed.features <- gsub("\\(\\)","",renamed.features)

  # Replace the old features in the dataframe with the new ones and return the dataframe afterwards
  names(smaller.data) <- renamed.features
  return(smaller.data)
}

AggregateIdActivity <- function(smaller.data) {
  # This function performs Step 5 in the 5 Step instruction list given in the course project overview
  # aggregate the smaller.data.set by taking the mean of all columns grouped by all ids and all activities (180 Groups)
  aggreg.data <- aggregate(.~id+activity,data=smaller.data,mean)

  # Order the dataset according to id and as a second order activity and then return the aggregated data set
  aggreg.data <- aggreg.data[order(aggreg.data$id, aggreg.data$activity), ]
  return(aggreg.data)
}

# read.table interprets a vector as a one column dataframe and names the column V1.
# In order to get the vector, the column V1 of the the dataframe will be extracted, each time this situation occurs.

# read in all the necessary files for the test data
test <- read.table("test/X_test.txt")
activity.test <- read.table('test/y_test.txt')
activity.test <- activity.test$V1

subject.test <- read.table("test/subject_test.txt")
subject.test <- subject.test$V1

# read in all the necessary files for the train data
train <- read.table("train/X_train.txt")
activity.train <- read.table('train/y_train.txt')
activity.train <- activity.train$V1

subject.train <- read.table("train/subject_train.txt")
subject.train <- subject.train$V1

# read in the activity labels and the featurenames for the X_test.txt and X_train.txt files
labels <- readLines("activity_labels.txt")
# use function CreateLabels to get the list that is needed from the MergeDataSets Function
labels.names <- CreateLabels(labels)

features <- read.table("features.txt")
features <- features$V2

# Step 1: Merge the data sets
whole.data <- MergeDataSets(train,test,activity.train,activity.test,subject.train,subject.test,features,labels.names)

# Sanity Check
CheckforAllActivities(whole.data)

# Step 2: Take only data that contains the mean and the std
smaller.data <- TakeTheMeanAndStd(whole.data)

# Step 3: Rename the activities to human understandable form and not encoded
smaller.data <- RenameActivity(smaller.data,labels.names)

# Step 4: Renaming the features to readable features
smaller.data <- RenameFeatures(smaller.data)

# Step 5: Aggregates the data by taking the mean of all features accodring to ID and Activity
aggregated.data <- AggregateIdActivity(smaller.data)

# Save the tidy data set in a seperate file using the write.table function with row.names=FALSE as instructed.  
write.table(aggregated.data,"tidy_data.txt",row.names = FALSE)