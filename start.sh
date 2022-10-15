#!/bin/bash

# Check if we have get_inlayer
if [[ ! -f /getiplayer/get_iplayer ]]
then
  /getiplayer/update.sh start
fi

if [[ ! -f /getiplayer/get_iplayer ]]
then  # pause for checking things out...
  echo err1 - Error occurred, pausing for 9999 seconds for investigation
  sleep 9999
fi

# Set some nice defaults
if [[ ! -f /root/.get_iplayer/options ]]
then
  echo No options file found, adding some nice defaults...
  /getiplayer/get_iplayer --prefs-add --whitespace
  /getiplayer/get_iplayer --prefs-add --subs-embed
  /getiplayer/get_iplayer --prefs-add --metadata
  /getiplayer/get_iplayer --prefs-add --nopurge
fi

# Force output location to a separate docker volume
echo Forcing output location...
/getiplayer/get_iplayer --prefs-add --output="/output/"

crond
