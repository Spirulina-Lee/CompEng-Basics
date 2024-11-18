module up3_cu (
    input logic [1:0] KEY,             // KEY[0]: clk, KEY[1]: reset
    output logic [6:0] HEX0, HEX1,     // HEX0、HEX1 显示 addr/value
    output logic [6:0] HEX2, HEX3,     // HEX2、HEX3 显示 opcode
    output logic [6:0] HEX4, HEX5,     // HEX4、HEX5 显示 PC
    output logic [9:0] LEDR            // 指示状态
);

    // 内部信号声明
    logic [7:0] pc_out;                // PC 的输出
    logic [7:0] ir_upper;              // IRU 的输出 (opcode)
    logic [7:0] ir_lower;              // IRL 的输出 (addr/value)
    logic [7:0] alu_result;            // ALU 的输出 (Z)
    logic [7:0] ram_out;               // RAM 的输出 (MDR)
    logic [7:0] address;               // RAM 地址
    logic [7:0] ac_out;                // AC 的输出
    logic ZFLG, NFLG;                  // ALU 标志
    logic LOAD_AC, LOAD_IRU, LOAD_IRL, LOAD_PC, INC_PC, FETCH, STORE_MEM; // 控制信号
    logic clk, reset;                  // 时钟和复位信号
    logic [2:0] state;                 // 控制模块状态输出

    // 分配按键
    assign clk = ~KEY[0];   // KEY[0] 上升沿工作，下降沿生成时钟
    assign reset = ~KEY[1]; // KEY[1] 高电平复位

    // 实例化 Control 模块
    control control_inst (
        .opcode(ir_upper[7:0]),   // IRU 的输出作为 opcode 输入
        .NFLG(NFLG),              // ALU 的负数标志
        .ZFLG(ZFLG),              // ALU 的零标志
        .RESET(reset),            // 重置信号
        .CLK(clk),                // 时钟信号
        .STATE(state),            // 当前状态输出
        .LOAD_AC(LOAD_AC),        // 加载 AC 信号
        .LOAD_IRU(LOAD_IRU),      // 加载 IRU 信号
        .LOAD_IRL(LOAD_IRL),      // 加载 IRL 信号
        .LOAD_PC(LOAD_PC),        // 加载 PC 信号
        .INC_PC(INC_PC),          // 增加 PC 信号
        .FETCH(FETCH),            // FETCH 信号
        .STORE_MEM(STORE_MEM)     // 存储信号
    );

    // 实例化 PC 模块
    pc pc_inst (
        .clk(clk),
        .reset(reset),
        .load(LOAD_PC),
        .inc(INC_PC),
        .pc_in(ir_lower),
        .pc_out(pc_out)
    );

    // 实例化 IR 模块
    ir ir_inst (
        .clk(clk),
        .reset(reset),
        .load_iru(LOAD_IRU),
        .load_irl(LOAD_IRL),
        .mdr_data(ram_out),
        .ir_upper(ir_upper),
        .ir_lower(ir_lower)
    );

    // 实例化 AC 模块
    ac ac_inst (
        .LOAD_AC(LOAD_AC),
        .clk(clk),
        .Z(alu_result),
        .AC(ac_out)
    );

    // 实例化 ALU 模块
    alu alu_inst (
        .AC(ac_out),
        .MDR(ram_out),
        .opcode(ir_upper[4:0]),
        .value(ir_lower),
        .Z(alu_result),
        .ZFLG(ZFLG),
        .NFLG(NFLG)
    );

    // 地址选择逻辑由控制模块的状态决定，无需额外的 MUX 逻辑
    // 当 FETCH 信号有效时，地址为 PC；否则，地址为 IRL（addr/value）
    assign address = (FETCH) ? pc_out : ir_lower;

    // 实例化 RAM 模块
    upram ram_inst (
        .address(address),
        .clock(clk),
        .data(ac_out),
        .wren(STORE_MEM),
        .q(ram_out)
    );

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
