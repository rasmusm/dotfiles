#!/bin/sh

name=bash

source $srcDir/lib.sh

runCmd "sed -e 's|__RUNDIR__|$srcDirRun|' \
            -e 's|__RMARCH__|$RMARCH|' \
            $srcDir/$name/bashrc.sh \
            > $srcDir/$name/bashrc.out.sh"
installUserRoot bashrc.out.sh .bashrc
installUserRoot bashrc.out.sh .bash_profile
