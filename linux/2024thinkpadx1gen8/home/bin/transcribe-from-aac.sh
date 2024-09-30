#!/bin/bash

# Super simple script to transcribe a target AAC from Signal.
# Requires Whisper to be installed and in the path, or in your pip3 bin directory.
# Usage: transcribe-from-aac.sh <audio-file.aac>

# Script takes one argument: the .aac audio file from Signal.
AUDIO_FILE=${1}

# Ensure the audio file exists.
if [ ! -f ${AUDIO_FILE} ]; then
    echo "Audio file not found."
    exit 1
fi
echo "Found audio file: ${AUDIO_FILE}"

# Ffmpeg converts to wav in tmpstore.
TMPSTORE=$(mktemp -d)
FFMPEG=$(which ffmpeg)

if [ -z ${FFMPEG} ]; then
    echo "Ffmpeg not found in path. Please install ffmpeg."
    exit 1
fi

echo "Converting audio file to wav..."
${FFMPEG} -loglevel error -i ${AUDIO_FILE} ${TMPSTORE}/signal-transcribe-audio.wav

# See if Whisper is in path.
WHISPER=$(which whisper)
if [ -z ${WHISPER} ]; then
    # Check if it's in the user's pip3 bin directory.
    if [ -f ~/.local/bin/whisper ]; then
        WHISPER=~/.local/bin/whisper
    else
        echo "Whisper not found in path. Please install Whisper."
        exit
    fi
fi

# Transcribe the wav file.
echo "Transcribing audio file..."
OUTPUT=$(${WHISPER} transcribe ${TMPSTORE}/signal-transcribe-audio.wav)
ERRORCODE=$?

# If cowsay is available we'll use it to print the output.
COWSAY=$(which cowsay)
if [ -z ${COWSAY} ]; then
    echo "${OUTPUT}"
else
    # Choose a random cow.
    COW=$(cowsay -l | tail -n +2 | tr ' ' '\n' | grep -v ^$ | shuf -n 1)
    ${COWSAY} -f ${COW} "${OUTPUT}"
fi

# cleanup the tmpstore.
rm -rf ${TMPSTORE}

exit ${ERRORCODE}

# End of script.