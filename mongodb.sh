#!/bin/bash

source ./common.sh

check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying Mongo Repo"

dnf install mongodb-org -y &>> $LOGS_FILE
VALIDATE $? "Installing MongoDB Server"

systemctl enable mongod &>> $LOGS_FILE
VALIDATE $? "Enabling MongoDB"

systemctl start mongod
VALIDATE $? "Starting MongoDB"

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf
VALIDATE $? "Allowing Remote Connections"

systemctl restart mongod
VALIDATE $? "Restart MongoDB"

print_total_time