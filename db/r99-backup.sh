#!/bin/sh
# .pgpass か PGPASSWORD を使う。

pg_dump -U user1 -W -h localhost r99 > backups/`date +%F`.sql
