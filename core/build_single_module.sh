#!/bin/bash
set -e
CURRENTPATH=$(cd `dirname $0`; pwd)
. $(cd `dirname $CURRENTPATH`; pwd)/envsetup.sh nosetenv
setenv

if [ ! "$(dirname $(dirname $PWD))" == "$(gettop)/src" ] ; then
    echo Error: this is not node module source path.
    exit 1
fi

echo 
echo ------------------
echo Build single module : $file
echo 
npm link
if [ -f binding.gyp ] ; then
    nw-gyp rebuild --target=0.8.4
fi
if [ "$file" == "sqlite3" ] ; then
    nw-gyp rebuild --target=0.8.4
fi
echo 
echo Successed building $file.
echo ==================
echo 
