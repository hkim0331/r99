all: new-plot

new-plot: by-numbers.svg
	$(eval DATE := $(shell date +%F))
	[ -f "../static/by-numbers.svg" ] && \
		mv "../static/by-numbers.svg" "../static/by-numbers-${DATE}.svg"
	cp by-numbers.svg ../static/

by-numbers.dat:
	sh by-numbers.sh > $@

by-numbers.svg: by-numbers.dat
	gnuplot by-numbers.plot

clean:
	${RM} *.dat *.svg
