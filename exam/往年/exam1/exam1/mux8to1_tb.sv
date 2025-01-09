//EE 310 Fundamentals of Computer Engineering
//Assignment: exam1
//Author: Cheng Anzhe
//Module Name: mux8to1
//Module Function:  8-to-1 multiplexer testbench
//**************************************************************************************

//Module Declaration
module mux8to1_tb(input logic [2:0] KEY, input logic [9:0] SW,
               output logic LEDR[0]);
					
mux8to1 mux(.sel(KEY), .D(SW),  .Y(LEDR[0]), .en(SW[9]));
endmodule