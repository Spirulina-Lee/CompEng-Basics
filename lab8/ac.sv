module ac(input logic LOAD_AC, clk,
					input logic signed [7:0] Z,
					output logic signed [7:0] AC);
	always_ff@(posedge clk)
		if(LOAD_AC) AC<=Z;
endmodule
