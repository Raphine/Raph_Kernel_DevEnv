#!/bin/sh
test -f /etc/bootstrapped && exit

apt-get update
apt-get install -y git g++ make parted emacs language-pack-ja-base language-pack-ja kpartx gdb bridge-utils
update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"

# install qemu
apt-get install -y libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev
wget http://wiki.qemu-project.org/download/qemu-2.4.1.tar.bz2
tar xvf qemu-2.4.1.tar.bz2
mkdir build-qemu
cd build-qemu
../qemu-2.4.1/configure --target-list=x86_64-softmmu --disable-kvm --enable-debug
make
make install
cd ..

# setup bridge initialize script
sed -i -e 's/exit 0//g' /etc/rc.local
echo -e "ifconfig eth0 down\nifconfig eth0 up\nip addr flush dev eth0\nbrctl addbr br0\nbrctl stp br0 off\nbrctl setfd br0 0\nbrctl addif br0 eth0\nifconfig br0 up\ndhclient br0\nexit 0\n" >> /etc/rc.local

date > /etc/bootstrapped
