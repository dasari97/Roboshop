#!/bin/bash

LID='lt-02a58e5505b68e560'
VLID=2

aws ec2 run-instances --launch-template LaunchTemplateId=$LID,Version=$VLID