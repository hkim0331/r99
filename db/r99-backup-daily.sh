#!/bin/sh
#
DEST=/srv/r99/db/backups/`date +%F`.sql
pg_dump -U ${R99_USER} -w -h localhost r99 > ${DEST}
