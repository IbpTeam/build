#!/bin/bash
if [ "$CROOT" == "" ] ; then
  echo ERROR: You should execute . set_env at project root path.
  exit 1
fi
set -e

lines=($(\find $CROOT/app -maxdepth 3 -name package.json| sed -e 's/\/[^/]*$//' | sort | uniq | sed -e '/demo-rio\/nodewebkit/d'))
if [[ ${#lines[@]} = 0 ]]; then
    echo "Not found"
    exit 1
fi
pathname=
choice=
index=
if [[ ${#lines[@]} > 1 ]]; then
    while [[ -z "$pathname" ]]; do
        index=1
        for line in ${lines[@]}; do
            printf "%6s %s\n" "[$index]" $line
            index=$(($index + 1))
        done
        echo
        echo -n "Select one: "
        unset choice
        if [ $# -ge 1 ] ; then
            choice=$1
            shift
        else
            read choice
        fi
        if [[ $choice -gt ${#lines[@]} || $choice -lt 1 ]]; then
            echo "Invalid choice, exit!"
            exit 1
        fi
        pathname=${lines[$(($choice-1))]}
    done
else
    pathname=${lines[0]}
fi

if [ ! -e $pathname/node_modules ] ; then
    bash $CROOT/build/core/link_modules_for_app.sh $pathname
fi
nw $pathname $*
if [ $? -ne 0 ] ; then
    echo Note: if some error like UNMET DEPENDENCY or No Symbol happened, you maybe try execute lall or mall to solve problem.
fi
