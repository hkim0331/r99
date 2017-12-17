DB=r99
USER=user

all: users problems answers

users:
	mysql -u ${USER} -p ${DB} < migrations/users.sql

problems:
	mysql -u ${USER} -p ${DB} < migrations/problems.sql

answers:
	mysql -u ${USER} -p ${DB} < migrations/answers.sql

