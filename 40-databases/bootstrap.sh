#!/bin/bash
component=$1
environment=$2
# dnf install ansible -y
# ansible-pull -U "https://github.com/Penke-Saivan/ansible-roboshop-roles-Terraform.git" -e component=$component main.yaml

echo "=== Fixing OpenSSL mismatch ==="
dnf install -y openssl openssl-libs openssh openssh-server openssh-clients || true
dnf install -y python3-devel gcc || true

echo "=== Installing Ansible ==="
dnf install ansible -y

#how to copy a file from terraform to ec2

REPO_URL=https://github.com/Penke-Saivan/ansible-roboshop-roles-Terraform.git
REPO_DIR=/opt/roboshop/ansible
ANSIBLE_DIR=ansible-roboshop-roles-Terraform

mkdir -p $REPO_DIR
mkdir -p /var/log/roboshop/

touch ansible.log

cd $REPO_DIR

if [ -d $ANSIBLE_DIR ]; then
#check if repo already exists
    cd $ANSIBLE_DIR
    git pull

else

    git clone $REPO_URL
    cd $ANSIBLE_DIR

fi
echo "environment is $2"
echo "=== Creating dynamic inventory for component ${component} ==="

cat <<EOF > inventory.ini
[${component}]
localhost

[all:vars]
ansible_connection=local
ansible_python_interpreter=/usr/bin/python3
EOF


echo "-------------------------------------environment is $2"
echo "-++++++++++++++++component is $1-------------------------------------------------------------"
ansible-playbook -e component=$component -e envir=$environment main.yaml

