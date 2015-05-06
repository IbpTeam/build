#!/bin/bash
if [ "$CROOT" == "" ] ; then
  echo ERROR: You should execute . set_env at project root path.
  exit 1
fi
set -e

function link_modules_for_one_app(){
  cd $1
  echo
  echo -----------------------------------
  echo Link node modules for $1
  echo

  if [ ! -f package.json ] ; then
      echo Error: no package.json found!
      return 1
  fi

  if [ "$PWD" == "$CROOT/app/demo-webde/nw" ] ; then
      echo For nw, we now use npm install to solve dependency.
      if [ ! -d "$HOME/.local/share/webde" ] ; then
        echo cp config file
        cp -r "$PWD/config/" "$HOME/.local/webde" 
      fi
      npm link demo-rio || return 1
      npm install || return 1
      if [ -e Gruntfile.js ] ; then
          grunt || return 1
      fi
      return 0
  fi

  if [ "$PWD" == "$CROOT/app/demo-webde/ui-lib" ] ; then
      echo For ui-lib, we now use npm install to solve dependency.
      npm install || return 1
      if [ -e Gruntfile.js ] ; then
          grunt || return 1
      fi
      return 0
  fi

    if [ "$PWD" == "$CROOT/app/demo-rio/newdatamgr" ] ; then
      echo For demo-rio/newdatamgr, we now use npm install to solve dependency.
      npm install || return 1
      if [ -e Gruntfile.js ] ; then
          grunt || return 1
      fi
      return 0
  fi

  for file in `$OUT/nodejs/bin/npm ls 2>/dev/null | grep "UNMET DEPENDENCY" | cut -d ' ' -f 4 | grep @  | cut -d '@' -f 1`
  do
      if [ ! -d node_modules ] ; then
          mkdir node_modules
      fi
      if [ ! -e node_modules/$file ] ; then
          if [ ! -e ../../../out/nodejs/lib/node_modules/$file ] ; then
              echo Error: No node_modules/$file found! You should execute m successful!
              return 1
          fi
          ln -s ../../../../out/nodejs/lib/node_modules/$file node_modules/$file
      fi
  done
}

function link_modules_for_all_app(){
  link_modules_for_one_app $CROOT/app/demo-rio/nodewebkit || return 1
  link_modules_for_one_app $CROOT/app/demo-rio/datamgr || return 1
  link_modules_for_one_app $CROOT/app/demo-rio/testAPI || return 1
  link_modules_for_one_app $CROOT/app/demo-webde/nw || return 1
  link_modules_for_one_app $CROOT/app/demo-webde/ui-lib || return 1
  link_modules_for_one_app $CROOT/app/demo-rio/newdatamgr || return 1
}

if [ $# == 1 ] ; then
  if [ "$1" == "all" ] ; then
    link_modules_for_all_app || exit 1
  elif [ -d $1 ] ; then
    link_modules_for_one_app $1 || exit 1
  else
    echo Error: can recognize $*
    exit 1
  fi
elif [ $# == 0 ] ; then
  #no param, we choose default app path to link modules
  link_modules_for_one_app $PWD || exit 1
else
  echo Error: can recognize $*
  exit 1
fi

echo
echo Successed linking node modules for $1
echo ===================================
echo

