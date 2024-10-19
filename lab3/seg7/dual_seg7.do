restart -f
add wave -r /*
force blank 0
force test 0
force bin_in 00000000
run 100ns
force bin_in 00010001
run 100ns
force bin_in 00100010
run 100ns
force bin_in 00110011
run 100ns
force bin_in 01000100
run 100ns
force bin_in 01010101
run 100ns
force bin_in 01100110
run 100ns
force bin_in 01110111
run 100ns
force bin_in 10001000
run 100ns
force bin_in 10011001
run 100ns
force bin_in 10101010
run 100ns
force bin_in 10111011
run 100ns
force bin_in 11001100
run 100ns
force bin_in 11011101
run 100ns
force bin_in 11101110
run 100ns
force bin_in 11111111
run 100ns
force test 1
run 100ns
force blank 1
run 100ns