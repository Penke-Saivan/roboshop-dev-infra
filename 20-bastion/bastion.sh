#!/bin/bash
set -e



echo "=== Starting libsnoopy preload fix ==="

# Disable libsnoopy preload if present
if [ -f /etc/ld.so.preload ]; then
    cp /etc/ld.so.preload /root/ld.so.preload.bak 2>/dev/null || true
    sed -i '/libsnoopy/d' /etc/ld.so.preload || true

    # If file becomes empty, disable it
    if [ ! -s /etc/ld.so.preload ]; then
        mv /etc/ld.so.preload /etc/ld.so.preload.disabled 2>/dev/null || true
    fi
fi

# Create backup directory (idempotent)
mkdir -p /root/syslib-backup

# Move any libsnoopy files (from any location) into backup
for f in /usr/local/lib/libsnoopy* /lib/libsnoopy* /lib64/libsnoopy*; do
    if [ -e "$f" ]; then
        mv "$f" /root/syslib-backup/ 2>/dev/null || true
    fi
done

# Refresh linker cache
ldconfig || true

# Restart SSH daemon
systemctl restart sshd || true

echo "=== libsnoopy fix completed ==="




echo "=== Expanding home volume ==="
growpart /dev/nvme0n1 4
lvextend -L +30G /dev/mapper/RootVG-homeVol
xfs_growfs /home

echo "=== Installing Terraform ==="
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform

echo "=== Bastion bootstrap completed successfully ===" > /var/log/bastion-userdata.log



