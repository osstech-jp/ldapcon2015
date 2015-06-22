set terminal eps

set logscale x
set xlabel "Concurrency Level"
set xrange [1:70]
set xtics (1,2,4,8,16,32,64)

set ylabel "Requests per second"

set output "add.eps"
plot \
"add.txt" using 1:2 title "back-wt req/sec" with lp,\
"add.txt" using 1:3 title "back-bdb req/sec" with lp

set output "search.eps"
plot \
"search.txt" using 1:2 title "back-wt req/sec" with lp,\
"search.txt" using 1:3 title "back-bdb req/sec" with lp

set output "bind.eps"
plot \
"bind.txt" using 1:2 title "back-wt req/sec" with lp,\
"bind.txt" using 1:3 title "back-bdb req/sec" with lp

