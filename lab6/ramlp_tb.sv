module ramlp_tb (
    input logic [9:0] SW,
    input logic [3:0] KEY,
    output logic [6:0] HEX0,    
    output logic [6:0] HEX1,   
    output logic [6:0] HEX2,    
    output logic [6:0] HEX3,    
    output logic [6:0] HEX4,   
    output logic [6:0] HEX5,    
    output logic [9:0] LEDR
);

    logic [7:0] pc_out;
    logic [7:0] ram_out;
    logic reset;
    logic load;
    logic inc;
    logic [7:0] data;
    logic wren;
    logic [7:0] address;

    // 控制信号
    assign reset = ~KEY[2];
    assign load = ~KEY[0];
    assign inc = SW[8];
    assign data = SW[7:0];
    assign wren = SW[9];

    // 使用 KEY[3] 直接作为时钟信号
    // 在实例化时使用 negation for KEY[3] 
    // 这样按下时为低电平，松开时为高电平
    pc pc_inst (
        .clk(!KEY[3]), // 使用反向的 KEY[3] 作为时钟
        .reset(reset),
        .load(load),
        .inc(inc),
        .pc_in(data),
        .pc_out(pc_out)
    );

    // 使用 PC 的输出作为地址输入
    assign address = pc_out;

    // 实例化 RAM 模块
    ramlpm ram_inst (
        .address(address),
        .clock(!KEY[3]), // 使用反向的 KEY[3] 作为时钟
        .data(data),
        .wren(wren),
        .q(ram_out)
    );

    // 实例化双位七段显示器模块
    dual_seg7 display_data (
        .bin_in(data),
        .blank(1'b0),
        .test(1'b0),
        .out1(HEX3),
        .out0(HEX2)
    );

    dual_seg7 display_address (
        .bin_in(address),
        .blank(1'b0),
        .test(1'b0),
        .out1(HEX5),
        .out0(HEX4)
    );

    dual_seg7 display_ram_out (
        .bin_in(ram_out),
        .blank(1'b0),
        .test(1'b0),
        .out1(HEX1),
        .out0(HEX0)
    );

    // LEDR 指示信号
    assign LEDR[9] = !KEY[3]; // 时钟信号显示到 LEDR[9]
    assign LEDR[8] = wren;    // 写使能信号显示到 LEDR[8]
    assign LEDR[7:0] = 8'b0;   // 其他 LEDR 熄灭

endmodule
