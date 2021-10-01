#!/bin/bash

source components/common.sh

component=shipping

echo -e "\e[1;33mSetting Up shipping component\e[0m"

print "Install Maven and Java.\t\t"
yum install maven -y &>>/tmp/log
status_check $?

ADD_USER

DOWNLOAD

cd shipping &>>/tmp/log && mvn clean package &>>/tmp/log && mv target/shipping-1.0.jar shipping.jar &>>/tmp/log

chown roboshop:roboshop -R /home/roboshop

Filebeat

Rsyslog

SYSTEMD_SETUP

