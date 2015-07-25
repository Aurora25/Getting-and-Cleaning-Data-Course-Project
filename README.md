---
title: "ReadMe"
author: "Sanja Stegerer"
date: "Thursday, July 23, 2015"
output: html_document
---

# The files in this repository

## run_analysis.R
This file contains the code, which performs the 5 steps given in the instructions. <br />
Further details on how run_analysis.R performs these, please see the section **Processing Steps fulfilled by run_analysis.R**

### Dependences 

#### The data source

In order to use run_analysis.R, please use the following link 

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

to download the folders, which contain the dataset. Please unzip it and go to the directory "/getdata-projectfile-UCI\ HAR\ Dataset/UCI\ HAR\ Dataset" (if on windows, on a unix machine please adjust the backslashes and forwardslashes accordingliny) within the unzipped folder . 

You can run run_analysis.R from this directory, as it has been written to be executed from within this directory. (Please make sure, to set the directory in RStudio accordingly). <br />
run_analysis.R will, once started, automatically load all the data into the appropriate environments in RStudio and start processing it according to the 5 stepts from the instructions and write the processed and tidy data into the file tidy_data.txt.  

For more information about the background of the dataset, please visit the website 

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

#### dplyr
run_analysis.R requires you to have the package dplyr installed. It will load it automatically when you use the 
```{r}
source("run_analysis.R")
```
command, if dplyr is installed on your mashine. 

If not, it will through an error, letting you know, that there is no package called dplyr. Please use the

```{r}
install.packages("dplyr")
```
command to install dplyr on your machine. And rerun run_analysis.R with the source-command. 


## CodeBook.md
The Codebook describes each feature in the tidy_data.txt file and gives a little bit of information about how the data got preprocessed by the contributors of the study which generated the data, and how it got changed by run_analysis.R

## tidy_data.txt
tidy_data.txt contains the dataset, that has been produced by run_analysis.R and has been written in this file. It is in the wide format of a tidy data set, containing 81 features and 180 rows. 

The wide format for the data set was used, as in my opinion this is the best format for this data to run further analyses on it.It is easily groupable by subject id and activity. The columns, in which the analyst might be interested in are easily accessible due to well formatted, easily readable, but relatively short feature names. (More on the feature names in Step 4). 

### Load tidy_data.txt into R
The tidy_data.txt file got written by the write.table-command and therefore can be read in by R with the 
```{r}
data <- read.table("tidy_data.txt",header=TRUE)
```
command. 


# Processing steps performed by run_analysis.R

## 1. Merges the training and the test sets to create one data set.
The run_analysis.R script reads in all the data, that is distributed over several files and concatenates them to a whole data set with proper feature names and the 2 extra features id and activity which had to be parsed together seperately from the rest of the data.

The downloaded data set contains additional data, which can be found in the inertial Signals folder in each the train and test folders. The inertial signals folder contains the **raw data**, which has been used by the contributors of the study to produce the data set, that run_analysis.R will read in. I will call the resulting dataset from the processing steps within the study the **original data set** for easier distinction. 

run_analysis.R will NOT use the raw data, because in Step 2, we are asked to select only the features, that contain a mean of some sort and standard deviation. As there hasn't been done any aggregating processing on the raw data, it doesn't contain a mean or a standard deviation. And therefore it would not have been selected by run_analysis.R, so  I didn't include it into the whole data set at all. <br/>
I used this (<https://class.coursera.org/getdata-030/forum/thread?thread_id=37>) confirmation of the TA David Hood, as reference, that this step is valid. 

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
run_analysis.R selects every feature that has mean or std in it's name, that includes the meanFreq features, but not the angle feature. I intentionally added meanFreq as it calculates the Mean Frequency of the collected data in the Aggregation process done by the study. <br/> 
I decided differently for the angle()-features, as the angle() calculates the angle between two given vectors. Even though all the vectors, which are given to the angle() function where mean vectors of some sort, the return value of angle remains an angle and not a mean value. Addtionally those vectors, which are given to the angle() functionn, are calculated differently than the rest of the mean vectors and not provided in the data set. I didn't see much to gain from the angle features and therefore excluded them in this selection step.

This selecting step shrinked the number of columns from 563 to 81. Leaving the number of rows untouched. 

## 3. Uses descriptive activity names to name the activities in the data set
For the descriptive activity names, run_analysis.R read the activity_labels.txt file of the data and uses the pointers from the encoding integer to the descriptive activiy. It changes the names to a more human readable form, all lowercase and no underscores, such that the activities are all labeled according to this table.


| encoding integer | descriptive activity |
|--|------------------|
| 1 | walking |
| 2 | walking upstairs |
| 3 | walking downstairs |
| 4 | sitting |
| 5 | standing |
| 6 | laying |


## 4. Appropriately labels the data set with descriptive variable names. 
Finding descriptive variable names for the kind of features we have in the data set was really hard. They either got too long or weren't descriptive enough. I decided to go a middle kind of way and made the important parts of the names as decriptive as possible and left the rest of the names to themselves or chose small prolongings to give the reader a better understanding of what they see. <br />
The point I was focussing on is: The user of the run_analysis.R script should be able to, with reading the Code Book once, immediately understand the feature names and make sense of their composition, but also be able to use the feature names to select columns easily. Very long, self describing feature names would have made the latter impossible. 

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Using the data set from Step 4, I used the aggregate function to calculate the mean of every feature for each activiy and each subject. As there are 30 subjects and 6 activities, this step shrinked the number of rows from 10299 to 180 rows. The number of features remained the same.
