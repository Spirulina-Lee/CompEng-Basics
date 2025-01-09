module reg16(
	input logic  CLK,
   input logic  [15:0] Rin,
   output logic  [15:0] Rout
);

always @(negedge CLK) begin
	Rout=Rin;
end


endmodule
