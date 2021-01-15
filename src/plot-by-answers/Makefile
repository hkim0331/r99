all: new-plot

new-plot: by-answers.svg
	$(eval DATE := $(shell date +%F))
	[ -f "../static/by-answers.svg" ] && \
		mv "../static/by-answers.svg" "../static/by-answers-${DATE}.svg"
	cp by-answers.svg ../static/

by-answers.dat:
	sh by-answers.sh | ruby sort.rb > $@

by-answers.svg: by-answers.dat
	gnuplot by-answers.plot

clean:
	${RM} *.dat *.svg
