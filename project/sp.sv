module sp(
    input  logic [7:0] data,       // 输入数据，用于加载到SP寄存器
    input  logic       reset,      // 复位信号，高电平有效
    input  logic       clk,        // 时钟信号
    input  logic       load_sp,    // 加载SP寄存器信号
    input  logic       decr_sp,    // 减少SP寄存器信号
    input  logic       incr_sp,    // 增加SP寄存器信号
    output logic [7:0] sp          // 输出SP寄存器值
);

    always @(posedge clk or posedge reset)
        if (reset)
            sp <= 8'b0;            // 复位时，SP清零
        else if (load_sp)
            sp <= data;            // 加载数据到SP寄存器
        else if (decr_sp)
            sp <= sp - 8'b1;       // SP寄存器减1
        else if (incr_sp)
            sp <= sp + 8'b1;       // SP寄存器加1
        else
            sp <= sp;              // 保持当前SP值

endmodule
