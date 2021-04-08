#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 <<-EOSQL
    CREATE USER ${R99_USER} with password '${R99_PASS}';
    CREATE DATABASE ${R99_DB};
    GRANT ALL PRIVILEGES ON DATABASE ${R99_DB} TO ${R99_USER};
EOSQL

# no. can not read seed.sql
# absolute path? --- no.
# symlink no.
# seed.sql no.
# ./seed.sql no.
# absolute path no.
# docker side? maybe.
#psql -v ON_ERROR_STOP=1 -U ${R99_USER} ${R99_DB} < /Users/hkim/common-lisp/r99/db/backups/2021-04-07.sql


