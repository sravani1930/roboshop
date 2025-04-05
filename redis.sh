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
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE
VALIDATE $? "REPO INSTALLATION"
dnf module enable redis:remi-6.2 -y &>> $LOGFILE
VALIDATE $? "Module Enable"
dnf install redis -y &>> $LOGFILE
VALIDATE $? "REDIS INSTALL"
sed -i '/s/127.0.0.1/0.0.0.0/g' /etc/redis.conf &>> $LOGFILE
VALIDATE $? "IP UPDATE"
sed -i '/s/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>> $LOGFILE
VALIDATE $? "IP UPDATE"
systemctl enable redis
VALIDATE $? "REDIS ENABLE"
systemctl start redis
VALIDATE $? "REDIS START"



