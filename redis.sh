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
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$Logfile
Validate $? "installing rpm redis"
yum module enable redis:remi-6.2 -y &>>$Logfile
Validate $? "enable redis"
yum install redis -y &>>$Logfile
Validate $? "installing redis"
sed -i 's/127.0.0.1/0.0.0.0' /etc/redis.conf &>>$Logfile
Validate $? "replacing config file"
systemctl enable redis &>>$Logfile
Validate $? "enabling redis"
systemctl start redis &>>$Logfile
Validate $? "starting redis"