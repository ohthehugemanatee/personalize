#!/bin/bash

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE_DIR[0]}" )" >/dev/null 2>&1 && pwd )"
# link subdirectories to a target.
subdir_link() {
  echo "Linking dirs in source: $1 to destination $2"
  if [ -z $1 ] || [ -z $2 ]; then
    echo "Usage: subdir_link [source] [destination]"
    exit 1
  fi
  SOURCE=$1
  DEST=$2
  for dir in ${SOURCE_DIR}/${SOURCE}/*; do
    BASENAME=$(basename $dir)
    echo "Linking ${BASENAME}"
    ln -sf ${dir} ${DEST}/
  done
}

subdir_link home ${HOME}
subdir_link xdg_config ${HOME}/.config
