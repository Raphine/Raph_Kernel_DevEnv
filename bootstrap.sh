#!/bin/sh
test -f /etc/bootstrapped && exit

#sudo apt-get update
sudo apt-get install -y git g++ make parted emacs language-pack-ja-base language-pack-ja kpartx qemu
sudo update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
date > /etc/bootstrapped
