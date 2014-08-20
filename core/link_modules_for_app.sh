#!/bin/bash
set -e
CURRENTPATH=$(cd `dirname $0`; pwd)
. $(cd `dirname $CURRENTPATH`; pwd)/envsetup.sh nosetenv
setenv

if [ $# == 1 ] ; then
    apppath=$1
else
    #no param, we choose default app path to link modules
    apppath=$(gettop)/app/demo-rio/nodewebkit
fi
cd $apppath

echo
echo -----------------------------------
echo Link node modules for $apppath
echo

if [ ! -f package.json ] ; then
    echo Error: no package.json found!
    exit 1
fi

for file in `$OUT/nodejs/bin/npm ls 2>/dev/null | grep "UNMET DEPENDENCY" | cut -d ' ' -f 4 | cut -d '@' -f 1`
do
    if [ ! -d node_modules ] ; then
        mkdir node_modules
    fi
    if [ ! -e node_modules/$file ] ; then
        if [ ! -e ../../../out/nodejs/lib/node_modules/$file ] ; then
            echo Error: No node_modules/$file found! You should execute m successful!
            exit 1
        fi
        ln -s ../../../../out/nodejs/lib/node_modules/$file node_modules/$file
    fi
done
echo
echo Successed linking node modules for $1
echo ===================================
echo
