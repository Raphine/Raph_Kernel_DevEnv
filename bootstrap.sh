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
echo "ifconfig eth0 down" >> /etc/rc.local
echo "ifconfig eth0 up" >> /etc/rc.local
echo "ip addr flush dev eth0" >> /etc/rc.local
echo "brctl addbr br0" >> /etc/rc.local
echo "brctl stp br0 off" >> /etc/rc.local
echo "brctl setfd br0 0" >> /etc/rc.local
echo "brctl addif br0 eth0" >> /etc/rc.local
echo "ifconfig br0 up" >> /etc/rc.local
echo "dhclient br0" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
/etc/rc.local

date > /etc/bootstrapped
