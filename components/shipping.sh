#!/bin/bash

source components/common.sh

component=shipping

echo -e "\e[1;33mSetting Up shipping component\e[0m"

print "Install Maven and Java.\t\t"
yum install maven -y &>>/tmp/log
status_check $?

ADD_USER


exit


Download the repo
$ cd /home/roboshop
$ curl -s -L -o /tmp/shipping.zip "https://github.com/roboshop-devops-project/shipping/archive/main.zip"
$ unzip /tmp/shipping.zip
$ mv shipping-main shipping
$ cd shipping
$ mvn clean package 
$ mv target/shipping-1.0.jar shipping.jar 
Update Servers IP address in /home/roboshop/shipping/systemd.service

Copy the service file and start the service.

# mv /home/roboshop/shipping/systemd.service /etc/systemd/system/shipping.service
# systemctl daemon-reload
# systemctl start shipping 
# systemctl enable shipping