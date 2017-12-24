#!/bin/sh
# -*- mode: Shell-script; coding: utf-8; -*-

if [ $# -ne 1 ]; then
    echo usage: $0 VERSION
    exit
else
    VERSION=$1
fi

# linux's sed is gnu sed, macOS not.
if [ -e /usr/local/bin/gsed ]; then
    SED=/usr/local/bin/gsed
else
    SED=`which sed`
fi
if [ -z ${SED} ]; then
    echo can not find SED
    exit
fi

# FIXME: leading two blank chars disappear.
${SED} -i.bak "/  :version/ c\
  :version \"${VERSION}\"" ./r99.asd

${SED} -i.bak "/(defvar \*version\*/ c\
(defvar *version* \"${VERSION}\")" src/r99.lisp

git tag ${VERSION}
echo ${VERSION} > VERSION
