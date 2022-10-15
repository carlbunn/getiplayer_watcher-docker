#!/bin/bash

# Watch the input folder
watch="/input"

# Iterate through each file and try to download it
find $watch -maxdepth 1 -mindepth 1 -type f -name "[A-Za-z0-9]*" | \
  while read file; do F="`basename $file`"; /getiplayer/get_iplayer --pid "$F"; rm -f "$file"; done
