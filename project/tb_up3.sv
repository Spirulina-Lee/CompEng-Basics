module tb_up3(
    input  logic [3:0] KEY,           // 输入控制信号
    output logic [9:0] LEDR,          // LED显示器
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 // 七段数码管
);

    logic [7:0] AC, MDR, PC, opcode, value, address, disp_data0, disp_data1, disp_data2;
    logic [4:0] state;
    logic load_ac, load_iru, load_irl, load_pc, incr_pc, store_mem, fetch;
    logic load_sp, incr_sp, decr_sp, fetch_sp, fetch_data, fetch_ac_data;
    logic [7:0] SP, MAR, Data, ac_data;

    up3 up3_inst(
        .clk(~KEY[0]), .reset(~KEY[1]), .state(state),
        .AC(AC), .MDR(MDR), .PC(PC), .opcode(opcode), 
        .value(value), .MAR(MAR), .store_mem(store_mem),
        .load_ac(load_ac), .load_h(load_iru), .load_l(load_irl), 
        .incr_pc(incr_pc), .fetch(fetch), .load_pc(load_pc)
    );

    dualseg7 disp_3(
        .blank(0), .test(0), .datain(disp_data2), .disp0(HEX4), .disp1(HEX5)
    );

    dualseg7 disp_2(
        .blank(0), .test(0), .datain(disp_data1), .disp0(HEX2), .disp1(HEX3)
    );

    dualseg7 disp_1(
        .blank(0), .test(0), .datain(disp_data0), .disp0(HEX0), .disp1(HEX1)
    );

    always @(*) begin
        if (~KEY[3]) begin
            disp_data2 = MAR;
            disp_data1 = MDR;
            disp_data0 = AC;
            LEDR[0] = store_mem;
            LEDR[1] = fetch;
            LEDR[2] = incr_pc;
            LEDR[3] = load_pc;
            LEDR[4] = load_irl;
            LEDR[5] = load_iru;
            LEDR[6] = load_ac;
            LEDR[7] = 1'b0;
            LEDR[8] = 1'b0;
            LEDR[9] = 1'b1;
        end else begin
            disp_data2 = state;
            disp_data1 = opcode;
            disp_data0 = value;
            LEDR[0] = PC[0];
            LEDR[1] = PC[1];
            LEDR[2] = PC[2];
            LEDR[3] = PC[3];
            LEDR[4] = PC[4];
            LEDR[5] = PC[5];
            LEDR[6] = PC[6];
            LEDR[7] = PC[7];
            LEDR[8] = 1'b0;
            LEDR[9] = 1'b0;
        end
    end

endmodule
