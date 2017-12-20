DB=r99
USER=user

create:
	mysql -u ${USER} -p ${DB} < create-all.sql

drop:
	mysql -u ${USER} -p ${DB} < drop-all.sql

seed:
	ruby seed.rb


