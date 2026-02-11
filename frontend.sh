#!/bin/bash

source ./common.sh
app_name=frontend
app_dir=/usr/share/nginx/html

check_root

dnf module disable nginx -y &>> $LOGS_FILE
dnf module enable nginx:1.24 -y &>> $LOGS_FILE
dnf install nginx -y &>> $LOGS_FILE
VALIDATE $? "Installing Nginx"

systemctl enable nginx &>> $LOGS_FILE
systemctl start nginx 
VALIDATE $? "Enabling and Starting Nginx"

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "Removing Default Content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> $LOGS_FILE
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>> $LOGS_FILE
VALIDATE $? "Downloaing and Unzipping Frontend"

rm -rf /etc/nginx/nginx.conf

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "Copied our nginx conf file"

systemctl restart nginx 
VALIDATE $? "Restarting Nginx"

print_total_time