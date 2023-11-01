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
cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $Logfile
Validate $? " Copied mongodb to yum.repos.d"
yum install mongodb-org -y &>> $Logfile
Validate $? " Installed Mongodborg"
systemctl enable mongod &>> $Logfile
Validate $? " Enabling mongodb"
systemctl start mongod &>> $Logfile
Validate $? " Starting mongodb"
sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf &>> $Logfile
Validate $? " replacing the conf file" 
systemctl restart mongod &>> $Logfile
Validate $? " Restarting mongodb"
