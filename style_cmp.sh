#!/bin/bash

#By: William van den Wall Bake, Student Number 23086983

#checking to see that input does exit, if not print error message
debug=0
#usage text, output when needed.
Usage="Usage: style_cmp.sh [ <directory of file to create profile off of> | <directory of file to analyze> <directory of profile> ]"

#Specified words for the profile to look for, and compund words
Wordarray=("also" "although" "and" "as" "because" "before" "but" "for" "if" "nor" "of" "or" "since" "that" "though" "until" "when" "whenever" "whereas" "which" "while" "yet")


#toggles based on existance of second paramter
profilemode=1

#Functions--Bunch of Functions so we don't have to keep reusing code
#commaNum () {
#  return $(grep -o -i , $1 | wc -l) 
#}




#checks of inouts to ensure existance of inputs
if [[ -z $1 ]]; then
  1>&2 echo "Please specify an file location, none detected"
  echo $Usage
  exit
elif [[ ! -f $1 ]]; then
  1>&2 echo "Could not find specified file $1"
  echo $Usage
  exit 1
elif [[ ! -z $2 ]]; then
  if [[ ! -f $2 ]]; then
    1>&2 echo "Could not find specified file $2"
    echo $Usage
    exit 1
  fi
  profilemode=0
  echo "Two specified files detected, entering analysis mode..."
else
  echo "Only One specified file detected, entering profile genration mode..."
fi


if [ $profilemode == 1 ]; then
  echo "Profilemode running..."

  
  #Gets rid of file so we can reset profile, useful in debugging and making sure clean fies
  echo "" > $1_profile.txt

  for i in "${Wordarray[@]}"; do

  #command gets rid of punctuation for word counts
    count=$(cat $1 | awk '{print tolower($0)}'| sed 's/--/ /g' | sed 's/[.,:;]//g' | tr -d '-' | grep -i -o -w $i | wc -l)
    echo "$i $count" >> $1_profile.txt

  done


  comma=$(grep -o -i , $1 | wc -l)
  echo "comma $comma" >> $1_profile.txt

  semi=$(grep -o -i \; $1 | wc -l)
  echo "semi_colon $semi" >> $1_profile.txt

  wordC=$(cat $1 | awk '{print tolower($0)}' | sed 's/--/ /g' | sed 's/[.,:;-]//g' | wc -w)
  echo "word $wordC" >> $1_profile.txt

  senten=$(cat $1 | awk '{print tolower($0)}' | sed 's/--/ /g' | grep -i -o \[\.\?\!] | wc -l) 
  echo "sentence $senten" >> $1_profile.txt
 
  declare -a textArray
  transfer=$(cat $1 | awk '{print tolower($0)}' | sed 's/--/ /g' | sed 's/"//g'); textArray=(${transfer})
  contraction=0
  compoundw=0
  #Loop through all words in text via array format (spaces used to delniate diffrent words)
  for i in "${textArray[@]}"; do 
    if [[ $i == [a-z]*\'[a-r,t-z]* ]] || [[ $i == [a-z]*\'[a-r]* ]] ; then
      contraction=$((contraction+1))
      echo $contraction
    fi
    if [[ $i == [a-z]*-[a-z]* ]]; then
      compoundw=$((compoundw+1))
    fi
  done
  echo "contraction $contraction" >> $1_profile.txt
  echo "comound_word $compoundw" >> $1_profile.txt

  echo "Profile Created, file located in current direcotry, called $1_profile.txt"

elif [[ $profilemode == 0 ]]; then
  echo "Entering Analysis Mode...."

fi 
