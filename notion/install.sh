#!/bin/sh

name=notion

source $srcDir/lib.sh

runCmd "ln $LNARGS -s $srcpath/ $installDir/.notion"
