#!/bin/sh
using="${vimPkgs:-vim-nix vim-pandoc-syntax nerdtree nerdtree-git-plugin vimwiki vim-pandoc}"
#using="vim-nix"

vim_nix_Start="start"
vim_nix_URL="https://github.com/LnL7/vim-nix.git"

nerdtree_Start="start"
nerdtree_URL="https://github.com/preservim/nerdtree.git"

nerdtree_git_plugin_Start="start"
nerdtree_git_plugin_URL="https://github.com/Xuyuanp/nerdtree-git-plugin.git"

vimwiki_Start="start"
vimwiki_URL="https://github.com/vimwiki/vimwiki.git"

vim_pandoc_Start="start"
vim_pandoc_URL="https://github.com/vim-pandoc/vim-pandoc.git"

vim_pandoc_syntax_Start="start"
vim_pandoc_syntax_URL="https://github.com/vim-pandoc/vim-pandoc-syntax.git"

vimPlugDir="${vimPlugDir:-"$(cd `dirname $0` && echo `pwd`)/plugs"}"
mkdir -p "$vimPlugDir"

logFile=${logFile:-$vimPlugDir/install.log}
errFile=${errFile:-$vimPlugDir/install-err.log}

logInit="${logInit:-echo "debug LOG for $0 at $(date):" > $logFile}"
errInit="${errInit:-echo "error LOG for $0 at $(date):" > $errFile}"

logPostfix="${LOG:->> $logFile}"
errPostfix="${ERR:->> $errFile}"

LOG=0
ERR=1

NEWLINE="
"

initLog () {
 eval $logInit
 eval $errInit
}

log () {
  local retStr="$1" retVal="${2:-$LOG}" prefix="${3:-""}"
  echo
  if [[ "x$retVal" == "x0" ]]; then
    local IFS=$NEWLINE
    for line in $retStr; do
      eval echo \'$(echo "$prefix${line}")\'" $logPostfix"
    done
  else
    local IFS=$NEWLINE
    for line in $retStr; do
      eval echo \'$(echo "$prefix${line}")\'" $errPostfix"
    done
  fi
}
getAttr () {
  local plug="${1//-/_}" att="$2"
  eval "echo \$${plug//-/_}_$att"
}

makeUrls () {
  local urls="" plug
  for plug in $using; do
    local url=""
    url=$(getAttr $plug "URL")
    if [[ -z "$url" ]]; then
      printf "Warrning: No url for %s\n" "$plug" > /dev/stderr
    else
      printf "%s|%s\n" "$url" "$plug"
    fi
  done
}

installPlug () {

  local url="$1" plug="$2" dir="$vimPlugDir/$plug"
  local cmd="git clone $url $dir"
  printf "command: '%s'\n" "$cmd"
  if [[ -e "$dir" ]]; then
      printf "Warning: Dir exist for %s dir: %s\n" "$plug" "$dir" > /dev/stderr
  else
    r="`$cmd 2>&1`"
    ret="$?"
    log "installing $cmd" $ret
    log "$r" $ret "-> "
  fi

}

installPlugs () {
  local url plug pair
  for pair in $(makeUrls);do
    echo "$pair" | while IFS="|" read url plug; do
      installPlug $url $plug
    done
  done
}

makePluginJSON () {
  local start="" opt="" plug
  for plug in $using; do
    local varset="" starttype
    starttype=$(getAttr ${plug} "Start")
    if [[ "X$starttype" != "Xstart" && "X$starttype" != "Xopt" ]]; then
      printf "Warrning: Not support start type %s for %s\n" "$starttype" "$plug"
    fi
    if [[ -z "$(eval "echo \$${starttype}")" ]]; then
      eval $(printf '%s="%s"' "${starttype}" '\"${plug}\"')
    else
      eval $(printf '%s="$%s, %s"' "${starttype}" "${starttype}"  '\"${plug}\"')
    fi
  done
  printf '{
      "plugins" : {
        "start" : [%s],
        "opt" : [%s]
      }
    }' "$start" "$opt"
}

initLog

while [ $# -gt 0 ]; do
  case $1 in
    -i|--installPlugs)
      installPlugs
      break;;
    -j|--json)
      makePluginJSON
      break;;
    -p|--pkgs)
      using="$2";shift ;;
    *)
      echo "Error: Unknown arg- $1"
      exit 1;
  esac
  shift;
done
