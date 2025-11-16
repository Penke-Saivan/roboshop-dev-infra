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

echo "=== Bastion bootstrap starting ==="

############################################
# 1. FIX LIBSNOOPY + OPENSSL MISMATCH ISSUE
############################################

cat <<'EOF' > /root/fix_openssl_snoopy.sh
#!/bin/bash
set -euo pipefail

echo "=== Starting OpenSSL/libsnoopy fix ==="

# 1. Backup preload file
if [ -f /etc/ld.so.preload ]; then
    echo "[+] Backing up /etc/ld.so.preload to /root/ld.so.preload.bak"
    cp /etc/ld.so.preload /root/ld.so.preload.bak 2>/dev/null || true
fi

# 2. Remove libsnoopy lines
if [ -f /etc/ld.so.preload ]; then
    sed -i '/libsnoopy/d' /etc/ld.so.preload || true
    # If file becomes empty, disable it
    if [ ! -s /etc/ld.so.preload ]; then
        mv /etc/ld.so.preload /etc/ld.so.preload.disabled 2>/dev/null || true
    fi
fi

# 3. Move libsnoopy libraries to a safe backup directory
mkdir -p /root/syslib-backup
for f in /usr/local/lib/libsnoopy*; do
    [ -e "$f" ] && mv "$f" /root/syslib-backup/ 2>/dev/null || true
done

# 4. Clean any remaining snoopy links/files
rm -f /usr/local/lib/libsnoopy.so \
      /usr/local/lib/libsnoopy.so.* \
      /usr/local/lib/libsnoopy.la 2>/dev/null || true

# 5. Refresh dynamic linker cache
ldconfig || true

# 6. Restart SSH daemon
systemctl restart sshd || true

echo "=== libsnoopy/openssl fix completed ==="
EOF

chmod +x /root/fix_openssl_snoopy.sh
bash /root/fix_openssl_snoopy.sh > /var/log/bastion-fix.log 2>&1

echo "=== libsnoopy fix executed (log: /var/log/bastion-fix.log) ==="


############################################
# 2.  EXISTING BASTION SETUP
############################################

echo "=== Expanding home volume ==="
sudo growpart /dev/nvme0n1 4
sudo lvextend -L +30G /dev/mapper/RootVG-homeVol
sudo xfs_growfs /home

echo "=== Installing Terraform ==="
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform

# echo "=== Cloning roboshop infra ==="
# cd /home/ec2-user
# git clone  https://github.com/Penke-Saivan/roboshop-dev-infra.git
# chown ec2-user:ec2-user -R roboshop-dev-infra

# echo "=== Running database Terraform ==="
# cd roboshop-dev-infra/40-databases
# terraform init
# terraform apply -auto-approve

# echo "=== Bastion setup complete ==="
