DB=r99
USER=user1
PSQL=psql -h localhost -U ${USER} -W ${DB}

create:
	${PSQL} < create-all.postgres

drop:
	${PSQL} < drop-all.postgres

migrate:
	${PSQL} < migrations/01-rename-pid-num.sql
	${PSQL} < migrations/02-add-midterm.sql

seed:
	ruby seed.rb

backup:
	pg_dump -h dbs.melt.kyutech.ac.jp -U ${USER} -W ${DB} > backups/`date +%F`.sql

# before restore, must drop database r99.
# if dropped, vanish grant.
# is this right? -- no.
# WARNING:  no privileges could be revoked for "public"
# REVOKE
# ERROR:  role "postgres" does not exist
# ERROR:  role "postgres" does not exist
# WARNING:  no privileges were granted for "public"
# GRANT

restore:
	${PSQL} < drop-tables.postgres
	${PSQL} < backups/2018-01-28.sql


