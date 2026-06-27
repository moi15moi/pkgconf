#!/bin/bash
set -e

# --- yum: point at the plain-HTTP CERN vault mirror (no TLS handshake) ---
rm -f /etc/yum.repos.d/*
cat > /etc/yum.repos.d/CentOS-Vault.repo << 'EOF'
[base]
name=CentOS-5.11 - Base
baseurl=http://linuxsoft.cern.ch/centos-vault/5.11/os/$basearch/
gpgcheck=0
enabled=1

[updates]
name=CentOS-5.11 - Updates
baseurl=http://linuxsoft.cern.ch/centos-vault/5.11/updates/$basearch/
gpgcheck=0
enabled=1

[extras]
name=CentOS-5.11 - Extras
baseurl=http://linuxsoft.cern.ch/centos-vault/5.11/extras/$basearch/
gpgcheck=0
enabled=1
EOF
# Force timeouts so a stalled mirror errors instead of hanging forever
echo "timeout=30" >> /etc/yum.conf
echo "retries=2"  >> /etc/yum.conf
echo "http_caching=none" >> /etc/yum.conf
# Only 64-bit packages — avoids i386/x86_64 multilib conflicts
echo "exclude=*.i?86" >> /etc/yum.conf


# --- toolchain ---
yum install -y --nogpgcheck gcc

# --- build muon (already cloned on host into /work/muon) ---
cd /work/muon
./bootstrap.sh build
build/muon-bootstrap setup -Dmeson-docs=disabled build
build/muon-bootstrap -C build samu
build/muon -C build install

# --- build your project (checked out at /work/project) ---
muon build builddir
muon -C builddir test -v -v