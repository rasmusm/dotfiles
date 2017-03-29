#!/bin/sh

pkgToInstall="zsh vimi misc"

for pkg in $pkgToInstall
do
    (cd $pkg && ./install.sh)
done
