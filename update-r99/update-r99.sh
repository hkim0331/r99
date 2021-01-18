#!/bin/sh
if [ -z "$1" ]; then
    echo "usage: $0 <r99-num>"
    exit
fi
clj -M -m r99.update-r99 $1

