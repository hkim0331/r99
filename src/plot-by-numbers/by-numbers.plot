set terminal svg size 600,300
set size ratio 0.5
set output 'by-numbers.svg'
set style fill solid
plot 'by-numbers.dat' with boxes
