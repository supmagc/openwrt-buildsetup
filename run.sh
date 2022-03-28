#!/bin/bash

set -x

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
make dirclean
./scripts/feeds update -a
./scripts/feeds install -a
cd ../openwrt-buildsetup

rm -r ../openwrt/patches
rm -r ../openwrt/files
cp -p ./configs/config.buildinfo ../openwrt/.config
cp -rp ./patches ../openwrt/
cp -rp ./files ../openwrt/

cd ../openwrt
git am
make menuconfig
make defconfig
make download -j3
make -j3
cd ../openwrt-buildsetup