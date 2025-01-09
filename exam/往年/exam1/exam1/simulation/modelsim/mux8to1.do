force D 8'b10011101;
force en 0 20ns
force en 1 380ns
force sel(0) 0 0ns, 1 50ns -r 100ns;
force sel(1) 0 0ns, 1 100ns -r 200ns;
force sel(2) 0 0ns, 1 200ns -r 400ns;
run 400ns;