#!/bin/bash

process_file()
{
    dst=$1/$(basename $2)
    src=$2

    if [ ! -e $src ]; then
      return
    fi

    if [ $dst == $src ]; then
      cp -f -p $src $src.tmp
      src=$2.tmp
    else
      cp -f -p --remove-destination $src $dst
    fi

    sed "s|/system/bin/linker64\x0|/sbin/linker64\x0\x0\x0\x0\x0\x0\x0|g" $src | sed "s|/system/bin/linker\x0|/sbin/linker\x0\x0\x0\x0\x0\x0\x0|g" | sed "s|/system/bin/sh\x0|/sbin/sh\x0\x0\x0\x0\x0\x0\x0|g" | sed "s|/system/lib64\x0|/sbin\x0\x0\x0\x0\x0\x0\x0\x0\x0|g" | sed "s|/system/lib\x0|/sbin\x0\x0\x0\x0\x0\x0\x0|g" > $dst

    [ -e $2.tmp ] && rm $2.tmp || echo
}


dest=$1
shift 1
for ARG in $*
do
    process_file $dest $ARG
done
