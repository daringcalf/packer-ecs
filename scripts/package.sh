#!/bin/bash
sudo yum -y erase 'ntp*'
sudo yum -y -x docker\\* -x ecs\\* update
sudo yum -y install chrony aws-cfn-bootstrap awslogs jq
