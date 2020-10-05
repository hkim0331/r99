#!/bin/sh
export R99_HOST=localhost
export R99_DB=r99
export R99_USER=user1
export R99_PASS=pass1
LANG=ja_JP.UTF-8

ssh -fN -L 5432:localhost:5432 ubuntu@roswell

echo ready

