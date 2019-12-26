#!/bin/sh
for i in 111 112 113 114 115 116 117 118 119 120; do
    echo $i
    psql -U user1 -W -h localhost r99 <<EOF
insert into problems (num, detail) values ('$i','[extra] なんか考える。乞うご期待');
EOF
done
