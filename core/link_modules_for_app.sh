#!/bin/bash
if [ "$CROOT" == "" ] ; then
  echo ERROR: You should execute . set_env at project root path.
  exit 1
fi
set -e

function create_link_module()
{
  file=$1
  if [ ! -d node_modules ] ; then
      mkdir node_modules
  fi
  isnode=0
  if [ $# == 1 -a "$2" == "--node" ] ; then
    isnode=1
  fi
  if [ ! -e $OUT/nodejs/lib/node_modules/$file ] ; then
      echo Error: No node_modules/$file found! You should execute m successful!
      return 1
  fi
  if [ $isnode == 1 -a -e node_modules/$file/binding.gyp ] ; then
      if [ -e $OUT/node4nw/lib/node_modules/$file ] ; then
          ln -s -f $OUT/node4nw/lib/node_modules/$file node_modules/$file
          echo Linked node module $file for nw successfully.
      else
          echo Error: No $file has been built for nw, so you should make sure that mm $file or m has been executed successfully.
          return 1
      fi
  else
      ln -s $OUT/nodejs/lib/node_modules/$file node_modules/$file
      echo Linked node module $file successfully.
  fi
}

function link_node_modules_from_global(){
  cd $1
  echo
  echo -----------------------------------
  echo Link node modules from global for $PWD \(only node\)
  echo
  for file in `$OUT/nodejs/bin/npm ls 2>/dev/null | grep "UNMET DEPENDENCY" | cut -d ' ' -f 4 | grep @  | cut -d '@' -f 1`
  do
    create_link_module $file --node
  done
}

function link_modules_from_global(){
  cd $1
  echo
  echo -----------------------------------
  echo Link node modules from global for $PWD \(for nw app\)
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
      npm link demo-rio || return 1
      npm install || return 1
      if [ -e Gruntfile.js ] ; then
          grunt || return 1
      fi
      return 0
  fi

    if [ "$PWD" == "$CROOT/app/demo-rio/newdatamgr" ] ; then
      echo For demo-rio/newdatamgr, we now use npm install to solve dependency.
      npm link demo-rio || return 1
      npm install || return 1
      if [ -e Gruntfile.js ] ; then
          grunt || return 1
      fi
      return 0
  fi

  for file in `$OUT/nodejs/bin/npm ls 2>/dev/null | grep "UNMET DEPENDENCY" | cut -d ' ' -f 4 | grep @  | cut -d '@' -f 1`
  do
    create_link_module $file
  done
}

function link_module_to_global()
{
  cd $1
  echo
  echo -----------------------------------
  echo Link node module $PWD to global
  echo

  if [ ! -f package.json ] ; then
      echo Error: no package.json found!
      return 1
  fi

  npm link
}

function link_modules_for_all()
{
  link_node_modules_from_global $CROOT/service/commdaemon || return 1
  link_module_to_global $CROOT/service/commdaemon || return 1

  link_node_modules_from_global $CROOT/framework/webde-rpc || return 1
  link_module_to_global $CROOT/framework/webde-rpc || return 1

  link_modules_from_global $CROOT/app/demo-rio/nodewebkit || return 1
  link_module_to_global $CROOT/app/demo-rio/nodewebkit || return 1

  link_modules_from_global $CROOT/app/demo-rio/nodewebkit || return 1
  link_modules_from_global $CROOT/app/demo-rio/datamgr || return 1
  link_modules_from_global $CROOT/app/demo-rio/testAPI || return 1
  link_modules_from_global $CROOT/app/demo-webde/nw || return 1
  link_modules_from_global $CROOT/app/demo-webde/ui-lib || return 1
  link_modules_from_global $CROOT/app/demo-rio/newdatamgr || return 1
  link_modules_from_global $CROOT/app/demo-rio/service/commdaemon || return 1
}

if [ $# == 1 ] ; then
  if [ "$1" == "all" ] ; then
    link_modules_for_all || exit 1
  elif [ -d $1 ] ; then
    link_node_modules_from_global $1 || exit 1
  else
    echo Error: can recognize $*
    exit 1
  fi
elif [ $# == 0 ] ; then
  #no param, we choose default app path to link modules
  link_node_modules_from_global $PWD || exit 1
else
  echo Error: can recognize $*
  exit 1
fi

echo
echo Successed linking node modules for $1
echo ===================================
echo

