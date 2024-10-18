# 加载编译后的设计模块
vsim work.and2in
# 设置波形窗口中显示的信号
add wave -r /*

force a 0;# comment: after a command, need a semicolon
force b 0
run 100ns
force a 1
run 100ns
force b 1
run 100ns
force a 0
run 100ns
force b 0
run 100ns