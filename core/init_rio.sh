#!/bin/bash
#set -e
CURRENTPATH=$(cd `dirname $0`; pwd)
. $(cd `dirname $CURRENTPATH`; pwd)/envsetup.sh nosetenv
setenv
echo create resources directory...
resourcePath=~/.resources
#If directory exists, remove it.
if [ -e $resourcePath ]; then
  rm -rf $resourcePath
fi
cd ~&& mkdir $resourcePath&& cd $resourcePath
cateArr=(contacts music documents video pictures)
for cateDir in ${cateArr[@]}
do
   mkdir $cateDir&& cd $cateDir&& git init&& cd ..
done

exit 0
