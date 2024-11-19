module up3 (
    input logic [9:0] SW,              // SW[0]: STORE_MEM, SW[1]: FETCH, SW[2]: INCR_PC, SW[3]: LOAD_PC, SW[4]: LOAD_IRL, SW[5]: LOAD_IRU, SW[6]: LOAD_AC
    input logic [1:0] KEY,             // KEY[0]: clk, KEY[1]: reset
    output logic [9:0] LEDR,           // 指示状态
    // 将内部信号暴露为输出，以供 tb 使用
    output logic [7:0] ir_lower,       // IRL 的输出 (addr/value)
    output logic [7:0] ir_upper,       // IRU 的输出 (opcode)
    output logic [7:0] pc_out          // PC 的输出
);

    // 内部信号声明
    logic [7:0] alu_result;            // ALU 的输出 (Z)
    logic [7:0] ram_out;               // RAM 的输出 (MDR)
    logic [7:0] address;               // RAM 地址
    logic [7:0] ac_out;                // AC 的输出
    logic ZFLG, NFLG;                  // ALU 标志
    logic STORE_MEM, FETCH, INCR_PC, LOAD_PC, LOAD_IRL, LOAD_IRU, LOAD_AC; // 控制信号
    logic clk, reset;                  // 时钟和复位信号

    // 分配开关和按键
    assign STORE_MEM = SW[0];
    assign FETCH = SW[1];
    assign INCR_PC = SW[2];
    assign LOAD_PC = SW[3];
    assign LOAD_IRL = SW[4];
    assign LOAD_IRU = SW[5];
    assign LOAD_AC = SW[6];
    assign clk = ~KEY[0];
    assign reset = ~KEY[1];

    // 实例化 PC 模块
    pc pc_inst (
        .clk(clk),
        .reset(reset),
        .load(LOAD_PC),
        .inc(INCR_PC),
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

    // MUX 逻辑，用于选择地址
    always_comb begin
        if (FETCH)
            address = pc_out;              // FETCH = 1 时，地址来源于 PC
        else
            address = ir_lower;            // FETCH = 0 时，地址来源于 addr/value
    end

    // 实例化 RAM 模块
    upram ram_inst (
        .address(address),
        .clock(clk),
        .data(ac_out),
        .wren(STORE_MEM),
        .q(ram_out)
    );
endmodule
