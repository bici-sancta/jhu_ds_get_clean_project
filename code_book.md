Johns Hopkins University
Data Science Series – Coursera
Getting & Cleaning Data
Course Project
2015-février

# Code Book

As outlined in the course project instructions , the original source of data is from this location :

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The specific data to be used for the class project are provided from this .zip file:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The instructions for data manipulation are as follows :

 You should create one R script called run_analysis.R that does the following.   
1. Merges the training and the test sets to create one data set.   
2. Extracts only the measurements on the mean and standard deviation for each measurement.    
3. Uses descriptive activity names to name the activities in the data set   
4. Appropriately labels the data set with descriptive variable names.    
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

The files provided from the above .zip file are : 
                       
 [9] ./UCI_HAR/activity_labels.txt   
[10] ./UCI_HAR/features_info.txt   
[11] ./UCI_HAR/features.txt   
[12] ./UCI_HAR/README.txt   
[13] ./UCI_HAR/test/Inertial Signals/body_acc_x_test.txt  
[14] ./UCI_HAR/test/Inertial Signals/body_acc_y_test.txt  
[15] ./UCI_HAR/test/Inertial Signals/body_acc_z_test.txt   
[16] ./UCI_HAR/test/Inertial Signals/body_gyro_x_test.txt   
[17] ./UCI_HAR/test/Inertial Signals/body_gyro_y_test.txt   
[18] ./UCI_HAR/test/Inertial Signals/body_gyro_z_test.txt   
[19] ./UCI_HAR/test/Inertial Signals/total_acc_x_test.txt 
[20] ./UCI_HAR/test/Inertial Signals/total_acc_y_test.txt     
[21] ./UCI_HAR/test/Inertial Signals/total_acc_z_test.txt   
[22] ./UCI_HAR/test/subject_test.txt   
[23] ./UCI_HAR/test/X_test.txt  
[24] ./UCI_HAR/test/y_test.txt   
[25] ./UCI_HAR/train/Inertial Signals/body_acc_x_train.txt   
[26] ./UCI_HAR/train/Inertial Signals/body_acc_y_train.txt   
[27] ./UCI_HAR/train/Inertial Signals/body_acc_z_train.txt   
[28] ./UCI_HAR/train/Inertial Signals/body_gyro_x_train.txt  
[29] ./UCI_HAR/train/Inertial Signals/body_gyro_y_train.txt  
[30] ./UCI_HAR/train/Inertial Signals/body_gyro_z_train.txt  
[31] ./UCI_HAR/train/Inertial Signals/total_acc_x_train.txt  
[32] ./UCI_HAR/train/Inertial Signals/total_acc_y_train.txt  
[33] ./UCI_HAR/train/Inertial Signals/total_acc_z_train.txt  
[34] ./UCI_HAR/train/subject_train.txt   
[35] ./UCI_HAR/train/X_train.txt    
[36] ./UCI_HAR/train/y_train.txt   


# To run the code :
1. install run_analysis.R in current working directory  
2. from the current working directory, the above listed data faile should be arranged in directory /UCI_HAR / with the directory tree as shown in the list.  

The Intertial Signals files are not used in the data manipulation exercise.

These are the only files read during the script execution :  
 [9] ./UCI_HAR/activity_labels.txt    
[11] ./UCI_HAR/features.txt    

[22] ./UCI_HAR/test/subject_test.txt  
[23] ./UCI_HAR/test/X_test.txt  
[24] ./UCI_HAR/test/y_test.txt   

[34] ./UCI_HAR/train/subject_train.txt   
[35] ./UCI_HAR/train/X_train.txt   
[36] ./UCI_HAR/train/y_train.txt   
  

#### activity_labels.txt has this information

> lbls   
  V1                 V2  
1  1            WALKING  
2  2   WALKING_UPSTAIRS  
3  3 WALKING_DOWNSTAIRS  
4  4            SITTING  
5  5           STANDING  
6  6             LAYING  
 

#### features.txt has this information (561 rows)

> head(ftrs)  
  V1                V2  
1  1 tBodyAcc-mean()-X  
2  2 tBodyAcc-mean()-Y  
3  3 tBodyAcc-mean()-Z  
4  4  tBodyAcc-std()-X  
5  5  tBodyAcc-std()-Y  
6  6  tBodyAcc-std()-Z  

> tail(ftrs)  
     V1                                   V2  
556 556 angle(tBodyAccJerkMean),gravityMean)  
557 557     angle(tBodyGyroMean,gravityMean)  
558 558 angle(tBodyGyroJerkMean,gravityMean)  
559 559                 angle(X,gravityMean)  
560 560                 angle(Y,gravityMean)  
561 561                 angle(Z,gravityMean)  

y_test.txt and y_train.txt are single column files, each value representing the 'Activity Number' corresponding to the activity provided in 'activity_labels.txt'. These values range from 1 to 6.

X_test.txt and X_train.txt contain the measured values (accelerations) takend the experiment.
These files have 561 columns of measured values, corresponding to the labels provided in the 'features.txt'file.

Lastly, the files subject_test.txt and subject_train.txt are sinlge column vectors, providing the 'Subject Number' of the person who participated in that measurement. These values range from 1 to 30.

### To process the data, the follwing steps are taken : 

1. read in all of the data files
2. since the main data files (X_test, X_train) do not have column labels, use the data labels as provided in the features.txt file to define column labels for both X_test and X_train
3. the course project defines to just use the features that either 'mean' or 'std' measured values, so identify the appropriate columns
4. create a new data frame that has just the down-selected columns
- (for this processing, the columns which have feature name 'meanFreq' were not selected for further processing)
- this is now 68 columns of data
5. with the reduced data sets, add new columns of data, the y_test/y_train values and the subject values (this adds 2 new columns to the data frames)
6. combine the _test and _train data sets together to create one data frame of all measured values
7. use a matching procedure to look up 'activity name' associated to the 'activity number', and add that as yet another column in the data frame
8. the data is then sub-setted to calculate the mean of each of the 66 features for each combination of subject and activity
* this yields 6 * 30 = 180 combinations for each feature
9. this subsetted data is then stored into one tidy data set with the following characteristics :
- 4 columns : Subject, Activity Name, Feature, Feature.Mean
- 6 * 30 * 66 = 11,880 columns

## The final data frame looks like this :

####> head(tidy)  
  Subject Activity.Txt              Feature Feature.Mean  
1       1      WALKING    tBodyAcc-mean()-X   0.27733076  
2       1      WALKING    tBodyAcc-mean()-Y  -0.01738382  
3       1      WALKING    tBodyAcc-mean()-Z  -0.11114810  
4       1      WALKING tGravityAcc-mean()-X   0.93522320  
5       1      WALKING tGravityAcc-mean()-Y  -0.28216502  
6       1      WALKING tGravityAcc-mean()-Z  -0.06810286  
 
####> tail(tidy)  
      Subject Activity.Txt                    Feature Feature.Mean  
11875      30       LAYING          fBodyGyro-std()-Y   -0.9651342  
11876      30       LAYING          fBodyGyro-std()-Z   -0.9721992  
11877      30       LAYING          fBodyAccMag-std()   -0.9640518  
11878      30       LAYING  fBodyBodyAccJerkMag-std()   -0.9680878  
11879      30       LAYING     fBodyBodyGyroMag-std()   -0.9526444  
11880      30       LAYING fBodyBodyGyroJerkMag-std()   -0.9754815  

### Tidy data frame
1. is writtent to file : project.txt
2. These are the data fields:
3. - Subject - Integer - represents the number of the person (subject) who participated in the measurements; the range of values for this experiement is 1 : 30
4.  - Activity.Txt - Character - identifies the specific activity being performed during the measurements; there are six (6) possible values in this experiment : (LAYING, WALKING, etc)
5.  - Feature - Character - identifies the type of activity being measured; there are 66 different measurement types in this summarized data table
6.  - Feature.Mean - Value(Real) - this represents the arithmetic mean of the collection of measurements taken for (a) given subject, (b) performing stated activity, (c) for given feature.
7.  - There are two (2) basic categories of measurements :
8.                     (1) time-based, preceded by letter 't', units are likely in seconds
9.                     (2) frequency-based, preceded by letter 'f', units are likely in acceleration units, such as 'g's'
10.                     For each time-based and frequency-based measurement type, the measurements are grouped by either average measurement, terminating with -mean(), or standard deviation of the measurements, terminating with -std()
11.                     For the 
