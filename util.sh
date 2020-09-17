#!bin/sh

source $srcDir/libdebug.sh

echoHelp () {
  local argStr="$1" a
  local IFS="
"
  for a in $argStr ;do
    case $a in
      ARGS0@*)
        local argType argVar argPat argVal argDefault argDoc
        split "@" "$a" argType argVar argPat argVal argDefault argDoc
        printf "[%s]: sets %s=\"%s\" (default %s)\n    %s\n" "$argPat" "$argVar" "$argVal" "$argDefault" "$argDoc"
        ;;
      ARGS1@*)
        local argType argVar argPat argVal argDefault argDoc
        split "@" "$a" argType argVar argPat argVal argDefault argDoc
        printf "[%s]: sets %s=\"%s\" (default %s)\n    %s\n" $argPat $argVar $argVal $argDefault "$argDoc"
        ;;
      ARGSR@*)
        local argType argVar argPat argCom argDoc
        split "@" "$a" argType argVar argPat argCom argDoc
        printf "[%s]: runs \"%s\" \n    %s\n" "$argPat" "$argCom" "$argDoc"
        ;;
      HELP@*)
        local argType argPat argCom argDoc
        split "@" "$a" argType argPat argCom argDoc
        printf "[%s]:\n    %s\n" "$argPat" "$argDoc"
        ;;
    esac
  done
}

makeDefaults () {
  local argStr="$1" a
  local IFS="
"
  for a in $argStr ;do
    case $a in
      ARGS0@*)
        local argType argVar argPat argVal argDefault argDoc
        split "@" "$a" argType argVar argPat argVal argDefault argDoc
        printf "%s=\${%s:-%s}\n" $argVar $argVar $argDefault
        ;;
      ARGS1@*)
        local argType argVar argPat argVal argDefault argDoc
        split "@" "$a" argType argVar argPat argVal argDefault argDoc
        printf "%s=\${%s:-%s}\n" $argVar $argVar $argDefault
        ;;
    esac
  done
}

argParserCase () {
  local argStr="$1" key="$2"
  case $argStr in
    ARGS0@*)
      local argType argVar argPat argVal argDefault argDoc
      split "@" "$argStr" argType argVar argPat argVal argDefault argDoc
      printf "%s) %s=\"%s\" ;;\n" $argPat $argVar $argVal
      ;;
    ARGS1@*)
      local argType argVar argPat argVal argDefault argDoc
      split "@" "$argStr" argType argVar argPat argVal argDefault argDoc
      printf "%s) %s=\"%s\"; shift ;;\n" $argPat $argVar $argVal
      ;;
      ARGSR@*)
        local argType argVar argPat argCom argDoc
        split "@" "$a" argType argVar argPat argCom argDoc
        printf "%s) %s ;;\n" "$argPat" "$argCom"
        ;;
    HELP@*)
      local argType argPat argCom argDoc
      split "@" "$argStr" argType argPat argCom argDoc
      printf "%s) %s ; exit 0 ;;\n" "$argPat" 'echoHelp "$args"'
      ;;
    UNKNOWN@*)
      local argType argMsgs argName=$key argVal="\$$key"
      split "@" "$argStr" argType argMsgs
      printf "*) echo -e \"%s\"; exit 1 ;;\n" $(eval 'echo "'"$argMsgs"'"')
      ;;
  esac
}

getArgCase () {
  local key="$1"
  local flatargs=$(echo $args)
  buildCase () {
    local key="$1"
    local a
    local IFS="
"
    printf "case \$%s in\n" $key
    for a in $args ;do
      argParserCase "$a" "$key"
    done
    printf "esac\n"
  }
  buildCase $key
}


getArgs () {
  local args="$1" argKey=${2:-"argKeyVar"}
  printf "while [ \$# -gt 0 ];do\n \
  %s=\"\$1\"\n \
  shift\n \
  %s\n \
  done \n" $argKey "$(getArgCase "$argKey")"
}


split () {
  local dim=$1 val="$2"
  shift ; shift
  local i=0
  while [ $# -gt 0 ];do
    i=$(( $i + 1 ))
    local var=$1
    local fval="$(echo "$val" | cut -d $dim -f $i)"
    eval "$var=\$fval"
    shift
  done
}
