#DATA670-Capstone- David Hannon- Summer 2021
#Data Import
setwd("C:/Datasets/670")
#Rent Data- main
Rent<- read.csv(file="Rent.csv", head=TRUE, sep=",")
head(Rent)

#Poverty Data- secondary
Poverty<- read.csv(file="Poverty.csv", head=TRUE, sep=",")
head(Poverty)

#Education Data- secondary
Education<- read.csv(file="Education.csv", head=TRUE, sep=",")
head(Education)

#Unemployment Data- secondary
Unemployment<- read.csv(file="Unemployment.csv", head=TRUE, sep=",")
head(Unemployment)

lapply(Rent,function(x) { length(which(is.na(x)))})
Rent<- na.omit(Rent)
lapply(Education,function(x) { length(which(is.na(x)))})
Education<- na.omit(Education)
lapply(Poverty,function(x) { length(which(is.na(x)))})
Poverty<- na.omit(Poverty)
lapply(Unemployment,function(x) { length(which(is.na(x)))})
Unemployment<- na.omit(Unemployment)

#JOINS
library(dplyr)
RP<-left_join(Rent, Poverty)
RPE<-left_join(RP,Education, by = "FIPS")
Master<-left_join(RPE, Unemployment, by ="FIPS")

lapply(Master,function(x) { length(which(is.na(x)))})
Master<-na.omit(Master)

install.packages("writexl")
library(writexl)
write_xlsx(Master,"C:/Datasets/670\\Master.xlsx")

#Data Explore
boxplot(Master$Rent50_2, main="Median Rent- 2 Bedroom", 
        ylab="price", col="orange", border="brown", notch=TRUE)

Master<-read.csv(file="Master1.csv", head=TRUE, sep=",")
summary(Master$Affordability)
hist(Master$Affordability)
table(Master$state_alpha, Master$BinAfford)
