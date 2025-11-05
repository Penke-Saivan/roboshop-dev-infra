#!/bin/bash
component=$1
dnf install ansible -y
ansible-pull -U "https://github.com/Penke-Saivan/ansible-roboshop-roles-Terraform.git" -e component=$component main.yaml

#how to copy a file from terraform to ec2