#!/bin/bash

status_check() {
    if [ $1 -eq 0 ];
        then
            echo -e "\e[1;32mSUCCESS\e[0m"
        else
            echo -e "\e[1;31mFAILURE\e[0m"
            echo -e "Reffer /tmp/log file once"
            exit 2
    fi
}

print() {
    
     echo -n -e " $1\t -  "
}


if [ $UID -ne 0 ];
    then 
            echo -e "\e[1;31mPremission deined. Need to be a ROOT user to execute this command\e[0m"
        exit 1
fi

rm -rf /tmp/log

ADD_USER() {
    print "Adding new user - 'roboshop'.\t\t"
    id roboshop &>>/tmp/log
    if [ $? -eq 0 ];
       then
         echo -e "\e[1;31mUser roboshop already exist.\e[0m "  &>>/tmp/log
         status_check $?
     else    
         useradd roboshop &>>/tmp/log
         status_check $?
    fi
    }
    
Filebeat(){
    
print "Downloading and installing the public signing key"
sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch &>>/tmp/log
status_check $?

print "Creating Filebeat Repo."
curl -L -o /etc/yum.repos.d/filebeat.repo "https://raw.githubusercontent.com/dasari97/Roboshop/main/filebeat.repos" &>>/tmp/log
status_check $?

print "Installing Filebeat."
yum install filebeat -y &>>/tmplog
status_check $?

print "Starting Filebeat."
systemctl enable filebeat &>>/tmp/log && systemctl start filebeat &>>/tmp/log
status_check $?

}


DOWNLOAD() {
    print "Downloading ${component} content \t\t"
    curl -s -L -o /tmp/${component}.zip "https://github.com/roboshop-devops-project/${component}/archive/main.zip" &>>/tmp/log
    status_check $?
    print "Extracting ${component}\t\t\t"
    cd /home/roboshop
    rm -rf ${component} && unzip -o /tmp/${component}.zip &>>/tmp/log && mv ${component}-main ${component}
    status_check $?
    }
    
SYSTEMD_SETUP() {
    print "Updating systemd.service file.\t\t"
    sed -i -e 's/MONGO_DNSNAME/mongodb.krishna.roboshop/' -e 's/REDIS_ENDPOINT/redis.krishna.roboshop/' -e 's/MONGO_ENDPOINT/mongodb.krishna.roboshop/' -e 's/CATALOGUE_ENDPOINT/catalogue.krishna.roboshop/' -e 's/CARTENDPOINT/cart.krishna.roboshop/' -e 's/DBHOST/mysql.krishna.roboshop/' -e 's/CARTHOST/cart.krishna.roboshop/' -e 's/USERHOST/user.krishna.roboshop/' -e 's/AMQPHOST/rabbitmq.krishna.roboshop/' /home/roboshop/${component}/systemd.service
    status_check $?

    print "Setup SystemD services\t\t\t"
    mv /home/roboshop/${component}/systemd.service /etc/systemd/system/${component}.service && systemctl daemon-reload && systemctl start ${component} &>>/tmp/log &&  systemctl enable ${component} &>>/tmp/log && systemctl restart ${component} &>>/tmp/log
    status_check $?

    echo -e "\e[1;35m${component} Component is ready to use.\n\e[0m"
    }
    
NODEJS() {
    print "Installing Nodejs.\t\t\t"

    yum install nodejs make gcc-c++ -y &>>/tmp/log
    status_check $?

    echo -e "Let's now set up the ${component} application."

    ADD_USER
    
    DOWNLOAD


    print "Loading Dependency  for ${component}.\t\t"
    cd /home/roboshop/${component}
    npm install --unsafe-perm &>>/tmp/log
    status_check $?

    chown roboshop:roboshop -R /home/roboshop
    
    SYSTEMD_SETUP
    }
    
Python(){
    
print "Install Python 3\t\t\t"
yum install python36 gcc python3-devel -y &>>/tmp/log
status_check $?

ADD_USER

DOWNLOAD

print "Install the dependencies\t\t"
cd /home/roboshop/payment && pip3 install -r requirements.txt &>>/tmp/log
status_check $?

USERID=$(id -u roboshop)
GROUPID=$(id -g roboshop)

print "updating the congif file.\t\t"
sed -i -e "/uid/ c uid=${USERID}"  -e "/gid/ c gid=${GROUPID}" /home/roboshop/payment/payment.ini
status_check $?

SYSTEMD_SETUP
}

