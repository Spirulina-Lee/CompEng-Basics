module up3_tb (
    input logic [3:0] KEY,             // KEY[0]: clk, KEY[1]: reset, KEY[3]: mode switch
    output logic [6:0] HEX0, HEX1,     // HEX displays
    output logic [6:0] HEX2, HEX3,
    output logic [6:0] HEX4, HEX5,
    output logic [9:0] LEDR            // LEDs
);

    // 内部信号，用于连接 up3_cu 模块的输出
    logic [7:0] ir_lower;
    logic [7:0] ir_upper;
    logic [7:0] pc_out;
    logic [7:0] ac_out;
    logic [7:0] ram_out;
    logic [7:0] address;
    // 控制信号
    logic STORE_MEM, FETCH, INC_PC, LOAD_PC, LOAD_IRL, LOAD_IRU, LOAD_AC;
    logic [3:0] state;

    // 实例化 up3_cu 模块
    up3_cu uut (
        .KEY(KEY[1:0]),
        .ir_lower(ir_lower),
        .ir_upper(ir_upper),
        .pc_out(pc_out),
        .ac_out(ac_out),
        .ram_out(ram_out),
        .address(address),
        .STORE_MEM(STORE_MEM),
        .FETCH(FETCH),
        .INC_PC(INC_PC),
        .LOAD_PC(LOAD_PC),
        .LOAD_IRL(LOAD_IRL),
        .LOAD_IRU(LOAD_IRU),
        .LOAD_AC(LOAD_AC),
        .state(state)
    );

    // 分配时钟和复位信号
    logic clk, reset;
    assign clk = KEY[0];
    assign reset = ~KEY[1];

    // 模式切换逻辑
    logic mode;

    // 按键未按下为高电平 '1'，按下为低电平 '0'
    // 当按下 KEY[3] 时，mode = 1（模式 1）；未按下时，mode = 0（模式 0）
    assign mode = ~KEY[3];

    // 根据模式选择要显示的数据
    logic [7:0] hex01_data, hex23_data, hex45_data;

    always_comb begin
        if (mode == 1'b0) begin
            // 模式 0
            hex01_data = ac_out;      // 显示 AC
            hex23_data = ir_lower;    // 显示 IRL
            hex45_data = ir_upper;    // 显示 IRU
        end else begin
            // 模式 1
            hex01_data = ram_out;     // 显示 MDR
            hex23_data = address;     // 显示 MAR
            hex45_data = pc_out;      // 显示 PC
        end
    end

    // 实例化双位七段显示器模块

    // 显示 HEX0 和 HEX1
    dual_seg7 display_hex01 (
        .bin_in(hex01_data),
        .blank(1'b0),
        .test(1'b0),
        .out1(HEX1),
        .out0(HEX0)
    );

    // 显示 HEX2 和 HEX3
    dual_seg7 display_hex23 (
        .bin_in(hex23_data),
        .blank(1'b0),
        .test(1'b0),
        .out1(HEX3),
        .out0(HEX2)
    );

    // 显示 HEX4 和 HEX5
    dual_seg7 display_hex45 (
        .bin_in(hex45_data),
        .blank(1'b0),
        .test(1'b0),
        .out1(HEX5),
        .out0(HEX4)
    );

    // 控制 LED 指示灯
    always_comb begin
        if (mode == 1'b0) begin
            // 模式 0
            LEDR[3:0] = state[3:0];    // 显示状态机的状态
            LEDR[9] = 1'b0;            // LEDR[9] 熄灭
            LEDR[8:4] = 5'b0;          // 其他 LED 熄灭
        end else begin
            // 模式 1
            LEDR[0] = STORE_MEM;
            LEDR[1] = FETCH;
            LEDR[2] = INC_PC;
            LEDR[3] = LOAD_PC;
            LEDR[4] = LOAD_IRL;
            LEDR[5] = LOAD_IRU;
            LEDR[6] = LOAD_AC;
            LEDR[9] = 1'b1;            // LEDR[9] 点亮
            LEDR[8:7] = 2'b0;          // 其他 LED 熄灭
        end
    end

endmodule
