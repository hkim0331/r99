RUBY=/usr/bin/env ruby
DBSERVER=db.melt.kyutech.ac.jp
DB=r99
USER=user1
PSQL=psql -h localhost -U ${USER} -W ${DB}

# dangerous! init
#init: create-tabless

seed-problems: problems.txt
	clj seed-problems.clj

# requires data/icome9.txt and data/students.txt
seed-users: 
	clj seed-users.clj

# seed-answers:
# 	${RUBY} seed-answers.rb

create-tables:
	${PSQL} < create-tables.sql

backup:
	pg_dump -h ${DBSERVER} -U ${USER} -W ${DB} > backups/`date +%F`.sql

