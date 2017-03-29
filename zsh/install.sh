#!/bin/sh

echo "installing zsh dotfiles"

if [ "X$force" = "Xtrue" ]; then
LNARGS=-f
fi

srcpath=`pwd`

ln $LNARGS -s $srcpath/zshenv $HOME/.zshenv
ln $LNARGS -s $srcpath/zshrc $HOME/.zshrc
ln $LNARGS -s $srcpath/zshenv-local-${RMARCH} $HOME/.zshenv-local

