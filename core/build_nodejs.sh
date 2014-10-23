#!/bin/bash
if [ "$CROOT" == "" ] ; then
  echo ERROR: You should execute . set_env at project root path.
  exit 1
fi
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

cd $CROOT/src/node
./configure --prefix=$OUT/nodejs
make
make install

$OUT/nodejs/bin/npm install nw-gyp -g
$OUT/nodejs/bin/npm install node-pre-gyp -g
$OUT/nodejs/bin/npm install grunt-cli -g

echo
echo Successed building node.js.
echo ===================================
echo
