
##CREATE MOCK OF ALL TABLES
#User Table- 5 Users, ensure 2 register in 2013, all make deposit
CREATE TABLE DuelUser (     
user_id VARCHAR(2) NOT NULL,     
username VARCHAR(255) NOT NULL,     
email VARCHAR(255) NOT NULL,     
deposit_count INT NOT NULL,     
account_suspended INT NOT NULL,     
registration_date DATE NOT NULL,     
PRIMARY KEY (user_id) );
INSERT INTO DuelUser(user_id, username, email, deposit_count, account_suspended, registration_date) VALUES ('U1','dhannon','dhannon@a.com', 5, 0, '2013-1-12');
INSERT INTO DuelUser(user_id, username, email, deposit_count, account_suspended, registration_date) VALUES ('U2','bellermeyer','bellermeyer@a.com',2,0,'2010-4-10');
INSERT INTO DuelUser(user_id, username, email, deposit_count, account_suspended, registration_date) VALUES ('U3','rboswell','rboswell@a.com',1,1,'2013-3-3');
INSERT INTO DuelUser(user_id, username, email, deposit_count, account_suspended, registration_date) VALUES ('U4','mbell','mbell@a.com',10,1,'2012-1-12');
INSERT INTO DuelUser(user_id, username, email, deposit_count, account_suspended, registration_date) VALUES ('U5','pwilt','pwilt@a.com',7,0,'2011-7-2');

#Entry Table- Ensure good portion in 2013, paid entries
CREATE TABLE DuelEntry (  
entry_id INT NOT NULL,     
game_id VARCHAR(2) NOT NULL,     
user_id VARCHAR(2) NOT NULL,     
entry_date DATE NOT NULL,     
entry_fee INT NOT NULL,     
winnings INT NOT NULL,    
mobile_entry INT NOT NULL,     
PRIMARY KEY (entry_id) );
INSERT INTO DuelEntry(entry_id,game_id,user_id,entry_date,entry_fee,winnings,mobile_entry) VALUES (1000,'G1','U4','2011-2-10',5,0,1);
INSERT INTO DuelEntry(entry_id,game_id,user_id,entry_date,entry_fee,winnings,mobile_entry) VALUES (1001,'G1','U3','2013-2-10',10,20,0);
INSERT INTO DuelEntry(entry_id,game_id,user_id,entry_date,entry_fee,winnings,mobile_entry) VALUES (1002,'G1','U5','2011-2-10',5,5,1);
INSERT INTO DuelEntry(entry_id,game_id,user_id,entry_date,entry_fee,winnings,mobile_entry) VALUES (1003,'G1','U4','2013-2-10',5,0,1);
INSERT INTO DuelEntry(entry_id,game_id,user_id,entry_date,entry_fee,winnings,mobile_entry) VALUES (1004,'G1','U1','2013-2-10',5,0,1);
INSERT INTO DuelEntry(entry_id,game_id,user_id,entry_date,entry_fee,winnings,mobile_entry) VALUES (1005,'G3','U1','2013-2-11',5,0,1);
INSERT INTO DuelEntry(entry_id,game_id,user_id,entry_date,entry_fee,winnings,mobile_entry) VALUES (1006,'G3','U3','2013-2-12',5,0,1);
INSERT INTO DuelEntry(entry_id,game_id,user_id,entry_date,entry_fee,winnings,mobile_entry) VALUES (1007,'G3','U1','2013-2-13',5,0,1);
INSERT INTO DuelEntry(entry_id,game_id,user_id,entry_date,entry_fee,winnings,mobile_entry) VALUES (1008,'G3','U4','2011-2-10',5,0,1);
INSERT INTO DuelEntry(entry_id,game_id,user_id,entry_date,entry_fee,winnings,mobile_entry) VALUES (1009,'G3','U2','2013-2-14',5,0,1);
INSERT INTO DuelEntry(entry_id,game_id,user_id,entry_date,entry_fee,winnings,mobile_entry) VALUES (1010,'G3','U1','2013-2-16',5,0,1);

##GAME TABLE- Ensure NFL Game
CREATE TABLE DuelGame (  
game_id VARCHAR(2) NOT NULL,     
sport VARCHAR(3) NOT NULL,     
size INT NOT NULL,     
PRIMARY KEY (game_id));
INSERT INTO DuelGame(game_id, sport, size) VALUES ('G1','NFL', 500);
INSERT INTO DuelGame(game_id, sport, size) VALUES ('G2','NBA', 200);
INSERT INTO DuelGame(game_id, sport, size) VALUES ('G3','MLB', 2);
CREATE TABLE DuelPayments (  
payment_id VARCHAR(3) NOT NULL,     
user_id VARCHAR(2) NOT NULL,     
payment_type VARCHAR(1) NOT NULL,     
payment_date DATE NOT NULL,     
amount INT NOT NULL,     
PRIMARY KEY (payment_id) );
INSERT INTO DuelPayments(payment_id, user_id, payment_type, payment_date, amount) VALUES ('P1','U3','D','2011-2-10',5);
INSERT INTO DuelPayments(payment_id, user_id, payment_type, payment_date, amount) VALUES ('P2','U4','D','2011-2-10',10);
INSERT INTO DuelPayments(payment_id, user_id, payment_type, payment_date, amount) VALUES ('P3','U1','D','2011-2-10',100);
INSERT INTO DuelPayments(payment_id, user_id, payment_type, payment_date, amount) VALUES ('P4','U2','D','2013-2-10',100);
INSERT INTO DuelPayments(payment_id, user_id, payment_type, payment_date, amount) VALUES ('P5','U5','D','2011-2-10',100);
INSERT INTO DuelPayments(payment_id, user_id, payment_type, payment_date, amount) VALUES ('P6','U3','W','2012-3-4',50);
INSERT INTO DuelPayments(payment_id, user_id, payment_type, payment_date, amount) VALUES ('P7','U5','W','2012-3-4',50);
INSERT INTO DuelPayments(payment_id, user_id, payment_type, payment_date, amount) VALUES ('P8','U1','D','2013-2-10',25);
INSERT INTO DuelPayments(payment_id, user_id, payment_type, payment_date, amount) VALUES ('P9','U1','D','2013-2-12',10);
INSERT INTO DuelPayments(payment_id, user_id, payment_type, payment_date, amount) VALUES ('P10','U2','W','2013-3-1',5);
INSERT INTO DuelPayments(payment_id, user_id, payment_type, payment_date, amount) VALUES ('P11','U2','D','2013-3-4',10);
INSERT INTO DuelPayments(payment_id, user_id, payment_type, payment_date, amount) VALUES ('P12','U4','D','2013-4-1',12);
INSERT INTO DuelPayments(payment_id, user_id, payment_type, payment_date, amount) VALUES ('P13','U1','W','2013-7-5',50);
INSERT INTO DuelPayments(payment_id, user_id, payment_type, payment_date, amount) VALUES ('P14','U2','W','2013-8-7',75);
INSERT INTO DuelPayments(payment_id, user_id, payment_type, payment_date, amount) VALUES ('P15','U4','W','2013-9-1',200);

SELECT COUNT(*) FROM DuelUser WHERE deposit_count >=1 AND Year(registration_date)=2013;

CREATE TABLE GameEntry AS 
SELECT
	DuelEntry.*,
    DuelGame.sport,
    DuelGame.size
FROM DuelEntry
LEFT JOIN DuelGame on DuelEntry.game_id=DuelGame.game_id;

SELECT*FROM GameEntry;

CREATE TABLE DuelPaymentsAdj AS
SELECT*, 
CASE WHEN payment_type = 'W' THEN -amount ELSE amount END AS adjusted_amount FROM DuelPayments;

CREATE TABLE NetDeposits AS 
SELECT user_id, SUM(adjusted_amount) AS net_deposit 
FROM DuelPaymentsAdj GROUP BY user_id;

CREATE TABLE UserPayments AS 
SELECT 
	DuelUser.*,
    NetDeposits.net_deposit
FROM DuelUser
LEFT JOIN NetDeposits on DuelUser.user_id = NetDeposits.user_id;
 SELECT*FROM UserPayments;
 
 CREATE TABLE MasterInfo AS 
 SELECT 
	GameEntry.*,
    UserPayments.username,
    UserPayments.email,
    UserPayments.deposit_count,
    UserPayments.account_suspended,
    UserPayments.registration_date,
    UserPayments.net_deposit
FROM GameEntry
LEFT JOIN UserPayments on GameEntry.user_id=UserPayments.user_id;
SELECT*FROM MasterInfo;

CREATE TABLE MasterInfo2 AS 
SELECT*,
CASE WHEN sport = 'NFL' AND YEAR(entry_date)=2013 THEN entry_fee ELSE 0 END AS NFL2013_Fees, 
CASE WHEN sport != 'NFL' AND YEAR(entry_date)=2013 THEN entry_fee ELSE 0 END AS Other2013_Fees 
FROM MasterInfo;
SELECT*FROM MasterInfo2;

CREATE TABLE MobileEntryInfo AS 
SELECT
	user_id,
    sum(CASE WHEN mobile_entry=1 THEN 1 ELSE 0 END) AS UserMobileEntries,
    count(*) AS TotalUserEntries
FROM MasterInfo2
GROUP BY user_id;
SELECT*FROM MobileEntryInfo;

CREATE TABLE MasterInfo3 AS
SELECT 
	MasterInfo2.*,
    MobileEntryInfo.UserMobileEntries,
    MobileEntryInfo.TotalUserEntries
FROM MasterInfo2
LEFT JOIN MobileEntryInfo on MasterInfo2.user_id=MobileEntryInfo.user_id;

SELECT*FROM MasterInfo3;

##FILTER FOR QUESTION 2- At least one deposit and registered in 2013- Get count
SELECT COUNT(*) FROM DuelUser WHERE deposit_count >=1 AND   Year(registration_date)=2013;

##FILTER FRO QUESTION 3- distinct users that satisfy previous criteria plus played NFL in 2013
SELECT COUNT(distinct user_id) FROM MasterInfo3  
WHERE deposit_count >=1 
AND Year(registration_date)=2013 
AND sport ='NFL' 
AND YEAR(entry_date)=2013;    

#Question 4- Create Table of just eligible users from question 3
CREATE TABLE Eligible_Users AS 
SELECT
distinct(user_id) FROM MasterInfo3  
WHERE deposit_count >=1 
AND Year(registration_date)=2013 
AND sport ='NFL' 
AND YEAR(entry_date)=2013;  

SELECT*FROM Eligible_Users;

##Created table of desired info from MasterInfo3 to be joined with Eligible Users
CREATE TABLE CRM AS
SELECT
	user_id,
    email,
    sum(NFL2013_Fees) AS 2013NFLFees,     
	sum(Other2013_Fees)AS 2013OtherFees,
    (UserMobileEntries)/(TotalUserEntries) AS PercentMobile,
    MAX(CASE WHEN entry_fee>0 THEN entry_date ELSE 'N/A' END) AS LastPaidEntry,
    net_deposit
FROM MasterInfo3
GROUP BY user_id, email, PercentMobile, net_deposit;

CREATE TABLE CRMFinal AS
SELECT
	CRM.*
FROM Eligible_Users
LEFT JOIN CRM on Eligible_Users.user_id=CRM.user_id;

#Final Result for CRM Manager
SELECT*FROM CRMFinal;