#!/bin/sh

srcDir=$(cd `dirname $0` && echo `pwd`)

source $srcDir/util.sh

args="$(cat <<- EOA
ARGS0@force@-f|--force@true@''@Force overwrire of files when installing
ARGSR@force@--unforce@unset force@Do not force overwrire of files when installing
ARGS1@userRoot@-u|--userRoot@\$1@\$HOME@Path to the users dotfiles at install time
ARGS1@userRootRun@-r|--userRootRun@\$1@\$userRoot@Path to the users dotfiles at run time
ARGS1@pkgs@-p|--pkgs@\$1@zsh vim misc@What pkgs to install\n    the pakages name are the name of the dir its in.
ARGS1@srcDirRun@-s|--srcDirRun@\$1@\$srcDir@path to where the config files are at runtime
ARGS1@binDir@-b|--binDir@\$1@\$HOME/bin@path to where script files are instelled
ARGS1@binDirRun@-B|--binDirRun@\$1@\$binDir@path to where script files are at runtime
ARGS0@dryRun@-y|--dryRun@true@''@echos commands insted of doing them
ARGS0@DEBUG@-d|--debug@true@''@echos commands insted of doing them
ARGS1@RMARCH@-a|--rmarch@\$1@''@What arch are we installing to?\nEg. diku fry netbsd nixos windows\nAre used to find zshenv-local-\${RMARCH} and _vimrc,\${RMARCH}\n\nNot all RMARCH's are surported for all pkgs.
HELP@-h|-?|/h|/?|--help@echoHelp "\$args"@Print help
UNKNOWN@Unknowen oprion: \$argVal (\$argName)\\nrun '\$0 --help' for help
EOA
)"

eval "$(getArgs "$args")"
eval "$(makeDefaults "$args")"

export srcDir srcDirRun userRoot userRootRun binDir binDirRun
export RMARCH force DEBUG dryRun
mkdir -p "$binDir" "$userRoot"

if [ "X${RMARCH}" = "X" ]; then
  echo "Error: No RMARCH"
  exit 2
fi

if [ "X$DEBUG" = "Xtrue" ]; then
  debugVar force
  debugVar dryRun
  debugVar srcDir
  debugVar userRoot
  debugVar userRootRun
  debugVar srcDirRun
  debugVar binDir
  debugVar binDirRun
  debugVar RMARCH
  debugVar pkgs
  (cd $srcDir/testpkg && ./install.sh)
fi

for pkg in $pkgs
do
  if [ "X$DEBUG" = "Xtrue" ]; then
    echo $pkg
  fi
  (cd $srcDir/$pkg && ./install.sh)
done
