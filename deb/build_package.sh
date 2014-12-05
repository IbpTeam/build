#!/bin/bash

if [ "$CROOT" == "" ] ; then
  echo ERROR: You should execute . set_env at project root path.
  exit 1
fi

debName=webde
debDir=$CROOT/out/deb
resourcePath=$debDir/$debName/usr/share/$debName
appPath=$debDir/$debName/usr/share/$debName/app
initPath=$debDir/$debName/usr/share/$debName/init
i386Path=$debDir/$debName/i386
amd64Path=$debDir/$debName/amd64
applist=(appExample datamgr newdatamgr viewerPDF)

echo clean...
if [ -e $debDir ] ; then
  rm -rf $debDir
fi

mkdir -p $resourcePath
mkdir -p $appPath
mkdir -p $initPath
mkdir -p $i386Path
mkdir -p $amd64Path

echo create env...
cp -r $CROOT/build/deb/debian $debDir/$debName
cp -r $CROOT/prebuilt/node-webkit-v0.8.4 $i386Path/node-webkit-v0.8.4
cp -r $CROOT/prebuilt/node-webkit-v0.8.4-linux-x64 $amd64Path/node-webkit-v0.8.4-linux-x64
cp -r $CROOT/app/demo-webde $resourcePath
rm -rf $resourcePath/demo-webde/nw/node_modules/demo-rio
cp -r $CROOT/app/demo-rio/nodewebkit $resourcePath/demo-webde/nw/node_modules/demo-rio
cp -r $CROOT/app/demo-rio/sdk $resourcePath

if [ -e $resourcePath/demo-webde/nw/config/webde/webde ] ; then 
  mv $resourcePath/demo-webde/nw/config/webde/webde $debDir/$debName
fi

for appName in ${applist[@]}
do	
  cp -r $CROOT/app/demo-rio/$appName $appPath
  rm -rf $appPath/$appName/lib
done

rm -rf $resourcePath/demo-webde/.git*
rm -rf $resourcePath/demo-webde/nw/node_modules/demo-rio/.git*

cp -r $CROOT/build/deb/applications $debDir/$debName/usr/share/
cp -r $CROOT/build/deb/pixmaps $debDir/$debName/usr/share/

cp -r $CROOT/build/core/init_rio.sh $initPath
cp -r $CROOT/build/core/init_database.sh $initPath

echo create node modules...
rm -rf $resourcePath/demo-webde/nw/node_modules/demo-rio/node_modules
cp -r $CROOT/src/node_modules $resourcePath/demo-webde/nw/node_modules/demo-rio/

echo start to build package...
cd $debDir/$debName
dpkg-buildpackage -tc

exit 0