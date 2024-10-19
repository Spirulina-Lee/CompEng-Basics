restart -f
add wave -r /*
force push_in 00
force switch_in 0
run 100ns
force push_in 01
run 100ns
force push_in 10
run 100ns
force push_in 11
run 100ns
force push_in 00
force switch_in 1
run 100ns
force push_in 01
run 100ns
force push_in 10
run 100ns
force push_in 11
run 100ns
