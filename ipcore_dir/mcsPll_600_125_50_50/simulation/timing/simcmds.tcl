# file: simcmds.tcl

# create the simulation script
vcd dumpfile isim.vcd
vcd dumpvars -m /mcsPll_600_125_50_50_tb -l 0
wave add /
run 50000ns
quit

