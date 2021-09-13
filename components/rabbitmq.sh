#!/bin/bash

source components/common.sh

echo "\e[1;33mSetting Up RabbitMQ Database\e[0m"

print "Installing Erlang.\t\t"
yum list installed | grep erlang
if [ $? -eq 0 ];
    then
        echo -e "Erlang is already installed" &>>/tmp/log
        status_check $?
    else
        yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>>/tmp/log
        status_check $?
fi


print "Setup YUM repositories for RabbitMQ."
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>/tmp/log
status_check $?

print "Install RabbitMQ.\t\t"
yum install rabbitmq-server -y &>>/tmp/log
status_check $?

print "Start RabbitMQ.\t\t"
systemctl start rabbitmq-server &>>/tmp/log && systemctl enable rabbitmq-server &>>/tmp/log && systemctl restart rabbitmq-server &>>/tmp/log
status_check $?


print "Creating application user.\t"
rabbitmqctl list_user | grep roboshop
if [ $? -nq 0 ];
    then
        rabbitmqctl add_user roboshop roboshop123 &>>/tmp/log
fi
rabbitmqctl set_user_tags roboshop administrator &>>/tmp/log && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/log
status_check $?