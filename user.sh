#!/bin/bash
ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0_$TIMESTAMP.log"
MONGDB_HOST=mongodb.practice.online

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
   if [ $1 -ne 0 ]
   then
      echo -e "ERROR :: $2 .. $R FAILED $N"
      exit 1;
   else
      echo -e "$2 ... $G SUCCESS $N"
   fi
}

if [ $ID -ne 0 ]
then
   echo -e "$R please switch to root user $N"
   exit 1
else
   echo "proceed to install the package"
fi
dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "nodejs disable"
dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "nodesjs enable"
dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "nodejs enable"
id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi
mkdir -p /app &>> $LOGFILE
curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE
VALIDATE $? "Application Code Download"
cd /app &>> $LOGFILE
unzip -o /tmp/user.zip &>> $LOGFILE
cd /app &>> $LOGFILE
npm install &>> $LOGFILE
VALIDATE $? "NPM INSTALL"

