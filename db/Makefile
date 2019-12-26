HOST=localhost
DB=r99
PSQL=psql -U user1 -W -h ${HOST} ${DB}

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
	pg_dump -h ${HOST} -U user1 -W ${DB} > backups/`date +%F`.sql

update:
	@echo "clj -m update-r99 <num>"

