all: new-plot

new-plot: by-answers.svg
	if [ -f "../static/by-answers.svg" ]; then \\
		mv "../static/by-answers.svg" "../static/by-answers-$(date +%F).svg"
	fi
	cp by-answers.svg ../static/

by-answers.dat:
	sh by-answers.sh | ruby sort.rb > $@

by-answers.svg: by-answers.dat
	gnuplot by-answers.plot

clean:
	${RM} *.dat *.svg
