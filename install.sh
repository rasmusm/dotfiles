#!/bin/sh

pkgToInstall="zsh"

for pkg in $pkgToInstall
do
    cd $pkg && ./install.sh
done
