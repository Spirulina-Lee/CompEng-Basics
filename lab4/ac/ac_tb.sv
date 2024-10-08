module ac_tb(
    input logic [8:0] SW,    // 9位开关输入，SW[7:0]作为Z输入，SW[8]作为LOAD_AC
    input logic [0:0] KEY,   // KEY[0]作为时钟输入
    output logic [6:0] HEX0, // 7段显示器0
    output logic [6:0] HEX1  // 7段显示器1
);

    // 内部信号
    logic signed [7:0] AC; // Accumulator寄存器

    // 实例化ac模块
    ac ac1(
        .Z(SW[7:0]),         // 8位输入Z，连接SW[7:0]
        .clk(KEY[0]),        // 时钟输入，连接KEY[0]
        .LOAD_AC(SW[8]),     // 负载信号，连接SW[8]
        .AC(AC)              // 输出AC寄存器
    );

    // 实例化dual_seg7模块，用于驱动7段显示器
    dual_seg7 dualright(
        .bin_in(AC),         // 输入AC寄存器的值
        .blank(1'b0),        // 熄灭信号为0，表示显示开启
        .test(1'b0),         // 测试信号为0，表示正常工作模式
        .out0(HEX0),         // 连接到HEX0的7段显示器
        .out1(HEX1)          // 连接到HEX1的7段显示器
    );

endmodule
