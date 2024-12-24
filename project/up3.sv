module up3(
    input  logic       clk,            // 时钟信号
    input  logic       reset,          // 复位信号，高电平有效
    output logic [4:0] state,          // 当前状态
    output logic [7:0] AC, MDR, PC, opcode, value, MAR, // 各寄存器和信号
    output logic       store_mem, load_ac, load_h, load_l, incr_pc, fetch, load_pc
);
    logic [7:0] Z;                     // ALU输出值
    logic       ZFLAG, NFLAG;          // 标志信号
    logic       load_sp, incr_sp, decr_sp, fetch_sp, fetch_data, fetch_ac_data;
    logic [7:0] SP, address, Data, ac_data;

    control cu_inst(
        .opcode(opcode), .NFLAG(NFLAG), .ZFLAG(ZFLAG), .RESET(reset), .CLK(clk),
        .STATE(state), .LOAD_AC(load_ac), .LOAD_IRU(load_h), .LOAD_IRL(load_l), 
        .LOAD_PC(load_pc), .INCR_PC(incr_pc), .FETCH(fetch), .STORE_MEM(store_mem),
        .LOAD_SP(load_sp), .DECR_SP(decr_sp), .INCR_SP(incr_sp), 
        .FETCH_SP(fetch_sp), .FETCH_DATA(fetch_data), .FETCH_AC_DATA(fetch_ac_data)
    );

    ram_256_8 ram_inst (
        .address(MAR), .clock(clk), .data(Data), .wren(store_mem), .q(MDR)
    );

    ir_com ir_inst(
        .data_in(MDR), .clk(clk), .reset(reset), .load_upper(load_h), 
        .load_lower(load_l), .opcode(opcode), .value(value)
    );

    alu alu_inst(
        .AC(AC), .MDR(MDR), .opcode(opcode), .value(value),
        .Z(Z), .ZFLAG(ZFLAG), .NFLAG(NFLAG)
    );

    ac ac_inst(
        .LOAD_AC(load_ac), .clk(clk), .Z(ac_data), .AC(AC)
    );

    pc pc_inst (
        .data(value), .reset(reset), .clk(clk), 
        .load_pc(load_pc), .incr_pc(incr_pc), .pc(PC)
    );

    sp sp_inst(
        .data(value), .reset(reset), .clk(clk), 
        .load_sp(load_sp), .decr_sp(decr_sp), .incr_sp(incr_sp), .sp(SP)
    );

    mux2to1 mux_inst(
        .input_1(PC), .input_2(value), .fetch(fetch), .output_1(address)
    );

    mux2to1 mux_sp_inst(
        .input_1(SP), .input_2(address), .fetch(fetch_sp), .output_1(MAR)
    );

    mux2to1 mux_data_inst(
        .input_1(PC), .input_2(AC), .fetch(fetch_data), .output_1(Data)
    );

    mux2to1 mux_ac_inst(
        .input_1(MDR), .input_2(Z), .fetch(fetch_ac_data), .output_1(ac_data)
    );

endmodule
