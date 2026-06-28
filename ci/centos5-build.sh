#!/bin/bash
set -e

cat > /etc/apt/sources.list << EOF
deb http://archive.debian.org/debian wheezy main
deb http://archive.debian.org/debian wheezy-lts main
deb http://archive.debian.org/debian-security wheezy/updates main
EOF

apt-get update || true
apt-get install -y --force-yes gcc

# --- build muon (already cloned on host into /work/muon) ---
cd /work/muon
LDFLAGS="-lrt" ./bootstrap.sh build
LDFLAGS="-lrt" build/muon-bootstrap setup -Dmeson-docs=disabled build
build/muon-bootstrap -C build samu
build/muon -C build install

# --- build your project (checked out at /work/project) ---
cd /work/project
muon build builddir
muon -C builddir test -v -v