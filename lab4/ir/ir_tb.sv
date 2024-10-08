module ir_tb (
    input logic [9:0] SW,         // 开关输入：SW[7:0]为MDR数据，SW[8]为load_irl，SW[9]为load_iru
    input logic [1:0] KEY,        // 按键输入：KEY[0]为时钟信号，KEY[1]为复位信号
    output logic [6:0] HEX0,      // 7段数码管输出
    output logic [6:0] HEX1,      // 7段数码管输出
    output logic [6:0] HEX2,      // 7段数码管输出
    output logic [6:0] HEX3       // 7段数码管输出
);

    // 内部信号
    logic [7:0] ir_upper;         // 上寄存器
    logic [7:0] ir_lower;         // 下寄存器

    // 实例化指令寄存器
    instruction_register ir (
        .clk(!KEY[0]),            // 时钟信号
        .reset(!KEY[1]),          // 复位信号
        .load_iru(SW[9]),        // 加载上寄存器控制信号
        .load_irl(SW[8]),        // 加载下寄存器控制信号
        .mdr_data(SW[7:0]),      // MDR输入数据
        .ir_upper(ir_upper),     // 上寄存器输出
        .ir_lower(ir_lower)      // 下寄存器输出
    );

    // 实例化dual_seg7模块，显示ir_upper的值到HEX2和HEX3
    dual_seg7 upper_display (
        .bin_in(ir_upper),       // 上寄存器的值
        .blank(1'b0),            // 熄灭信号为0，表示显示开启
        .test(1'b0),             // 测试信号为0，表示正常工作模式
        .out0(HEX2),             // 连接到HEX2的数码管
        .out1(HEX3)              // 连接到HEX3的数码管
    );

    // 实例化dual_seg7模块，显示ir_lower的值到HEX0和HEX1
    dual_seg7 lower_display (
        .bin_in(ir_lower),       // 下寄存器的值
        .blank(1'b0),            // 熄灭信号为0，表示显示开启
        .test(1'b0),             // 测试信号为0，表示正常工作模式
        .out0(HEX0),             // 连接到HEX0的数码管
        .out1(HEX1)              // 连接到HEX1的数码管
    );

endmodule
