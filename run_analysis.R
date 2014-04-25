# read the data from the .txt files
activity.labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")
x.test <- read.table("./test/X_test.txt")
y.test <- read.table("./test/y_test.txt")
subject.test <- read.table("./test/subject_test.txt")
x.train <- read.table("./train/X_train.txt")
y.train <- read.table("./train/y_train.txt")
subject.train <- read.table("./train/subject_train.txt")

# merge test and training data into one data set
data.test <- cbind(subject.test, y.test, x.test)
data.train <- cbind(subject.train, y.train, x.train)
data.all <- rbind(data.test, data.train)

# Label the columns with meaningful names
names(data.all)[1:2] <- c("subject", "activity")
names(data.all)[3:length(data.all)] <- as.character(features[, 2])

# Set activity names
data.all$activity <- factor(data.all$activity, levels = activity.labels[, 1],
							labels = activity.labels[, 2])

# Extract only measurements on mean and standard deviation for each observation
index.mean <- grep("-mean\\(\\)", names(data.all))
index.std <- grep("-std\\(\\)", names(data.all))

# Merge in one single data set (containing means and standard deviation)
data.mean.std <- data.all[, c(1, 2, index.mean, index.std)]

# Filtering the variables names
varnames <- names(data.mean.std)
varnames <- gsub("-", "", varnames)
varnames <- gsub("\\(\\)", "", varnames)
varnames <- gsub("BodyBody", "Body", varnames)
names(data.mean.std) <- varnames

# create the tidy data set containing the average of each variable
library(reshape)
data.molten <- melt(data.mean.std, id.vars = c("subject", "activity"))
data.varmeans <- cast(data.molten, subject + activity ~ variable, mean)

# write the tidy data set to a .csv file
write.csv(data.varmeans, "tidydata.csv", row.names = F)
