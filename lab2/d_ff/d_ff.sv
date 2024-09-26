module d_ff(input logic clk,d, reset,
 output logic q);
 always_ff @(posedge clk, negedge reset)
 if (~reset) q <= 0;//reset is active low
 else q <= d;
endmodule