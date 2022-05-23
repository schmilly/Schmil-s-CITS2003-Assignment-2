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

#Functions--Bunch of Functions so we don't have to keep reusing code -TODO IF TIME ALLOWS
commaNum () {
  comma=$(grep -o -i , $1 | wc -l)  
}

semis () {
  semi=$(grep -o -i \; $1 | wc -l)
}

wordCount () {
  wordC=$(cat $1 | awk '{print tolower($0)}' | sed 's/--/ /g' | sed 's/[.,:;-]//g' | wc -w)

}

sentence () {
  senten=$(cat $1 | awk '{print tolower($0)}' | sed 's/--/ /g' | grep -i -o \[\.\?\!] | wc -l)
}

compoundContract () {
  declare -a textArray
  transfer=$(cat $1 | awk '{print tolower($0)}' | sed 's/--/ /g' | sed 's/"//g'); textArray=(${transfer})
  contraction=0; compoundw=0
  #Loop through all words in text via array format (spaces used to delniate diffrent words)
  for i in "${textArray[@]}"; do 
    if [[ $i == [a-z]*\'[a-r,t-z]* ]]; then 
      contraction=$((contraction+1))
      echo $contraction
    fi
    if [[ $i == [a-z]*-[a-z]* ]]; then
      compoundw=$((compoundw+1))
  fi
  done

}

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



##################PROFILE MODEEEEE########################
if [ $profilemode == 1 ]; then
  echo "Profilemode running..."

  
  #Gets rid of file so we can reset profile, useful in debugging and making sure clean fies
  echo "" > $1_profile.txt

  for i in "${Wordarray[@]}"; do
  #command gets rid of punctuation for word counts
    count=$(cat $1 | awk '{print tolower($0)}'| sed 's/--/ /g' | sed 's/[.,:;]//g' | tr -d '-' | grep -i -o -w $i | wc -l)
    echo "$i $count" >> $1_profile.txt
  done

  commaNum $1
  echo "comma $comma" >> $1_profile.txt

  semis $1
  echo "semi_colon $semi" >> $1_profile.txt

  wordCount $1
  echo "word $wordC" >> $1_profile.txt

  sentence $1 
  echo "sentence $senten" >> $1_profile.txt
 
  compoundContract $1
  echo "contraction $contraction" >> $1_profile.txt
  echo "comopund_word $compoundw" >> $1_profile.txt

  echo "Profile Created, file located in current direcotry, called $1_profile.txt"



  ##########ANALYSIS MODEEEE#############
elif [[ $profilemode == 0 ]]; then
  echo "Entering Analysis Mode...."
  #profile  data gathering
  commaNum $1; semis $1; wordCount $1; sentence $1; compoundContract $1

  declare -a Prf2 #Profile 2 
  declare -a Norm #Normalised Array (comparing both values)
  NormArCounter=0
  readarray -t Prf2 < <(cat $2) #put every line of profile text file into array
  #Loop to find word count of $2 profile 
  for i in "${Prf2[@]}"; do
    word=$(echo $i | cut -f1 -d " ")
    if [[ $word == "word" ]] ; then
      wordCC=$(echo $i | cut -f2 -d " ") #word count of file found!
    fi
  done
   
  #Main loop where normalisation is done
  echo "" > full_normalised

  for i in "${Prf2[@]}"; do
    if [[ -z $i ]]; then
      echo ""
    else
      word=$(echo $i | cut -f1 -d " ")
      occ_num=$(echo $i | cut -f2 -d " ") #occurance Number
      normword2=$(echo "${occ_num} / ${wordCC} * 1000" | bc -l ) #Normalised word for profile2
    count_=1
    case $word in
      comma)
        normword1=$(echo "${comma} / ${wordC} * 1000" | bc -l)
        ;;
      semi_colon)
        normword1=$(echo "${semi} / ${wordC} * 1000" | bc -l)
        ;;
      word) #used to skip since word cout doesn't need to be counted
        ;;
      sentence)
        normword1=$(echo "${senten} / ${wordC} * 1000" | bc -l) 
        echo $normword1
        ;;
      contraction)
        normword1=$(echo "${contraction} / ${wordC} * 1000" | bc -l)
        ;;
      compound_word)
        normword1=$(echo "${compoundw} / ${wordC} * 1000" | bc -l)
        ;;
      *)
        count=$(cat $1 | awk '{print tolower($0)}'| sed 's/--/ /g' | sed 's/[.,:;]//g' | tr -d '-' | grep -i -o -w $word | wc -l)
        normword1=$(echo "${count} / ${wordC} * 1000" | bc -l )
        ;;
      esac
      if [ "$word" != "word" ]; then
        euqlid=$(echo "($normword1-$normword2)^2" | bc -l )
        echo "$word $euqlid" >> full_normalised
        Norm[$NormArCounter]=$(echo $euqlid) 
        NormArCounter=$NormArCounter+1
      fi
    fi
  done
  EuclidianDistance=0
  for o in ${Norm[@]}; do    
    EuclidianDistance=$(echo "($o+$EuclidianDistance)" | bc -l)
  done
  EuclidianDistance=$(echo "sqrt($EuclidianDistance)" | bc -l)
  echo "The Euclidian Distance between the two texts is: $EuclidianDistance"
  echo "Eucldiain Distance $EuclidianDistance" >> full_normalised


fi 
