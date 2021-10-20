#Data630 Assignment 2
#David Hannon 6/21/2020
#Professor Ami Gates

#Objective- run the Naive Bayes classification to determine 
#the probability of a person survivng a burn injury based on 7 other factors 

#Introduction
#Set directory and connect burn.csv
setwd("C:/Datasets")
dir()
#Instal e1071
install.packages("e1071")

#Load arules and e1071
library("arules")
library("e1071")
burn <- read.csv(file="burn.csv", head=TRUE, sep=",")
head(burn)

#Exploratory analysis
str(burn)
summary(burn)
#Summary shows no missing data.
#Graphs of numeric data
hist(burn$AGE, main="Ages of Burn Data Set", xlab="Ages")
hist(burn$TBSA, main="TBSA of Burn Data Set", xlab="TBSA (as a %)")
boxplot(burn$TBSA, horizontal=TRUE, main="TBSA of Burn Victims")

#Data Pre-Processing
#Remove ID
burn$ID<-NULL
burn$FACILITY<-NULL
#Ensure Discharge Status is a factor variable
burn$DEATH<-factor(burn$DEATH)
#Transform all factor variables accordingly
burn$GENDER<-factor(burn$GENDER)
burn$RACEC<-factor(burn$RACEC)
burn$INH_INJ<-factor(burn$INH_INJ)
burn$FLAME<-factor(burn$FLAME)

#Discretize numeric data
burn$AGE <- discretize(burn$AGE, method="fixed",
                      breaks=c(0,10.0,20.0,30.0,40.0,50.0,60.0,70.0,80.0,90.0))

burn$TBSA <- discretize(burn$TBSA, method="fixed",
                        breaks=c(0,20,40,60,80,100))

summary(burn)
str(burn)

#Reproducability
set.seed(1234)

#Split into training and test data
ind <- sample(2, nrow(burn), replace = TRUE, prob = c(0.7, 0.3))
train.data <- burn[ind == 1, ]
test.data <- burn[ind == 2, ]

#Use NaiveBayes function to build the model1 with all independent variables
model1<-naiveBayes(DEATH~., train.data)
print(model1)

#Use NaiveBayes function to build model 2 with just age and TBSA
model2<-naiveBayes(DEATH~AGE+TBSA+GENDER, train.data)
print(model2)

#Use NaiveBayes function to build model3 with just race and gender
model3<-naiveBayes(DEATH~RACEC+GENDER+TBSA, train.data)
print(model3)

#Compare accuracies for traing data
#Model 1
table(predict(model1,train.data), train.data$DEATH)
#Model 1 Training accuracy- 92.12%
#Model 2
table(predict(model2,train.data), train.data$DEATH)
#Model 2 training accuracy- 93.41%
#Model 3
table(predict(model3,train.data), train.data$DEATH)
#Model 3 training accuracy=91.26%

#Compare accuracies for test data
table(predict(model1,test.data), test.data$DEATH)
#Model 1 test accuracy- 90.39%
#Model 2
table(predict(model2,test.data), test.data$DEATH)
#Model 2 test accuracy- 90.73%
table(predict(model3,test.data), test.data$DEATH)
#Model 3 test accuracy=88.74%

print(model2)

#Create mosaic plot for model 2 over test data
mosaicplot(table(predict(model,test.data),test.data$DEATH),shade=TRUE, main="Predicted vs Actual Survival")


#ROCR
library(ROCR)
mypredictions<-predict(model2, test.data, type="class")
ROCRpred <- prediction(as.numeric(mypredictions)-1, test.data$DEATH)
ROCRperf <- performance(ROCRpred, 'tpr','fpr')
plot(ROCRperf, colorize = TRUE, text.adj = c(-0.2,1.2), lwd=2)
abline(a=0,b=1,lwd=2,lty=2,col="gray")

#End of Script