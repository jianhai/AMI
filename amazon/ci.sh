#!/bin/bash

# Get All Package from system
rpm -qa | sort > packages

# Delete all Package information
rm -rf pkg/*

while read LINE
do
  # Ignore Some Exclude package
  package=${LINE%-*}
  grep $package excludes 
  if [ $? == 0 ]; then 
    continue
  fi

  # Show Processing Line
  echo $LINE

  # Create Package Directory
  if [ ! -d "pkg/$package" ]; then
    mkdir pkg/$package
  fi
  DIR=pkg/$package

  # Collection infromation from each Package
  rpm -q -l $package > $DIR/list
  rpm -q -i $package > $DIR/info
  rpm -q -R $package > $DIR/depend
  rpm -q --changelog $package > $DIR/changelog
  rpm -q --scripts $package > $DIR/scripts
done < packages
