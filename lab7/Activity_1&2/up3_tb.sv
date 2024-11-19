module up3_tb (
    input logic [9:0] SW,              // SW 输入
    input logic [1:0] KEY,             // KEY 输入
    output logic [6:0] HEX0, HEX1,     // HEX 显示
    output logic [6:0] HEX2, HEX3,
    output logic [6:0] HEX4, HEX5,
    output logic [9:0] LEDR            // LED 指示
);

    // 内部信号，用于连接 up3 模块的输出
    logic [7:0] ir_lower;
    logic [7:0] ir_upper;
    logic [7:0] pc_out;
    // 从 up3 模块输出的控制信号
    logic STORE_MEM, FETCH, INCR_PC, LOAD_PC, LOAD_IRL, LOAD_IRU, LOAD_AC;

    // 实例化 up3 模块
    up3 uut (
        .SW(SW),
        .KEY(KEY),
        .ir_lower(ir_lower),
        .ir_upper(ir_upper),
        .pc_out(pc_out),
        .STORE_MEM(STORE_MEM),
        .FETCH(FETCH),
        .INCR_PC(INCR_PC),
        .LOAD_PC(LOAD_PC),
        .LOAD_IRL(LOAD_IRL),
        .LOAD_IRU(LOAD_IRU),
        .LOAD_AC(LOAD_AC)
    );

    // 在 tb 中实例化 dual_seg7 模块

    // 显示 addr/value 到 HEX0 和 HEX1
    dual_seg7 display_addr_value (
        .bin_in(ir_lower),
        .blank(1'b0),
        .test(1'b0),
        .out1(HEX1),
        .out0(HEX0)
    );

    // 显示 opcode 到 HEX2 和 HEX3
    dual_seg7 display_opcode (
        .bin_in(ir_upper),
        .blank(1'b0),
        .test(1'b0),
        .out1(HEX3),
        .out0(HEX2)
    );

    // 显示 PC 到 HEX4 和 HEX5
    dual_seg7 display_pc (
        .bin_in(pc_out),
        .blank(1'b0),
        .test(1'b0),
        .out1(HEX5),
        .out0(HEX4)
    );

    // 指示状态到 LEDR
    assign LEDR[0] = STORE_MEM;
    assign LEDR[1] = FETCH;
    assign LEDR[2] = INCR_PC;
    assign LEDR[3] = LOAD_PC;
    assign LEDR[4] = LOAD_IRL;
    assign LEDR[5] = LOAD_IRU;
    assign LEDR[6] = LOAD_AC;

endmodule
