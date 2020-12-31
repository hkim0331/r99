#!/bin/sh
psql -U user1 -W -h localhost r99 -t \
	   -c "select count(id) from answers group by myid" | sort | uniq -c | \
    awk '{if(NF == 2){print $2, $1}}'
