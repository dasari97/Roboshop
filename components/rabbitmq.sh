#!/bin/bash

source components/commom.sh

print "Install Erlang\t"
    yum list installed | grep erlang &>>/tmp/log
    if [ $? -eq 0 ];
        then
            echo "Package Already Installed" &>>/tmp/log
        else
            yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.e17.x86_64.rpm -y &>>/tmp/log
    fi
status_check $?

print "setting Rabbitmq Repos\t"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>/tmp/log
status_check $?

print "Install RabbitMQ.\t"
yum install rabbitmq-server -y &>>/tmp/log
status_check $?

print "Starting RabbitMQ.\t"
systemctl enable rabbitmq-server &>>/tmp/log && systemctl start rabbitmq-server &>>/tmp/log
status_check $?

print "creating App user\t"
rabbitmqctl list_users | grep roboshop &>>/tmp/log
if [ $? -ne 0 ];
    then
        rabbitmqctl add_user roboshop roboshop123 &>>/tmp/log
fi

rabbitmqctl set_user_tags roboshop administrator &>>/tmp/log && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/log
status_check $?
        