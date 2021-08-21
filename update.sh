#!/bin/bash

function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) echo "Aborted" ; return  1 ;;
        esac
    done
}

if [ $UID -eq 0 ]; then
    echo "You can't run this script as root."
    exit
fi

ENDPOINT=https://github.com

REPOS=( ricelinux/riceman )

rm -rf build
rm -rf x86_64/*

mkdir build
cd build

for REPO_NUM in "${!REPOS[@]}"; do
    git clone $ENDPOINT/${REPOS[$REPO_NUM]} $REPO_NUM
    cd $REPO_NUM
    makepkg -s
    cp *.pkg.tar.gz ../../x86_64
    cd ../
done

cd ../x86_64

repo-add -n -R ricelinux.db.tar.gz *.pkg.tar.gz

yes_or_no "Do you want to push the changes to Github?" && git add -A && git commit -m "Updated packages" && git push
