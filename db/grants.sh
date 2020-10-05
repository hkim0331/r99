#!/bin/sh
DB=${R99_DB}
USER=${R99_USER}

for i in users problems answers old_answers; do
    echo "grant all on $i to ${USER};"
    echo "grant all on ${i}_id_seq to ${USER};"
done  | psql -U ${USER} -W -h localhost ${DB}



