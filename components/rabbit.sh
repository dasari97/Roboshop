#!/bin/bash

source components/common.sh

echo -e "Setting Up RabbitMQ server."

print "Installing Erlang.\t\t"
yum list installed | grep erlang &>>/tmp/log
if [ $? -eq 0 ];
    then
    echo "package already installed." &>>/tmp/log
    else
    yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>>/tmp/log
fi
status_check $?

print "setting Up RabbitMQ Repos.\t"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>/tmp/log
status_check $?

print "Installing RabbitMQ.\t\t"
yum install rabbitmq-server -y &>>/tmp/log
status_check $?

print "starting RabbitMQ.\t\t"
systemctl start rabbitmq-server &>>/tmp/log && systemctl enable rabbitmq-server &>>/tmp/log && systemctl restart rabbitmq-server &>>/tmp/log
status_check $?

print "creating App user.\t\t"
rabbitmqctl list_users | grep roboshop &>>/tmp/log
if [ $? -ne 0 ];
    then
    rabbitmqctl add_user roboshop roboshop123 &>>/tmp/log
fi
rabbitmqctl set_user_tags roboshop administrator &>>/tmp/log && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/log
status_check $?

echo -e "RabbitMq is ready to use."