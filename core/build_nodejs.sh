#!/bin/bash
echo
echo -----------------------------------
echo Build node.js
echo
set -e
# This script mustn't be run with root rights.
if [ $UID -eq 0 ]; then
    echo Error! You should not run this shell with root rights.
    exit 1
fi
CURRENTPATH=$(cd `dirname $0`; pwd)
. $(cd `dirname $CURRENTPATH`; pwd)/envsetup.sh nosetenv
setenv

cd $(gettop)/src/node
./configure --prefix=$OUT/nodejs
make
make install

$OUT/nodejs/bin/npm install nw-gyp -g
$OUT/nodejs/bin/npm install node-pre-gyp -g
echo
echo Successed building node.js.
echo ===================================
echo
