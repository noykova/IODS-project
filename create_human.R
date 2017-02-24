#WEEK 4: data wringling exercise Part 1. 

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# look at the dimension, structure and column names of the data 
#195 observations of 8 variables
dim(hd)
str(hd)
colnames(hd)
summary(hd)

#gii - data
#195 observations of 10 variables
dim(gii)
str(gii)
colnames(gii)
summary(gii)

# change the column names of hd:
colnames(hd)[1] <- "HDIrank"
colnames(hd)[2] <- "Country"
colnames(hd)[3] <- "HDI"
colnames(hd)[4] <- "Life.Exp"
colnames(hd)[5] <- "Edu.Exp"
colnames(hd)[6] <- "MeanYearEduc"
colnames(hd)[7] <- "CrossNatIncGNIcapita"
colnames(hd)[8] <- "GNIcapitaRankMinusHDIrank"

colnames(hd)

# change the column names of gii:
colnames(gii)[1] <- "GIIrank"
colnames(gii)[2] <- "Country"
colnames(gii)[3] <- "gender"
colnames(gii)[4] <- "Mat.Mor"
colnames(gii)[5] <- "Ado.Birth"
colnames(gii)[6] <- "Parli.F"
colnames(gii)[7] <- "edu2F"
colnames(gii)[8] <- "edu2M"
colnames(gii)[9] <- "labF"
colnames(gii)[10] <- "labM"

colnames(gii)


#12. mutate gii data: define a new columns edu2FtoM  
# and labFtoM
gii <- mutate(gii, Edu2.FM = edu2F / edu2M)
gii <- mutate(gii, Labo.FM = labF / labM)

glimpse(gii)

#13.Join the two data sets 

#hd_gii <- merge(hd, gii, by = "country")
hd_gii <-inner_join(x=hd, y=gii, by = "Country", suffix = c(".hd",".gii"))


# common columns to use as identifiers
join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")


# see the new column names
colnames(hd_gii)

# glimpse at the data
glimpse(hd_gii)


#WEEK 5: data wringling exercise Part 2. 
library(stringr)

#1. Transform the Gross National Income (GNI) variable to numeric

# remove the commas from GNI and print out a numeric version of it
GNI_num <- str_replace(hd_gii$GNI, pattern=",", replace ="")%>%as.numeric()
# add GNI_num to dataset using mutate() function 
hd_gii <- mutate(hd_gii, GNI_num)
colnames(hd_gii)


#2. keep only the columns matching the following variable names: 
# "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F

# columns to keep
keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI_num", "Mat.Mor", "Ado.Birth", "Parli.F")

# select the 'keep' columns
human <- select(hd_gii, one_of(keep))

#rename GNI_num to GNI
colnames(human)[6] <- "GNI"
colnames(human)

# 3.Remove all rows with missing values 

# print out a completeness indicator of the 'human' data
complete.cases(human)

# print out the data along with a completeness indicator as the last column
data.frame(human[-1], comp = complete.cases(human))

# filter out all rows with NA values
human_ <- filter(human, complete.cases(human)==TRUE)
str(human_)

#4.Remove the observations which relate to regions instead of countries.
# These are last 10 observations(rows)

# look at the last 10 observations of human
tail(human_, n=10L)

#In this case we see that the last 10 observations are related to countries, 
#not to regions. Therefore we do not delete them as in DataCamp exercise. 
# define the last indice we want to keep
#last <- nrow(human_) - 7

# choose everything until the last 7 observations
#human <- human_[1:last, ]


#5.Define the row names of the data by the country names 
# and remove the country name column from the data.

# add countries as rownames
rownames(human_) <- human_$Country

# remove the Country variable
human <- select(human_, -Country)
str(human)

#Save the human data in your data folder including the row names
# export data as *txt file. 
write.table(human, file="human1.txt", quote=F)
# export data as *csv file.
write.csv(human, file = "human1.csv")


