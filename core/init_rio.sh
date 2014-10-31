#!/bin/bash
#set -e
CURRENTPATH=$(cd `dirname $0`; pwd)
. $(cd `dirname $CURRENTPATH`; pwd)/envsetup.sh nosetenv
setenv
echo create resources directory...
rioPath=~/.demo-rio
resourcePath=~/.resources
#If directory exists, remove it.
if [ -e $rioPath ]; then
  rm -rf $rioPath
fi
if [ -e $resourcePath ]; then
  rm -rf $resourcePath
fi
cd ~&& mkdir $rioPath&& cd $rioPath&& touch uniqueID.js
cd ~&& mkdir $resourcePath&& cd $resourcePath
cateArr=(music document video picture desktop contactDes musicDes documentDes videoDes pictureDes desktopDes)
for cateDir in ${cateArr[@]}
do
   mkdir $cateDir&& cd $cateDir&& mkdir data&& git init&& cd ..
done

exit 0
