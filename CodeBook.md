Code Book for the *Getting and Cleaning Data* Course Project
------------------------------------------------------------

This code book markdown file describes the following:
* where and when the original data set was downloaded
* what the original data files represent
* what preprocessing steps were done to produce the final tidy data set
* which variables are included in that final data set
all within the script named *run_analysis.R*

###R Version
* R version 3.0.3 (2014-03-06) -- "Warm Puppy"
* Platform: x86_64-w64-mingw32/x64 (64-bit)	

### Data set download

The data linked to from the course website represent data collected
from the accelerometers from the Samsung Galaxy S smartphone: *Human Activity
Recognition Using Smartphones Dataset*
A full description is available at the site where the data was obtained:
<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

The data set used in this project has been downloaded from the link given on
the assessment webpage:
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

###Data files (Original/raw data set)
- **README.txt**

	The readme file accompanying the original data set describes the
	following:
	- The experiment performed and methods used to collect the data
	- The files included in the data set zip file and how they are organized
	
- **features_info.txt**

	Shows information about the variables used on the feature vector

- **features.txt**

	List of all features

- **activity_labels.txt**  

	Links the class labels with their activity name

- **train/X_train.txt**  

	Training set

- **train/y_train.txt**  

	Training labels

- **train/subject_train.txt**  

	Each row identifies the subject who performed the activity for each window 
	sample. Its range is from 1 to 30. (training set)

- **test/X_test.txt**  

	Test set

- **test/y_test.txt**  

	Test labels

- **test/subject_test.txt**  

	Each row identifies the subject who performed the activity for each window 
	sample. Its range is from 1 to 30. (test set)

*Note*:
	The data files contained in the **Inertial Signals** directory of the
	training set and test set were not included in the data preprocessing done
	in this project
	
###Data preprocessing steps

The following preprocessing steps are performed on the original data
set to produce the final tidy data set as required for this project.

-  First, all the data is read:

<!-- -->

	activity.labels <- read.table("activity_labels.txt")
	features <- read.table("features.txt")
	x.test <- read.table("./test/X_test.txt")
	y.test <- read.table("./test/y_test.txt")
	subject.test <- read.table("./test/subject_test.txt")
	x.train <- read.table("./train/X_train.txt")
	y.train <- read.table("./train/y_train.txt")
	subject.train <- read.table("./train/subject_train.txt")

-  The subjects data, features data, and activities data) are joined within 
the test set and training set respectively:

<!-- -->

	data.test <- cbind(subject.test, y.test, x.test)
	data.train <- cbind(subject.train, y.train, x.train)

-  All the observations from both sets are merged into one single data set:

<!-- -->

	data.all <- rbind(data.test, data.train)

-  The columns of the merged data set were labelled with descriptive names:

<!-- -->

	names(data.all)[1:2] <- c("subject", "activity")
	names(data.all)[3:length(data.all)] <- as.character(features[, 2])

-  The values of the *activity* column are replaced with descriptive 
activity names:

<!-- -->

	data.all$activity <- factor(data.all$activity, levels = activity.labels[, 1],
								labels = activity.labels[, 2])

-  Only the variables containing the mean and standard deviations of
the observations were included in tidy data set.
In the features.txt file, these are the variables with either *mean()* or
*std()* in their variable names:

<!-- -->

	index.mean <- grep("-mean\\(\\)", names(data.all))
	index.std <- grep("-std\\(\\)", names(data.all))

	data.mean.std <- data.all[, c(1, 2, index.mean, index.std)]

-  Filters the variable names to remove the dashes and parentheses,
and fix the names containing "BodyBody" replacing that substring with "Body":

<!-- -->

	varnames <- names(data.mean.std)
	varnames <- gsub("-", "", varnames)
	varnames <- gsub("\\(\\)", "", varnames)
	varnames <- gsub("BodyBody", "Body", varnames)
	names(data.mean.std) <- varnames

-  The final tidy data set was created with the average of each variable
for each activity and each subject:

<!-- -->

	library(reshape)
	data.molten <- melt(data.mean.std, id.vars = c("subject", "activity"))
	data.varmeans <- cast(data.molten, subject + activity ~ variable, mean)

-  Finally outputs the tidy data set into a .csv file:

<!-- -->

	write.csv(data.varmeans, "tidydata.csv", row.names = F)
	