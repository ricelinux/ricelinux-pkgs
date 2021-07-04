#!/bin/bash


REPOS=( https://github.com/ricelinux/riceman )

rm -rf build
rm -rf x86_64/*.pkg.tar.zst

mkdir build
cd build

for REPO_NUM in "${!REPOS[@]}"; do
    git clone ${REPOS[$REPO_NUM]} $REPO_NUM
    cd $REPO_NUM
    makepkg -s
    cp *.pkg.tar.zst ../../x86_64
    cd ../
done

cd ../x86_64

repo-add -n -R ricelinux.db.tar.gz *.pkg.tar.zst