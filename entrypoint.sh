#!/bin/bash
VAR="$1"

if [ -z "$VAR" ]; then
  echo "No argument provided"
  exit 1
fi

cd /opt/darknet/

wget $VAR -O detect.jpg || { echo "Failed to download file"; exit 2; }

./darknet detect cfg/yolov3.cfg yolov3.weights detect.jpg || echo "Darknet detection failed"
