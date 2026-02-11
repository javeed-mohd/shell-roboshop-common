#!/bin/bash

source ./common.sh
app_name=mysql

check_root

dnf install mysql-server -y &>> $LOGS_FILE
VALIDATE $? "Installing MySQL Server"

systemctl enable mysqld &>> $LOGS_FILE
systemctl start mysqld
VALIDATE $? "Enabling and Starting MySQL"

# Get the password from user
mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Setup root password"

print_total_time