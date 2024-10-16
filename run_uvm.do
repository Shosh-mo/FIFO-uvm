vlib work
vlog -f src_files.list.txt -sv +cover
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -coverage
run 0
add wave /top/FIFOif/*
coverage save FIFO.ucdb -onexit
run -all
#quit -sim
#vcover report FIFO.ucdb -details -annotate -all -output cov1.txt
