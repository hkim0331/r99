all: r99

rerun: clean r99 run

dev: run

run:
	ros r99.ros

r99:
	ros build r99.ros

# r99: r99.lisp
# 	sbcl \
# 		--eval "(ql:quickload '(hunchentoot cl-who cl-dbi))"\
# 		--load $< \
# 		--eval "(in-package :r99)" \
# 		--eval "(sb-ext:save-lisp-and-die \"r99\" :executable t :toplevel 'main)"

install: r99
	sudo systemctl stop r99
	# install r99 /srv/r99/
	# necessary?
	# rsync static/* /srv/r99/static/
	sudo systemctl start r99

clean:
	${RM} r99 *.bak

plot:
	(cd plot-by-numbers && make all)

reinstall:
	make clean plot install
