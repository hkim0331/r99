DB=r99
USER=user

create:
	mysql -u ${USER} -p ${DB} < migrations/create-all.sql

drop:
	mysql -u ${USER} -p ${DB} < migrations/drop-all.sql

seed:
	ruby seed.rb


