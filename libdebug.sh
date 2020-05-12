debugPost=${debugPost:-""}
debugprint () {
  if [ "X$DEBUG" = "Xtrue" ]; then  
    echo $1 $debugPost
  fi
}

debugVar () {
  if [ "X$DEBUG" = "Xtrue" ]; then  
    eval "var=\$$1"
    echo "$1: '$var'"
  fi
}
