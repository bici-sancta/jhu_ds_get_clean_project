
# ...	-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# ...			coursera - getting & cleaning data - class project
#                                               2015-fév-17
# ...	-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#
# ...	-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# ...     project instructions  ...
#
#   You should create one R script called run_analysis.R that does the following. 
#
#   1. Merges the training and the test sets to create one data set.
#   2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#   3. Uses descriptive activity names to name the activities in the data set
#   4. Appropriately labels the data set with descriptive variable names. 
#   5. From the data set in step 4, creates a second, independent tidy data set with the average of
#       each variable for each activity and each subject.
# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


# ...	-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# ...       code to accomplish the above 5 steps
# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

library(gdata)

# ...   list of all original source files & directories needed

d_one <- "./UCI_HAR/"
d_tst <- "./UCI_HAR/test/"
d_trn <- "./UCI_HAR/train/"
f_lst1 <- c("activity_labels.txt", "features.txt")
f_lst2 <- c("subject_test.txt", "X_test.txt", "y_test.txt")
f_lst3 <- c("subject_train.txt", "X_train.txt", "y_train.txt")

# ...	-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# ...	read all of the data files into data frames
# ...	-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	lbls <- read.table(paste(d_one, f_lst1[1], sep = ""), header = FALSE)
	ftrs <- read.table(paste(d_one, f_lst1[2], sep = ""), header = FALSE)

	s.tst <- read.table(paste(d_tst, f_lst2[1], sep = ""), header = FALSE)
	x.tst <- read.table(paste(d_tst, f_lst2[2], sep = ""), header = FALSE)
	y.tst <- read.table(paste(d_tst, f_lst2[3], sep = ""), header = FALSE)

	s.trn <- read.table(paste(d_trn, f_lst3[1], sep = ""), header = FALSE)
	x.trn <- read.table(paste(d_trn, f_lst3[2], sep = ""), header = FALSE)
	y.trn <- read.table(paste(d_trn, f_lst3[3], sep = ""), header = FALSE)

# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# ...   features.txt file is list of all data labels ... 
#...      - create list vector of data labels and then assign to column names
#...        in both X - test & train data sets
# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	col.names <- as.vector(ftrs$V2) # this will create a character vector
	colnames(x.tst) <- col.names
	colnames(x.trn) <- col.names
	
# ...	-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# ...   get column names for 'mean' & 'std deviation' from data files
# ...     --> I don't retain the columns with 'meanFreq', only 'mean'
# ...
# ...   this corresponds to step 2 of the assignment
# ...    this method assumes that test & training files have same columns ... 
# ...     for a more robust script, should probably check & verify this, but this works OK
# ...     for the project assignment
# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	mean_cols <- matchcols(x.tst, with=c("mean"), without=c("meanFreq"))
	std_cols  <- matchcols(x.tst, with=c("std"))
	new_cols <- c(mean_cols, std_cols)
	
# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# ...   create new data frames with just the selected columns of 'mean' & 'std' 
# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	new.x.tst <- x.tst[new_cols]
	new.x.trn <- x.trn[new_cols]
	
# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# ...   add columns with activity numbers and subjects to the measurement data frames
# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

  new.x.tst["activity.num"] <- as.vector(y.tst)
	new.x.trn["activity.num"] <- as.vector(y.trn)
	
	new.x.tst["subject"] <- as.vector(s.tst)
	new.x.trn["subject"] <- as.vector(s.trn)

# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# ...   combine test & training data sets into one data frame
# ...   - this corresponds to step 1 of the assignment
# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	x.all <- rbind(new.x.tst, new.x.trn)

# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# ...	  this finds correspondence between activity numbers and activity labels
# ...   and adds activity labels to the main data frame
# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	look_up_lbls <- lbls[match(x.all$activity.num, lbls[,1]),2]
	x.all["activity.txt"] <- as.vector(look_up_lbls)


# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# ...    preparation for creating the tidy data set
# ...     - allocate some empty vectors for creating data column values
# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	tidy_length <- max(x.all$subject) * max(x.all$activity.num) * length(new_cols)
	
	s <- numeric(tidy_length)   # ... vector for subject numbers 
	l <- character(tidy_length) # ... vector for activity descriptions
	c <- character(tidy_length) # ... vector for measured data labels
	m <- numeric(tidy_length)	  # ... vector for mean of each measured data set

# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# ...    just create a loop for:
# ...       - range of subject numbers
# ...       - range of activity values
# ...       - range of measured data labels
# ...         --> and take the mean of each data subset
# ...   (there is probably a more efficient way to do this in R, but this works)
# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	ii <- 1L
	for (ss in min(x.all$subject): max(x.all$subject))
	{
		for (act in min(x.all$activity.num): max(x.all$activity.num))
		{
			for (col in 1:length(new_cols))
			{
				var <- new_cols[col]
				x.sub <- subset(x.all, subject == ss & activity.num == act, select = c(var))
				ans <- mean(x.sub[,1])
				
				s[ii] <- ss
				l[ii] <- as.character(lbls[match(act, lbls[,1]),2])
				c[ii] <- var
				m[ii] <- ans
				ii <- ii + 1L
			}
		}
	}

# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# ...    arrange all of the above vectors into a tidy data frame
# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	tidy <- data.frame(
				Subject = s,
				Activity.Txt = l,
				Feature =  c,
				Feature.Mean = m)

# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# ...   here is the structure of the tidy data frame ...
#
# Subject Activity.Txt              Feature Feature.Mean
#    1      WALKING       tBodyAcc-mean()-X   0.27733076
#    1      WALKING       tBodyAcc-mean()-Y  -0.01738382
#    1      WALKING       tBodyAcc-mean()-Z  -0.11114810
#    1      WALKING    tGravityAcc-mean()-X   0.93522320
#    1      WALKING    tGravityAcc-mean()-Y  -0.28216502
#    1      WALKING    tGravityAcc-mean()-Z  -0.06810286
# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# ...    write data frame to text file .... well done !!!
# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

	write.table(tidy, file = "project.txt", append = FALSE, quote = TRUE, sep = " ",
	            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
	            col.names = TRUE, qmethod = c("escape", "double"), fileEncoding = "")

# ...  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# ...			end of file
# ...	-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-