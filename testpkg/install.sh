#!/bin/sh

echo "==> test dotfiles <=="

source $srcDir/lib.sh

if [ "X$force" = "Xtrue" ]; then
  echo "force: true"
else 
  echo "force: false"
fi

debugVar force
debugVar dryRun
debugVar srcDir
debugVar userRoot
debugVar userRootRun
debugVar srcDirRun
debugVar RMARCH
