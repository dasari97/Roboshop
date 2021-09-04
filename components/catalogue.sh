#!/bin/bash

source components/common.sh

print "\e[1;35mInstalling Nodejs.\e[0m"

yum install nodejs make gcc-c++ -y &>>/tmp/log
status_check $?

print "\e[1;33mLet's now set up the catalogue application.\e[0m"

print "\e[1;35m\nAdding new user - 'roboshop' .\e[0m"

if [ id roboshop -eq 0 ];
    then
        echo -e "\e[1;33mUser roboshop already exist.\e[0m "  &>>/tmp/log
    else    
        useradd roboshop
fi
status_check $?

print "\e[1;35mDownloading catalogue zip file.\e[0m"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>/tmp/log
status_check $?

cd /home/roboshop
rm -rf catalogue && unzip /tmp/catalogue.zip &>>/tmp/log && mv catalogue-main catalogue
status_check $?

print "\e[1;35mLoading Dependency  for catalogue.\e[0m"
npm install --unsafe-perm &>>/tmp/log
status_check $?

chown roboshop:roboshop -R /home/roboshop

print "\e[1;35mUpdating systemd.service file.\e[0m"
sed -i -e 's/MONGO_DNSNAME/mongo.krishna.roboshop/' /home/roboshop/catalogue/systemd.service
status_check $?

print "\e[1;35mEnabling Catalogue Component.\e[0m"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service && systemctl daemon-reload && systemctl restart catalogue &&  systemctl enable catalogue &>>/tmp/log
status_check $?

print "\e[1;35mCatalogue Component is ready to use.\e[0m"