#!/bin/bash

LID="lt-02a58e5505b68e560"
VLID=1

instance_name=$1

if [ -z '${instance_name}' ];
    then
        echo -e "\e[1;33mFailed to provide Instance Name\e[0m"
        exit 1
        
fi

aws ec2 describe-instances --filters "Name=tag:Name,Values=Owner" | jq .Reservation[].Instance[].State.name | grep running &>/dev/null
if [ $? -eq 0 ];
    then 
        echo -e "\e[1;33mInstance already exists\e[0m"
        exit 1
fi

aws ec2 describe-instances --filters "Name=tag:Name,Values=Owner" | jq .Reservation[].Instance[].State.name | grep stopped &>/dev/null
if [ $? -eq 0 ];
    then 
        echo -e "\e[1;33mInstance already exists\e[0m"
        exit 1
fi

IP=$(aws ec2 run-instances --launch-template LaunchTemplateId=$LID,Version=$VLID --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=$instance_name}" "ResourceType=instances,Tags=[{Key=Name,Value=$instance_name}" | jq .Instances[].PrivateIpAddress | sed -e 's/"//g')

sed -e 's/instance_name/$instance_name/' -e 's/instance_ip/$IP/' record.json >tmp/record.json
aws route53 change-resource-record-sets --hosted-zone-id Z06986272M4T56TOB7K70 --change-batch file:///tmp/record.json | jq