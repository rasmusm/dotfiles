#!/bin/sh

name=vim

source $srcDir/lib.sh

archFilter="\
    linux|*bsd*)linux\
    nixos*)nixos\
    win*)windows\
"

findArchInstallUserRoot "_vimrc." ".vimrc"

debugVar temparch

installBin "startvim.sh" "startvim"
installBin "startvim.sh" "edit"
ifTempArchDo "nixos" 'runCmd "$srcDir/$name/plugins.sh -j > $srcDir/$name/plugins.json"'
