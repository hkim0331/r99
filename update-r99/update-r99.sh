#!/bin/sh
if [ -z "$1" ]; then
    echo "usage: $0 <r99-num>"
    exit
fi
clj -m update-r99 $1

