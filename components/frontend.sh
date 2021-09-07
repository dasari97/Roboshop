#!/bin/bash

source components/common.sh

print "\e[1;33mInstall Nginx.\e[0m"
yum install nginx -y &>>/tmp/log
status_check $?

print "\e[1;33mLet's download the HTDOCS content and deploy under the Nginx path.\e[0m"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>/tmp/log
status_check $?

print "\e[1;33mDeploy in Nginx Default Location.\e[0m"
rm -rf /usr/share/nginx/* && cd /usr/share/nginx/html && unzip -o /tmp/frontend.zip &>>/tmp/log && mv frontend-main/* . && mv static/* . &&  mv localhost.conf /etc/nginx/default.d/roboshop.conf
status_check $?

sed -i -e '/'

print "\e[1;33mEnabling Nginx.\e[0m"
systemctl start nginx &>>/tmp/log && systemctl enable nginx &>>/tmp/log && systemctl restart nginx &>>/tmp/log
status_check $?

echo "\e[1;32mFrontend component is ready to use.\e[0m"