/*
	name:Xiangyu Dou
	Lab Number:Lab3
	module name : seg7
	function: BCD-to-7-seg decoder
*/
module seg7(input logic blank, test,
			input logic [3:0] data,
			
			output logic [6:0] disp);
			
    always_comb
		if (blank) 					disp = 7'b000_0000;
		else if (~blank & test) 	disp = 7'b111_1111;
		else	
			case(data)
			0: disp = 7'b100_0000;
			1: disp = 7'b111_1001;
			2: disp = 7'b010_0100;
			3: disp = 7'b011_0000;
			4: disp = 7'b001_1001;
			5: disp = 7'b001_0010;
			6: disp = 7'b000_0010;
			7: disp = 7'b111_1000;
			8: disp = 7'b000_0000;
			9: disp = 7'b001_1000;
			10:disp = 7'b000_1000;
			11:disp = 7'b000_0011;
			12:disp = 7'b100_0110;
			13:disp = 7'b010_0001;
			14:disp = 7'b000_0110;
			15:disp = 7'b000_1110;
			endcase
endmodule
