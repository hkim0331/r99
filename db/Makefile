DBSERVER=db.melt.kyutech.ac.jp

DB=r99
USER=user1
PSQL=psql -h localhost -U ${USER} -W ${DB}

backup:
	pg_dump -h ${DBSERVER} -U ${USER} -W ${DB} > backups/`date +%F`.sql

start: drop create init

drop:
	${PSQL} < drop-all.postgres

create:
	${PSQL} < create-all.postgres

init:
	ruby problems-init.rb

seed:
	ruby problems-seed.rb

uid.txt: sid-uid-myid-jname.txt
	gawk '{print $$2}' $^ > $@

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
	${PSQL} < backups/last.sql


