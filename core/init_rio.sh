#!/bin/bash

echo create resources directory...
basePath=~/.custard
#rioPath=~/.demo-rio
configPath=$basePath/config
#resourcePath=~/.resources
resourcePath=$basePath/resource
typeSourcePath=$CROOT/app/demo-rio/nodewebkit/backend/data
typePath=$configPath/custard_type
DefinePath=$typePath/typeDefine
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
#custard_type
if [ -e $typePath ]; then
  rm -rf $typePath
fi
mkdir -p $typePath
if [ -e $DefinePath ]; then
  rm -rf $DefinePath
fi
cp -r -f $typeSourcePath/typeDefine $typePath
for file in  "contacts.js" "document.js" "music.js" "picture.js" "video.js" "other.js";  do
  echo $file
  cp -f $typeSourcePath/$file $typePath
done

exit 0

