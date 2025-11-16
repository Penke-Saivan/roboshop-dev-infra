#!/bin/bash
set -e
component=$1
environment=$2
dnf install ansible -y git python3-pip gcc python3-devel
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

# --- CRITICAL: OVERRIDE ansible.cfg to force system SSH ---
cat > ansible.cfg <<'EOF'
[defaults]
transport = ssh
inventory = ./inventory.ini
host_key_checking = False
roles_path = ./roles

[ssh_connection]
ssh_args = -C -o ControlMaster=auto -o ControlPersist=60s
pipelining = True
EOF

echo "=== ansible.cfg overridden to use system SSH (no Paramiko) ==="

echo "=== Running Ansible Playbook ==="
echo "Component: $component | Environment: $environment"

echo "environment is $2"
echo "=== Testing connectivity ====================================================================="
ansible all -m ping -vvv
ansible-playbook -e component=$component -e envir=$environment main.yaml

