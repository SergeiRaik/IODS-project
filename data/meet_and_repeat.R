#12.12.2022
#Sergei Raik

#Read the datasets from the GitHub repository
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt")

# column names
names(BPRS) 
names(RATS) 

#structurre and summary of both datasets
str(BPRS) 
str(RATS) 
summary(BPRS) 
summary(RATS) 

#Convert the categorical variables of both datasets to factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)


#Converting data sets to long form
library(dplyr)
library(tidyr)
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks, 5,5))) 
RATSL <- RATS %>% gather(key = WD, value = Weight, -ID, -Group) %>% mutate(Time = as.integer(substr(WD,3,4))) 


names(BPRSL)
names(RATSL)
str(BPRSL)
str(RATSL)
summary(BPRSL)
summary(RATSL)

#writing the files to the folder
write.csv(RATSL, file = "data/RATSL.csv")
write.csv(RATS, file = "data/RATS.csv")
write.csv(BPRSL, file = "data/BPRSL.csv")
write.csv(BPRS, file = "data/BPRS.csv")
