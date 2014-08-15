#!/bin/bash
echo
echo -----------------------------------
echo Build node.js
echo
set -e
CURRENTPATH=$(cd `dirname $0`; pwd)
. $(cd `dirname $CURRENTPATH`; pwd)/envsetup.sh nosetenv
setenv

cd $(gettop)/src/node
./configure --prefix=$OUT/nodejs
make
make install

npm install nw-gyp -g
echo
echo Successed building node.js.
echo ===================================
echo
