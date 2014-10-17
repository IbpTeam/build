#!/bin/bash
set -e
# This script mustn't be run with root rights.
if [ $UID -eq 0 ]; then
  echo Error! You should not run this shell with root rights.
  exit 1
fi
CURRENTPATH=$(cd `dirname $0`; pwd)
. $(cd `dirname $CURRENTPATH`; pwd)/envsetup.sh nosetenv
setenv

if [ ! "$(dirname $(dirname $PWD))" == "$(gettop)/src" ] ; then
  echo Error: this is not node module source path.
  exit 1
fi

isfornode=0
if [ $# -ge 1 ] ; then
  if [ "$1" == "--node" ] ; then
      isfornode=1
  fi
fi

echo 
echo ------------------
echo Build single module : $PWD
echo 
if [ -f package.json ] ; then
  $OUT/nodejs/bin/npm link
  if [ $isfornode -eq 0 ] ; then
    echo ---Rebuilding for nw 0.8.4
    if [ -f binding.gyp ] ; then
        $OUT/nodejs/bin/nw-gyp rebuild --target=0.8.4
    fi
    echo ---Finish rebuilding for nw 0.8.4
  fi
fi
echo 
echo Successed building $PWD.
echo ==================
echo 
