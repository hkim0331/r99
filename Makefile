all: run

run:
	cd src && ros r99.ros
	
make-db:
	cd db && make init

make-src:
	cd src && make clean r99 install

clean:
	${RM} *~ *.bak

