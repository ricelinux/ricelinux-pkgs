#!/bin/bash

if [ $UID -eq 0 ]; then
    echo "You can't run this script as root."
    exit
fi

ENDPOINT=https://raw.githubusercontent.com/

REPOS=( ricelinux/riceman )

rm -rf build
rm -rf x86_64/*

mkdir build
cd build

for REPO_NUM in "${!REPOS[@]}"; do
    mkdir $REPO_NUM
    cd $REPO_NUM
    wget https://raw.githubusercontent.com/${REPOS[$REPO_NUM]}/master/PKGBUILD
    
    makepkg -s
    cp *.pkg.tar.zst ../../x86_64
    cd ../
done

cd ../x86_64

repo-add -n -R ricelinux.db.tar.gz *.pkg.tar.zst