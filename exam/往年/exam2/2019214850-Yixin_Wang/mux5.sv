module mux5(
		input logic [2:0] sel, 
		input logic [15:0] R0,
		input logic [15:0] R1,
		input logic [15:0] R2,
		input logic [15:0] R3,
		input logic [15:0] d_in,//5 inputs
		
		output logic [15:0] d_out//1 output
);

always_comb begin
	case (sel)
		3'b000: d_out=R0;
		3'b001: d_out=R1;
		3'b010: d_out=R2;
		3'b011: d_out=R3;
		3'b100: d_out=d_in;
		3'b101: d_out=d_in;
		3'b110: d_out=d_in;
		3'b111: d_out=d_in;
	   default: d_out=0;
	endcase

end

endmodule
