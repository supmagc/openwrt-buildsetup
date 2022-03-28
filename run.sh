#!/bin/bash

if [! -d '../openwrt']; then
    cd ../
    git clone https://git.openwrt.org/openwrt/openwrt.git
    cd openwrt
else
    cd ../openwrt
    git checkout master
    git pull origin
fi
make dirclean
./scripts/feeds update -a
./scripts/feeds install -a
cd ../openwrt-buildtools

rm ../openwrt/patches
rm ../openwrt/files
cp ./configs/config.buildinfo ../openwrt/.config
cp ./patches ../openwrt/
cp ./files ../openwrt/

cd ../openwrt
git am
make menuconfig
make defconfig
make download -j3
make -j3
cd ../openwrt-buildtools