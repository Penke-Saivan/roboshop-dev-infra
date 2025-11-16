# #!/bin/bash
# sudo growpart /dev/nvme0n1 4
# sudo lvextend -L +30G /dev/mapper/RootVG-homeVol
# sudo xfs_growfs /home

# sudo yum install -y yum-utils
# sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
# sudo yum -y install terraform

# # creating databases
# cd /home/ec2-user
# git clone https://github.com/Penke-Saivan/roboshop-dev-infra.git
# chown ec2-user:ec2-user -R roboshop-dev-infra
# cd roboshop-dev-infra/40-databases
# terraform init
# terraform apply -auto-approve

#!/bin/bash
set -euo pipefail

echo "=== Starting Bastion libsnoopy/OpenSSL fix ==="

# Create log file
LOG_FILE="/var/log/bastion-fix.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "[1/5] Backing up /etc/ld.so.preload (if exists)..."
if [ -f /etc/ld.so.preload ]; then
    cp /etc/ld.so.preload /root/ld.so.preload.bak || true
else
    echo "No preload file found (OK)."
fi

echo "[2/5] Removing libsnoopy entries from preload..."
if [ -f /etc/ld.so.preload ]; then
    sed -i '/libsnoopy/d' /etc/ld.so.preload || true

    # Disable the preload file if it becomes empty
    if [ ! -s /etc/ld.so.preload ]; then
        mv /etc/ld.so.preload /etc/ld.so.preload.disabled || true
        echo "Preload file was empty → disabled."
    fi
else
    echo "Nothing to clean (preload disabled already)."
fi

echo "[3/5] Moving libsnoopy libraries to backup directory..."
mkdir -p /root/syslib-backup
for f in /usr/local/lib/libsnoopy*; do
    if [ -e "$f" ]; then
        mv "$f" /root/syslib-backup/ || true
    fi
done

echo "[4/5] Refreshing dynamic linker cache..."
ldconfig || true

echo "[5/5] Restarting SSH daemon..."
systemctl restart sshd || true

echo "=== libsnoopy/OpenSSL fix completed successfully ==="
echo "Log stored at: $LOG_FILE"



############################################
# 2. NORMAL BASTION SETUP
############################################

echo "=== Expanding home volume ==="
growpart /dev/nvme0n1 4
lvextend -L +30G /dev/mapper/RootVG-homeVol
xfs_growfs /home

echo "=== Installing Terraform ==="
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform

echo "=== Bastion bootstrap completed successfully ==="


# echo "=== Cloning roboshop infra ==="
# cd /home/ec2-user
# git clone  https://github.com/Penke-Saivan/roboshop-dev-infra.git
# chown ec2-user:ec2-user -R roboshop-dev-infra

# echo "=== Running database Terraform ==="
# cd roboshop-dev-infra/40-databases
# terraform init
# terraform apply -auto-approve

# echo "=== Bastion setup complete ==="
