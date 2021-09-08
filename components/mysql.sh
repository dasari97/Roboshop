#!/bin/bash


source components/common.sh

print "Setting MYSQL Repos.\t\t"
echo '[mysql57-community]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/$basearch/
enabled=1
gpgcheck=0' > /etc/yum.repos.d/mysql.repo
status_check $?

print "Install MySQL \t\t\t"
yum remove mariadb-libs -y &>>/tmp/log && yum install mysql-community-server -y &>>/tmp/log
status_check $?


print "Start MySQL service.\t\t"
systemctl enable mysqld &>>/tmp/log && systemctl start mysqld &>>/tmp/log && systemctl restart mysqld &>>/tmp/log
status_check $?


default_pass=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')


print "Resetting Default password.\t"
echo 'show databases' | mysql -u root -pRoboShop@1 &>>/tmp/log
if [ $? -eq 0 ];
    then 
        echo "Root password reset already done." &>>/tmp/log 
    else 
        echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" >/tmp/reset.sql
        mysql --connect-expired-password -uroot -p"${default_pass}" </tmp/reset.sql &>>/tmp/log
        
fi
status_check $?

print "Uninstall Password Validate Plugin."
echo 'show plugins;' | mysql -u root -pRoboShop@1 2>/dev/null | grep -i validate_password &>>/tmp/log
if [ $? -eq 0 ];
    then
        echo "uninstall plugin validate_password;" >/tmp/pass.sql
        mysql -u root -p"RoboShop@1" </tmp/pass.sql &>>/tmp/log
        
    else 
        echo "Validate Password pulgin already remove" &>>/tmp/log
fi 
status_check $?

print "Downloading Schema.\t\t"
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>/tmp/log
status_check $?

print "Extract schema file.\t\t"
cd /tmp &&  unzip -o mysql.zip &>>/tmp/log
status_check $?

print "Load the schema for Services.\t"
cd mysql-main
mysql -u root -pRoboShop@1 </tmp/mysql-main/shipping.sql &>>/tmp/log
status_check $?

echo -e "\e[1;33mMysql component is ready to use.\e[0m"
