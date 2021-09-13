#!/bin/bash
if [ $UID -ne 0 ];
    then 
        echo -e "\e[1;31mPremission deined. Need to be a ROOT user to execute this command\e[0m"
        exit 1
    else
        echo hy   
fi
