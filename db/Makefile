RUBY=/usr/bin/env ruby
DBSERVER=db.melt.kyutech.ac.jp
DB=r99
USER=user1
PSQL=psql -h localhost -U ${USER} -W ${DB}

init: drop create seed-problems seed-users seed-answers

# simply insert one answer.
seed-problems: problems-2018.txt problems-extra.txt
	${RUBY} seed-problems.rb $^

seed-users: sid-uid-myid-jname.txt
	time ${RUBY} seed-users.rb

seed-answers:
	time ${RUBY} seed-answers.rb

# r99-2018.md:
# 	${RUBY} make-r99-2018.rb > $@
# 	cat problem* >> $@

backup:
	pg_dump -h ${DBSERVER} -U ${USER} -W ${DB} > backups/`date +%F`.sql

drop:
	${PSQL} < drop-all.postgres

create:
	${PSQL} < create-all.postgres

# nouse in 1.1
#init:
#	${RUBY} init-problems.rb

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
