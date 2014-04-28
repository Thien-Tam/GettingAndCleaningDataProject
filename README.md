Getting and Cleaning Data Project
---------------------------------

This repository contains the files required for the peer-reviewed project
of the *Getting and Cleaning Data* course

##R script file to get the required tidy data set

### **run_analysis.R**

This R script is provided for reproducibility of the preprocessing steps
done on the original data set.  It assumes that the data files have already
been extracted from the provided ".zip" file in the peer assessment
instructions and placed in your R working directory.
	
The R script performs the following processing steps:
	
* Reads data from the different data files
	
* Merges the feature values, labels, and subject data to create the
**training** set data frame

* Merges the feature values, labels, and subject data to create the
**test** set data frame
	
* Merges the training and the test sets to create one data set
**(point 1 of the required script processing steps)**
	
* Replaces the activity integer values with the activity labels, that is 
using descriptive activity names to name the activities in the data set
**(point 3 and 4 of the required script processing steps)**
	
* Extracts only the measurements on the mean and standard deviation for
each measurement
**(point 2 of the required script processing steps)**
	
* Fixes the variable names to remove dashes, parentheses, and duplicated
sub-strings
	
* Creates a tidy data set containing the average of each variable for each
activity and subject
**(point 5 of the required script processing steps)**
