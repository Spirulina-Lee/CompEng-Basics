restart -f

force clk 0
force reset 0 0ns,1 500ns -repeat 1000ns 
force d 0 0ns, 1 50ns,0 150ns -repeat 200ns 
run 50ns
 
force clk 0
run 50ns

force clk 1 0ns, 0 50ns -repeat 100ns  

run 900ns  