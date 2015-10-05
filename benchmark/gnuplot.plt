set terminal eps

set logscale x
set xlabel "Concurrency Level"
set xrange [1:512]
set xtics (1,2,4,8,16,32,64,128,256,512)

set key left top

set ylabel "Requests per second"

set output "add_sync.eps"
plot \
"add_sync.txt" using 1:2 title "  back-wt req/sec" with lp,\
"add_sync.txt" using 1:3 title "  back-bdb req/sec" with lp,\
"add_sync.txt" using 1:4 title "  back-mdb req/sec" with lp

set output "add_nosync.eps"
plot \
"add_nosync.txt" using 1:2 title "  back-wt req/sec" with lp,\
"add_nosync.txt" using 1:3 title "  back-bdb req/sec" with lp,\
"add_nosync.txt" using 1:4 title "  back-mdb req/sec" with lp

#set xrange [1:70]
#set xtics (1,2,4,8,16,32,64)

set output "search.eps"
plot \
"search.txt" using 1:2 title "  back-wt req/sec" with lp,\
"search.txt" using 1:3 title "  back-bdb req/sec" with lp,\
"search.txt" using 1:4 title "  back-mdb req/sec" with lp

set output "bind.eps"
plot \
"bind.txt" using 1:2 title "  back-wt req/sec" with lp,\
"bind.txt" using 1:3 title "  back-bdb req/sec" with lp,\
"bind.txt" using 1:4 title "  back-mdb req/sec" with lp

