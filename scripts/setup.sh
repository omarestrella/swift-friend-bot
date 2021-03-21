#!/bin/sh

sudo apt update && sudo apt upgrade
sudo apt-get install -y libatomic1 \
    libcurl4 \
    libxml2 \
    libedit2 \
    libsqlite3-0 \
    libc6-dev \
    binutils \
    libgcc-5-dev \
    libstdc++-5-dev \
    zlib1g-dev \
    libpython2.7 \
    tzdata \
    git \
    pkg-config \
    libssl-dev \
    libssl1.0-dev \
    curl \
    libbsd0 \
    libatomic1 \
    sqlite3 \
    libsqlite3-dev
wget https://swift.org/builds/swift-5.3.3-release/ubuntu1804/swift-5.3.3-RELEASE/swift-5.3.3-RELEASE-ubuntu18.04.tar.gz
tar xzf swift-5.3.3-RELEASE-ubuntu18.04.tar.gz
rm -f swift-5.3.3-RELEASE-ubuntu18.04.tar.gz
mv swift-5.3.3-RELEASE-ubuntu18.04 swift-bin
echo "export PATH=`pwd`/swift-bin/usr/bin:$PATH" >> ~/.bashrc
source  ~/.bashrc
