# Sergei Raik
# 11.11.2022
# script for week 2 data wrangling
library(tidyverse)
library(dplyr)
# read tab separated data from the website
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# dimensions of the data:
dim(lrn14)
# dataframe has 183 rows (observations) and 60 columns (variables)

# structure of the data:
str(lrn14)
# in dataframe 59 variables are integers, 1 variable is factor with 2 levels (M, F)

# scaling attitude points (mean of 10 attitude-related answers)
lrn14$attitude <- lrn14$Attitude / 10

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning 
deep_columns <- select(lrn14, one_of(deep_questions))
# and create column 'deep' by averaging
lrn14$deep <- rowMeans(deep_columns)

# select the columns related to surface learning 
surface_columns <- select(lrn14, one_of(surface_questions))
# and create column 'surf' by averaging
lrn14$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning 
strategic_columns <- select(lrn14, one_of(strategic_questions))
# and create column 'stra' by averaging
lrn14$stra <- rowMeans(strategic_columns)

# choose necessary columns for a new dataframe
keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")

#create a new dataset with necessary columns
learning2014 <- select(lrn14, one_of(keep_columns))

# change the names of columns 2 and 7 to make it lower case
colnames(learning2014)[2] <- "age"
colnames(learning2014)[7] <- "points"

# exclude rows with zero exam result
learning2014 <- filter(learning2014, points > 0)

str(learning2014)
# save new dataset as  csv file
write_csv(learning2014, "data/learning2014.csv")

#read csv file, specify column types
learning2014 <- read_csv("data/learning2014.csv", col_types = cols(.default = "n", age = "i", gender = "f", points = "i"))

# check the structure of the imported dataset
str(learning2014)
head(learning2014)
