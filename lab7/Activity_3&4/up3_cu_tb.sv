module up3_cu_tb (
    input logic [1:0] KEY,             // 输入按键
    output logic [6:0] HEX0, HEX1,     // HEX 显示
    output logic [6:0] HEX2, HEX3,
    output logic [6:0] HEX4, HEX5,
    output logic [9:0] LEDR            // LED 指示
);

    // 内部信号，用于连接 up3_cu 模块的输出
    logic [7:0] ir_lower;
    logic [7:0] ir_upper;
    logic [7:0] pc_out;
    // 从 up3_cu 模块输出的控制信号
    logic STORE_MEM, FETCH, INC_PC, LOAD_PC, LOAD_IRL, LOAD_IRU, LOAD_AC;
    logic [2:0] state;

    // 实例化 up3_cu 模块
    up3_cu uut (
        .KEY(KEY),
        .ir_lower(ir_lower),
        .ir_upper(ir_upper),
        .pc_out(pc_out),
        .STORE_MEM(STORE_MEM),
        .FETCH(FETCH),
        .INC_PC(INC_PC),
        .LOAD_PC(LOAD_PC),
        .LOAD_IRL(LOAD_IRL),
        .LOAD_IRU(LOAD_IRU),
        .LOAD_AC(LOAD_AC),
        .state(state)
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
    assign LEDR[2] = INC_PC;
    assign LEDR[3] = LOAD_PC;
    assign LEDR[4] = LOAD_IRL;
    assign LEDR[5] = LOAD_IRU;
    assign LEDR[6] = LOAD_AC;
    assign LEDR[9:7] = state; // 显示控制模块的状态

endmodule
