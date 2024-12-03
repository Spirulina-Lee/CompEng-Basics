module up3_cu (
    input logic [1:0] KEY,             // KEY[0]: clk, KEY[1]: reset
    // 将内部信号暴露为输出，以供 tb 使用
    output logic [7:0] ir_lower,       // IRL 的输出 (addr/value)
    output logic [7:0] ir_upper,       // IRU 的输出 (opcode)
    output logic [7:0] pc_out,         // PC 的输出
    output logic [7:0] ac_out,         // AC 的输出
    output logic [7:0] ram_out,        // MDR 的输出
    output logic [7:0] address,        // MAR (地址) 的输出
    // 将控制信号暴露为输出，以供 tb 使用
    output logic STORE_MEM,
    output logic FETCH,
    output logic INC_PC,
    output logic LOAD_PC,
    output logic LOAD_IRL,
    output logic LOAD_IRU,
    output logic LOAD_AC,
    output logic [3:0] state           // 控制模块状态输出
);

    // 内部信号声明
    logic [7:0] alu_result;            // ALU 的输出 (Z)
    logic ZFLG, NFLG;                  // ALU 标志
    logic clk, reset;                  // 时钟和复位信号

    // 分配按键
    assign clk = KEY[0];   // KEY[0] 上升沿工作，下降沿生成时钟
    assign reset = ~KEY[1]; // KEY[1] 高电平复位

    // 实例化 Control 模块
    control control_inst (
        .opcode(ir_upper[7:0]),
        .NFLG(NFLG),
        .ZFLG(ZFLG),
        .RESET(reset),
        .CLK(clk),
        .STATE(state),
        .LOAD_AC(LOAD_AC),
        .LOAD_IRU(LOAD_IRU),
        .LOAD_IRL(LOAD_IRL),
        .LOAD_PC(LOAD_PC),
        .INC_PC(INC_PC),
        .FETCH(FETCH),
        .STORE_MEM(STORE_MEM)
        // MEM_READ 和 MEM_WRITE 信号在您的设计中未使用，因此省略
    );

    // 实例化 PC 模块
    pc pc_inst (
        .clk(clk),
        .reset(reset),
        .load(LOAD_PC),
        .inc(INC_PC),
        .pc_in(ir_lower),        // 当 LOAD_PC 有效时，加载 IRL（value）到 PC
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
        .NFLG(NFLG),
    );

    // 地址选择逻辑，由控制信号 FETCH 决定
    assign address = (FETCH) ? pc_out : ir_lower;

    // 实例化 RAM 模块
    upram ram_inst (
        .address(address),
        .clock(clk),
        .data(ac_out),
        .wren(STORE_MEM),     // 使用 STORE_MEM 作为写使能信号
        .q(ram_out)
    );

endmodule
