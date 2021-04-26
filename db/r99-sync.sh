#!/bin/sh
# .pgpass か PGPASSWORD を使う。

if [ -z "${R99_HOST}" ]; then
  echo need source ../env.sh
  exit
fi

# backup
pg_dump -U user1 -W -h localhost r99 > `date +backups/+%F.sql`

# restore
FROM=$1
if [ -z "$FROM" ]; then
    FROM=`date +backups/%F.sql"
fi

# must drop tables first.
psql -h localhost -U ${R99_USER} -W ${R99_DB} < tables-drop.sql

# then restore.
psql -h localhost -U ${R99_USER} -W ${R99_DB} < ${FROM}
