#!/bin/sh

echo "installing misc dotfiles"

if [ "X$force" = "Xtrue" ]; then
LNARGS=-f
fi

srcpath=`pwd`

ln $LNARGS -s $srcpath/screenrc $HOME/.screenrc

