#!/bin/sh
for i in users problems answers old_answers; do
    echo "grant all on $i to user1;"
    echo "grant all on ${i}_id_seq to user1;"
done  | psql r99



