#!/bin/bash
if [ "$CROOT" == "" ] ; then
  echo ERROR: You should execute . set_env at project root path.
  exit 1
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
        return 0
    fi

    # yum - Fedora
    #yum --version &> /dev/null
    #if [ $? -eq 0 ]; then
    #    installDependenciesWithYum
    #    return 0
    #fi

    printNotSupportedMessageAndExit
}

function installDependenciesWithApt {
    # These are dependencies necessary for building node-module mdns.

    dpkg -l libavahi-compat-libdnssd-dev g++ libexpat1-dev | grep ii >/dev/null
    if [ $? -ne 0 ] ; then
      sudo apt-get install libavahi-compat-libdnssd-dev g++ libexpat1-dev
    fi

    echo install ruby
    dpkg -l ruby | grep ii > /dev/null
    if [ $? -ne 0 ] ; then
      echo install ruby
      sudo apt-get install ruby
    fi
    dpkg -l ruby1.9.1-dev| grep ii > /dev/null
    if [ $? -ne 0 ] ; then
      sudo apt-get install ruby1.9.1-dev
    fi
    echo install jekyll
    gem list jekyll | grep 'jekyll ' > /dev/null
    if [ $? -ne 0 ] ; then
      sudo gem install jekyll
    fi

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
            sudo ln -sf "$i" $(dirname $i)/libudev.so.0
            break
        fi
    done
}
checkInstaller


echo
echo Successed installing deps.
echo ===================================
echo
