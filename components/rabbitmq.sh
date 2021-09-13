#!/bin/bash

if [ $UID -ne 0 ];
    then 
            echo -e "\e[1;31mPremission deined. Need to be a ROOT user to execute this command"
        exit 1
fi

status_check () {
    if [ $1 -eq 0 ];
        then
            echo -e "\e[1;32mSUCCESS\e[0m"
        else
            echo -e "\e[1;31mFAILURE\e[0m"
            exit 2
    fi
    }

echo -e "Setting Up Rabbitmq component."

echo -e  "install Erlang.\t\t"
yum list installed | grep erlang
if [ $? -eq 0 ];
    then
        echo -e "Erlang is already installed" &>>/tmp/log
        status_check $?
    else
        yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>>/tmp/log
        status_check $?
fi


echo -e "Setup YUM repos for RabbitMQ.\t"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>/tmp/log
status_check $?

echo -e "Install RabbitMQ.\t\t"
yum install rabbitmq-server -y &>>/tmp/log
status_check $?

echo -e  "Start RabbitMQ.\t"
systemctl enable rabbitmq-server &>>/tmp/log && systemctl start rabbitmq-server &>>/tmp/log
status_check $?


echo -e "Creating application user.\t"
rabbitmqctl list_user | grep roboshop &>>/tmp/log
if [ $? -nq 0 ];
    then 
        rabbitmqctl add_user roboshop roboshop123 &>>/tmp/log 
fi
rabbitmqctl set_user_tags roboshop administrator &>>/tmp/log && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/log
status_check $?