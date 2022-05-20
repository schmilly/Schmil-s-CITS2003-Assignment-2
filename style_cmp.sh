#!/bin/bash

#checking to see that input does exit, if not print error message

#usage text, output when needed.
Usage = "Usage: style_cmp.sh [ <directory of file to create profile off of> | <directory of file to analyze> <directory of profile> ]"

#toggles based on existancr of second paramters
profilemode=1

#checks of inouts to ensure existance of inputs
if [[ -z "$1" ]]; then
  1>&2 echo "Please specify an argument, non detected"
  echo $Usage
  exit
elif [[ ! -f $1 ]]
then
  1>%2 echo "Could not find specified file $1"
  echo $Usage
  exit 1
elif [[ -z "$2" ]]; then
  $profilemode=0
  if [[ ! -f $2 ]]; then
    1>&2 echo "Could not find specified file $2"
    echo $Usage
    exit 1
  fi
fi

#array of words to use, can be changed (obvi)
wordarray = ("also" "although" "and" "as" "because" "before" "but" "for" "if" "nor" "of" "or" "since" "that" "though" "until" "when" "whenever" "whereas" "which" "while" "yet")
