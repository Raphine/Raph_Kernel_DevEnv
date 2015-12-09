#!/bin/sh
test -f /etc/bootstrapped && exit

#sudo apt-get update
sudo apt-get install -y git g++ make parted emacs language-pack-ja-base language-pack-ja kpartx
sudo update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"

# install qemu
sudo apt-get install -y libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev
wget http://wiki.qemu-project.org/download/qemu-2.4.1.tar.bz2
tar xvf qemu-2.4.1.tar.bz2
mkdir build-qemu
cd build-qemu
../qemu-2.4.1/configure --target-list=x86_64-softmmu --disable-kvm --enable-debug
make
sudo make install
cd ..

date > /etc/bootstrapped

