all: make-src

make-db:
	cd db && make init

make-src:
	cd src && make clean r99 install

clean:
	${RM} *~ *.bak

