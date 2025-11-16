#!/bin/bash

component=$1
environment=$2
dnf install ansible -y 
#REMOTE-EXEC SCRIPT
sudo mkdir -p /etc/ansible

sudo tee /etc/ansible/ansible.cfg > /dev/null << 'EOF'
[defaults]
transport = ssh

[ssh_connection]
ssh_args =
ssh_executable = /usr/bin/ssh
pipelining = True
EOF

# ansible-pull -U "https://github.com/Penke-Saivan/ansible-roboshop-roles-Terraform.git" -e component=$component main.yaml

#how to copy a file from terraform to ec2

REPO_URL=https://github.com/Penke-Saivan/ansible-roboshop-roles-Terraform.git
REPO_DIR=/opt/roboshop/ansible
ANSIBLE_DIR=ansible-roboshop-roles-Terraform

mkdir -p $REPO_DIR
mkdir -p /var/log/roboshop/

# touch ansible.log

cd $REPO_DIR

if [ -d $ANSIBLE_DIR ]; then
#check if repo already exists
    cd $ANSIBLE_DIR
    git pull

else

    git clone $REPO_URL
    cd $ANSIBLE_DIR

fi

echo "Component: $component | Environment: $environment"

echo "-------------------------------------environment is $2"
ansible-playbook -e component=$component -e envir=$environment main.yaml

