restart -f

force clk 0
force reset 0
run 50ns
force d 0 0ns, 1 100ns -repeat 200ns  

force reset 1
force clk 0
run 50ns

force clk 1 0ns, 0 50ns -repeat 100ns  

run 500ns  