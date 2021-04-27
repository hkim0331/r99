#!/bin/sh
# .pgpass か PGPASSWORD を使う。

if [ -z "${R99_HOST}" ]; then
  echo need source ../env.sh
  exit
fi

FROM=$1
if [ -z "$FROM" ]; then
  BACKUP=`date +backups/+%F.sql`
  pg_dump -U user1 -W -h localhost r99 > ${BACKUP}
  FROM=${BACKUP}
fi

# must drop tables first.
psql -h localhost -U ${R99_USER} -W ${R99_DB} < tables-drop.sql

# then restore.
psql -h localhost -U ${R99_USER} -W ${R99_DB} < ${FROM}
