# Neli Noykova, 01.02.2017

# This is a R script file for reading data from the net 
# and wrangling data.

#It corresponds to the first part of RStudio Exercise 2.
#And follows the first task from DatCamp exercises part. 

# Access the dplyr library
library(dplyr)

#Read data from the net: 
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# look at the dimensions of the data (183 x 60)
dim(lrn14)

# look at the structure of the data 
# 183 observations of 60 variables
str(lrn14)


#Combining questions and selecting columns as 
#defined in DataCamp Exercise 2
#

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning 
deep_columns <- select(lrn14, one_of(deep_questions))
#and create column 'deep' by averaging
lrn14$deep <- rowMeans(deep_columns)


# select the columns related to surface learning and 
surface_columns <- select(lrn14, one_of(surface_questions))
#create column 'surf' by averaging
lrn14$surf <- rowMeans(surface_columns)


# select the columns related to strategic learning and 
strategic_columns <- select(lrn14, one_of(strategic_questions))
#create column 'stra' by averaging
lrn14$stra <- rowMeans(strategic_columns)


# choose a handful of columns to keep
keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")

# select the 'keep_columns' to create a new dataset
learning2014 <- select(lrn14, one_of(keep_columns))

# see the stucture of the new dataset
#str(learning2014)

# change the name of the second, 3rd and 7th column
colnames(learning2014)[2] <- "age"
colnames(learning2014)[3] <- "attitude"
colnames(learning2014)[7] <- "points"

# select rows where points is greater than zero
learning2014 <- filter(learning2014,points>0) 

#see the dimension and structure of the modified data
# 166 observations of 7 variables
dim(learning2014)

# Guide from  http://uc-r.github.io/exporting
# export data as *txt file. 
write.table(learning2014, file="learning2014.txt", quote=F)
# export data as *csv file.
write.csv(learning2014, file = "learning2014.csv")

#read *csv - data. Check if they are written correctly
mydataCsv = read.csv("learning2014.csv") 
mydataCsv
str(mydataCsv)
head(mydataCsv)

#read table - data
mydataTable <- read.table("learning2014.txt")
mydataTable
str(mydataTable)
head(mydataTable)
 







