#!/bin/sh
# -*- mode: Shell-script; coding: utf-8; -*-

if [ $# -ne 1 ]; then
    echo usage: $0 VERSION
    exit
else
    VERSION=$1
fi

# linux's sed is gnu sed, macOS not.
SED=/bin/sh
if [ -e $HOMEBREW_PREFIX/bin/gsed ]; then
    SED=$HOMEBREW_PREFIX/bin/gsed
fi

${SED} -i.bak "/^\s*:version/ c\
  :version \"${VERSION}\"" ./r99.asd

${SED} -i.bak "/(defvar \*version\*/ c\
(defvar *version* \"${VERSION}\")" src/r99.lisp
