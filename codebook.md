## R Markdown
Introduction
### 
The run_analysis scripts performs the task of extracting statstical data, namely mean and standard deviation from
the URL that stores the data collected from the accelerometers from the Samsung Galaxy S smartphone and cleaning them into 
readable and analyzable form.
## 
Structure of Scrips
###
1. Merges the training and the test sets to create one data set.
There are many files in the foldes, but only the following files are required to combine into one data set with matching
rows and columns dimensions using rbind and cbind fucntions.

* feature.txt
* activity_labels.txt
* subject_train.txt / subject_test.txt
* X_train.txt/ X_test.txt
* y_train.txt/ y_test.txt

Merging is done through rbind function of X_train and X_test text files to produce the main dataframe.

2. Extracts only the measurements on the mean and standard 
These are extracted by searching specfically for 'mean()' and 'std()' text. ( and ) need to be preceded by \\ to be taken literally. 
The search is done through grep function that returns positions of the variables. The positions obtained are then used for subsetting.

3. Uses descriptive activity names to name the activities in the data set.
Both y_train and y_test dataframe are combined through rbind function. The resulting dataframe is then combined  with 
the main dataframe through cbind based on the activity id. Finally, activity_label is mapped accordingly through merge function through
the actviity id.

4. Appropriately labels the data set with descriptive variable names
The feature dataframe that contain the variable names are matched to the main datafframe based on the sequential 
ordering of the orignal X_train and X_test dataframe. The label names decriptions are then replaced with more descriptive words
using the gsub function to replace through the names of the main dataframe.

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity 
and each subject. 

2 methods are used. Method 1 use the melt function followed by dcast to group the mean of the variables by Subject and Activity.
Method 2 uses the aggregate functions by Subject and Actvitity.
