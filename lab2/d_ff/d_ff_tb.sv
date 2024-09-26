module d_ff_tb(input logic [0:0] SW, input logic [1:0] KEY,
 output logic [0:0] LEDR);
d_ff d_ff_1(.d(SW[0]), .reset(KEY[1]), .clk(KEY[0]), .q(LEDR[0]));
endmodule