#!/bin/bash
set -e

# See: https://www.howtoforge.com/using-old-debian-versions-in-your-sources.list
cat > /etc/apt/sources.list << EOF
deb http://archive.debian.org/debian/ wheezy main non-free contrib
deb-src http://archive.debian.org/debian/ wheezy main non-free contrib

deb http://archive.debian.org/debian-security/ wheezy/updates main non-free contrib
deb-src http://archive.debian.org/debian-security/ wheezy/updates main non-free contrib
EOF

apt-get update || true
apt-get install -y --force-yes gcc

# Build muon
cd /work/muon
# To know why "-lrt" is needed, see: https://github.com/muon-build/muon/issues/268
LDFLAGS="-lrt" ./bootstrap.sh build
LDFLAGS="-lrt" build/muon-bootstrap setup -Dmeson-docs=disabled build
build/muon-bootstrap -C build samu
build/muon -C build install

# Build pkgconf + run tests
cd /work/pkgconf
muon build builddir
muon -C builddir test -v -v