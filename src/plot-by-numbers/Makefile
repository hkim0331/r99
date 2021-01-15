all: new-plot

new-plot: by-numbers.svg
	if [ -f "../static/by-numbers.svg" ]; then \\
		mv "../static/by-numbers.svg" "../static/by-numbers-$(date +%F).svg"
	fi
	cp by-numbers.svg ../static/

by-numbers.dat:
	sh by-numbers.sh > $@

by-numbers.svg: by-numbers.dat
	gnuplot by-numbers.plot

clean:
	${RM} *.dat *.svg
