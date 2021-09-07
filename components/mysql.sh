#!/bin/bash


source components/common.sh

print "Setting MYSQL Repo\t\t"
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

exit

Now a default root password will be generated and given in the log file.
# grep temp /var/log/mysqld.log

Next, We need to change the default root password in order to start using the database service.
# mysql_secure_installation

You can check the new password working or not using the following command.

# mysql -u root -p

Run the following SQL commands to remove the password policy.
> uninstall plugin validate_password;