PSQL=psql -U ${R99_USER} -W -h ${R99_HOST} ${R99_DB}

all: create problems users backup

drop:
	${PSQL} < drop-tables.sql

delete:
	echo "delete from problems" | ${PSQL}
	echo "delete from users"    | ${PSQL}

create: drop
	${PSQL} < create-tables.sql
	sh grants.sh

problems: problems.md
	clj -M init-problems.clj

users:
	clj -M init-users.clj

backup:
	pg_dump -h ${R99_HOST} -U ${R99_USER} -W ${R99_DB} > backups/`date +%F`.sql

update:
	@echo "clj -m update-r99 <num>"

