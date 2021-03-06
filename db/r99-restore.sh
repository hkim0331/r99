#!/bin/sh
if [ -z "${R99_HOST}" ]; then
  echo need source ../env.sh
  exit
fi

FROM=$1
if [ -z "$FROM" ]; then
    FROM=`date +backups/%F.sql"
fi

# must drop tables first.
psql -h localhost -U ${R99_USER} -W ${R99_DB} < tables-drop.sql

# then restore.
psql -h localhost -U ${R99_USER} -W ${R99_DB} < ${FROM}
