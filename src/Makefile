all: r99

rerun: clean r99 run

dev: run

run:
	ros r99.ros

r99:
	ros build r99.ros

install: r99
	sudo systemctl stop r99
	sudo systemctl start r99

clean:
	${RM} r99 *.bak

plot:
	(cd plot-by-numbers && make all)
  (cd plot-by-answers && make all)

reinstall:
	make clean plot install
