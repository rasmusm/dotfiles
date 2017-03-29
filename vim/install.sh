#!/bin/sh

echo "installing vim dotfiles"

if [ "X$force" = "Xtrue" ]; then
LNARGS=-f
fi

srcpath=`pwd`

temparch=linux

case ${RMARCH} in
    linux|*bsd)
        temparch=linux
        ;;
    *)
        temparch=${RMARCH}
        ;;
esac        

ln $LNARGS -s $srcpath/_vimrc.${temparch} $HOME/.vimrc
