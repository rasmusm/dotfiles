#!/bin/sh

name=zsh

source $srcDir/lib.sh

archFilter="\
    *linux*|*bsd*)linux\
    nixos*)nixos\
"

findArchInstallUserRoot "zshenv-local-" ".zshenv-local"

debugVar temparch

installUserRoot zshenv .zshenv
installUserRoot zshrc .zshrc

