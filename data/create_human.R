# Sergei Raik
# 28.11.2022
library(tidyverse)

#Read in the “Human development” and “Gender inequality” data sets
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

#structure and dimensions of datasets
glimpse(hd)
glimpse(gii)

#summary of datasets' variables
summary(hd)
summary(gii)

# rename variables according to https://github.com/KimmoVehkalahti/Helsinki-Open-Data-Science/blob/master/datasets/human_meta.txt
hd <- rename(hd, "GNI" = "Gross National Income (GNI) per Capita")
hd <- rename(hd, "Edu.Exp" = "Expected Years of Education")
hd <- rename(hd, "Life.Exp" = "Life Expectancy at Birth")

gii <- rename(gii, "Mat.Mor" = "Maternal Mortality Ratio")
gii <- rename(gii, "Ado.Birth" = "Adolescent Birth Rate")
gii <- rename(gii, "Edu2.F" = "Population with Secondary Education (Female)")
gii <- rename(gii, "Edu2.M" = "Population with Secondary Education (Male)")
gii <- rename(gii, "Labo.F" = "Labour Force Participation Rate (Female)")
gii <- rename(gii, "Labo.M" = "Labour Force Participation Rate (Male)")

# create new variables (ratios of labor force and secondary education distributions)
gii <- mutate(gii, Labo.FM = (Labo.F / Labo.M))
gii <- mutate(gii, Edu2.FM = (Edu2.F / Edu2.M))

# join two datasets by country variable
human <- inner_join(hd, gii, by = "Country")

#explore the structure (195 obs, 19 variables)
glimpse(human)

#save dataset
write_csv(human, "data/human.csv")

# Week 5 wrangling
# let's load the dataset from the web to ensure it's correct
human <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human1.txt")

human$GNI <- as.numeric(human$GNI)
sapply(human, class)

#list of Columns to keeep
keepcol <- c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F") 

#keep selected columns
human <- dplyr::select(human, one_of(keepcol)) 

#exclude observations with missing values
human <- drop_na(human)

#the last 7 observations relate to regions. We exclude them
human <- human[1:155, ]

#save country names to a new variable (for some reason rownames are deleted after Countries column removal)
country <- human$Country

# remove Country column
human <- dplyr::select(human, -Country)

#set countries as rownames
rownames(human) <-  country

write.csv(human, "data/human.csv", row.names = TRUE)

#for some reasons it doesn't read rownames
test <- read.csv("data/human.csv")
