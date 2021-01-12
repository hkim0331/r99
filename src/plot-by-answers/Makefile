all: new-plot

new-plot: by-answers.svg
	cp by-answers.svg ../static/

by-answers.dat:
	sh by-answers.sh | ruby sort.rb > $@

by-answers.svg: by-answers.dat
	gnuplot by-answers.plot

clean:
	${RM} *.dat *.svg
