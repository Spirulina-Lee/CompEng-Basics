# 加载编译后的设计模块
vsim work.jk_ff

# 设置波形窗口中显示的信号
add wave -r /*
force clk 1 0ns, 0 50ns -repeat 100ns  

force reset 0 0ns
force j 0
force k 0
force clk 0
run 50ns

force reset 1
force j 0
force k 0
force clk 0
run 50ns

force j 0
force k 0
run 200ns

force j 0
force k 1
run 200ns

force j 1
force k 0
run 200ns

force j 1
force k 1
run 200ns

