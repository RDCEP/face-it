set terminal png enhanced
set nokey
set output "cumulativeplot.png"
set ylabel "number of completed jobs"
set title "Cumulative jobs"
plot "plot_cumulative.txt" using 1:2 with lines
set output "activeplot.png"
set xlabel "Time in sec"
set ylabel "number of active jobs"
set title "Active jobs"
plot "plot_active.txt" using 1:2 with line
