#!/bin/bash
echo
echo -----------------------------------
echo Link node modules for app modules
echo
set -e
CURRENTPATH=$(cd `dirname $0`; pwd)
. $(cd `dirname $CURRENTPATH`; pwd)/envsetup.sh nosetenv
setenv

cd $(gettop)/app/demo-rio/nodewebkit
if [ ! -d node_modules ] ; then
    mkdir node_modules
fi

for file in `npm ls 2>/dev/null | grep "UNMET DEPENDENCY" | cut -d ' ' -f 4 | cut -d '@' -f 1`
do
    if [ ! -e node_modules/$file ] ; then
        ln -s ../../../../out/nodejs/lib/node_modules/$file node_modules/$file
    fi
done
echo
echo Successed linking node modules for app.
echo ===================================
echo
