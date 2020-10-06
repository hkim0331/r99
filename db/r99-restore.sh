#!/bin/sh
if [ -z ${R99_HOST} ]; then
  echo need source ../env.sh
  exit
end
psql -h localhost -U ${R99_USER} -W ${R99_DB} < $1
