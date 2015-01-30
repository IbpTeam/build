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
applist=(newdatamgr viewerPDF controlPPT)
nodeModules=(chokidar csvtojson dbus file-stream fs-extra getmac hashtable id3v2-parser node-rsa request socket.io socket.io-client sqlite3 tape ws)

echo Clean last build package...
if [ -e $debDir ] ; then
  rm -rf $debDir
fi

echo Create directory...
mkdir -p $resourcePath/demo-webde
mkdir -p $appPath
mkdir -p $initPath
mkdir -p $i386Path
mkdir -p $amd64Path

echo Create debian environment...
cp -r $CROOT/build/deb/debian $debDir/$debName
echo Copy node-webkit...
cp -r $CROOT/prebuilt/node-webkit-v0.8.6-linux-ia32 $i386Path/node-webkit-v0.8.6-linux-ia32
cp -r $CROOT/prebuilt/node-webkit-v0.8.6-linux-x64 $amd64Path/node-webkit-v0.8.6-linux-x64
echo Copy demo-webde...
cp -r $CROOT/app/demo-webde/nw/* $resourcePath/demo-webde
rm -rf $resourcePath/demo-webde/old*
echo Copy demo-rio...
rm -rf $resourcePath/demo-webde/node_modules/*
mkdir $resourcePath/demo-webde/node_modules/demo-rio
cp -r $CROOT/app/demo-rio/nodewebkit/* $resourcePath/demo-webde/node_modules/demo-rio
cd $resourcePath/demo-webde/node_modules/demo-rio/backend/app/default/
rm -f ./App.list
mv ./App.list-inDeb ./App.list
echo Copy sdk...
cp -r $CROOT/app/demo-rio/sdk $resourcePath

echo Copy desktop config file and image...
cp -r $CROOT/build/deb/applications $debDir/$debName/usr/share/
cp -r $CROOT/build/deb/pixmaps $debDir/$debName/usr/share/

echo Copy default app...
for appName in ${applist[@]}
do	
  cp -r $CROOT/app/demo-rio/$appName $appPath
  cd $appPath/$appName
  rm lib
  ln -s ../../sdk/lib
done

echo Create datamgr link...
cd $debDir/$debName/usr/share/$debName/app/newdatamgr/node_modules
rm -rf ./*
ln -s ../../../demo-webde/node_modules/demo-rio demo-rio 

echo Copy init shell...
cp -r $CROOT/build/deb/init/init_custard.sh $initPath

echo create node modules...
rm -rf $resourcePath/demo-webde/node_modules/demo-rio/node_modules/*
for moduleName in ${nodeModules[@]}
do
  cp -r $CROOT/src/node_modules/$moduleName $resourcePath/demo-webde/node_modules/demo-rio/node_modules/
done
#cp -r $CROOT/src/node_modules $resourcePath/demo-webde/node_modules/demo-rio/

echo Create global config...
if [ -e $resourcePath/demo-webde/config/webde/webde ] ; then 
  mv $resourcePath/demo-webde/config/webde/webde $debDir/$debName
fi

echo Remove git related in demo-webde...
rm -rf $resourcePath/demo-webde/.git*
echo Remove git related in demo-rio...
rm -rf $resourcePath/demo-webde/node_modules/demo-rio/.git*

echo Remove git related in each node module...
for moduleName in `ls $resourcePath/demo-webde/node_modules/demo-rio/node_modules`
do
  rm -rf $resourcePath/demo-webde/node_modules/demo-rio/node_modules/$moduleName/.git*
done

echo start to build package...
cd $debDir/$debName
dpkg-buildpackage -tc

exit 0