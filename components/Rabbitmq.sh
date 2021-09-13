#!/bin/bash

if [ $UID -ne 0 ];
    then 
            echo -e "\e[1;31mPremission deined. Need to be a ROOT user to execute this command"
        exit 1
fi

echo hy