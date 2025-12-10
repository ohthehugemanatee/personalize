#!/bin/bash

# wrapper for powerprofilesctl to allow cycling through available options.
# Passes arguments directly to powerprofilesctl except for "toggle",
# which cycles through profiles.

PPC=$(which tlpctl)

getoptions() {
  OPTIONS=performance balanced power-saver
  echo $OPTIONS
}

# Gets the index of the given profile state in the array of options.
getindex() {
  TARGET=${1}
  OPTIONS=($(getoptions))
  COUNT=${#OPTIONS[*]}
  for (( i=0; i<=$(( $COUNT -1 )); i++ ))
  do
    if [[ ${OPTIONS[${i}]} == ${TARGET} ]]
    then
      echo ${i}
    fi
  done

}

getpercentage() {
  OPTIONS=($(getoptions))
  COUNT=${#OPTIONS[*]}
  CURRENT=$(${PPC} get)
  INDEX=$(getindex ${CURRENT})
  DIVIDEND=$(( ${INDEX} +1 ))
  echo $( bc -l <<< ${DIVIDEND}/${COUNT} )
}

getjson() {
  CURRENT=$(${PPC} get)
  printf '{"text":"%s", "alt":"%s", "tooltip":"%s", "class":"%s"}\n' "icon-${CURRENT}" "icon-${CURRENT}" "${CURRENT}" "${CURRENT}" 
}

toggle() {
  OPTIONS=($(getoptions))
  COUNT=${#OPTIONS[*]}
  CURRENT=$(${PPC} get)
  echo "current: ${CURRENT}"
  INDEX=$(getindex ${CURRENT})
  if (( ${INDEX} == $(( ${COUNT} -1 )) ))
  then 
    TARGET=${OPTIONS[0]}
  else 
    TARGET=${OPTIONS[(( ${INDEX} +1 ))]}
  fi
  if [ -v TARGET ]
  then
    echo "Switching to ${TARGET}"
    ${PPC} set ${TARGET}
    return
  fi
  echo "No new target power state found. Exiting..."
  return
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

if [[ $1 == 'getpercent' ]]
then
  getpercentage
  exit 0
fi

if [[ $1 == 'getjson' ]]
then
  getjson
  exit 0
fi
$PPC $@

