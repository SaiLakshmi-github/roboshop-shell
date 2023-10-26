#!/bin/bash

Date=$(date +%F)
Script_name=$0
#implementation of log file
Logdir=/tmp
Logfile=$Logdir/$Script_name-$Date.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
UserID=$(id -u)
    if [ $UserID -ne 0 ]
    then
    echo -e "$R error execute the file with root access $N"
    exit 1
    fi

Validate(){
       if [ $1 -ne 0 ]
    then
    echo -e "$2... $R  Failure $N"
    else
    echo -e "$2..  $G Success $N"
     fi
    
}
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $Logfile
Validate $? "install rpm"
yum install nodejs -y &>> $Logfile
Validate $? "installing nodjs"
useradd roboshop &>> $Logfile

Validate $? "adding user roboshop"
mkdir /app &>> $Logfile
Validate $? "adding directory"
curl -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $Logfile
Validate $? "downloading zip"
cd /app &>> $Logfile

unzip /tmp/user.zip &>> $Logfile
Validate $? "unzipping file"

npm install &>> $Logfile
Validate $? "installing dependencies"
cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service &>> $Logfile
Validate $? "coping user service"

systemctl daemon-reload &>> $Logfile
Validate $? "daemon-reload"
systemctl enable user &>> $Logfile
Validate $? "enabling user"
systemctl start user &>> $Logfile
Validate $? "starting user"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "Copying mongo repo"

yum install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $? "Installing mongo client"

mongo --host mongodb.joindevops.online </app/schema/user.js &>>$LOGFILE

VALIDATE $? "loading user data into mongodb"