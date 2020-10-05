PSQL=psql -U ${R99_USER} -W -h ${R99_HOST} ${R99_DB}

all: drop create problems users dump

drop:
	${PSQL} < tables-drop.sql

delete:
	echo "delete from problems" | ${PSQL}
	echo "delete from users"    | ${PSQL}

create: drop
	${PSQL} < tables-create.sql
	sh grants.sh

problems: problems.md
	clj -M init-problems.clj

users:
	clj -M init-users.clj

dump:
	pg_dump -h ${R99_HOST} -U ${R99_USER} -W ${R99_DB} > backups/`date +%F`.dump

restore:

update:
	@echo "clj -m update-r99 <num>"

