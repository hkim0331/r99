#!/bin/sh
psql -U user1 -W -h localhost r99  -A -F' ' -t \
     -c  "select num, count(*) from answers  group by num order by num"


