#!/bin/bash

echo Checking latest versions of get_iplayer...

# Get main script version
if [[ -f /getiplayer/get_iplayer ]]
then
  VERSION=$(cat /getiplayer/get_iplayer | grep version | grep -oP 'version\ =\ \K.*?(?=;)' | head -1)
fi

# Get current github release version
RELEASE=$(wget -q -O - "https://api.github.com/repos/get-iplayer/get_iplayer/releases/latest" | grep -Po '"tag_name": "v\K.*?(?=")')

# If no github version returned
if [[ "$RELEASE" == "" ]] && [[ "$FORCEDOWNLOAD" -eq "" ]]
then
  #indicates something wrong with the github call
  echo ******** Warning - unable to check latest release!!  Please raise an issue https://github.com/kolonuk/get_iplayer-docker/issues/new
fi

echo get_iplayer installed        $VERSION
echo get_iplayer release          $RELEASE

if [[ "$VERSION" == "" ]] || \
   [[ "$VERSION" != "$RELEASE" ]] || \
   [[ "$FORCEDOWNLOAD" != "" ]]
then
  echo Getting latest version of get_iplayer...
  if [[ "$RELEASE" == "" ]]
  then
    # No release returned from github, download manually
    wget -q https://raw.githubusercontent.com/get-iplayer/get_iplayer/master/get_iplayer.cgi -O /getiplayer/get_iplayer.cgi
    wget -q https://raw.githubusercontent.com/get-iplayer/get_iplayer/master/get_iplayer -O /getiplayer/get_iplayer
    chmod 755 /getiplayer/get_iplayer
  else
    # Download and unpack release
    wget -q https://github.com/get-iplayer/get_iplayer/archive/v$RELEASE.tar.gz -O /getiplayer/latest.tar.gz
    cd /getiplayer
    tar -xzf /getiplayer/latest.tar.gz get_iplayer-$RELEASE --directory /getiplayer/ --strip-components=1
    rm /getiplayer/latest.tar.gz
  fi
fi