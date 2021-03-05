#!/bin/sh
#
DEST=/srv/r99/db/backups/`date +%F`.sql
pg_dump -U user1 -w -h localhost r99 > ${DEST}

# after back-upping, update plots.

for i in plot-by-answers plot-by-numbers; do
  (cd /srv/r99/src/$i && echo pass1 | make)
done   
    
