#!/bin/sh

pkgToInstall="zsh vim"

for pkg in $pkgToInstall
do
    (cd $pkg && ./install.sh)
done
