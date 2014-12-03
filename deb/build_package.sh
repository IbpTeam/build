#!/bin/bash

if [ "$CROOT" == "" ] ; then
  echo ERROR: You should execute . set_env at project root path.
  exit 1
fi

debName=webde
debDir=$CROOT/out/deb
resourcePath=$debDir/$debName/usr/share/$debName
i386Path=$debDir/$debName/i386
amd64Path=$debDir/$debName/amd64

if [ -e $debDir ] ; then
  rm -rf $debDir
fi

mkdir -p $resourcePath
mkdir -p $i386Path
mkdir -p $amd64Path

cp -r $CROOT/build/deb/debian $debDir/$debName
cp -r $CROOT/prebuilt/node-webkit-v0.8.4 $i386Path/node-webkit-v0.8.4
cp -r $CROOT/prebuilt/node-webkit-v0.8.4-linux-x64 $amd64Path/node-webkit-v0.8.4-linux-x64


exit 0