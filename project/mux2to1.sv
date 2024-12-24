module	mux2to1(
	input	logic	[7:0]	input_1		,
	input	logic	[7:0]	input_2		,
	input	logic			fetch		,
	
	output	logic	[7:0]	output_1

);
	always @(*)
		if(fetch)	output_1 = input_1;
		else 		output_1 = input_2;

endmodule
