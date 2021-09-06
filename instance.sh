#!/bin/bash

LID="lt-02a58e5505b68e560"
VLID=1
INSTANCE_NAME=$1

if [ -z "${INSTANCE_NAME}" ];
    then
        echo -e "\e[1;33mFailed to provide Instance Name\e[0m"
        exit 1
        
fi

aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE_NAME" | jq .Reservations[].Instances[].State.Name | grep running &>/dev/null
if [ $? -eq 0 ];
    then 
        echo -e "\e[1;33mInstance : $instances already exists\e[0m"
        exit 0
fi

aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE_NAME" | jq .Reservations[].Instances[].State.Name | grep stopped &>/dev/null
if [ $? -eq 0 ];
    then 
        echo -e "\e[1;33mInstance : $instances already exists\e[0m"
        exit 0
fi

IP=$(aws ec2 run-instances --launch-template LaunchTemplateId=$LID,Version=$VLID --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" "ResourceType=instances,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" | jq .Instances[].PrivateIpAddress | sed -e 's/"//g')

sed -e 's/instance_name/$INSTANCE_NAME/' -e 's/instance_ip/$IP/' record.json >tmp/record.json
aws route53 change-resource-record-sets --hosted-zone-id Z06986272M4T56TOB7K70 --change-batch file:///tmp/record.json | jq