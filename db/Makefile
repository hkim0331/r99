DB=r99
USER=user

create: users problems answers

drop:
	mysql -u ${USER} -p ${DB} < migrations/drop.sql

seed:
	ruby seed-users.rb
	ruby seed-problems.rb

users:
	mysql -u ${USER} -p ${DB} < migrations/users.sql

problems:
	mysql -u ${USER} -p ${DB} < migrations/problems.sql

answers:
	mysql -u ${USER} -p ${DB} < migrations/answers.sql

