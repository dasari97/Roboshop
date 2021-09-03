#!/bin/bash

source components/common.sh

print "\e[1;35mThis service is written in NodeJS, Hence need to install NodeJS in the system.\e[0m"

yum install nodejs make gcc-c++ -y &>>/tmp/log
status_check $?

print "\e[1;35mLet's now set up the catalogue application.\e[0m"


useradd roboshop
status_check $?

sudo su - roboshop
status_check $?

curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>/tmp/log
status_check $?

cd /home/roboshop

unzip /tmp/catalogue.zip &>>/tmp/log
status_check $?

mv catalogue-main catalogue
cd /home/roboshop/catalogue

npm install 

#NOTE: We need to update the IP address of MONGODB Server in systemd.service file
#Now, lets set up the service with systemctl.

# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue