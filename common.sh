#!/bin/bash

# To log files
USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop" # shell-roboshop --> folder name
LOGS_FILE="$LOGS_FOLDER/$0.log"  # $0=12-logs.sh(script name)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SCRIPT_DIR=$PWD
START_TIME=$(date +%s)
MONGODB_HOST=mongodb.devopsdaws.online

mkdir -p $LOGS_FOLDER 

echo "$(date "+%Y-%m-%d %H:%M:%S") | Script started executing at: $(date)" | tee -a $LOGS_FILE

check_root(){
    if [ $USERID -ne 0 ]; then
        echo -e "$R Please run this script with root user access $N" | tee -a $LOGS_FILE
        exit 1 
    fi
}

# By default shell will not execute this, only it will be executed when called (It can be validate, status_check...)
VALIDATE(){

    if [ $1 -ne 0 ]; then
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2... $R FAILURE $N" | tee -a $LOGS_FILE # Tee is used for showing the output both in terminal and file (logs_file)
        exit 1
    else 
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2... $G SUCCESS $N" | tee -a $LOGS_FILE
    fi

}

nodejs_setup(){

    dnf module disable nodejs -y &>> $LOGS_FILE
    VALIDATE $? "Disabling NodeJS default version"

    dnf module enable nodejs:20 -y &>> $LOGS_FILE
    VALIDATE $? "Enabling NodeJS 20"

    dnf install nodejs -y &>> $LOGS_FILE
    VALIDATE $? "Install NodeJS"

    npm install &>> $LOGS_FILE
    VALIDATE $? "Installing Dependencies"
}

app_setup(){

    # 2.Creating the System User

    id roboshop &>> $LOGS_FILE
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOGS_FILE
        VALIDATE $? "Creating System User"
    else
        echo -e "Roboshop user already exists... $Y SKIPPING $N"
    fi

    # 1.Downloading the App

    mkdir -p /app 
    VALIDATE $? "Creating App Directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>> $LOGS_FILE
    VALIDATE $? "Downloading $app_name Code"

    cd /app 
    VALIDATE $? "Moving to App Directory"

    rm -rf /app/* # It removes all the content which is present in that folder
    VALIDATE $? "Removing existing code"

    unzip /tmp/$app_name.zip &>> $LOGS_FILE
    VALIDATE $? "Unzip $app_name Code"
}

systemd_setup(){

    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATE $? "Created systemctl service"

    systemctl daemon-reload
    systemctl enable $app_name &>> $LOGS_FILE
    systemctl start $app_name
    VALIDATE $? "Enabling and Starting $app_name"
}

system_restart(){
    systemctl restart $app_name
    VALIDATE $? "Restarting $app_name"
}

print_total_time(){

    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Script executed in: $G $TOTAL_TIME seconds $N" | tee -a $LOGS_FILE 
}