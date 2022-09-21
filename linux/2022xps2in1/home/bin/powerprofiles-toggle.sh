#!/bin/bash

# wrapper for powerprofilesctl to allow cycling through available options.
# Passes arguments directly to powerprofilesctl except for "toggle",
# which cycles through profiles.

PPC=$(which powerprofilesctl)

getoptions() {
  OPTIONS=$(${PPC} list |sed 's/\s\s\s\s.*//g' |sed 's/^[ \*]*//g' | sed 's/:.*$//g')
  echo $OPTIONS
}

# Gets the index of the given profile state in the array of options.
getindex() {
  for (( i=0; i<=$(( $COUNT -1 )); i++ ))
  do
    if [[ ${OPTIONS[${i}]} == ${CURRENT} ]]
    then
      if (( ${i} == $(( ${COUNT} -1 )) ))
      then 
        TARGET=${OPTIONS[0]}
      else 
        TARGET=${OPTIONS[(( ${i} +1 ))]}
      fi
      if [ -v TARGET ]
      then
        echo "Switching to ${TARGET}"
        ${PPC} set ${TARGET}
        return
      fi
      echo "No new target power state found. Exiting..."
      return
    fi
  done

}

toggle() {
  OPTIONS=($(getoptions))
  COUNT=${#OPTIONS[*]}
  CURRENT=$(${PPC} get)
  echo "current: ${CURRENT}"
  for (( i=0; i<=$(( $COUNT -1 )); i++ ))
  do
    if [[ ${OPTIONS[${i}]} == ${CURRENT} ]]
    then
      if (( ${i} == $(( ${COUNT} -1 )) ))
      then 
        TARGET=${OPTIONS[0]}
      else 
        TARGET=${OPTIONS[(( ${i} +1 ))]}
      fi
      if [ -v TARGET ]
      then
        echo "Switching to ${TARGET}"
        ${PPC} set ${TARGET}
        return
      fi
      echo "No new target power state found. Exiting..."
      return
    fi
  done

}

if [[ $1 == 'options' ]]
then
  getoptions
  exit 0
fi

if [[ $1 == 'toggle' ]]
then
  toggle
  exit 0
fi

$PPC $@

