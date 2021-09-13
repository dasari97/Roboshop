#!/bin/bash

source components/common.sh

echo -e "\e[1;33mSetting Up Mangobd\e[0m"

echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
    
print "\e[1;33mMongoDB Repo Created\t\t\t\e[0m"
  

yum install -y mongodb-org &>>/tmp/log
status_check $?

print "\e[1;33mConfiguring Mongodb\t\t\t\e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
status_check $?


print "\e[1;33mStarting Mongobd and enabling it\t\e[0m"
systemctl enable mongod
systemctl restart mongod
status_check $?


print "\e[1;33mLoading schema into mongodb\t\t\e[0m"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
status_check $?


cd /tmp

print "\e[1;33mExtracing Schema Archive\t\t\e[0m"
unzip -o mongodb.zip &>>/tmp/log
status_check $?


cd mongodb-main

print "\e[1;33mUploading catalogue Schema to Mongodb\t\e[0m"
mongo < catalogue.js &>>/tmp/log
status_check $?


print "\e[1;33mUploading User Schema to Mongodb\t\e[0m"
mongo < users.js &>>/tmp/log
status_check $?


echo -e  "\e[1;33mMongodb setup is done. Ready to use\t\e[0m"