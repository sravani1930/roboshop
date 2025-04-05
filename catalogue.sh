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

validate(){
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
validate $? "INSTALLATION of disable nodejs"
dnf module enable nodejs:18 -y &>> $LOGFILE
dnf install nodejs -y

dnf install nodejs -y &>> $LOGFILE
validate $? "nodejs installation"
id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi
mkdir -p /app &>> $LOGFILE
validate $? "creating Directory"
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE
validate $? "Downloading file"
cd /app &>> $LOGFILE
unzip -o /tmp/catalogue.zip &>> $LOGFILE
validate $? "Unzipping file"
cd /app &>> $LOGFILE
npm install &>> $LOGFILE
validate $? "npm install"
cp /home/centos/roboshop/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE
validate $? "file copying "
systemctl daemon-reload &>> $LOGFILE
validate $? "catalogue daemon reload"
systemctl enable catalogue &>> $LOGFILE
validate $? "Enable catalogue"
systemctl start catalogue &>> $LOGFILE
validate $? "Starting catalogue"
cp /home/centos/roboshop/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
validate $? "copying mongodb repo"
dnf install mongodb-org-shell -y &>> $LOGFILE
validate $? "Installing MongoDB client"
mongo --host $MONGDB_HOST </app/schema/catalogue.js &>> $LOGFILE
validate $? "Loading catalouge data into MongoDB"
mongo --host $MONGODB_HOST </app/schema/catalogue.js