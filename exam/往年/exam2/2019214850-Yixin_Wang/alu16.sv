module alu16(
	input logic signed [15:0] A,
	input logic signed [15:0] B,
	input logic [2:0] opcode,
	output logic signed [15:0] z
);


always_comb begin
	case(opcode)
		3'b000:begin z=A|B; end
		3'b001:begin z=A&B; end
		3'b010:begin z=A^B; end
		3'b011:begin z=~(A&B); end
		3'b100:begin z=B; end
		3'b101:begin z=A+1; end 
		3'b110:begin z=A+B; end
		3'b111:begin z=A-B; end
	endcase
end
	
endmodule
