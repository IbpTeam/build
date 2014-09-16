#!/bin/bash
set -e
CURRENTPATH=$(cd `dirname $0`; pwd)
. $(cd `dirname $CURRENTPATH`; pwd)/envsetup.sh nosetenv
setenv

# This script needs to be run with root rights.
if [ $UID -ne 0 ]; then
    sudo bash $0
    exit 0
fi

echo
echo -----------------------------------
echo Install Deps
echo

function printNotSupportedMessageAndExit() {
    echo
    #echo "Currently this script only works for distributions supporting apt-get and yum."
    echo "Currently this script only works for distributions supporting apt-get."
    #echo "Please add support for your distribution: http://webkit.org/b/110693"
    echo
    exit 1
}

function checkInstaller {
    # apt-get - Debian based distributions
    apt-get --version &> /dev/null
    if [ $? -eq 0 ]; then
        installDependenciesWithApt
        exit 0
    fi

    # yum - Fedora
    #yum --version &> /dev/null
    #if [ $? -eq 0 ]; then
    #    installDependenciesWithYum
    #    exit 0
    #fi

    printNotSupportedMessageAndExit
}

function installDependenciesWithApt {
    # These are dependencies necessary for building node-module mdns.
    apt-get install libavahi-compat-libdnssd-dev

    apt-get install g++

    apt-get install libexpat1-dev

    # fix the lack of libudev.so.0.

    paths=(
    "/lib/x86_64-linux-gnu/libudev.so.1" # Ubuntu, Xubuntu, Mint
    "/usr/lib64/libudev.so.1" # SUSE, Fedora
    "/usr/lib/libudev.so.1" # Arch, Fedora 32bit
    "/lib/i386-linux-gnu/libudev.so.1" # Ubuntu 32bit
    )
    for i in "${paths[@]}"
    do
        if [ -f $(dirname $i)/libudev.so.0 ] ; then
            break
        fi
        if [ -f $i ]
        then
            ln -sf "$i" $(dirname $i)/libudev.so.0
            break
        fi
    done
}

checkInstaller


echo
echo Successed installing deps.
echo ===================================
echo
