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
cateArr=(contact music document video picture desktop contactsDes musicDes documentsDes videoDes picturesDes desktopDes)
for cateDir in ${cateArr[@]}
do
   mkdir $cateDir&& cd $cateDir&& mkdir data&& git init&& cd ..
done

exit 0
