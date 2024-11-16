#!/usr/bin/gnuplot -c

set encoding utf
set xlabel "Ordem da matriz"
set grid
set style data point
set style function line
set xtics
set boxwidth 1
set style line 1 lc 3 pt 7 ps 0.3
set datafile separator space

set title "FLOPS/S"
set ylabel "FLOPS/S"
plot 'flops.dat' using 1:2 title "MVM 1" with linespoints, \
    '' using 1:3 title "MMM 1" with linespoints, \
    '' using 1:4 title "MVM 2" with linespoints, \
    '' using 1:5 title "MMM 2" with linespoints
pause -1

set title "L3 Cache Miss Ratio"
set ylabel "L3 Miss Ratio"
plot 'l3.dat' using 1:2 title "MVM 1" with linespoints, \
    '' using 1:3 title "MMM 1" with linespoints, \
    '' using 1:4 title "MVM 2" with linespoints, \
    '' using 1:5 title "MMM 2" with linespoints
pause -1

set title "Energy Consumption"
set ylabel "Energy [J]"
plot 'energy.dat' using 1:2 title "MVM 1" with linespoints, \
    '' using 1:3 title "MMM 1" with linespoints, \
    '' using 1:4 title "MVM 2" with linespoints, \
    '' using 1:5 title "MMM 2" with linespoints
pause -1
