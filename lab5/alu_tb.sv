module alu_tb (
    input logic [9:0] SW,       // 开关输入：SW[7:0]为数据输入，SW[8]为复位信号，SW[9]为IRU加载信号
    input logic [3:0] KEY,      // 按键输入：KEY[0]为时钟信号，KEY[1]为IRL加载信号，KEY[2]为AC加载信号，KEY[3]为PC加载信号
    output logic [9:0] LEDR,    // 10个LED用于显示输入和标志位
    output logic [6:0] HEX0,    // 显示Z的7段显示器
    output logic [6:0] HEX1,    // 显示Z的7段显示器
    output logic [6:0] HEX2,    // 显示PC的7段显示器
    output logic [6:0] HEX3,    // 显示PC的7段显示器
    output logic [6:0] HEX4,    // 显示AC的7段显示器
    output logic [6:0] HEX5     // 显示AC的7段显示器
);

    // 内部信号
    logic signed [7:0] AC, MDR, Z;     // AC寄存器、MDR寄存器（由PC输出）和ALU输出Z
    logic ZFLG, NFLG;                  // 零标志位和负数标志位
    logic [4:0] opcode;                // 5位操作码
    logic signed [7:0] value;          // ALU的立即数输入

    // 实例化AC模块，AC加载到HEX4和HEX5上，同时作为ALU输入
    ac ac_reg (
        .LOAD_AC(!KEY[2]),             // AC加载信号，来自KEY[2]
        .clk(!KEY[0]),                 // 时钟信号，来自KEY[0]
        .Z(SW[7:0]),                   // 输入数据，来自SW[7:0]
        .AC(AC)                        // 输出AC，连接到显示和ALU输入
    );

    // 显示AC值到HEX4和HEX5
    dual_seg7 ac_display (
        .bin_in(AC), 
        .blank(1'b0),                  // 不熄灭显示
        .test(1'b0),                   // 不启用测试模式
        .out1(HEX3), 
        .out0(HEX2)
    );

    // 实例化PC模块，PC加载信号来自KEY[3]，PC输出到HEX2和HEX3，同时作为ALU的MDR输入
    pc pc_reg (
        .clk(!KEY[0]),                 // 时钟信号，来自KEY[0]
        .reset(SW[8]),                 // 全局复位信号，来自SW[8]
        .load(!KEY[3]),                // PC加载信号，来自KEY[3]
        .inc(1'b0),                    // PC自增禁用
        .pc_in(SW[7:0]),               // 输入数据，来自SW[7:0]
        .pc_out(MDR)                   // PC输出，连接到显示和ALU输入MDR
    );

    // 显示PC值到HEX2和HEX3
    dual_seg7 pc_display (
        .bin_in(MDR), 
        .blank(1'b0),                  // 不熄灭显示
        .test(1'b0),                   // 不启用测试模式
        .out1(HEX5), 
        .out0(HEX4)
    );

    // 实例化IR模块，IR用于加载操作码和立即数，同时将IRL输出到LEDR[7:0]
    instruction_register ir (
        .clk(!KEY[0]),                 // 时钟信号，来自KEY[0]
        .reset(SW[8]),                 // 复位信号，来自SW[8]
        .load_iru(SW[9]),              // IRU加载信号，来自SW[9]
        .load_irl(!KEY[1]),            // IRL加载信号，来自KEY[1]
        .mdr_data(SW[7:0]),            // 输入数据，来自SW[7:0]
        .ir_upper(opcode),             // 输出操作码，连接到ALU
        .ir_lower(value)               // 输出立即数，连接到ALU和LEDR
    );

    // 将IR的下部输出显示到LEDR[7:0]
    assign LEDR[7:0] = value;

    // 实例化ALU，ALU的输入为AC、MDR、操作码和立即数，输出Z
    alu alu_unit (
        .AC(AC), 
        .MDR(MDR), 
        .opcode(opcode), 
        .value(value), 
        .Z(Z), 
        .ZFLG(ZFLG), 
        .NFLG(NFLG)
    );

    // 显示ALU输出Z到HEX0和HEX1
    dual_seg7 z_display (
        .bin_in(Z), 
        .blank(1'b0),                  // 不熄灭显示
        .test(1'b0),                   // 不启用测试模式
        .out1(HEX1), 
        .out0(HEX0)
    );

    // 显示标志位到LEDR[8]和LEDR[9]
    assign LEDR[8] = NFLG;             // 负数标志位
    assign LEDR[9] = ZFLG;             // 零标志位

endmodule
