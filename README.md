# Getting_and_cleaning_data_project

I have described how the code works in the R script but will briefly indicate it here to. 
I first load the files using "read.table"
Then i rename them and organise both the test and train data
I then bind data sets together using the function "rbind"

I then create the vectors that i will need for my tidy data set: id_labels and data_labels
Then i melt the variables using the function "melt", from the reshape2 package
Finally, i transpose the column of variables using the function "dcast" from the reshape2 package, so that each variable now makes up a new column, and i provide the mean for each variable for each subject.



