#!/bin/bash


source components/common.sh

print "install Erlang.\t\t"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>>/tmp/log
status_check $?

print "Setup YUM repos for RabbitMQ.\t"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>/tmp/log
status_check $?

print "Install RabbitMQ.\t\t"
yum install rabbitmq-server -y &>>/tmp/log
status_check $?

print "Start RabbitMQ.\t"
systemctl enable rabbitmq-server &>>/tmp/log && systemctl start rabbitmq-server &>>/tmp/log
status_check $?


print "Creating application user.\t"
rabbitmqctl add_user roboshop roboshop123 &>>/tmp/log && rabbitmqctl set_user_tags roboshop administrator &>>/tmp/log && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/log
status_check $?