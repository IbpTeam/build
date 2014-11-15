#!/bin/bash
#set -e
if [ "$CROOT" == "" ] ; then
  echo ERROR: You should execute . set_env at project root path.
  exit 1
fi

#Base on param, "clean" for clean db;init for initialize db.
#Default is init.
if [ $# == 1 ] ; then
    isInit=$1
else
    isInit="init"
fi

#Is install sqlite3
isInstallSqlite3=`which sqlite3`
if [ ! $isInstallSqlite3 ] ; then
    echo Sqlite3 is not installed, please install first.
    echo You could use "apt-get install sqlite3" to install.
    exit 1
fi

#Is db file exists
dbPath=~/.demo-rio/rio.sqlite3
if [ -e $dbPath ] ; then
    if [ $isInit == "init" ] ; then
        echo Database is already exists.
        exit 0
    else
        rm -f $dbPath
    fi
fi

echo create and clean database...
#SQL for init database
initSQL="BEGIN TRANSACTION;\
CREATE TABLE category (logoPath TEXT, id INTEGER PRIMARY KEY, type TEXT, desc TEXT);\
CREATE TABLE contact (is_delete INTEGER, URI TEXT, photoPath TEXT, id INTEGER PRIMARY KEY, name TEXT, phone NUMERIC, sex TEXT, age NUMERIC, email TEXT,createTime TEXT,createDev TEXT, lastAccessTime TEXT,lastAccessDev TEXT,lastModifyTime TEXT,lastModifyDev TEXT,others TEXT);\
CREATE TABLE devices (lastSyncTime TEXT, resourcePath TEXT, ip TEXT, name TEXT, id INTEGER PRIMARY KEY, device_id TEXT, account TEXT);\
CREATE TABLE document (is_delete INTEGER, URI TEXT, postfix TEXT, filename TEXT, id INTEGER PRIMARY KEY, size TEXT, path TEXT, project TEXT, createTime TEXT,createDev TEXT, lastAccessTime TEXT,lastAccessDev TEXT,lastModifyTime TEXT,lastModifyDev TEXT,others TEXT);\
CREATE TABLE music (is_delete INTEGER, URI TEXT, postfix TEXT, filename TEXT, id INTEGER PRIMARY KEY, size TEXT, path TEXT, album TEXT, composerName TEXT, actorName TEXT, createTime TEXT,createDev TEXT, lastAccessTime TEXT,lastAccessDev TEXT,lastModifyTime TEXT,lastModifyDev TEXT,others TEXT);\
CREATE TABLE picture (is_delete INTEGER, URI TEXT, postfix TEXT, filename TEXT, id INTEGER PRIMARY KEY, size TEXT, path TEXT, location TEXT, createTime TEXT,createDev TEXT, lastAccessTime TEXT,lastAccessDev TEXT,lastModifyTime TEXT,lastModifyDev TEXT,others TEXT);\
CREATE TABLE tags (id INTEGER PRIMARY KEY, file_URI TEXT, tag TEXT);\
CREATE TABLE video (is_delete INTEGER, URI TEXT, postfix TEXT, name TEXT, path TEXT, id INTEGER PRIMARY KEY, size TEXT, type TEXT, createTime TEXT,createDev TEXT, lastAccessTime TEXT,lastAccessDev TEXT,lastModifyTime TEXT,lastModifyDev TEXT,others TEXT);\
CREATE TABLE other (filename TEXT, postfix TEXT, path TEXT, URI TEXT, createTime TEXT, id INTEGER PRIMARY KEY,others TEXT, size TEXT,createDev TEXT, lastAccessTime TEXT,lastAccessDev TEXT,lastModifyTime TEXT,lastModifyDev TEXT);\
INSERT INTO category VALUES('./frontend-dev/images/contacts.jpg',101,'Contact','联系人');\
INSERT INTO category VALUES('./frontend-dev/images/pictures.png',102,'Picture','图片');\
INSERT INTO category VALUES('./frontend-dev/images/videos.png',103,'Video','视频');\
INSERT INTO category VALUES('./frontend-dev/images/documents.jpg',104,'Document','文档');\
INSERT INTO category VALUES('./frontend-dev/images/music.png',105,'Music','音乐');\
INSERT INTO category VALUES('./frontend-dev/images/devices.jpg',106,'Devices','设备');\
COMMIT;"

echo $initSQL | sqlite3 $dbPath
echo $isInit dabase successfully.

exit 0
