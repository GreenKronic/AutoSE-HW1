#!/bin/bash
set -e
VAR="$1"
PIPE="$PWD/hostbrowserpipe"
dir="$PWD"

rm -rf "$PIPE"         
mkfifo "$PIPE"

# Background pipe listener
(
  while read -r URL; do
    echo "Opening: $URL"
    xdg-open "$URL"
  done <"$PIPE"
) &

LISTENER_PID=$!
echo "Listener PID: $LISTENER_PID"



cleanup() {
  echo "Cleaning up..."
  kill "$LISTENER_PID" 2>/dev/null || true
  rm -rf "$PIPE" "predictions.jpg"
}
trap cleanup EXIT



# Docker run 
docker run -it --rm \
  -v "$PIPE":/var/run/hostbrowserpipe \
  -v "$dir":/vol \
  -e HOST_DIR="$dir" \
  greenkronic/hw1 \
  "$VAR"

while true; do
  sleep 1
done
# docker run -it hw1 https://hips.hearstapps.com/hmg-prod/images/dog-puppy-on-garden-royalty-free-image-1586966191.jpg