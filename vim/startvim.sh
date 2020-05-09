#!/bin/sh

indent() { sed 's/^/  /'; }
debug() { if [[ -n "$DEBUG" ]]; then echo "$@"; fi }

startOnly() {
  ONLYSTARTVIM="true"
  ONLYRUNVIM=""
}

runOnly() {
  ONLYSTARTVIM=""
  ONLYRUNVIM="true"
}

guard() {
  local str="$1" msg="$2" retval=$3
  if [[ -n "$str" ]]; then
    echo "$msg"
    debug "The Argunents are '$FULLARGS'"
    debug "Servername='$SERVERNAME'"
    exit $retval
  fi
}

guardStart() {
  guard "$ONLYRUNVIM" "$1" -5
}

guardNoCMD() {
  guard "$VIMCMD" "$1" -7
}

guardRun() {
  guard "$ONLYSTARTVIM" "$1" -6
}

FULLARGS=$@

if [[ "$1" == "@D" ]]; then
  DEBUG="true"
  shift
fi
if [[ "$1" == "@R" ]]; then
  guardRun "Can't use $1 with start only"
  runOnly
  shift
else
  if [[ "$1" == "@S" ]]; then
    guardStart "Can't use $1 with run only"
    startOnly
    shift
  fi
fi

case "$1" in
  "@USE")
    VIMSERVER_TOUSE=$2
    shift
    shift
    ;;
  "@RUN")
    VIMSERVER_TOUSE=$2
    guardRun "Can't use $1 with start only"
    runOnly
    shift
    shift
    ;;
  "@START")
    VIMSERVER_TOUSE=$2
    guardStart "Can't use $1 with run only"
    startOnly
    shift
    shift
    ;;
esac

SERVERNAME=${VIMSERVER_TOUSE:-edit}

REMOTEVIMCMD=${REMOTEVIMCMD:-"--remote"}

if [[ "$1" == "@--" ]]; then
    REMOTEVIMCMD=""
    shift
else
  if [[ "$1" == "@CMD" ]]; then
    guardRun "Can't use $1 with start only"
    runOnly
    REMOTEVIMCMD="--remote-expr"
    shift
    VIMCMD="execute('$@')"
  fi
fi

srvs=`gvim --serverlist`
if [[ -z "$(echo "$srvs" | grep -i $SERVERNAME)" ]]; then
  guardNoCMD "$(
    printf "%s\n\n%s\n%s\n"\
      "Can't start vim new server with Command"\
      "The servers are:"\
      "$(echo "$srvs" | indent)"
    )"
  guardStart "$(
    printf "%s\n\n%s\n%s\n"\
      "Vim server '$SERVERNAME' are not running and run only are set!"\
      "The servers are:"\
      "$(echo "$srvs" | indent)"
    )"
  debug gvim --servername $SERVERNAME $@
  gvim --servername $SERVERNAME $@
else
  if [[ -n "$ONLYSTARTVIM" ]]; then
    echo "Vim server '$SERVERNAME' are running!"
    exit -1
  fi
  CMD="${VIMCMD:-$@}"
  if [[ -z "$CMD" ]]; then 
    echo "Missing arguments for remote command"
    debug "The Argunents are '$FULLARGS'"
    debug "Servername='$SERVERNAME'"
    debug "CMD='$CMD'"
    exit -5
  fi

  debug vim --servername $SERVERNAME $REMOTEVIMCMD "$CMD"
  vim --servername $SERVERNAME $REMOTEVIMCMD "$CMD"
fi
