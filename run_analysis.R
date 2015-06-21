
# reading train set data
train.activity <- read.table("UCI HAR Dataset/train/y_train.txt")
train.subject <- read.table("UCI HAR Dataset/train/subject_train.txt")
train.sensor <- read.table("UCI HAR Dataset/train/X_train.txt")

# reading test set data
test.activity <- read.table("UCI HAR Dataset/test/y_test.txt")
test.subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
test.sensor <- read.table("UCI HAR Dataset/test/X_test.txt")

# merging data sets
activity <- rbind(train.activity, test.activity)
subject <- rbind(train.subject, test.subject)
sensor <- rbind(train.sensor, test.sensor)

# cleaning workspace
rm(list = c("train.activity", "train.subject", "train.sensor"))
rm(list = c("test.activity", "test.subject", "test.sensor"))

# sensors data set naming
sensor.names <- read.table("UCI HAR Dataset/features.txt")
names(sensor) <- sensor.names[,2]

# sensors data set projection
projected.columns <- c(1:6, 41:46, 81:86, 121:126, 161:166, 201:202, 214:215, 227:228, 240:241, 253:254, 266:271, 345:350, 424:429, 503:504, 516:517, 529:530, 542:543)
sensor <- sensor[,projected.columns]

# joining activities and subjects to sensor data
sensor <- cbind(activity, subject, sensor)
names(sensor)[1] <- "activity"
names(sensor)[2] <- "subject"

# descriptive activity names
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt")
names(activity.labels) <- c("activity", "activity.label")
sensor <- merge(activity.labels, sensor, by.x = "activity", by.y = "activity")

# tidy data set
tidy.sensor <- aggregate(sensor[,c(-1:-3)], by = list(activity = sensor$activity.label, subject = sensor$subject), FUN = mean)

# writing tidy data set out
write.table(tidy.sensor, file = "tidy_data_set.txt", row.names = FALSE)