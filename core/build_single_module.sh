#!/bin/bash
if [ "$CROOT" == "" ] ; then
  echo ERROR: You should execute . set_env at project root path.
  exit 1
fi
set -e
# This script mustn't be run with root rights.
if [ $UID -eq 0 ]; then
  echo Error! You should not run this shell with root rights.
  exit 1
fi

if [ ! "$(dirname $(dirname $PWD))" == "$CROOT/src" ] ; then
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
    if [ "$WD_RT_VERSION" == "" ]; then
      echo Error: No WD_RT_VERSION is set. You should execute source set_env at project root path.
      exit 1
    fi
    echo ---Rebuilding module for nw ${WD_RT_VERSION%%-*}
    if [ -f binding.gyp ] ; then
        $OUT/nodejs/bin/nw-gyp rebuild --target=${WD_RT_VERSION%%-*}
    fi
    echo ---Finish rebuilding module for nw ${WD_RT_VERSION%%-*}
  fi
fi
echo 
echo Successed building $PWD.
echo ==================
echo 
