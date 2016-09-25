#!/bin/bash

while read LINE
do
  echo $LINE

  if [ ! -d "pkg/$LINE" ]; then
    mkdir pkg/$LINE
  fi

  rpm -q -l $LINE > pkg/$LINE/list
  rpm -q -i $LINE > pkg/$LINE/info
  rpm -q -R $LINE > pkg/$LINE/depend
  rpm -q --changelog $LINE > pkg/$LINE/changelog
  rpm -q --scripts $LINE > pkg/$LINE/scripts
done < packages
