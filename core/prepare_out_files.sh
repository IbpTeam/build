#!/bin/bash
echo CROOT:$CROOT
if [ "$CROOT" == "" ] ; then
  echo ERROR: You should execute . set_env at project root path.
  exit 1
fi
echo
echo -----------------------------------
echo Prepare out files from resources
echo
set -e
# This script mustn't be run with root rights.
if [ $UID -eq 0 ]; then
    echo Error! You should not run this shell with root rights.
    exit 1
fi

if [ ! -e $OUT ] ; then
    mkdir $OUT
fi
if [ ! -d $OUT ] ; then
    echo "Error: $OUT can not be created or $OUT is not a dir."
    return 1
fi

if [ ! -e $OUT/resources ] ; then
  cp -r $T/resources $OUT/resources
  rm -rf $OUT/resources/.git
fi

echo
echo Successed preparing out files from resources
echo ===================================
echo
