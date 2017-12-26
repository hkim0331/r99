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
	pg_dump r99 > backup.sql

# before restore, must drop database r99.
# if dropped, vanish grant.
restore:
	psql r99 < backup.sql
