module ir_com(
    input  logic [7:0] data_in,    // 输入数据
    input  logic       clk,        // 时钟信号
    input  logic       reset,      // 复位信号，高电平有效
    input  logic       load_upper, // 加载高位数据的控制信号
    input  logic       load_lower, // 加载低位数据的控制信号
    output logic [7:0] opcode,     // 高位输出，用作指令码
    output logic [7:0] value       // 低位输出，用作操作数
);

    ir ir_upper(
        .data_in(data_in),
        .clk(clk), 
        .reset(reset), 
        .load_flag(load_upper & (load_upper ^ load_lower)), // 确保单一加载信号有效
        .data_out(opcode)
    );

    ir ir_lower(
        .data_in(data_in),
        .clk(clk), 
        .reset(reset), 
        .load_flag(load_lower & (load_upper ^ load_lower)), // 确保单一加载信号有效
        .data_out(value)
    );

endmodule
