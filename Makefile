all: make-db make-src

make-db:
	cd db && make start

make-src:
	cd src && make r99 install

clean:
	${RM} *~ *.bak

