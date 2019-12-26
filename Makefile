all: run

dump:
	pg_dump -U user1 -W -h localhost r99 > db/backups/`date +%F`.dump

# select latest dump
restore:
	@echo be carefull to restore from local backups.
	@echo use "find db/backups -name \*.dump | tail -1"

run:
	cd src && ros r99.ros

make-db:
	cd db && make init

make-src:
	cd src && make clean r99 install

clean:
	${RM} *~ *.bak

