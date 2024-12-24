module pc(
    input  logic [7:0] data,    // 输入数据，用于加载到PC寄存器
    input  logic       reset,   // 复位信号，高电平有效
    input  logic       clk,     // 时钟信号
    input  logic       load_pc, // 加载PC寄存器信号
    input  logic       incr_pc, // 增加PC寄存器信号
    output logic [7:0] pc       // 输出PC寄存器值
);

    always @(posedge clk or posedge reset)
        if (reset)
            pc <= 8'b0;           // 复位时，PC清零
        else if (load_pc)
            pc <= data;           // 加载数据到PC寄存器
        else if (incr_pc)
            pc <= pc + 1'b1;      // PC寄存器加1
        else
            pc <= pc;             // 保持当前PC值

endmodule
