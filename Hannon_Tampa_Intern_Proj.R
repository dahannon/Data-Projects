###David Hannon
###Internship Candidate

####RScript for Tampa Bay Rays Internship Application
setwd("C:/Datasets")
df<-read.csv(file="battedBallData.csv", head=TRUE, sep=",")
library("dplyr")
library("plyr")
library("ggplot2")
library("tidyr")


#STEP 1: Analyze results of System A v System B
summary(df$speed_A)
summary(df$speed_B)
df %>% select(speed_A, speed_B) %>%
  pivot_longer(., cols = c(speed_A, speed_B), names_to = "Var", values_to = "Val") %>%
  ggplot(aes(x = Var, y = Val)) +
  geom_boxplot(color="navy blue", fill="turquoise2")+
  ggtitle("System A vs System B: Exit Velocity")

summary(df$vangle_A)
summary(df$vangle_B)
df %>% select(vangle_A, vangle_B) %>%
  pivot_longer(., cols = c(vangle_A, vangle_B), names_to = "Var", values_to = "Val") %>%
  ggplot(aes(x = Var, y = Val)) +
  geom_boxplot(color="navy blue", fill="turquoise2")+
  ggtitle("System A vs System B: Launch Angle")

#Relationship speed and vangle?
ggplot(df, aes(x=speed_A, y=vangle_A, group=hittype))+
  geom_point(aes(color=hittype))+
  ggtitle("System A: Relationship between Exit Velocity and Launch Angle")



#Investigate pop-up issue with System A
df.popups<- subset(df, df$hittype=="popup")
summary(df.popups$vangle_A)



###Investigation of difference of observations
df$speed_diff<- df$speed_A-df$speed_B
df$vangle_diff <- df$vangle_A-df$vangle_B
summary(df$speed_diff)
boxplot(df$speed_diff, main="Difference of speed meas. (A-B)")

ggplot(df, aes(x="speed_diff", y=speed_diff))+
  geom_boxplot(color="navy blue", fill="turquoise2")+
  ggtitle("Difference in Launch Angle: A - B")

ggplot(df, aes(x=speed_diff, y=vangle_diff, group=hittype))+
  geom_point(aes(color=hittype))+
  ggtitle("Relationship between Exit Velocity Diff. and Launch Angle Diff.")

summary(df$vangle_diff)

#STEP 2: Data Cleansing
#Create a copy of df with missing A's imputed by missing B's, vice versa
df2<-df
df2$speed_A[is.na(df2$speed_A)]<-df2$speed_B[is.na(df2$speed_A)]
df2$speed_B[is.na(df2$speed_B)]<-df2$speed_A[is.na(df2$speed_B)]
df2$vangle_A[is.na(df2$vangle_A)]<-df2$vangle_B[is.na(df2$vangle_A)]
df2$vangle_B[is.na(df2$vangle_B)]<-df2$vangle_A[is.na(df2$vangle_B)]
df2$speed_diff<- df2$speed_A-df2$speed_B
df2$vangle_diff <- df2$vangle_A-df2$vangle_B


#Remove Obs with NA from both Sys A and B
df2<-na.omit(df2)
n_distinct(df2$batter)
n_distinct(df$batter)


#Remove outliers based on differenc of recorded speed
df.trimmed<- subset(df2, df2$speed_diff<=11.081 & df2$speed_diff>=-11.081)
df.outliers<- subset(df2, !(batter%in%df.trimmed$batter))

summary(df.trimmed)
summary(df.trimmed$speed_diff)
boxplot(df.trimmed$speed_diff, main="Trimmed set: Difference of speed meas. (A-B)")
ggplot(df.trimmed, aes(x="speed_diff", y=speed_diff))+
  geom_boxplot(color="navy blue", fill="turquoise2")+
  ggtitle("Trimmed: Difference in Launch Angle: A - B")

n_distinct(df2$batter)
n_distinct(df.trimmed$batter)
n_distinct(df.outliers$batter)

#STEP 3: Average Calculation
df.trimmed$average_speed<-((df.trimmed$speed_A+df.trimmed$speed_A+df.trimmed$speed_B)/3)
summary(df.trimmed$average_speed)

#Aggregate average per player
Batter_Average<- ddply(df.trimmed, .(batter), summarize, AverageExitVelo=mean(average_speed), N=length(batter), sd= sd(average_speed))
Batter_Average

#Add Confidence Interval Lower Bound
Batter_Average$CI95_L<- ifelse(Batter_Average$N > 2,
                               Batter_Average$AverageExitVelo - (qt(0.975, df=(Batter_Average$N-1))*(Batter_Average$sd)/sqrt(Batter_Average$N)),
                               Batter_Average$AverageExitVelo - (qnorm(.975))*9.778126/sqrt(Batter_Average$N))
#Add Confidence Interval Upper Bound
Batter_Average$CI95_U<- ifelse(Batter_Average$N > 2,
                               Batter_Average$AverageExitVelo + (qt(0.975, df=(Batter_Average$N-1))*(Batter_Average$sd)/sqrt(Batter_Average$N)),
                               Batter_Average$AverageExitVelo + (qnorm(.975))*9.778126/sqrt(Batter_Average$N))

#Mean Average Exit Velocity for all batters in Final Table
mean(Batter_Average$AverageExitVelo)
#Mean 95%CI Lower Bound
mean(Batter_Average$CI95_L)
#Mean 95% Upper Bound
mean(Batter_Average$CI95_U)

#Quick calculation for missing players
df.outliers$average_speed<-((df.outliers$speed_A+df.outliers$speed_A+df.outliers$speed_B)/3)
Outlier_Averages<-ddply(df.outliers, .(batter), summarize, AverageExitVelo=mean(average_speed), N=length(batter))
Outlier_Averages
