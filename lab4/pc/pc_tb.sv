module pc_tb (
    input logic [9:0] SW,       // 开关输入：SW[7:0]为pc_in，SW[8]为inc，SW[9]为load
    input logic [1:0] KEY,      // 按键输入：KEY[0]为时钟信号，KEY[1]为复位信号
    output logic [6:0] HEX0,    // 7段数码管输出
    output logic [6:0] HEX1     // 7段数码管输出
);

    // 内部信号
    logic [7:0] pc_out;         // PC寄存器的输出

    // 实例化程序计数器模块
    pc pc1 (
        .clk(KEY[0]),           // 时钟信号
        .reset(!KEY[1]),         // 复位信号
        .load(SW[9]),           // 加载信号
        .inc(SW[8]),            // 自增信号
        .pc_in(SW[7:0]),        // pc_in输入数据
        .pc_out(pc_out)         // PC输出
    );

    // 实例化dual_seg7模块，显示pc_out的值到HEX0和HEX1
    dual_seg7 pc_display (
        .bin_in(pc_out),        // 程序计数器的值
        .blank(1'b0),           // 熄灭信号为0，表示显示开启
        .test(1'b0),            // 测试信号为0，表示正常工作模式
        .out0(HEX0),            // 连接到HEX0的数码管
        .out1(HEX1)             // 连接到HEX1的数码管
    );

endmodule
