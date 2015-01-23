#!/bin/bash

echo create resources directory...
basePath=~/.custard
#rioPath=~/.demo-rio
configPath=$basePath/config
#resourcePath=~/.resources
resourcePath=$basePath/resource
name=`whoami`
userConifg="var uniqueID=\"rio"$RANDOM"rio\";\nexports.uniqueID=uniqueID;\nvar Account=\""$name"\";\nexports.Account=Account;"
#If directory exists, remove it.
if [ -e $basePath ]; then
  rm -rf $basePath
fi
mkdir -p $basePath
cd $basePath&& mkdir $configPath&& cd $configPath
echo -e $userConifg > uniqueID.js
cd $basePath&& mkdir $resourcePath&& cd $resourcePath
cateArr=(music document video picture desktop other contactDes musicDes documentDes videoDes pictureDes desktopDes otherDes)
for cateDir in ${cateArr[@]}
do
   mkdir $cateDir&& cd $cateDir&& mkdir data&& git init&& cd ..
done

exit 0
