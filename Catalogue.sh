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
Validate $? "installing nodejs"
useradd roboshop &>> $Logfile

Validate $? "adding user roboshop"
mkdir /app &>> $Logfile
Validate $? "adding directory"
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $Logfile
Validate $? "downloading zip"
cd /app &>> $Logfile

unzip /tmp/catalogue.zip &>> $Logfile
Validate $? "unzipping file"

npm install &>> $Logfile
Validate $? "installing dependencies"
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>> $Logfile
Validate $? "coping catalogue service"

systemctl daemon-reload &>> $Logfile
Validate $? "daemon-reload"
systemctl enable catalogue &>> $Logfile
Validate $? "enabling catalogue"
systemctl start catalogue &>> $Logfile
Validate $? "starting catalogue"

mongo --host mongodb.skilldevops.online </app/schema/catalogue.js