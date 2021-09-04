#!/bin/bash

source components/common.sh

print "\e[1;33mInstalling YUM Utilitties\e[0m"
yum install epel-release yum-utils http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y &>>/tmp/log
status_check $?

#print "\e[1;33mInstalling Remi Repos\e[0m;"
#yum install  -y &>>/tmp/log
#status_check $?

print "\e[1;mEnabling Remi\e[0m"
yum-config-manager --enable remi &>>/tmp/log
status_check $?

print "\e[1;33mInstalling Redis Component\e[0m"
yum install redis -y &>>/tmp/log
status_check $?

print "\e[1;33mConfiguring Redis Component\e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>/tmp/log
status_check $?

systemctl start redis
systemctl enable redis &>>/tmp/log

echo -e  "\e[1;35mRedis Component is ready to use.\e[0m"