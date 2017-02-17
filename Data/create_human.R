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
colnames(hd)[2] <- "country"
colnames(hd)[3] <- "HDI"
colnames(hd)[4] <- "lifeExpBirth"
colnames(hd)[5] <- "ExpYearEduc"
colnames(hd)[6] <- "MeanYearEduc"
colnames(hd)[7] <- "CrossNatIncGNIcapita"
colnames(hd)[8] <- "GNIcapitaRankMinusHDIrank"

colnames(hd)

# change the column names of gii:
colnames(gii)[1] <- "GIIrank"
colnames(gii)[2] <- "country"
colnames(gii)[3] <- "gender"
colnames(gii)[4] <- "mothMortalityRatio"
colnames(gii)[5] <- "adolescentBrate"
colnames(gii)[6] <- "RepresParliament"
colnames(gii)[7] <- "edu2F"
colnames(gii)[8] <- "edu2M"
colnames(gii)[9] <- "labF"
colnames(gii)[10] <- "labM"

colnames(gii)

#12. mutate gii data: define a new columns edu2FtoM  
# and labFtoM
gii <- mutate(gii, edu2FtoM = edu2F / edu2M)
gii <- mutate(gii, labFtoM = labF / labM)

glimpse(gii)

#13.Join the two data sets 

#hd_gii <- merge(hd, gii, by = "country")
hd_gii <-inner_join(x=hd, y=gii, by = "country", suffix = c(".hd",".gii"))


# common columns to use as identifiers
join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")


# see the new column names
colnames(hd_gii)

# glimpse at the data
glimpse(hd_gii)







