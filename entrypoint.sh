#!/bin/bash
VAR="$1"
PIPE="/var/run/hostbrowserpipe"

if [ -z "$VAR" ]; then
  echo "No argument provided"
  exit 1
fi

cd /opt/darknet/

wget $VAR -O detect.jpg || { echo "Failed to download file"; exit 2; }

./darknet detect cfg/yolov3.cfg yolov3.weights detect.jpg || echo "Darknet detection failed"

mv predictions.jpg /vol || { echo "Failed to move predictions.jpg"; }

if [ -z "$HOST_DIR" ]; then
  echo "no VOLUME mounted, skipping browser open."
  exit 0
fi

URL="file://$HOST_DIR/predictions.jpg"


if [ -p "$PIPE" ]; then
  if ! timeout 1 bash -c "echo \"$URL\" > \"$PIPE\""; then
    echo "Pipe exists but no reader available, skipping open."
  fi
else
  echo "Host browser pipe not found, skipping."
fi

