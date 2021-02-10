#!/bin/sh
#
DEST=/srv/r99/db/backups/`date +%F`.sql
pg_dump -U user1 -w -h localhost r99 > ${DEST}
