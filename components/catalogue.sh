#!/bin/bash

source components/common.sh

print "\e[1;33mInstalling Nodejs.\t\t\t\e[0m"

yum install nodejs make gcc-c++ -y &>>/tmp/log
status_check $?

echo -e "\e[1;35mLet's now set up the catalogue application.\e[0m"

print "\e[1;33mAdding new user - 'roboshop'.\t\t\e[0m"
id roboshop &>>/tmp/log
if [ $? -eq 0 ];
    then
        echo -e "\e[1;31mUser roboshop already exist.\e[0m "  &>>/tmp/log
    else    
        useradd roboshop &>>/tmp/log
fi
status_check $?

print "\e[1;33mDownloading catalogue zip file.\t\e[0m"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>/tmp/log
status_check $?

print "\e[1;33mExtracting Catalogue.\t\t\t\e[0m"
cd /home/roboshop
rm -rf catalogue && unzip -o /tmp/catalogue.zip &>>/tmp/log && mv catalogue-main catalogue
status_check $?

print "\e[1;33mLoading Dependency  for catalogue.\t\e[0m"
cd /home/roboshop/catalogue
npm install --unsafe-perm &>>/tmp/log
status_check $?

chown roboshop:roboshop -R /home/roboshop

print "\e[1;33mUpdating systemd.service file.\t\t\e[0m"
sed -i -e 's/MONGO_DNSNAME/mongo.krishna.roboshop/' /home/roboshop/catalogue/systemd.service
status_check $?

print "\e[1;33mEnabling Catalogue Component.\t\t\e[0m"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service && systemctl daemon-reload && systemctl restart catalogue &&  systemctl enable catalogue &>>/tmp/log
status_check $?

echo -e "\e[1;35mCatalogue Component is ready to use.\n\e[0m"