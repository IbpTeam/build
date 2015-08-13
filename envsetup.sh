function hh() {
cat <<EOF
Invoke ". set_env" from your shell to add the following functions to your environment:
- cmaster:   Create master branch for committing code by git push.
- cm:        Change the manifest for changing the master branch.
- m:         Build
- idep:      Install dependency lib.
- mall:      Build all node modules. No param will build for nw, while with param --node will build for node.
- lall:      Create link with node modules from global for all app included demo-rio datamgr testAPI webde/nw
- lapp:      Create link with node modules from global for one app in current path or param 1 path.
- r:         Run
- irio       Initialize Rio: 1.create directory for resources; 2.create and clean database.
- cr:        Change Runtime
- godir:     Go to the directory containing a file.
- bp         Build package.
- genlog:    Echo your code's contribution about all repositries into ~/LOG by default.
- svcInit:   Initialize a service package.
- svcDebug:  List|stop|restart running services.
- generator: Generate proxy, stub and index based on an interface file.
- h:         Show more help.
- stops:     Stop running services.
- restarts:  Restart running services.

Look at the source to view more functions. The complete list is:
EOF
    T=$(gettop)
    local A
    A=""
    for i in `cat $T/build/envsetup.sh | sed -n "/^function /s/function \([a-z_]*\).*/\1/p" | sort`; do
      A="$A $i"
    done
    echo $A
}

function setenv()
{
    T=$(gettop)
    if [ ! "$T" ]; then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
    fi

    echo -----------------------------------------------
    export CROOT=$T
    export TOP=$T
    export OUT=$T/out
    echo CROOT: $CROOT
    echo OUT: $OUT
    machine=$(uname -m)
    if [ ! $WD_RUNTIME -o ! $WD_RT_VERSION  ] ; then
        if [ $machine == "i686" ] ; then
            export WD_RUNTIME=node-webkit
            export WD_RT_VERSION=0.8.4
            echo Runtime is $WD_RUNTIME $WD_RT_VERSION
        elif [ $machine == 'x86_64' ] ; then
            export WD_RUNTIME=node-webkit
            export WD_RT_VERSION=0.8.6-linux-x64
            echo Runtime is $WD_RUNTIME $WD_RT_VERSION
        else
            export WD_RUNTIME=node-webkit
            export WD_RT_VERSION=0.8.4
            echo We choose default runtime $WD_RUNTIME $WD_RT_VERSION for unknown machine\($machine\)
        fi
    else
        echo Runtime is kept as  $WD_RUNTIME $WD_RT_VERSION
    fi
    export npm_config_userconfig=$OUT/nodejs/.npmrc
    if [ ! -e $OUT/nodejs/.npmrc ] ; then
        if [ ! -e $OUT/nodejs ] ; then
            mkdir -p $OUT/nodejs
        fi
        echo "registry = https://registry.npm.taobao.org" > $OUT/nodejs/.npmrc
    fi
    export npm_config_cache=$OUT/nodejs/cache
    export npm_config_init_module="$OUT/nodejs/.npm-init.js"
    addpath "$T/prebuilt/$WD_RUNTIME-v${WD_RT_VERSION}"
    addpath "$OUT/nodejs/bin"

    (cd $T/documents;git config core.quotepath false)
    echo -----------------------------------------------
}

function cr()
{
    T=$(gettop)
    if [ ! "$T" ]; then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
    fi

    echo Current runtime is $WD_RUNTIME $WD_RT_VERSION
    echo Choose the runtime you want to change:
    echo 1. node-webkit 0.8.4
    echo 2. node-webkit 0.8.6-linux-ia32
    echo 3. node-webkit 0.8.4-linux-x64
    echo 4. node-webkit 0.8.6-linux-x64
    unset choice
    read choice
    if [[ $choice -gt 4 || $choice -lt 1 ]]; then
        echo "Invalid choice, exit!"
        return 1
    elif [ $choice -eq 1 ] ; then
        export WD_RUNTIME=node-webkit
        export WD_RT_VERSION=0.8.4
        echo Current runtime is $WD_RUNTIME $WD_RT_VERSION
        addpath "$T/prebuilt/$WD_RUNTIME-v${WD_RT_VERSION}"
    elif [ $choice -eq 2 ] ; then
        export WD_RUNTIME=node-webkit
        export WD_RT_VERSION=0.8.6-linux-ia32
        echo Current runtime is $WD_RUNTIME $WD_RT_VERSION
        addpath "$T/prebuilt/$WD_RUNTIME-v${WD_RT_VERSION}"
    elif [ $choice -eq 3 ] ; then
        export WD_RUNTIME=node-webkit
        export WD_RT_VERSION=0.8.4-linux-x64
        echo Current runtime is $WD_RUNTIME $WD_RT_VERSION
        addpath "$T/prebuilt/$WD_RUNTIME-v${WD_RT_VERSION}"
    elif [ $choice -eq 4 ] ; then
        export WD_RUNTIME=node-webkit
        export WD_RT_VERSION=0.8.6-linux-x64
        echo Current runtime is $WD_RUNTIME $WD_RT_VERSION
        addpath "$T/prebuilt/$WD_RUNTIME-v${WD_RT_VERSION}"
    fi
}

function addpath()
{
	if [ $# == 1 ] ; then
		exist="false"
        if [ -d $1 ] ; then
		    pathadded=$(cd $1; pwd)
        else
            pathadded=$1
        fi
		for THIS_PATH in `echo $PATH | sed 's/:/ /g'`
		do
			if [ "$THIS_PATH" == "$pathadded" ];then
				exist="true"
				break
			fi
		done

		if [ "$exist" == "false" ];then
			export PATH=$pathadded:$PATH
		fi
	fi
}

function h()
{
    T=$(gettop)
    if [ ! "$T" ]; then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
    fi

    echo Later for showing help.
    cat $T/build/help.txt | more
}

function repo()
{
    T=$(gettop)
    if [ ! "$T" ]; then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
    fi
    if [ $# -eq 1 ] ; then
        if [ "$1" == "sync" ] ; then
            res=`repo status | grep ^project | grep branch | sed /branch\ master$/d | wc -l`
            if [ ! "$res" == "0" ] ; then
                echo "You should checkout the following projects into master branch before executing repo sync, like using cmaster"
                repo status | grep ^project | grep branch | sed /branch\ master$/d
                return 1
            fi
        fi
    fi

    
    $T/.repo/repo/repo $*

    if [ $# -eq 1 ] ; then
        if [ "$1" == "sync" ] ; then
            source $T/build/envsetup.sh
        fi
    fi
}

function npm4nw()
{
    npm_config_prefix=$OUT/node4nw npm $*
}


function resource()
{
    source $T/build/envsetup.sh
}

function addcompletions()
{
    local T dir f

    # Keep us from trying to run in something that isn't bash.
    if [ -z "${BASH_VERSION}" ]; then
        return 1
    fi

    # Keep us from trying to run in bash that's too old.
    if [ ${BASH_VERSINFO[0]} -lt 3 ]; then
        return 1
    fi

    dir="sdk/bash_completion"
    if [ -d ${dir} ]; then
        for f in `/bin/ls ${dir}/[a-z]*.bash 2> /dev/null`; do
            echo "including $f"
            . $f
        done
    fi
}

function gettop
{
    local TOPFILE=build/envsetup.sh
    if [ -n "$TOP" -a -f "$TOP/$TOPFILE" ] ; then
        echo $TOP
    else
        if [ -f $TOPFILE ] ; then
            # The following circumlocution (repeated below as well) ensures
            # that we record the true directory name and not one that is
            # faked up with symlink names.
            PWD= /bin/pwd
        else
            # We redirect cd to /dev/null in case it's aliased to
            # a command that prints something as a side-effect
            # (like pushd)
            local HERE=$PWD
            T=
            while [ \( ! \( -f $TOPFILE \) \) -a \( $PWD != "/" \) ]; do
                cd .. > /dev/null
                T=`PWD= /bin/pwd`
            done
            cd $HERE > /dev/null
            if [ -f "$T/$TOPFILE" ]; then
                echo $T
            fi
        fi
    fi
}

function croot()
{
    T=$(gettop)
    if [ "$T" ]; then
        cd $(gettop)
    else
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
    fi
}

function cmaster()
{
    T=$(gettop)
    if [ ! "$T" ]; then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
    fi
    echo "Before cmaster: repo branches are"
    (repo branches | grep ^* ) 2>/dev/null

    echo "Executing..."
    repo forall -c git checkout -b master remotes/m/master 2>/dev/null
    repo forall -c git checkout -q master
    repo forall -c git config push.default upstream
    echo "After cmaster: repo branches are"
    (repo branches | grep ^* ) 2>/dev/null
}

function cm()
{
    T=$(gettop)
    if [ ! "$T" ]; then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
    fi

    local currentxml
    currentxml=$(basename $(readlink  $T/.repo/manifest.xml))
    echo "The current manifest is $currentxml"

    local lines
    lines=($(cd $T/.repo/manifests && ls *.xml | sort | uniq))

    local toxml
    if [ $# == 0 ] ; then
      echo "You can change into following manifest files:"
      local i
      local choice
      i=1
      for file in ${lines[@]}; do
        echo $i. $file
        i=$(($i + 1))
      done
      unset choice
      read choice
      if [[ $choice -gt ${#lines[@]} || $choice -lt 1 ]]; then
        echo "Invalid choice"
        return 1
      fi
      toxml=${lines[$(($choice-1))]}
    else
      if [ -f $T/.repo/manifests/$1.xml ] ; then
        toxml=$1.xml
      else
        echo "The $1 manifest file does not exists."
        return 1
      fi
    fi

    if [ "$currentxml" == "$toxml" ] ; then
      echo "The manifest has already been $toxml."
      return 0
    fi

    res=`repo status | grep ^project | sed /branch\ master$/d | wc -l`
    if [ ! "$res" == "0" ] ; then
      echo "You should checkout the following projects into master branch before executing cm, like using cmaster"
      repo status | grep ^project | sed /branch\ master$/d
      return 1
    fi

    echo "------------------------------------------"
    echo "Start changing manifest into $toxml"
    repo init -m $toxml
    echo "------------------------------------------"
    echo "Start repo sync with new manifest $toxml"
    repo sync
}

function checktools()
{
	echo Later for checking tools.
    command -v reprepro > /dev/null
    if [ ! $? == 0 ] ; then
        echo ERROR: reprepro has not been installed.
        return 1
    fi
    return 0
}

function checkdep()
{
	echo Later for checking dependency.
}

function idep()
{
    T=$(gettop)
    if [ ! "$T" ]; then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
    fi
    bash $T/build/core/install_deps.sh || return
}

function mall()
{
    T=$(gettop)
    if [ ! "$T" ]; then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
    fi
    bash $T/build/core/build_node_modules.sh $* || return
}

function lapp(){
    T=$(gettop)
    if [ ! "$T" ]; then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
    fi
    bash $T/build/core/link_modules_for_app.sh $* || return
}

function lall(){
    T=$(gettop)
    if [ ! "$T" ]; then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
    fi
    bash $T/build/core/link_modules_for_app.sh all || return
}

function m()
{
    echo Building the whole projects.
    T=$(gettop)
    if [ ! "$T" ]; then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
    fi
    bash $T/build/core/install_deps.sh || return
    bash $T/build/core/build_nodejs.sh || return
    bash $T/build/core/build_node_modules.sh || return
    bash $T/build/core/link_modules_for_app.sh all || return
}

function mm()
{
    bash $T/build/core/build_single_module.sh $* || return
}

function r()
{
    echo Run app in app folder.
    T=$(gettop)
    if [ ! "$T" ]; then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
    fi
    bash $T/build/core/run_app.sh $* || return
}

case `uname -s` in
    Darwin)
        function sgrep()
        {
            find -E . -name .repo -prune -o -name .git -prune -o  -type f -iregex '.*\.(c|h|cpp|S|java|xml|sh|mk)' -print0 | xargs -0 grep --color -n "$@"
        }

        ;;
    *)
        function sgrep()
        {
            find . -name .repo -prune -o -name .git -prune -o  -type f -iregex '.*\.\(c\|h\|cpp\|S\|java\|xml\|sh\|mk\)' -print0 | xargs -0 grep --color -n "$@"
        }
        ;;
esac

function jgrep()
{
    find . -name .repo -prune -o -name .git -prune -o  -type f -name "*\.java" -print0 | xargs -0 grep --color -n "$@"
}

function psgrep()
{
    find . -name .repo -prune -o -name .git -prune -o  -type f \( -name '*.py' -o -name '*.js' \) -print0 | xargs -0 grep --color -n "$@"
}

function cgrep()
{
    find . -name .repo -prune -o -name .git -prune -o -type f \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.h' \) -print0 | xargs -0 grep --color -n "$@"
}


case `uname -s` in
    Darwin)
        function mgrep()
        {
            find -E . -name .repo -prune -o -name .git -prune -o  -type f -iregex '.*/(Makefile|Makefile\..*|.*\.make|.*\.mak|.*\.mk)' -print0 | xargs -0 grep --color -n "$@"
        }

        function treegrep()
        {
            find -E . -name .repo -prune -o -name .git -prune -o -type f -iregex '.*\.(c|h|cpp|S|java|xml)' -print0 | xargs -0 grep --color -n -i "$@"
        }

        ;;
    *)
        function mgrep()
        {
            find . -name .repo -prune -o -name .git -prune -o -regextype posix-egrep -iregex '(.*\/Makefile|.*\/Makefile\..*|.*\.make|.*\.mak|.*\.mk)' -type f -print0 | xargs -0 grep --color -n "$@"
        }

        function treegrep()
        {
            find . -name .repo -prune -o -name .git -prune -o -regextype posix-egrep -iregex '.*\.(c|h|cpp|S|java|xml)' -type f -print0 | xargs -0 grep --color -n -i "$@"
        }

        ;;
esac


function godir () {
    if [[ -z "$1" ]]; then
        echo "Usage: godir <regex>"
        return 1
    fi
    T=$(gettop)
	if [ ! -d $OUT ] ; then
        mkdir $OUT
	fi
    if [[ ! -f $OUT/filelist ]]; then
        echo -n "Creating index..."
        (cd $T; find . -wholename ./out -prune -o -wholename ./.repo -prune -o -type f > $OUT/filelist)
        echo " Done"
        echo ""
    fi
    local lines
    lines=($(\grep "$1" $OUT/filelist | sed -e 's/\/[^/]*$//' | sort | uniq))
    if [[ ${#lines[@]} = 0 ]]; then
        echo "Not found"
        return 1
    fi
    local pathname
    local choice
    if [[ ${#lines[@]} > 1 ]]; then
        while [[ -z "$pathname" ]]; do
            local index=1
            local line
            for line in ${lines[@]}; do
                printf "%6s %s\n" "[$index]" $line
                index=$(($index + 1))
            done
            echo
            echo -n "Select one: "
            unset choice
            read choice
            if [[ $choice -gt ${#lines[@]} || $choice -lt 1 ]]; then
                echo "Invalid choice"
                continue
            fi
            pathname=${lines[$(($choice-1))]}
        done
    else
        pathname=${lines[0]}
    fi
    cd $T/$pathname
}

if [ "x$SHELL" != "x/bin/bash" ]; then
    case `ps -o command -p $$` in
        *bash*)
            ;;
        *)
            echo "WARNING: Only bash is supported, use of other shell would lead to erroneous results"
            ;;
    esac
fi
if [ $# == 0 ] ; then
    setenv
    addcompletions
    echo
	echo Finish setup enviroment. Enter hh to get more info.
    echo
fi

#Initialize Rio
#1.create directory
#2.create/clean db
function irio () {
    echo --------------------- Initialize Rio ---------------------
    T=$(gettop)
    if [ ! "$T" ]; then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
    fi
    bash $T/build/core/init_rio.sh || return
    bash $T/build/core/init_database.sh clean || return
    echo --------------------- Initialize Rio Successfully---------------------
}

function bp () {
    echo --------------------- Build Package ---------------------
    T=$(gettop)
    if [ ! "$T" ]; then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
    fi
    bash $T/build/deb/build_package.sh || return
    echo --------------------- Build Package Finished---------------------
}

function bp-dev () {
    echo --------------------- Build Package ---------------------
    T=$(gettop)
    if [ ! "$T" ]; then
        echo "Couldn't locate the top of the tree.  Try setting TOP."
        return 1
    fi
    bash $T/build/deb/build_package_dev.sh || return
    echo --------------------- Build Package Finished---------------------
}

function genlog () {
  echo --------------------- Echo Git Log ---------------------
  T=$(gettop)
  if [ ! "$T" ]; then
    echo "Couldn't locate the top of the tree.  Try setting TOP."
    return 1
  fi

  local after
  local before
  local output
  if [ $# == 1 ]; then
    output="$HOME/LOG"
    after="1.weeks.ago"
  elif [ $# == 2 ]; then
    output="$HOME/$2"
    after="1.weeks.ago"
  elif [ $# == 3 ]; then
    output="$HOME/LOG"
    after=$2
    before=$3
  elif [ $# == 4 ]; then
    output="$HOME/$4"
    after=$2
    before=$3
  else
    echo "Usage: genlog email [after_data before_data] [output filename]"
    echo "e.g. genlog lianggy0719@126.com 2015-01-01 2015-02-05 MyLOG"
    echo "  or genlog lianggy0719@126.com"
    echo "p.s. [] means optional"
    echo "The second example will echo commits during last week into ~/LOG by default"
    return 1
  fi

  local author=$1
  local currentxml="$T/.repo/manifest.xml"
  local sepatator="*******************************************************************************************"
  local date="提交时间"
  local description="提交描述"
  local change="提交变更"

  echo "" > $output
  for line in `grep -Eo "path=\""[^\"]+"\"" $currentxml | awk -F \" '{print $2}'`; do
    echo -e "\nProject $line:\n" >> $output
    (cd $T/$line && git log --branches -p --stat --pretty=format:"$sepatator%n$date：%cd%n$description：%s%n$change：%n"\
  --author=$author --no-merges --after={$after} --before={$before} >> $output)
    # echo $line
  done
  echo --------------------- Echo Git Log Finished ---------------------
}

function svcInit() {
  echo --------------------- Service Initialize ---------------------
  if [ -e ./package.json ]; then
    echo "Service has initialized, or remove ./package.json first."
    return 1
  fi

  npm init && mkdir implements interface "test"
  echo --------------------- Service Initialize Finished ---------------------
}

function svcDebug() {
  $CROOT/service/svcmgr/tools/debug.js $*
}

function generator() {
  echo --------------------- Service Interface Generate ---------------------
  $CROOT/framework/webde-rpc/tools/generator.js $*
  echo --------------------- Service Interface Generate Finished ---------------------
}

function stops(){
  lines=($(ps aux|grep node|grep service|awk '{print $12}'))
    if [[ ! -n $lines ]]; then
      echo "There are no node service running."
      return
    fi
  index=1
  choice=
  tmpserv=
  echo "Running service as follows :"
    for line in ${lines[@]}; do
      printf "%6s %s\n" "[$index]" ${line##*/}
      index=$(($index + 1))
    done
  echo "Input service numbers to stop :"
  unset choice
  read -a choice
  for j in ${choice[@]}
    do
      if [[ $j -gt ${#lines[@]} || $j -lt 1 ]]; then
        echo "Invalid choice, exit!"
        return
      fi
    done
  echo "Stopping ${#choice[@]} services"
  for k in ${choice[@]}
    do
      unset tmpserv
      tmpserv=($(ps aux|grep node|grep service|grep ${lines[$k-1]}|awk '{print $2}'))
      kill $tmpserv && echo "stop ${lines[$k-1]} successful." 
    done
}

function restarts(){
  lines=($(ps aux|grep node|grep service|awk '{print $12}'))
    if [[ ! -n $lines ]]; then
      echo "There are no node service running."
      return
    fi
  index=1
  choice=
  servnum=
  log=
  echo "Running service as follows :"
    for line in ${lines[@]}; do
      printf "%6s %s\n" "[$index]" ${line##*/}
      index=$(($index + 1))
    done
  echo "Input service numbers to restart :"
  unset choice
  read -a choice
  for j in ${choice[@]}
    do
      if [[ $j -gt ${#lines[@]} || $j -lt 1 ]]; then
        echo "Invalid choice, exit!"
        return
      fi
    done
  echo "Restarting ${#choice[@]} services"
  for k in ${choice[@]}
    do
      unset servnum
      unset log
      servnum=($(ps aux|grep node|grep service|grep ${lines[$k-1]}|awk '{print $2}'))
      log=${lines[$k-1]}
      kill $servnum  && echo "kill ${lines[$k-1]} successful, Restarting"
      node ${lines[$k-1]} 2>&1>/home/$USER/.custard/servlog/${log##*/}.log &  
    done
}

