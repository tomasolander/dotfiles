#!/bin/sh

# searches for a subdirectory in a parent directory (like .hg, .git, et cetera)

# first parameter must be the directory name to find
[ -z $1 ] && exit 2

d=$PWD
while [ "$d" != "" ]; do
  if [ -d "$d/$1" ]
  then
    echo "$d/$1"
    exit 0
  fi
  d=${d%/*}
done
exit 1
