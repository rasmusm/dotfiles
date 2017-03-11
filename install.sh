#!/bin/sh

pkgToInstall="zsh vim misc"

for pkg in $pkgToInstall
do
    (cd $pkg && ./install.sh)
done
