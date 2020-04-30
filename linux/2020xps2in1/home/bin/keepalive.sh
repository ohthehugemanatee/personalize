#!/bin/bash

# Ensures that an arbitrary command stays running until it exits gracefully.

# Usage statement.
usage() {
  echo "Keeps an arbitrary command alive." 1>&2
  echo "Usage: $0 [cmd]" 1>&2
}
exit_abnormal() {
  usage
  exit 1
}

# Make sure there's an argument.
if [ -z "$1" ]; then
  echo "Missing command argument, exiting..." 1>&2
  exit_abnormal
fi

# Make sure the argument is an executable file.
if [ ! $(command -v $1) ]; then
  echo "$1 is not an executable, or cannot be found in PATH. Exiting..."
  exit_abnormal
fi

# Run the command as a child process.
until $1; do
  echo "$1 died with exit code $?.  Respawning..." >&2
  sleep 3 # Sleep to give the program time to start properly.
done
