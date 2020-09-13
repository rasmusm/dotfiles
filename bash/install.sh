#!/bin/sh

name=bash

source $srcDir/lib.sh

runCmd "sed -e 's|__RUNDIR__|$srcDirRun|' $srcDir/$name/bashrc.sh > $srcDir/$name/bashrc.out"
installUserRoot bashrc.out .bashrc
