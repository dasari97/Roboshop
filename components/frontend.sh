#!/bin/bash

source components/common.sh

print "\e[1;33mInstall Nginx.\t\t\t\e[0m"
yum install nginx -y &>>/tmp/log
status_check $?

print "\e[1;33mDownloading Nginx\t\t\e[0m"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>/tmp/log
status_check $?

print "\e[1;33mExtracting Nginx\t\t.\e[0m"
rm -rf /usr/share/nginx/* && cd /usr/share/nginx/ && unzip -o /tmp/frontend.zip &>>/tmp/log && mv frontend-main/* . &>>/tmp/log && mv static html &>>/tmp/log
status_check $?

print "\e[1;33mDeploy in Nginx Default Location.\e[0m"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>/tmp/log
status_check $?

print "\e[1;33mConfiguring Nginx.\t\t\e[0m"
sed -i -e '/catalogue/ s/localhost/catalogue.krishna.roboshop/' -e '/user/ s/localhost/user.krishna.roboshop/' -e '/cart/ s/localhost/cart.krishna.roboshop/' -e '/shipping/ s/localhost/shipping.krishna.roboshop/' -e '/payment/ s/localhost/payment.krishna.roboshop/' /etc/nginx/default.d/roboshop.conf &>>/tmp/log
status_check $?

print "\e[1;33mEnabling Nginx.\t\t\e[0m"
systemctl start nginx &>>/tmp/log && systemctl enable nginx &>>/tmp/log && systemctl restart nginx &>>/tmp/log
status_check $?

Filebeat

echo -e "\e[1;32mFrontend component is ready to use.\e[0m"

