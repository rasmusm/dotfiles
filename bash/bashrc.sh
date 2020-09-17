export PATH=$PATH:~/bin
export RMARCH=__RMARCH__

# Prompt {{{
GIT_PROMPT_ONLY_IN_REPO=0
GIT_PROMPT_THEME_FILE=__RUNDIR__/bash/gitprompt.bgptheme
GIT_PROMPT_THEME="Custom"
source __RUNDIR__/../bash-git-prompt/gitprompt.sh


setvim () {
  export VIMSERVER_TOUSE="$1"
}

vimvar () {
  if [[ "$1" = "-v" ]]; then
    echo "VIMSERVER_TOUSE='$VIMSERVER_TOUSE'"
  else
    echo "$VIMSERVER_TOUSE"
  fi
}

setVimPrompt () {
  local prompt=""
  if [[ -n "$VIMSERVER_TOUSE" ]]; then
    prompt=" [vim:$VIMSERVER_TOUSE]"
  fi
  PS1=${PS1/__GitVimPrompt__/"$prompt"}
}

setNixosPrompt () {
  local prompt="" result="" defaultnix="" shellnix=""
  local pa=()
  if [[ -e ./shell.nix ]]; then
    pa+=("${BoldMagenta}s${ResetColor}")
  fi
  if [[ -e ./default.nix ]]; then
    pa+=("${BoldMagenta}d${ResetColor}")
  fi
  if [[ -h ./result ]];  then
    pa+=("${Blue}r${ResetColor}")
  fi
  if [[ ${#pa[@]} -eq 0 ]]; then
    prompt=""
  else
    prompt=" [$(IFS=: ; echo "${pa[*]}")]"
  fi
  PS1=${PS1/__NixosPrompt__/"$prompt"}
}

PROMPT_COMMAND="$PROMPT_COMMAND;setVimPrompt;setNixosPrompt"
# end Prompt }}}
