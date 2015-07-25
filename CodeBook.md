---
title: "Code Book for the data in file tidy_data.txt"
author: "Sanja Stegerer"
date: "Thursday, July 23, 2015"
output: html_document
---
# Introductional Note

In order to make the feature names understandable, I have to refer to different kinds of stages in the process of analyzing the measured data, where two out of three have been done by the contributers of the study, in which the data got generated. <br />
To get more information about the study and its data processing and generation, please use the link provided in the README.md file, which is accompanying this Code Book, to download the data  with it's accompanying feature_info.txt and README.txt files. 

#### Three types of data set
The **raw data** are a set of vectors of the same length, which have been processed by different processing steps (described in the sections *Processing, Axis, Measurement type and Sequence type*). <br /> 
The **original data** contains the vectors in an aggregated form (types of aggregation described in the section *Analyzing steps*) and normalized to [-1,1]. This is the data, my script "run_analysis.R" will read in and process further to produce the **final data**.

#### labels in feature names
The feature names are designed to point to how the data was collected, which processing steps has been done and to the units of the data in the raw data set. 

In the following section I will start off with the units in this dataset, then list all informations necessary to understand each feature name, except for the first two which will be explained seperately right at the beginning. <br />
Because every feature name is a composition of labels, which are seperated by a dot. The folling list will explain every label seperately. I won't write a table of all feature names, as this file would otherwise loose it's readability without adding information but a lot of text.<br/>
At the end I will use three examplary feature names and explain the values they contain according to the description of the labels in section **Feature 3 to 81** 

***
# Units

The original data is a normalized dataset. During the process of normalization the units get eradicated (for confirmation and further explanation see <https://class.coursera.org/getdata-030/forum/thread?thread_id=237#comment-664>). The original dataset thereofore is free of units and so is the final data. 

# Feature 1 and 2
## Feature 1: ID

Values: integers (range  1-30)
Points to one of the 30 subjects in the study, which created the data of the original data set. 

## Feature 2: activity

Values: characters (6 possibilites)
Descriptive character strings, which describe one of the following 6 activities, that the subjects perfomed in the study. 

* sitting, 
* laying, 
* walking downstairs, 
* walking upstairs, 
* walking, 
* standing. 

# Feature 3 to 81

## Note
Every entry of every feature of the final data is the average value of each activity performed by each subject and a result of the run_analysis.R script. Please read the README.md file for more information about how this average got obtained. But since the same aggregation technique (averaging) has been used for all features in the final data it is not explicitly noted as such in the feature names. 

The raw data, are several vectors of length 128 for each activity for each subject. The described processing steps in sections **Measurement Type, Axis, Sequence type** and **Processing** are all referring to the processing that has been done to these 128 entries-long vectors of the raw data during the study. In the **Analyzing steps**-section, I describe the kind of aggregation and analyzing, that has been done to the raw data to obtain the original data set before Normalization.

Value type: numeric (floats)

## Measurement Type

### accelerometer
These features are the processed sensor output of the accelerometer in the smartphone used in the study (Samsung Galaxy S II). The kind of processing that has been made will be described in the section **Processing**.

### gyroscope
These features are the processed sensor output of the gyroscope in the the smartphone used in the study (Samsung Galaxy S II). The kind of processing that has been made will be described in the section **Processing**. 

## Axis

### X.axis, Y.axis, Z.axis
These labels refer to the axis along which the movement occured to what degree. There will be only one of the three in one name, as sensor data got split up into the three axis and got stored in separate features.

## Sequence type

### time 
Features with time in their names are time domain signals in the raw data. Therefore these are the signals produced by the respective measurement type over a specific time with a constant reading rate of 50Hz.

### fourier
Features with the word fourier in their names are the respective time domain signals, which have been fouriertransformed with a FFT as a transformation step after the Processing and before the Analyzing steps. 

## Processing

### body
These features contain values, that have been extracted from the raw data set with the help of a filter and recognized as being produced by bodymovement.   

### gravity
These features contain values, that have been extracted from the raw data set with the help of a filter and recognized as being produced by gravity. 

### magnit
magnit is shortcut for Magnitude. The euclidean norm has been used to calculate the magnitude of the three dimensional signals generated by the respective measurement types and processing (according to the other names in the feature vectors). <br />
It will never be matched with an Axis-label as the magnitude takes in the threedimensional signals (not the ones that are split up per dimension) and reduces them to a scalar that represents the magnitude. (the raw data vector is still of length 128)

### jerk
jerk refers to the jerk vector which in physics is a pseudovector that contains information about the rate of change of acceleration around one axis. 


## Analyzing steps 

### mean
the raw data vectors have been processed with the respective processing steps (according to the names in the feature names) and the average value of this vector has been calculated as a last step.

### std
the raw data vectors have been processed with the respective processing steps (according to the names in the feature names) and the standard deviation of this vector has been calculated as a last step.

### meanFreq 
the raw data vectors have been processed with the respective processing steps (according to the names in the feature names) and the a "weighted average of the frequency components [have been calculated to] [...] obtain the mean frequency"" of this vector as a last step. (Cited from the features_info.txt file of the original data set.)

# Example features and explanation
### fourier.body.gyroscope.jerk.magnit.meanFreq
The data in this column has been collected with the gyroscope. It contains only the values that can be linked to body movement and got the gravity excluded. Then the jerk vector and the magnitude of it's three dimensional data have been calculated. The resulting data got transformed by the fourier transformation and as a last step the mean frequency got obtained. 

### time.body.accelerometer.mean.X.axis
The data in this column has been collected by the accelerometer. It only contains the time domain signals of along the x axis produced by the body movement only (gravity excluded). As a final step the average has been calculated. 

### time.body.accelerometer.std.Z.axis
The data in this column has been collected by the accelerometer. It only contains the time domain signals of along the z axis produced by the body movement only (gravity excluded). As a final step the standard deviation has been calculated. 

***

# The run_analysis.R script
The run_analysis.R script reads in the original data, concatenates it to a full data set, changes the labels for the activities, selects only the features, that contain the mean, standard deviation and meanFreq preprocessed values of the original data set (reduces the number of features from 563 to 81) and renames the features for a better understanding. 