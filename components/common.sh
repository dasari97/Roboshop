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