DB=r99
USER=user1

create:
	psql -h localhost -U ${USER} -W ${DB} < create-all.postgres

drop:
	psql -h localhost -U ${USER} -W ${DB} < drop-all.postgres

seed:
	ruby seed.rb

# backup:
# 	pg_dump r99 > backup.sql

# restore:
# 	psql r99 < backup.sql
