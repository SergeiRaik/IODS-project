# Sergei Raik
# 20.11.2022
# Script for week 2 IODS 2022 course data wrangling
# Dataset from the UCI Machine Learning Repository, Student Performance Data (incl. Alcohol consumption)
# https://archive.ics.uci.edu/ml/datasets/Student+Performance

# access libraries
library(dplyr)
library(tidyverse)

# reading math and portugese datasets
math <- read.table("data/student-mat.csv", sep=";", header=TRUE)
por <- read.table("data/student-por.csv", sep=";", header=TRUE)

# explore structure and dimensions of two datasets
str(math)
dim(math)
str(por)
dim(por)

# give the columns that vary in the two data sets
free_cols <- c("failures", "paid", "absences", "G1", "G2", "G3")

# the rest of the columns are common identifiers used for joining the data sets
join_cols <- setdiff(colnames(por), free_cols)

# join the two data sets by the selected identifiers
math_por <- inner_join(math, por, by = join_cols, suffix = c(".math", ".por"))

# look at the column names of the joined data set
colnames(math_por)

# glimpse at the joined data set
glimpse(math_por)

# create a new data frame with only the joined columns
alc <- select(math_por, all_of(join_cols))

# for every column name not used for joining...
for(col_name in free_cols) {
  # select two columns from 'math_por' with the same original name
  two_cols <- select(math_por, starts_with(col_name))
  # select the first column vector of those two columns
  first_col <- select(two_cols, 1)[[1]]
  
  # then, enter the if-else structure!
  # if that first column vector is numeric...
  if(is.numeric(first_col)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[col_name] <- round(rowMeans(two_cols))
  } else { # else (if the first column vector was not numeric)...
    # add the first column vector to the alc data frame
    alc[col_name] <- first_col
  }
}

# glimpse at the new combined data
glimpse(alc)

# define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# define a new logical column 'high_use' (true if alc_use > 2)
alc <- mutate(alc, high_use = if_else (alc_use > 2,TRUE,FALSE))

# take a look at the modified dataset
glimpse(alc)

# write modified dataset as a csv file
write_csv(alc, "data/alc.csv")
