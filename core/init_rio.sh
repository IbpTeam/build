#!/bin/bash

echo create resources directory...
basePath=~/.custard
#rioPath=~/.demo-rio
configPath=$basePath/config
#resourcePath=~/.resources
resourcePath=$basePath/resource
tmpPath=$basePath/tmp
typeSourcePath=$CROOT/app/demo-rio/nodewebkit/backend/data
typePath=$configPath/custard_type
backupPath=~/.custardBac
backupEditionPath=$backupPath/edition
backupExtractPath=$backupPath/extract
name=`whoami`
userConifg="var uniqueID=\"rio"$RANDOM"rio\";\nexports.uniqueID=uniqueID;\nvar Account=\""$name"\";\nexports.Account=Account;"
# if [ -e $backupExtractPath ]; then
#   mkdir ~/.backup
#   mv -R  backupExtractPath  ~/.backup
# fi
#If directory exists, remove it.
if [ -e $basePath ]; then
  rm -rf $basePath
fi
mkdir -p $basePath
cd $basePath&& mkdir $configPath&& cd $configPath
echo -e $userConifg > uniqueID.js
cd $basePath&& mkdir $resourcePath&& cd $resourcePath
cateArr=(music document video picture desktop other)
for cateDir in ${cateArr[@]}
do
   #mkdir $cateDir&& cd $cateDir&& mkdir data&& git init&& cd ..
    mkdir $cateDir&& cd $cateDir&& mkdir data && cd ..
done
#backup
if [ ! -e $backupPath ]; then
  mkdir -p $backupPath
fi
if [ ! -e $backupExtractPath ]; then
  mkdir -p $backupExtractPath
fi
if [ ! -e $backupEditionPath ]; then
  mkdir -p $backupEditionPath
fi

#custard_type
mkdir $typePath
cp -r -f $typeSourcePath/typeDefine $typePath && echo Successful copy folder : $typeSourcePath/typeDefine To $typePath  
mkdir $tmpPath
exit 0
