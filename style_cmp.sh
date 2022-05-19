#!/bin/bash

#checking to see that input does exit, if not print error message

Usage = "Usage: style_cmp.sh [ <directory of file to create profile off of> | <directory of file to analyze> <directory of profile> ]"

if [[ -z "$1" ]]; then
  1>&2 echo "Please specify an argument, non detected"
  exit
elif [[ ! -f $1 ]]
then
  1>%2 echo "Could not find specified file $1"
  exit 1
elif [[ -z "$2" ]]; then
  if [[ ! -f $2 ]]; then
    1>&2 echo "Could not find specified file $2"
    exit 1
  fi
fi
