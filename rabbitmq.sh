#!/bin/bash

source ./common.sh
app_name=rabbitmq

check_root

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "Adding RabbitMQ Repo"

dnf install rabbitmq-server -y &>> $LOGS_FILE
VALIDATE $? "Installing RabbitMQ-Server"

systemctl enable rabbitmq-server &>> $LOGS_FILE
systemctl start rabbitmq-server
VALIDATE $? "Enabling and Starting RabbitMQ"

rabbitmqctl add_user roboshop roboshop123 &>> $LOGS_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGS_FILE
VALIDATE $? "Created User and given permissions"

print_total_time