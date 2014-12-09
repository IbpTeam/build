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

echo Clean last build package...
if [ -e $debDir ] ; then
  rm -rf $debDir
fi

echo Create directory...
mkdir -p $resourcePath
mkdir -p $appPath
mkdir -p $initPath
mkdir -p $i386Path
mkdir -p $amd64Path

echo Create debian environment...
cp -r $CROOT/build/deb/debian $debDir/$debName
echo Copy node-webkit...
cp -r $CROOT/prebuilt/node-webkit-v0.8.4 $i386Path/node-webkit-v0.8.4
cp -r $CROOT/prebuilt/node-webkit-v0.8.4-linux-x64 $amd64Path/node-webkit-v0.8.4-linux-x64
echo Copy demo-webde...
cp -r $CROOT/app/demo-webde $resourcePath
echo Copy demo-rio...
rm -rf $resourcePath/demo-webde/nw/node_modules/demo-rio
cp -r $CROOT/app/demo-rio/nodewebkit $resourcePath/demo-webde/nw/node_modules/demo-rio
echo Copy sdk...
cp -r $CROOT/app/demo-rio/sdk $resourcePath

echo Copy desktop config file and image...
cp -r $CROOT/build/deb/applications $debDir/$debName/usr/share/
cp -r $CROOT/build/deb/pixmaps $debDir/$debName/usr/share/

echo Copy default app...
for appName in ${applist[@]}
do	
  cp -r $CROOT/app/demo-rio/$appName $appPath
  rm -rf $appPath/$appName/lib
done

echo Copy init shell...
cp -r $CROOT/build/core/init_rio.sh $initPath
cp -r $CROOT/build/core/init_database.sh $initPath

echo create node modules...
rm -rf $resourcePath/demo-webde/nw/node_modules/demo-rio/node_modules
cp -r $CROOT/src/node_modules $resourcePath/demo-webde/nw/node_modules/demo-rio/

echo Create global config...
if [ -e $resourcePath/demo-webde/nw/config/webde/webde ] ; then 
  mv $resourcePath/demo-webde/nw/config/webde/webde $debDir/$debName
fi

echo Remove git related in demo-webde...
rm -rf $resourcePath/demo-webde/.git*
echo Remove git related in demo-rio...
rm -rf $resourcePath/demo-webde/nw/node_modules/demo-rio/.git*

echo Remove git related in each node module...
for moduleName in `ls $resourcePath/demo-webde/nw/node_modules/demo-rio/node_modules`
do
  rm -rf $resourcePath/demo-webde/nw/node_modules/demo-rio/node_modules/$moduleName/.git*
done

echo start to build package...
cd $debDir/$debName
dpkg-buildpackage -tc

exit 0