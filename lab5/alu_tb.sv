module alu_tb (
    input logic [9:0] SW,       // 开关输入：SW[7:0]为数据输入，SW[7:3]为操作码，SW[8]为reset，SW[9]为load opcode
    input logic [3:0] KEY,      // 按键输入：KEY[0]为时钟信号，KEY[1]为load input to LED，KEY[2]为load AC，KEY[3]为load MDR
    output logic [9:0] LEDR,    // 10个LED用于显示输入和标志位
    output logic [6:0] HEX0,    // HEX0显示器
    output logic [6:0] HEX1,    // HEX1显示器
    output logic [6:0] HEX2,    // HEX2显示器
    output logic [6:0] HEX3,    // HEX3显示器
    output logic [6:0] HEX4,    // HEX4显示器
    output logic [6:0] HEX5     // HEX5显示器
);

    // 内部信号
    logic signed [7:0] AC, MDR, Z;   // AC寄存器、MDR寄存器和ALU输出Z
    logic ZFLG, NFLG;                // 零标志位和负数标志位
    logic [4:0] opcode;              // 5位操作码
    logic signed [7:0] value;        // ALU的输入值
    logic signed [7:0] input_value;  // 用于存储SW输入的值

    // 处理指令寄存器和AC寄存器
    instruction_register ir (
        .clk(!KEY[0]), 
        .reset(SW[8]), 
        .load_iru(SW[9]), 
        .load_irl(1'b0),  // 只需要load_iru
        .mdr_data(SW[7:0]), 
        .ir_upper(opcode), 
        .ir_lower(value)
    );

    // AC寄存器的实例化
    ac ac_reg (
        .LOAD_AC(!KEY[2]), 
        .clk(!KEY[0]), 
        .Z(Z), 
        .AC(AC)
    );

    // MDR寄存器的实例化
    ac mdr_reg (
        .LOAD_AC(!KEY[3]), 
        .clk(!KEY[0]), 
        .Z(SW[7:0]), 
        .AC(MDR)
    );

    // ALU的实例化
    alu alu_unit (
        .AC(AC), 
        .MDR(MDR), 
        .opcode(opcode), 
        .value(value), 
        .Z(Z), 
        .ZFLG(ZFLG), 
        .NFLG(NFLG)
    );

    // 如果KEY[1]按下，SW[7:0]加载到LED
    always_ff @(posedge KEY[0]) begin
        if (!KEY[1]) begin
            input_value <= SW[7:0];   // 将SW的值加载到input_value
        end
    end

    // LEDR[7:0] 显示 input_value
    assign LEDR[7:0] = input_value;
    
    // LEDR[8] 显示 NFLG (负数标志)
    assign LEDR[8] = NFLG;

    // LEDR[9] 显示 ZFLG (零标志)
    assign LEDR[9] = ZFLG;

    // 实例化7段显示器显示Z、AC和MDR
    dual_seg7 z_display (
        .bin_in(Z), 
        .blank(1'b0), 
        .test(1'b0), 
        .out1(HEX1), 
        .out0(HEX0)
    );

    dual_seg7 ac_display (
        .bin_in(AC), 
        .blank(1'b0), 
        .test(1'b0), 
        .out1(HEX3), 
        .out0(HEX2)
    );

    dual_seg7 mdr_display (
        .bin_in(MDR), 
        .blank(1'b0), 
        .test(1'b0), 
        .out1(HEX5), 
        .out0(HEX4)
    );

endmodule
