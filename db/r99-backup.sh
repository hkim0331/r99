#!/bin/sh
# .pgpass か PGPASSWORD を使う。

pg_dump -U ${R99_USER} -W -h localhost r99 > backups/`date +%F`.sql

