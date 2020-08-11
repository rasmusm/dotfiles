#!/bin/sh

name=misc

source $srcDir/lib.sh

installUserRoot screenrc .screenrc
installUserRoot tmux.conf .tmux.conf
installUserRoot gitconfig .gitconfig
