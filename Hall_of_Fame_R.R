#Data630- Assignment 3
#Written by David Hannon on 7/1/2020
#Professor Ami Gates

# Introduction
#The objective of this script is to create a ctree model that 
#determines a players deservingness for enshrinment in the
#Baseball Hall of Fame
#Load party package
install.packages("party")
library("party")

#Set the working directory
setwd("C:/Datasets")

#Read the HOF data
HOF<-read.csv(file="MLBHOF.csv", head=TRUE, sep=",")
#Preview
str(HOF) 
summary(HOF)

#Visualizations
boxplot(Batting.Average~Hall.Of.Fame.Membership,data=HOF, main="HOF by Average",
       xlab="HOF Induction Type", ylab="Batting Average")

boxplot(Home.Runs~Hall.Of.Fame.Membership,data=HOF, main="HOF by Home Runs",
        xlab="HOF Induction Type", ylab="Home Runs")

boxplot(Batting.Average~Hall.Of.Fame.Membership,data=HOF, main="HOF by Average",
        xlab="HOF Induction Type", ylab="Batting Average")

# Data pre-processing
#Remove Name
HOF$Name<-NULL

#Change Position to factor variable
HOF$Primary.Position.Played<-factor(HOF$Primary.Position.Played)

#Check strikeout variable
boxplot(HOF$Strikeouts, main="Strikeouts", horizontal= TRUE)

#Replace NA Strikeouts and Stolen Bases with mean
HOF$Strikeouts[is.na(HOF$Strikeouts)]<- mean(HOF$Strikeouts, na.rm=TRUE)
HOF$Stolen.Bases[is.na(HOF$Stolen.Bases)]<- mean(HOF$Stolen.Bases, na.rm=TRUE)

#Factroize HOF Status
HOF$Hall.Of.Fame.Membership<-factor(HOF$Hall.Of.Fame.Membership)

#Remove Caught Stealing and Stolen Base Runs
HOF$Caught.Stealing<-NULL
HOF$Stolen.Base.Runs<-NULL

#Create new variable combining Hall of Famers- This model is superior!!!
#To Run the script for Model 1, comment out lines 56,57, and 58
#Keep variable in combined factors
install.packages("rockchalk")
library(rockchalk)
HOF$Hall.Of.Fame.Membership<-combineLevels(HOF$Hall.Of.Fame.Membership,levs = c("1", "2"), newLabel = c("1") )

#Algorithm 
set.seed(1234)
ind <- sample(2, nrow(HOF), replace = TRUE, prob = c(0.7, 0.3))
train.data <- HOF[ind == 1, ]
test.data <- HOF[ind == 2, ]

#Run the method on a training data
myFormula1<-Hall.Of.Fame.Membership~.
HOF_ctree1 <- ctree(myFormula1, data = train.data)


#Output the tree structure
print(HOF_ctree1) 
 
#Visualize the tree
plot(HOF_ctree1)
plot(HOF_ctree1, type="simple")

#Confusion matrix
#Model2
table(predict(HOF_ctree1), train.data$Hall.Of.Fame.Membership)
prop.table(table(predict(HOF_ctree1), train.data$Hall.Of.Fame.Membership))

#7. Evaluate the model on a test data
testPred <- predict(HOF_ctree1, newdata = test.data)
table (testPred, test.data$Hall.Of.Fame.Membership)

#End of Script
