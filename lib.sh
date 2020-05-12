#!/bin/sh

echo " === installing $name dotfiles ==="
LN="ln -sn"

source $srcDir/util.sh

printError () {
  echo -e "$1" > /dev/stderr
  return 1
}

runCmd () {
  if [ "X$dryRun" = "Xtrue" ]; then
    echo "--> dryrun: $1"
  else
    echo "--> run: $1"
    eval "$1"
  fi
}

linkFile () {
  runCmd "$LN $LNARGS $1 $2"
}

installBin () {
  linkFile $srcpath/$1 $binDirRun/$2
}

installUserRoot () {
  linkFile $srcpath/$1 $userRootRun/$2
}

ifTempArchDo () {
  local arch="$1" t="$2"
  if [[ "$arch" == "$temparch" ]]; then
    eval "$t"
  fi
}

ifTempArch () {
  local t=${1:-true} f="${2:-false}" arch="${3:-""}"
  echo "$arch"
  if [[ -z "$arch" && "X$temparch" != "X$arch" ]]; then
    eval "$t"
  else
    eval "$f"
  fi
}

testTempArch () {
  ifTempArch true 'printError "-+++ Error: no \$temparch: RMARCH=\"${RMARCH}\""' ""
}

ifFile () {
  local file=$1 t=${2:-true} f=${3:-false}
  if [[ -e "$srcDir/$name/$file" ]]; then
    eval "$t"
  else
    eval "$f"
  fi
}

testTempArchFile () {
  local file="$1$temparch" filename=$1${RMARCH}
  ifFile $file true 'printError "++++ Error: no $filename found: RMARCH=${RMARCH} temparch=\"${temparch}\"" ++++ \n echo test'
}

ifArchAndFileInstallUserRoot () {
  local pre=$1 file="$1$temparch" target=$2 filename=$1${RMARCH}
  testTempArch && testTempArchFile $pre && installUserRoot $file $target
}

buildFilter () {
  local filter=$1 com=$2
  for f in $filter; do
    split ")" $f p a
    echo "$p ) $com $a ;;"
  done
}

findArch () {
  eval "\
    case $RMARCH in \
      $(buildFilter "$archFilter" echo) \
    esac \
   "
}
  
findArchInstallUserRoot () {
  local preName=$1 file=$1${RMARCH} target=$2

  ifFile $file temparch=${RMARCH} temparch=$(findArch)

  debugprint "$(buildFilter $archFilter echo)"
  debugVar temparch
  ifArchAndFileInstallUserRoot $preName $target
}

if [ "X$force" = "Xtrue" ]; then
LNARGS=-f
fi

srcpath=$srcDirRun/$name

debugVar LNARGS
debugVar srcpath

temparch=""

