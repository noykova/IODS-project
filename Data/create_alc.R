#RStudio Exercise 3, part 1: Data Wringling
#Name: Neli Noykova
#Date: 08.02.2017

# This is a R script file for reading data from the net 
# and wrangling data.

#Student Alcohol consumption data are taken from: https://archive.ics.uci.edu/ml/datasets/STUDENT+ALCOHOL+CONSUMPTION 

# Access the dplyr library
library(dplyr)

#1.-3. read *csv - data. Check if they are written correctly

#read student-mat.csv
stMat = read.csv(file ="student-mat.csv", header=TRUE, sep = ";") 
dim(stMat)
# look at the structure of the data 
# 395 observations of 1 variable
str(stMat)
colnames(stMat)
glimpse(stMat)

#read student-por.csv 
stPor = read.csv(file = "student-por.csv", header=TRUE, sep = ";") 
dim(stPor)
# look at the structure of the data 
# 649 observations of 1 variable
str(stPor)
colnames(stPor)


#4.Join the two data sets 
# common columns to use as identifiers
join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")

# join the two datasets by the selected identifiers
# math_por <- inner_join(math, por, by = join_by)
math_por <- inner_join(x=stMat, y=stPor, by = join_by, suffix = c(".math",".por"))

# see the new column names
colnames(math_por)

# glimpse at the data
glimpse(math_por)

#5. The if-else structure (from DataCamp) to combine the 'duplicated' answers in the joined data
# create a new data frame with only the joined columns
alc <- select(math_por, one_of("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet"))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(stMat)[!colnames(stMat) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# glimpse at the new combined data
#382 observations of 32 variables. 
glimpse(alc)


#6. define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

#7. Glimpse at the joined and modified data. 
 
#382 observations of 35 variables. 
glimpse(alc)

#Write the data into the file or table.
# export data as *txt file. 
write.table(alc, file="alc.txt", quote=F)
# export data as *csv file.
write.csv(alc, file = "alc.csv")






