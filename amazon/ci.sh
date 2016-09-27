#!/bin/bash

function is_ignore()
{
  package=$1

  rec=`grep "$package" excludes`
  if [ -z "$rec" ]; then 
    return 1
  fi
  return 0
}

function do_ci()
{
  package=$1
  DIR=$2

  rpm -q -l $package > $DIR/list
  rpm -q -i $package > $DIR/info
  rpm -q -R $package > $DIR/depend
  rpm -q --changelog $package > $DIR/changelog
  rpm -q --scripts $package > $DIR/scripts
}

function do_srpm()
{
  package=$1

  ./scripts/getsrc.expect $package
}

# Set default Action
ACTION="default"

# Set Action from parameter
if [ $# -gt 1 ]; then 
  echo "./ci.sh [srpm]"
  exit 0
fi

if [ $# -eq 0 ]; then
  ACTION="default"
elif [ $1 = "srpm" ]; then
  ACTION="srpm"
fi

# Delete all Package information
if [ $ACTION == "default" ]; then
  rm -rf pkg/*
elif [ $ACTION == "srpm" ]; then
  rm -rf srpm/*
fi 

# Get All Package from system
rpm -qa | sort > packages

while read LINE
do
  package=${LINE%%-[0-9]*}

  # Ignore Some Exclude package
  if [ `is_ignore $package` ]; then 
    continue
  fi

  # Show Processing Line
  echo $LINE

  # Create Package Directory
  if [ ! -d "pkg/$package" ]; then
    mkdir pkg/$package
  fi
  DIR=pkg/$package

  if [ $ACTION == "default" ]; then
    # Collection infromation from each Package
    do_ci $package $DIR
  elif [ $ACTION == "srpm" ]; then
    # Down SRPM to /usr/src/srpm/debug/ 
    do_srpm $package
  fi 
done < packages
