set terminal svg size 600,300
set size ratio 0.5
set output 'by-answers.svg'
set style fill solid
plot 'by-answers.dat' with boxes
