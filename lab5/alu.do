# 加载编译后的设计模块
vsim work.alu

# 设置波形窗口中显示的信号
add wave -r /*

# 强制输入信号，开始仿真
# Force 输入信号初始值
force AC 10         
force MDR 1         
force value 1    

# 设定操作码，并观察输出
force opcode 5'b00000  
run 10ns                

force opcode 5'b00101   
run 10ns

force opcode 5'b00110  
run 10ns

force opcode 5'b01001   
run 10ns
run 10ns

force opcode 5'b01010   
force opcode 5'b01100  
run 10ns

