# force file for two-input logic gate
# comment: need a # followed by a space
force sw0 0;# comment: after a command, need a semicolon
force sw1 0
run 100ns
force sw0 1
run 100ns
force sw1 1
run 100ns
force sw0 0
run 100ns
force sw1 0
run 100ns