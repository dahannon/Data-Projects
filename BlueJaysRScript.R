#Script Written for Technical Excercise given by Toronto Blue Jays#
#Code Written by David Hannon 01/26/2021#

#Task- Given list of ground-ball plays, determine which shortstop
#converted the most outs above average

library("dplyr")
library("data.table")
library("ggplot2")
library("viridis")
#Import given dataset "shortstopdefense.xlsx"
#This code assumes that this .xlsx file is saved in a Desktop folder named "Datasets"

setwd("C:/Datasets")
SSDefense<-read.csv('shortstopdefense.csv')

summary(SSDefense)
str(SSDefense)

##INTRO##
#Create a table to show number of outs credited and opportunities for each player
SSOuts<-subset(SSDefense, player_out_credit=="TRUE")
summary(SSOuts)
#Create a dataframe with only plays where shortstop "fielded"
SSOpps<-subset(SSDefense, SSDefense$fielded_pos==6)
#Get counts and join to one dataframe
Outs<-table(SSOuts$playerid)
Opps<-table(SSOpps$playerid)
outs=as.data.frame(Outs)
names(outs)[1]='Player'
names(outs)[2]='Total Outs'
opps=as.data.frame(Opps)
names(opps)[1]='Player'
names(opps)[2]='Opportunities'
W<-left_join(outs, opps, by = "Player")
print(W)

##STEP 1##
#Determine a baseline for the average out
#Key variables will be fielder angle compared to spray angle and launch speed
#Spin rate should also be factored but data is inconsistent for this variable

#Use arctan to convert positioning x,y to an angle
SSOpps$Fielder_Angle<- atan2(SSOpps$player_x,SSOpps$player_y)
SSOpps$Fielder_Angle<- 180/pi*SSOpps$Fielder_Angle
#Create variable DegreesOff to quantify how many degrees the player started from the 
#path of the ball
SSOpps$DegreesOff<-abs(SSOpps$Fielder_Angle-SSOpps$launch_horiz_ang)

#Create variable that adjusts distance with launch speed
SSOpps$DegreesOffAdj<- SSOpps$DegreesOff*SSOpps$launch_speed

#Filter to only plays where outs were achieved
SSAllOuts<-subset(SSOpps, SSOpps$player_out_credit=="TRUE")

#Now use summary statistics to set baseline for the "average SS Out"
summary(SSAllOuts$DegreesOff)
summary(SSAllOuts$DegreesOffAdj)

#Degrees Off: Mean=4.607 3rdQuart=6.60359
#Degrees Off Adj: Mean=393.8189 3rdQuart=571.9204

boxplot(SSAllOuts$DegreesOff, main='DegreesOff',horizontal =TRUE, col = "royalblue2")
text(x= round(boxplot.stats(SSAllOuts$DegreesOff)$stats), 
     labels =round(boxplot.stats(SSAllOuts$DegreesOff)$stats), y=1.3)

boxplot(SSAllOuts$DegreesOffAdj, main='DegreesOffAdj',horizontal =TRUE, col = "royalblue2")
text(x= round(boxplot.stats(SSAllOuts$DegreesOffAdj)$stats), 
     labels =round(boxplot.stats(SSAllOuts$DegreesOffAdj)$stats), y=1.3)

##STEP 2##
#Filter out all plays that would be average difficulty for a SS
#First we recreate variables Degrees Off and Degrees Off Adj for SSDefense
#Add Degrees Off and Degrees OffAdj to initial data with all plays
SSDefense$Fielder_Angle<- atan2(SSDefense$player_x,SSDefense$player_y)
SSDefense$Fielder_Angle<- 180/pi*SSDefense$Fielder_Angle
SSDefense$DegreesOff<-abs(SSDefense$Fielder_Angle-SSDefense$launch_horiz_ang)
SSDefense$DegreesOffAdj<- SSDefense$DegreesOff*SSDefense$launch_speed

#For DegreesOff, we will look for plays where the SS was 7 degrees away
SSToughPlays<-subset(SSDefense, SSDefense$DegreesOff>7)
#For DegreesOffAdj, we will look for plays where the value exceeds 572
SSToughPlays<-subset(SSToughPlays, SSToughPlays$DegreesOffAdj>572)

#This has eliminated 4,550 plays that should have been "routine for a SS"
#Now see how many outs were recorded on non-routine plays
SSToughPlays<-subset(SSToughPlays, SSToughPlays$player_out_credit=="TRUE")
ToughOuts<-table(SSToughPlays$playerid)
print(ToughOuts)

##STEP 3##
#Subtract number of errors made on routine plays
SSRoutineErrors<-subset(SSDefense,SSDefense$eventtype=='field_error')
SSRoutineErrors<-subset(SSRoutineErrors,SSRoutineErrors$pos=='6')

#To filter out errors in which the Degrees Off and Adj were large, uncomment 
#SSRoutineErrors<-subset(SSRoutineErrors,SSRoutineErrors$DegreesOff<7)
#SSRoutineErrors<-subset(SSRoutineErrors,SSRoutineErrors$DegreesOffAdj<572)
#However, to be scored as an error the SS must have had a chance to make a play
#Thus these errors will still be included
#Get error count per player
Errors<-table(SSRoutineErrors$playerid)
print(Errors)                        

##STEP 4##
#Combine into one readable table
toughouts=as.data.frame(ToughOuts)
names(toughouts)[1]='Player'
names(toughouts)[2]='Tough Outs'
errors=as.data.frame(Errors)
names(errors)[1]='Player'
names(errors)[2]='Errors'
X<-left_join(toughouts, errors, by = "Player")
print(X)
X[is.na(X)]<-0
X$OAA<- X$`Tough Outs`-X$Errors
print(X)

#Create Final Leaderboard
Y<-merge(X, W, by='Player')
Y<-Y[order(-Y$OAA),]

Final<-(Y[-c(2,3,5)])
rownames(Final)<-NULL
print(Final)



##EXTRAS##
#Add OAA/Opp to Final
Final$"OAA/Opp"<-(Final$OAA) / (Final$Opp)
print(Final)
Final2<-left_join(Final,errors, by="Player")
Final2<-Final2[order(-Final2$`OAA/Opp`),]
Final2<-subset(Final2, Final2$Opportunities>10)
rownames(Final2)<-NULL
print(Final2)

#Average x,y for committing an out#
SSLocation<-subset(SSDefense, SSDefense$player_out_credit=="TRUE")
summary(SSLocation$player_x)
summary(SSLocation$player_y)
par(mar=c(1,1,1,1))
boxplot(SSLocation$player_x, SSLocation$player_y, 
        main="Player Location for Outs",
        at=c(1,2),
        names=c("x,y"),
        col=c("royalblue","red"),
        horizontal=TRUE)
text(x= round(boxplot.stats(SSLocation$player_x)$stats), 
     labels =round(boxplot.stats(SSLocation$player_x)$stats), y=1.6)
text(x= round(boxplot.stats(SSLocation$player_y)$stats), 
     labels =round(boxplot.stats(SSLocation$player_y)$stats), y=2.5)
