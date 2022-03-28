#!/bin/bash

set -ex

git config pull.rebase true
git pull origin

if [ ! -d '../openwrt' ]; then
    cd ../
    git clone https://git.openwrt.org/openwrt/openwrt.git
    cd openwrt
else
    cd ../openwrt
    git config pull.rebase true
    git checkout master
    git pull origin
fi
./scripts/feeds update -a
./scripts/feeds install -a
cd ../openwrt-buildsetup

if [ -d '../openwrt/patches' ]; then rm -r '../openwrt/patches'; fi
if [ -d '../openwrt/files' ]; then rm -r '../openwrt/files'; fi
cp -p ./configs/config.buildinfo ../openwrt/.config
cp -rp ./patches ../openwrt/
cp -rp ./files ../openwrt/

cd ../openwrt
git am ./patches
make dirclean
make menuconfig
make defconfig
make download -j3
make -j3
cd ../openwrt-buildsetup