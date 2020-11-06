#!/bin/sh
PSQL='psql -U user1 -w -h localhost r99'

${PSQL} -c 'select count(*) from answers'
${PSQL} -c 'select num, timestamp from answers where id=(select max(id) from answers)'

