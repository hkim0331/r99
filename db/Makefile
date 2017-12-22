DB=r99
USER=user1

create:
	psql -h localhost -U ${USER} -W ${DB} < create-all.pg

drop:
	psql -h localhost -U ${USER} -W ${DB} < drop-all.sql

seed:
	ruby seed.rb
