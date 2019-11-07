HOST=localhost
DB=r99
PSQL=psql -h ${HOST} ${DB}

all: drop create problems users admins backup

drop:
	${PSQL} < tables-drop.sql

create:
	${PSQL} < tables-create.sql
	sh grants.sh

problems: data/problems.md
	clj seed-problems.clj

users: 
	clj seed-users.clj

admins:
	clj delete-admins.clj
	clj seed-admins.clj

backup:
	pg_dump -h ${HOST} ${DB} > backups/`date +%F`.sql

