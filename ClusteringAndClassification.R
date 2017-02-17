library(MASS)
library(tidyr); 
library(dplyr); 
library(ggplot2)
library(corrplot)

# load the data
data("Boston")

# explore the dataset
str(Boston)
summary(Boston)
glimpse(Boston)


# plot matrix of the variables
pairs(Boston)
library(GGally)
ggpairs(Boston, diag=list(continuous="density", discrete="bar"), axisLabels="show")

# calculate the correlation matrix and round it
cor_matrix<-cor(Boston) %>% round(digits =2)

# print the correlation matrix
cor_matrix

# visualize the correlation matrix
corrplot(cor_matrix, method="circle", type = "upper", cl.pos = "b", tl.pos = "d", tl.cex = 0.6)

# center and standardize variables
boston_scaled <- scale(Boston, center = TRUE, scale = TRUE)

# summaries of the scaled variables
summary(boston_scaled)

# class of the boston_scaled object
class(boston_scaled)

# change the object to data frame
boston_scaled <- as.data.frame(boston_scaled)

#creating a factor variable
#Create a categorical variable of the crime rate in 
#the Boston dataset (from the scaled crime rate). 
#Use the quantiles as the break points in the categorical variable. 
#Drop the old crime rate variable from the dataset. 
#Divide the dataset to train and test sets, 
#so that 80% of the data belongs to the train set.*/

#save the scaled crim as scaled_crim
scaled_crim <- boston_scaled$crim 

# summary of the scaled_crim

summary(scaled_crim)
#glimpse(scaled_crim)
#dim(scaled_crim)

# create a quantile vector of crim and print it
#bins <- colQuantiles(scaled_crim, probs=0:3/3)
#problem: scaled_crim is a data frame, but should be a vector!!!! --> take only one column

bins <- quantile(scaled_crim) 
 
bins


# create a categorical variable 'crime'
crime <- cut(scaled_crim, breaks = bins, labels = c("low", "med_low", "med_high", "high"), include.lowest = TRUE)

# look at the table of the new factor crime
table(crime)

# remove original crim from the dataset
boston_scaled <- dplyr::select(boston_scaled, -crim)

# add the new categorical value to scaled data
boston_scaled <- data.frame(boston_scaled, crime)

# number of rows in the Boston dataset 
n <- nrow(boston_scaled)

# choose randomly 80% of the rows
ind <- sample(n,  size = n * 0.8)

# create train set
train <- boston_scaled[ind,]

# create test set 
test <- boston_scaled[-ind,]
glimpse(test)

# linear discriminant analysis
lda.fit <- lda(crime ~ ., data = train)


# print the lda.fit object
lda.fit

# the function for lda biplot arrows
lda.arrows <- function(x, myscale = 1, arrow_heads = 0.1, color = "red", tex = 0.75, choices = c(1,2)){
  heads <- coef(x)
  arrows(x0 = 0, y0 = 0, 
         x1 = myscale * heads[,choices[1]], 
         y1 = myscale * heads[,choices[2]], col=color, length = arrow_heads)
  text(myscale * heads[,choices], labels = row.names(heads), 
       cex = tex, col=color, pos=3)
}

# target classes as numeric
classes <- as.numeric(train$crime)


# plot the lda result
plot(lda.fit, dimen = 3, col = classes, pch = classes)
lda.arrows(lda.fit, myscale = 2)

# predict classes with test data
lda.pred <- predict(lda.fit, newdata = test)
#lda.pred$class

# cross tabulate the results
table(correct = test$crime, predicted = lda.pred$class)

#K-means
#stadardized Boston data:
#boston_scaled <- scale(Boston, center = TRUE, scale = TRUE)
summary(boston_scaled)

# euclidean distance matrix
dist_eu <- dist(boston_scaled, method = "euclidean")

# look at the summary of the distances
summary(dist_eu)

# manhattan distance matrix
dist_man <- dist(boston_scaled, method = "manhattan")

# look at the summary of the distances
summary(dist_man)

# k-means clustering
km <-kmeans(dist_eu, centers = 4)


# plot the Boston dataset with clusters
pairs(boston_scaled, col = km$cluster)

# MASS, ggplot2 and Boston dataset are available
set.seed(123)

# determine the number of clusters
k_max <- 10

# calculate the total within sum of squares
twcss <- sapply(1:k_max, function(k){kmeans(dist_eu, k)$tot.withinss})

# visualize the results
plot(1:k_max, twcss, type='b')

# k-means clustering
km <-kmeans(dist_eu, centers = 6)

# plot the Boston dataset with clusters
pairs(Boston, col = km$cluster)

# Bonus: linear discriminant analysis using the clusters as target classes
lda.fit <- lda(km$cluster ~ ., data = train)

# print the lda.fit object
lda.fit

# the function for lda biplot arrows
lda.arrows <- function(x, myscale = 1, arrow_heads = 0.1, color = "red", tex = 0.75, choices = c(1,2)){
  heads <- coef(x)
  arrows(x0 = 0, y0 = 0, 
         x1 = myscale * heads[,choices[1]], 
         y1 = myscale * heads[,choices[2]], col=color, length = arrow_heads)
  text(myscale * heads[,choices], labels = row.names(heads), 
       cex = tex, col=color, pos=3)
}

# target classes as numeric
clusters <- as.numeric(km$cluster)


# plot the lda result
plot(lda.fit, dimen = 3, col = clusters, pch = clusters)
lda.arrows(lda.fit, myscale = 2)

#3D plot
library(plotly)
model_predictors <- dplyr::select(train, -crime)
# check the dimensions
dim(model_predictors)
dim(lda.fit$scaling)
# matrix multiplication
matrix_product <- as.matrix(model_predictors) %*% lda.fit$scaling
matrix_product <- as.data.frame(matrix_product)
plot_ly(x = matrix_product$LD1, y = matrix_product$LD2, z = matrix_product$LD3, type= 'scatter3d', mode='markers', color = train$crime)

