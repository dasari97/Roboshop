#!/bin/bash
if [ $UID -ne 0 ];
    then
        echo -e "\e[1;31mPermission denied. Need to be a root user to perform this command\e[0m"
        exit 1
fi

echo -e "Setting Up RabbitMQ."

echo -e "Installing Erlang.\t\t"
yum list installed | grep erlang &>>/tmp/log
if [ $? -eq 0 ];
    then
        echo -e "Erlang is already installed." &>>/tmp/log
        status_check $?
    else
        yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>>/tmp/log
        status_check $?
fi

   exit     
#Setup YUM repositories for RabbitMQ.
# curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
#Install RabbitMQ
# yum install rabbitmq-server -y 
#Start RabbitMQ
# systemctl enable rabbitmq-server 
# systemctl start rabbitmq-server 


#Create application user
# rabbitmqctl add_user roboshop roboshop123
# rabbitmqctl set_user_tags roboshop administrator
# rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
echo -e "RabbitMq setup is finished."