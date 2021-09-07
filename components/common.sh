#!/bin/bash

status_check() {
    if [ $1 -eq 0 ];
        then
            echo -e "\e[1;32mSUCCESS\e[0m"
        else
            echo -e "\e[1;31mFAILURE\e[0m"
            exit 2
    fi
}

print() {
    
     echo -n -e " $1\t -  "
}

if [ $UID -ne 0 ];
    then 
            echo -e "\e[1;31mPremission deined. Need to be a ROOT user to execute this command"
        exit 1
fi

rm -rf /tmp/log

ADD_USER() {
    print "\e[1;33mAdding new user - 'roboshop'.\t\t\e[0m"
    id roboshop &>>/tmp/log
    if [ $? -eq 0 ];
       then
         echo -e "\e[1;31mUser roboshop already exist.\e[0m "  &>>/tmp/log
     else    
         useradd roboshop &>>/tmp/log
    fi
    status_check $?
    }

DOWNLOAD() {
    print "\e[1;33mDownloading ${component} zip file.\t\e[0m"
    curl -s -L -o /tmp/${component}.zip "https://github.com/roboshop-devops-project/${component}/archive/main.zip" &>>/tmp/log
    status_check $?
    }

EXTRACT() {
    print "\e[1;33mExtracting ${component}.\t\t\t\e[0m"
    cd /home/roboshop
    rm -rf ${component} && unzip -o /tmp/${component}.zip &>>/tmp/log && mv ${component}-main ${component}
    status_check $?
    }
    
SYSTEMD_SETUP() {
    print "\e[1;33mUpdating systemd.service file.\t\t\e[0m"
    sed -i -e 's/MONGO_DNSNAME/mongodb.krishna.roboshop/' /home/roboshop/${component}/systemd.service
    status_check $?

    print "\e[1;33mEnabling ${component} Component.\t\t\e[0m"
    mv /home/roboshop/${component}/systemd.service /etc/systemd/system/${component}.service && systemctl daemon-reload && systemctl restart ${component} &&  systemctl enable ${component} &>>/tmp/log
    status_check $?

    echo -e "\e[1;35m${component} Component is ready to use.\n\e[0m"
    }
    
NODEJS() {
    print "\e[1;33mInstalling Nodejs.\t\t\t\e[0m"

    yum install nodejs make gcc-c++ -y &>>/tmp/log
    status_check $?

    echo -e "\e[1;35mLet's now set up the ${component} application.\e[0m"

    ADD_USER
    
    DOWNLOAD

    EXTRACT

    print "\e[1;33mLoading Dependency  for ${component}.\t\e[0m"
    cd /home/roboshop/${component}
    npm install --unsafe-perm &>>/tmp/log
    status_check $?

    chown roboshop:roboshop -R /home/roboshop
    
    SYSTEMD_SETUP
    }