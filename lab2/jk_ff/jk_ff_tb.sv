module jk_ff_tb(
    input logic [1:0] KEY,
    input logic [1:0] SW,
    output logic [0:0] LEDR
    );
    jk_ff jk_ff_1(.j(SW[0]), .k(SW[1]), .clk(KEY[0]), .reset(KEY[1]), .q(LEDR[0]));
endmodule
//